-- Количество измерений для конкретного наименования изделия
EXPLAIN ANALYSE
SELECT i.name, count(1)FROM proc
                                LEFT JOIN tests t on proc.id_test = t.id
                                LEFT JOIN items i on t.id = i.id
WHERE i.name = '0a27d6cc81d6b75e60240e92367f73df'
group by i.name;

-- Самые большие значения параметров по всем изделиям
EXPLAIN ANALYSE
SELECT i.name, max(p.value) FROM proc p
                                     LEFT JOIN tests t on p.id_test = t.id
                                     LEFT JOIN items i on t.id = i.id
GROUP BY i.id;

-- Изделия у которых значение параметра равно заданному
EXPLAIN ANALYSE
SELECT i.name, p.value FROM proc p
                                LEFT JOIN tests t on p.id_test = t.id
                                LEFT JOIN items i on t.id = i.id
WHERE p.value = 999.9293521371371;
