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





-- MSSQL



-- Эта функция выполняет сравнение двух строк (a и b) по правилам "альфанумерического" (или "естественного") порядка
CREATE OR ALTER FUNCTION dbo.alphanum_compare(@a NVARCHAR(MAX), @b NVARCHAR(MAX))
    RETURNS INT
AS
BEGIN
    DECLARE @a_chunk NVARCHAR(MAX)
    DECLARE @b_chunk NVARCHAR(MAX)
    DECLARE @a_rest NVARCHAR(MAX) = ISNULL(@a, '')
    DECLARE @b_rest NVARCHAR(MAX) = ISNULL(@b, '')
    DECLARE @a_num BIGINT
    DECLARE @b_num BIGINT
    DECLARE @is_a_num BIT
    DECLARE @is_b_num BIT
    DECLARE @a_pos INT
    DECLARE @b_pos INT

    WHILE LEN(@a_rest) > 0 OR LEN(@b_rest) > 0
        BEGIN
            -- Обработка для @a_rest
            SET @a_pos = PATINDEX('%[0-9]%', @a_rest)
            IF @a_pos = 0
                SET @a_chunk = @a_rest
            ELSE IF @a_pos = 1
                SET @a_chunk = LEFT(@a_rest, PATINDEX('%[^0-9]%', @a_rest + 'X') - 1)
            ELSE
                SET @a_chunk = LEFT(@a_rest, @a_pos - 1)

            -- Обработка для @b_rest
            SET @b_pos = PATINDEX('%[0-9]%', @b_rest)
            IF @b_pos = 0
                SET @b_chunk = @b_rest
            ELSE IF @b_pos = 1
                SET @b_chunk = LEFT(@b_rest, PATINDEX('%[^0-9]%', @b_rest + 'X') - 1)
            ELSE
                SET @b_chunk = LEFT(@b_rest, @b_pos - 1)

            IF LEN(@a_chunk) = 0 AND LEN(@b_chunk) = 0
                RETURN 0

            IF LEN(@a_chunk) = 0
                RETURN -1

            IF LEN(@b_chunk) = 0
                RETURN 1

            -- Проверяем, являются ли части числами
            SET @is_a_num = CASE WHEN @a_chunk NOT LIKE '%[^0-9]%' AND LEN(@a_chunk) > 0 THEN 1 ELSE 0 END
            SET @is_b_num = CASE WHEN @b_chunk NOT LIKE '%[^0-9]%' AND LEN(@b_chunk) > 0 THEN 1 ELSE 0 END

            IF @is_a_num = 1 AND @is_b_num = 1
                BEGIN
                    -- Сравниваем числа
                    SET @a_num = TRY_CAST(@a_chunk AS BIGINT)
                    SET @b_num = TRY_CAST(@b_chunk AS BIGINT)

                    IF @a_num < @b_num RETURN -1
                    IF @a_num > @b_num RETURN 1
                END
            ELSE
                BEGIN
                    -- Сравниваем как строки
                    IF @a_chunk < @b_chunk RETURN -1
                    IF @a_chunk > @b_chunk RETURN 1
                END

            -- Обрезаем обработанную часть
            SET @a_rest = STUFF(@a_rest, 1, LEN(@a_chunk), '')
            SET @b_rest = STUFF(@b_rest, 1, LEN(@b_chunk), '')
        END

    RETURN 0
END


-- Эта функция преобразует строку в "ключ сортировки", который сохраняет альфанумерический порядок
CREATE OR ALTER FUNCTION dbo.alphanum_sort_key(@input_string NVARCHAR(MAX))
    RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @result NVARCHAR(MAX) = ''
    DECLARE @chunk NVARCHAR(MAX)
    DECLARE @remaining_text NVARCHAR(MAX) = ISNULL(@input_string, '')
    DECLARE @num_length INT = 30
    DECLARE @pos INT
    DECLARE @non_num_pos INT

    WHILE LEN(@remaining_text) > 0
        BEGIN
            SET @pos = PATINDEX('%[0-9]%', @remaining_text)

            IF @pos = 0
                SET @chunk = @remaining_text
            ELSE IF @pos = 1
                BEGIN
                    SET @non_num_pos = PATINDEX('%[^0-9]%', @remaining_text + 'X')
                    SET @chunk = LEFT(@remaining_text, @non_num_pos - 1)
                END
            ELSE
                SET @chunk = LEFT(@remaining_text, @pos - 1)

            -- Если блок числовой, добавляем ведущие нули
            IF @chunk LIKE '[0-9]%' AND @chunk NOT LIKE '%[^0-9]%'
                SET @result = @result + RIGHT(REPLICATE('0', @num_length) + @chunk, @num_length)
            ELSE
                SET @result = @result + @chunk

            SET @remaining_text = STUFF(@remaining_text, 1, LEN(@chunk), '')
        END

    RETURN CASE WHEN @input_string IS NULL THEN NULL ELSE @result END
END

RETURN result;
END;
$$ LANGUAGE plpgsql IMMUTABLE;
