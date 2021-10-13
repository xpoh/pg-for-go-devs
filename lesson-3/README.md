# Поиск номера телефона по адресу email

```sql
SELECT email, phone
FROM employees
WHERE email = 'aliddell@gopher_corp.com';
```

# Заполнение таблицы синтетическими данными

```bash
sudo rm -rf mock && mkdir -p mock && sudo chown -R 10000 mock

docker run \
    --rm \
    --name mock-pg \
    -v $HOME/pg-for-go-devs/lesson-3/mock:/home/mock \
    ghcr.io/pivotal-gss/mock-data:latest \
    -a 172.17.0.2 \
    -d gopher_corp \
    -u gopher \
    -w P@ssw0rd \
    -r 100000 \
    tables -t employees
```

# Оценка объема. Подсчет количества строк

Напрямую:

```sql
SELECT count(1)
FROM employees;
```

Оценка количества строк:

```sql
SELECT oid::regclass::text AS tablename, reltuples::bigint AS rows_estim
FROM pg_class
WHERE oid::regclass::text = 'employees';
```

Заметна ли разница во времени исполнения? Измерим время выполнения прямого подсчета:

```sql
EXPLAIN
SELECT count(1) FROM employees;
```

и оценки:

```sql
EXPLAIN
SELECT oid::regclass::text AS tablename, reltuples::bigint AS rows_estim
FROM pg_class
WHERE oid::regclass::text = 'employees';
```

# Оценка объема данных в таблице employees

```sql
\dt+ employees
```

# Получение случайной строки

```sql
SELECT *
FROM employees
ORDER BY RANDOM()
LIMIT 1;
```

# Поиск телефона по email

```sql
SELECT email, phone
FROM employees
WHERE email = 'NSims@gopher_corp.com';
```

Построим план запроса:

```sql
EXPLAIN
SELECT email, phone
FROM employees
WHERE email = 'NSims@gopher_corp.com';
```

Откроем методичку и посмотрим, что ожидалось. Почему наблюдаем другой результат?

# Настройка Postgres для параллельного выполнения

```bash
parallel_setup_cost = 1000.0
min_parallel_table_scan_size = 8MB
min_parallel_index_scan_size = 128kB
```

Обновим конфигурацию:

```sql
SELECT pg_reload_conf();
```

И выполним еще раз:

```sql
EXPLAIN
SELECT email, phone
FROM employees
WHERE email = 'NSims@gopher_corp.com';
```

Что наблюдаем?

# Explain Analyze

Восстановим конфигурацию и выполним:

```sql
EXPLAIN ANALYZE
SELECT email, phone
FROM employees
WHERE email = 'NSims@gopher_corp.com';
```

Опять сконфигурируем БД для параллельной обработки и выполним тот же запрос:

```sql
EXPLAIN ANALYZE
SELECT email, phone
FROM employees
WHERE email = 'NSims@gopher_corp.com';
```

С чем связаны эти результаты?

# Create index

Создадим индекс на столбце `email`:

```sql
CREATE INDEX
ON employees(email);
```

Выполним запрос еще раз:

```sql
EXPLAIN ANALYZE
SELECT email, phone
FROM employees
WHERE email = 'NSims@gopher_corp.com';
```

# Поиск по префиксу

Попробуем искать ту же самую информацию, но с использованием оператора `LIKE`:

```sql
EXPLAIN ANALYZE
SELECT email, phone
FROM employees
WHERE email LIKE 'NSims%';
```

Рассмотрим доступные классы операторов:

```sql
SELECT am.amname AS index_method,
       opc.opcname AS opclass_name,
       opc.opcintype::regtype AS indexed_type,
       opc.opcdefault AS is_default
    FROM pg_am am, pg_opclass opc
    WHERE opc.opcmethod = am.oid
    ORDER BY index_method, opclass_name;
```

Создадим индекс для поиска по префиксу:

```sql
CREATE INDEX
ON employees(email text_pattern_ops);
```

Проверим:

```sql
EXPLAIN ANALYZE
SELECT email, phone
FROM employees
WHERE email LIKE 'NSims%';
```

Посмотрим статистику по индексам:

```sql
\di+ employees_email_idx1
```

И по таблице:

```sql
\dt+ employees
```

# Covering Index

```sql
CREATE INDEX
ON employees(email text_pattern_ops)
INCLUDE phone;
```

Выполним запрос снова:

```sql
EXPLAIN ANALYZE
SELECT email, phone
FROM employees
WHERE email LIKE 'NSims%';
```

Что наблюдаем?

Посмотрим на размеры индексов:

```sql
\di+ employees_email_phone_idx
```

# Порядок индексации

```sql
EXPLAIN ANALYZE
SELECT first_name, last_name
FROM employees
ORDER BY last_name DESC;
```

```sql
CREATE INDEX first_last_name_desc
ON employees (first_name, last_name);
```

# Частичная индексация

```sql
CREATE INDEX alice_employees
ON employees (manager_id) WHERE (manager_id = 3);
```

# Индексация нескольких столбцов

```sql
EXPLAIN ANALYZE
SELECT first_name, last_name
FROM employees
WHERE first_name = 'Adrian' AND last_name = 'Smith';
```

Создадим индекс:

```sql
CREATE INDEX first_last_name
ON employees (first_name, last_name);
```

Повторим:

```sql
EXPLAIN ANALYZE
SELECT first_name, last_name
FROM employees
WHERE first_name = 'Adrian' AND last_name = 'Smith';
```

# Индексация выражений

```sql
EXPLAIN ANALYZE
SELECT last_name
FROM employees
where lower(first_name) = 'adrian';
```

Построим индекс:

```sql
CREATE INDEX first_name_lower
ON employees(lower(first_name));
```

Перепроверим:

```sql
EXPLAIN ANALYZE
SELECT last_name
FROM employees
where lower(first_name) = 'adrian';
```

# Просмотр статистики

```sql
SELECT *
FROM pg_stats
WHERE tablename = 'employees'
    AND attname = 'email';
```

```sql
EXPLAIN ANALYZE
WITH managers AS (
    SELECT *
    FROM employees
)
SELECT *
FROM managers
WHERE first_name = 'Alice';
```