--    Проект для накопления и обработки информации получаемой в процессе производства изделий на заводе
--    Есть различные операции (рабочие места) на каждом проводится набор испытаний (тестов)
--    В результате получается набор значений параметров
--    Изделия могут состоять из входящих в них изделий, т.е существует древовидная структура
--    Описание таблиц:
--    items      - справочник изделий
--    workspaces - справочник рабочих мест
--    params     - справочник параметров
--    test       - таблица об информации с проверками
--    proc       - таблица с результатами проверки

-- Table: public.items

DROP TABLE IF EXISTS public.items CASCADE;

CREATE TABLE public.items
(
    id bigint PRIMARY KEY GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    name TEXT,
    parent_id bigint
);



COMMENT ON TABLE public.items
    IS 'Справочник изделий';

-- Table: public.params
DROP TABLE IF EXISTS public.params;

CREATE TABLE public.params
(
    id bigint PRIMARY KEY GENERATED ALWAYS AS IDENTITY ,
    name TEXT NOT NULL,
    CONSTRAINT pk_id_uniq UNIQUE (id)
);

COMMENT ON TABLE public.params
    IS 'Справочник параметров';


-- Table: public.workspaces

DROP TABLE IF EXISTS public.workspaces CASCADE;

CREATE TABLE IF NOT EXISTS public.workspaces
(
    id bigint PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name character varying COLLATE pg_catalog."default" NOT NULL
);

COMMENT ON TABLE public.workspaces
    IS 'Справочник рабочих мест';


-- Table: public.tests
DROP TABLE IF EXISTS public.tests CASCADE;

CREATE TABLE IF NOT EXISTS public.tests
(
    id bigint PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    id_item bigint NOT NULL,
    id_workspace bigint NOT NULL,
    date timestamp with time zone,
    name text COLLATE pg_catalog."default",
    CONSTRAINT fk_item FOREIGN KEY (id)
        REFERENCES public.items (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_workspace FOREIGN KEY (id)
        REFERENCES public.workspaces (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

COMMENT ON TABLE public.tests
    IS 'Испытание на рабочем месте';


-- Table: public.proc

DROP TABLE IF EXISTS public.proc;

CREATE TABLE IF NOT EXISTS public.proc
(
    id bigint PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    id_test bigint,
    id_param bigint,
    value double precision CHECK ( abs(value) < 1000 ),
    raw_data "char"[],
    misc text COLLATE pg_catalog."default",
    CONSTRAINT fk_test FOREIGN KEY (id_test)
        REFERENCES public.tests (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_param FOREIGN KEY (id_param)
        REFERENCES public.tests (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE

);

COMMENT ON TABLE public.proc
    IS 'Таблица с измерениями параметров изделий';