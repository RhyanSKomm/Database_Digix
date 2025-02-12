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



--Função


create function soma (a int, b int) returns int 
deterministic
begin
    return a+b;
end;

select soma(10,20);


CREATE PROCEDURE insere_partida (IN time1 INT, IN time2 INT, IN gols1 INT, IN gols2 INT)
BEGIN
    INSERT INTO partida (time_1, time_2, time_1_gols, time_2_gols)
    VALUES (time1, time2, gols1, gols2);
END;

create or replace function consulta_time() returns time as
begin
    return query select * from time;
end;

create or replace function consulta_vencedor_por_time(id_time integer) returns setof varchar(50) as $$
declare
    vencedor varchar(50);
begin
    select case
        when time_1_gols > time_2_gols (select nome from time where id = time_1)
        when time_1_gols < time_2_gols (select nome from time where id = time_2)
            else 'EMPATE'
        end into vencedor
        from partida
        where time_1 = id_time or time_2 = id_time;
        return vencedor;
end;
$$ language plpgsql;