-- Эта функция выполняет сравнение двух строк (a и b) по правилам "альфанумерического" (или "естественного") порядка
CREATE OR REPLACE FUNCTION alphanum_compare(a text, b text) RETURNS integer AS $$
DECLARE
a_chunk text;
    b_chunk text;
    a_rest text := COALESCE(a, '');
    b_rest text := COALESCE(b, '');
    a_num bigint;
    b_num bigint;
    is_a_num boolean;
    is_b_num boolean;
BEGIN
    -- Цикл продолжается, пока хотя бы одна строка не будет полностью обработана
    WHILE a_rest <> '' OR b_rest <> '' LOOP
            -- Извлекаем части до первого числа или нечислового блока
            a_chunk := substring(a_rest from '^([^0-9]*|[0-9]+)');
            b_chunk := substring(b_rest from '^([^0-9]*|[0-9]+)');

            IF a_chunk = '' AND b_chunk = '' THEN
                RETURN 0; -- строки идентичны
            ELSIF a_chunk = '' THEN
                RETURN -1; -- `a` короче, значит, она должна быть раньше
            ELSIF b_chunk = '' THEN
                RETURN 1; -- `b` короче, значит, она должна быть раньше
END IF;

            -- Проверяем, являются ли части числами
            is_a_num := a_chunk ~ '^[0-9]+$';
            is_b_num := b_chunk ~ '^[0-9]+$';

            IF is_a_num AND is_b_num THEN
                -- Сравниваем числа
                a_num := a_chunk::bigint;
                b_num := b_chunk::bigint;

                IF a_num < b_num THEN
                    RETURN -1;
                ELSIF a_num > b_num THEN
                    RETURN 1;
END IF;
ELSE
                -- Сравниваем как строки
                IF a_chunk < b_chunk THEN
                    RETURN -1;
                ELSIF a_chunk > b_chunk THEN
                    RETURN 1;
END IF;
END IF;

            -- Обрезаем обработанную часть
            a_rest := substring(a_rest from length(a_chunk) + 1);
            b_rest := substring(b_rest from length(b_chunk) + 1);
END LOOP;

RETURN 0;
END;
$$ LANGUAGE plpgsql IMMUTABLE;





-- Эта функция преобразует строку в "ключ сортировки", который сохраняет альфанумерический порядок
CREATE OR REPLACE FUNCTION alphanum_sort_key(text) RETURNS text AS $$
DECLARE
result text := '';
    chunk text;
    remaining_text text := $1;
BEGIN
    -- Если входное значение NULL, возвращаем NULL
    IF remaining_text IS NULL THEN
        RETURN NULL;
    END IF;

    WHILE remaining_text != '' LOOP
            chunk := substring(remaining_text from '^([^0-9]*|[0-9]+)');

            IF chunk ~ '^[0-9]+$' THEN
                -- Форматируем числа с ведущими нулями
                result := result || lpad(chunk, 30, '0');
ELSE
                result := result || chunk;
END IF;

            remaining_text := substring(remaining_text from length(chunk) + 1);
END LOOP;

RETURN result;
END;
$$ LANGUAGE plpgsql IMMUTABLE;