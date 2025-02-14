--Operaçoes

create or replace function operacao_funcao() returns void as $$
declare
    v_id integer;
    v_nome varchar(50);
begin
    v_id := 1;
    v_nome := 'CORINTHIANS';
    raise notice 'ID: %, Nome: %', v_id, v_nome;

    v_id := v_id + 1;
    raise notice 'Soma: %', v_id;
    raise notice 'Subtração: %', v_id - 1;
    raise notice 'Multiplicação: %', v_id * 2;
    raise notice 'Divisão: %', v_id / 2;

    raise notice 'Maior: %', 1 > 1;
    raise notice 'Menor: %', 1 < 1;
    raise notice 'Maior ou igual: %', 1 >= 1;
    raise notice 'Menor ou igual: %', 1 <= 1;
    raise notice 'Igual: %', 1 = 1;
    raise notice 'Diferente: %', 1 <> 1;

    raise notice 'Concatenação: %', 'a' || 'b';

    raise notice 'E: %', true and true;
    raise notice 'Ou: %', true or false;
    raise notice 'Não: %', not true;

    raise notice 'Tamanho: %', length('Aula Digix');
    raise notice 'Substituição: %', replace('Aula Digix', 'Aula', 'Digix');
    raise notice 'Posição: %', position('Digix', 'Aula Digix');
    raise notice 'Substring: %', substring('Aula Digix', 6, 5);
    raise notice 'Maiúscula: %', upper('aula digix');
    raise notice 'Minúscula: %', lower('AULA DIGIX');
    raise notice 'Iniciais maiúsculas: %', initcap('aula digix');
    raise notice 'Trim: %', trim(' Aula Digix ');

    raise notice 'Data atual: %', now();
    raise notice 'Data atual: %', current_date;
    raise notice 'Dia: %', extract(day from current_date);
    raise notice 'Diferença de datas: %', age('2025-01-01', '2025-02-02');
    raise notice 'Intervalo: %', interval '1 day';

    raise notice 'Array: %', array[1, 2, 3];
    raise notice 'Array: %', array['Aula', 'Digix'];
    -- raise notice 'Array: %', array['Aula', 1, true];
    raise notice 'Matriz: %', array[[1, 2], [3, 4]];
    raise notice 'Matriz tridimensional: %', array[[[1, 2], [3, 4]], [[5, 6], [7, 8]]];
    
end;
$$ language plpgsql;

select operacao_funcao();

create or replace function obter_nome_time(p_id integer) returns varchar as $$
    declare
        v_nome varchar(50);
    begin
        select nome into v_nome from time where id = p_id;
        return v_nome;
    end;
$$ language plpgsql;

select obrter_nome_time(1);

create or replace function obter_times() returns setof time as $$
declare 
    i int := 1;
begin
    loop
        exit when i > 5;
        raise notice 'Valor de i:%', i;
        i :=i+1;
    end loop;

    for i in 1..5 loop
        raise notice 'Valor de i:%', i;
    end loop;

    while i <= 5 loop
        raise notice 'Valor de i:%', i;
        i := i + 1;
    end loop;
end;
$$ language plpgsql;

select * from obter_times();

create or replace function obter_times_dados() returns setof time as $$
declare 
    v_time time %rowtype;
begin 
    for v_time in select * from time loop 
    return next v_time;
    end loop;
end;
$$ language plpgsql;

select * from obter_times_dados();

create or replace function gols() returns setof time as $$
declare
    v_gols integer;
begin
    select time_1_gols into v_gols from partida where time_1 = 1;
    if v_gols > 2 then
        raise notice 'Time marcou mais de 2 gols';
    else
        raise notice 'Time marcou menos de 2 gols';
    end if;
end;
$$ language plpgsql;

select * from gols();

create or replace function obter_nome_time(id_time integer) returns varchar as $$
declare
    v_nome varchar(50);
begin
    select nome into v_nome from time where id = id_time;
    return v_nome;
    Exception
        when no_data_found then
            raise notice 'Time não encontrado';
end;
$$ language plpgsql;

select obter_nome_time(1);