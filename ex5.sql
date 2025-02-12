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

--1
create view vpartida as
select p.id, t.nome as time_1, t2.nome as time_2, p.time_1_gols, p.time_2_gols from partida p
join time t on p.time_1 = t.id
join time t2 on p.time_2 = t2.id;

select * from vpartida;

--2
select t.nome as time_1, t2.nome as time_2 from partida p
join time t on p.time_1 = t.id
join time t2 on p.time_2 = t2.id
where t.nome like '%A%' or t2.nome like '%C%';

--3
create or replace view classificacao as
select p.id, t.nome as time_1, t2.nome as time_2, p.time_1_gols, p.time_2_gols, 
    case 
        when p.time_1_gols > p.time_2_gols then t.nome 
        when p.time_1_gols < p.time_2_gols then t2.nome 
        else 'EMPATE' 
    end as vencedor
from partida p
join time t on p.time_1 = t.id
join time t2 on p.time_2 = t2.id
order by vencedor desc;


select * from classificacao;

--4
create or replace view vtime as
select t.id, t.nome, 
    count(
    case 
        when p.time_1 = t.id then 1
        when p.time_2 = t.id then 1
        else null
    end) as partidas,
    count(
    case 
        when p.time_1 = t.id and p.time_1_gols > p.time_2_gols then 1
        when p.time_2 = t.id and p.time_2_gols > p.time_1_gols then 1
        else null
    end) as vitorias,
    count(
    case 
        when p.time_1 = t.id and p.time_1_gols < p.time_2_gols then 1
        when p.time_2 = t.id and p.time_2_gols < p.time_1_gols then 1
        else null
    end) as derrotas,
    count(
    case 
        when p.time_1 = t.id and p.time_1_gols = p.time_2_gols then 1
        when p.time_2 = t.id and p.time_2_gols = p.time_1_gols then 1
        else null
    end) as empates,
    SUM(
    case 
        when p.time_1 = t.id and p.time_1_gols > p.time_2_gols then 3
        when p.time_2 = t.id and p.time_2_gols > p.time_1_gols then 3
        when p.time_1 = t.id and p.time_1_gols = p.time_2_gols then 1
        when p.time_2 = t.id and p.time_2_gols = p.time_1_gols then 1
        else 0
    end) as pontos
from time t
join partida p on t.id = p.time_1 or t.id = p.time_2
group by t.id
order by pontos desc;

select * from vtime;

--5
select * from classificacao;

--6
drop view vpartida;

drop table partida ,time