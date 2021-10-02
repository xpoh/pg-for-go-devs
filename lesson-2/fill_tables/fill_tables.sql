/*
  docker run \
    -d \
    -p 5432:5432 \
    --name postgres \
    -e POSTGRES_PASSWORD=P@ssw0rd \
    -e PGDATA=/var/lib/postgresql/data \
    -v $HOME/pg-for-go-devs/lesson-2/data:/var/lib/postgresql/data \
    -v $HOME/pg-for-go-devs/lesson-2/init_2:/docker-entrypoint-initdb.d \
    -v $HOME/pg-for-go-devs/lesson-2/fill_tables:/fill_tables \
    postgres:13.4
*/

INSERT INTO positions (title)
VALUES
    ('CTO'),
    ('CEO'),
    ('CSO')
ON CONFLICT(title) DO NOTHING;

INSERT INTO departments (id, parent_id, name)
OVERRIDING SYSTEM VALUE
VALUES
    (0, 0, 'root') ON CONFLICT(id) DO NOTHING;

INSERT INTO departments (parent_id, name)
VALUES 
    (
        (
            SELECT id
            FROM departments
            WHERE name = 'root'
        ),
        'executives'
    ) ON CONFLICT(name) DO NOTHING;

BEGIN DEFERRABLE;
    INSERT INTO employees (first_name, last_name, salary, manager_id, department_id, position)
    VALUES 
        (
            'Bob',
            'Morane',
            500000,
            42,
            (SELECT id FROM departments WHERE name = 'executives'),
            (SELECT id FROM positions WHERE title = 'CSO')
        );
    UPDATE employees
    SET manager_id = (
        SELECT id
        FROM employees
        WHERE 
            first_name = 'Bob'
            AND last_name = 'Morane'
    )
    WHERE
        first_name = 'Bob'
        AND last_name = 'Morane';

    INSERT INTO employees (first_name, last_name, salary, manager_id, department_id, position)
    VALUES 
        (
            'Charley',
            'Bucket',
            1000000,
            42,
            (SELECT id FROM departments WHERE name = 'executives'),
            (SELECT id FROM positions WHERE title = 'CEO')
        );
    UPDATE employees
    SET manager_id = (
        SELECT id
        FROM employees
        WHERE 
            first_name = 'Charley'
            AND last_name = 'Bucket'
    )
    WHERE
        first_name = 'Charley'
        AND last_name = 'Bucket';

    INSERT INTO employees (first_name, last_name, salary, manager_id, department_id, position)
    VALUES 
        (
            'Alice',
            'Liddell',
            500000,
            42,
            (SELECT id FROM departments WHERE name = 'executives'),
            (SELECT id FROM positions WHERE title = 'CTO')
        );
    UPDATE employees
    SET manager_id = (
        SELECT id
        FROM employees
        WHERE 
            first_name = 'Alice'
            AND last_name = 'Liddell'
    )
    WHERE
        first_name = 'Alice'
        AND last_name = 'Liddell';
COMMIT;