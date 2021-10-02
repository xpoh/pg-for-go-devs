INSERT INTO public.items(name, parent_id)  VALUES ('Самолет', 0) ON CONFLICT(id) DO NOTHING;
INSERT INTO public.items(name, parent_id)  VALUES ('Вертолет', 0) ON CONFLICT(id) DO NOTHING;
INSERT INTO public.items(name, parent_id)  VALUES ('Автомобиль', 0) ON CONFLICT(id) DO NOTHING;
INSERT INTO public.items(name, parent_id)  VALUES ('Двигатель', 1) ON CONFLICT(id) DO NOTHING;


INSERT INTO public.params(name)  VALUES ('Масса') ON CONFLICT(id) DO NOTHING;
INSERT INTO public.params(name)  VALUES ('Скорость') ON CONFLICT(id) DO NOTHING;
INSERT INTO public.params(name)  VALUES ('Цена') ON CONFLICT(id) DO NOTHING;
INSERT INTO public.params(name)  VALUES ('Ускорение') ON CONFLICT(id) DO NOTHING;

INSERT INTO public.workspaces(name) VALUES ('Весовая лаборатория') ON CONFLICT(id) DO NOTHING;
INSERT INTO public.workspaces(name) VALUES ('Лаборатория скорости') ON CONFLICT(id) DO NOTHING;

INSERT INTO public.tests(id_item, id_workspace, date, name) VALUES (1, 1, '01-01-2021', 'Проверка в производстве');
INSERT INTO public.tests(id_item, id_workspace, date, name) VALUES (1, 1, '01-02-2021', 'Проверка ОТК');

INSERT INTO public.proc(id_test, id_param, value, raw_data, misc) VALUES (1, 1, -124, NULL, 'все ок');
INSERT INTO public.proc(id_test, id_param, value, raw_data, misc) VALUES (1, 2, 111, NULL, 'все ок');
INSERT INTO public.proc(id_test, id_param, value, raw_data, misc) VALUES (2, 3, 222, NULL, 'все ок');
INSERT INTO public.proc(id_test, id_param, value, raw_data, misc) VALUES (1, 3, 333, NULL, 'все ок');
INSERT INTO public.proc(id_test, id_param, value, raw_data, misc) VALUES (2, 2, 444, NULL, 'все ок');

