CREATE TABLE time (
id INTEGER PRIMARY KEY,
nome VARCHAR(50)
);
CREATE TABLE partida (
id INTEGER PRIMARY KEY,
time_1 INTEGER,
time_2 INTEGER,
time_1_gols INTEGER,
time_2_gols INTEGER,
FOREIGN KEY(time_1) REFERENCES time(id),
FOREIGN KEY(time_2) REFERENCES time(id)
);
INSERT INTO time(id, nome) VALUES
(1,'CORINTHIANS'),
(2,'SÃO PAULO'),
(3,'CRUZEIRO'),
(4,'ATLETICO MINEIRO'),
(5,'PALMEIRAS');
INSERT INTO partida(id, time_1, time_2, time_1_gols, time_2_gols)
VALUES
(1,4,1,0,4),
(2,3,2,0,1),
(3,1,3,3,0),
(4,3,4,0,1),
(5,1,2,0,0),
(6,2,4,2,2),
(7,1,5,1,2),
(8,5,2,1,2);


--POSTGRES
create or replace procedure inserir_partida(id integer, time_1 integer, time_2 integer, time_1_gols integer, time_2_gols integer) as $$
begin
    insert into partida(id, time_1, time_2, time_1_gols, time_2_gols) values(id, time_1, time_2, time_1_gols, time_2_gols);
end;
$$ language plpgsql;



-- MYSQL
create procedure inserir_partida(
    id int,
    time_1 int,
    time_2 int, 
    time_1_gols int, 
    int time_2_gols
)
begin
    insert into partida(id, time_1, time_2, time_1_gols, time_2_gols) values(id, time_1, time_2, time_1_gols, time_2_gols);
end;

--CHAMANDO
call inserir_partida(9, 1,2,2,1);



create or replace procedure alterar_nome(id_time integer, novo_nome varchar(50)) as $$
begin
    update time 
    set nome = novo_nome
    where id = id_time;
    if not found then
            raise notice 'Time não encontrado';
        end if;
end;
$$ language plpgsql;

call alterar_nome(4,'FLUMINENSE');

select * from time ORDER BY id;


create or replace procedure delete_partida(id_partida integer) as $$
begin
    delete from partida where id = id_partida;
    if not found then
        raise notice 'Partida não encontrada';
    end if;
end;
$$ language plpgsql;

call delete_partida(9);

select * from partida;

drop table partida, time;

