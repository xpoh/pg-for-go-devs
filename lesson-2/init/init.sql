CREATE USER gopher
WITH PASSWORD 'P@ssw0rd';

CREATE DATABASE gopher_corp
    WITH OWNER gopher
    TEMPLATE = 'template0'
    ENCODING = 'utf-8'
    LC_COLLATE = 'C.UTF-8'
    LC_CTYPE = 'C.UTF-8';

\c gopher_corp

SET ROLE gopher;

DROP TABLE IF EXISTS departments CASCADE;
CREATE TABLE departments (
    id INT GENERATED ALWAYS AS IDENTITY,
    parent_id INT NOT NULL,
    name VARCHAR(200)
);

DROP TABLE IF EXISTS positions CASCADE;
CREATE TABLE positions(
    id INT GENERATED ALWAYS AS IDENTITY,
    title VARCHAR(200)
);

DROP TABLE IF EXISTS employees CASCADE;
CREATE TABLE employees(
    id INT GENERATED ALWAYS AS IDENTITY,
    first_name VARCHAR(200),
    last_name VARCHAR(200),
    salary MONEY,
    manager_id INT,
    department_id INT,
    position INT
);

INSERT INTO departments (id, parent_id, name)
OVERRIDING SYSTEM VALUE
VALUES
    (0, 0, 'root');

INSERT INTO departments (parent_id, name)
VALUES
    (
        (
            SELECT id
            FROM departments
            WHERE name = 'root'
        ),
        'Romulus'
    ),
    (
        (
            SELECT id
            FROM departments
            WHERE name = 'root'
        ),
        'Remus'
    );

INSERT INTO departments (parent_id, name)
VALUES
    (
        (
            SELECT id
            FROM departments
            WHERE name = 'Romulus'
        ),
        'Backend'
    ),
    (
        (
            SELECT id
            FROM departments
            WHERE name = 'Romulus'
        ),
        'Frontend'
    ),
    (
        (
            SELECT id
            FROM departments
            WHERE name = 'Romulus'
        ),
        'QA'
    ),
    (
        (
            SELECT id
            FROM departments
            WHERE name = 'Remus'
        ),
        'Backend'
    ),
    (
        (
            SELECT id
            FROM departments
            WHERE name = 'Remus'
        ),
        'Frontend'
    ),
    (
        (
            SELECT id
            FROM departments
            WHERE name = 'Remus'
        ),
        'QA'
    );