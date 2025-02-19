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

create table log_partida(
    id serial primary key,
    partida_id integer,
    acao varchar(20),
    data timestamp default current_timestamp
);

--MYSQL
create trigger log_partida_insert
after insert on partida
for each row
begin
    insert into log_partida(partida_id, acao) values (new.id, 'INSERT');
end;

--POSTGRES
create or replace function log_partida_insert()
returns trigger as $$
begin
    insert into log_partida(partida_id, acao) values (new.id, 'INSERT');
    return new;
end;
$$ language plpgsql;

create trigger log_partida_insert
after insert on partida
for each row
execute function log_partida_insert();

insert into partida(id, time_1, time_2, time_1_gols, time_2_gols)
values(9, 1,2,2,1);

select * from log_partida;


--MYSQL
create function insert_partida() 
returns trigger as $$
begin
    if new.time_1 = new.time_2 then
        raise exception 'Times iguais';
    end if;
    return new;
end;
$$ language plpgsql;


--POSTGRES
create trigger insert_partida
before insert on partida
for each row
execute procedure insert_partida();

insert into partida(id, time_1, time_2, time_1_gols, time_2_gols) values(10, 1,1,2,1);

create view partidas_v as select id, time_1, time_2, time_1_gols, time_2_gols from partida;

create or replace function insert_partida_v()
returns trigger as $$
begin
    insert into partida(id, time_1, time_2, time_1_gols, time_2_gols) values(new.id, new.time_1, new.time_2, new.time_1_gols, new.time_2_gols);
    return null;
end;
$$ language plpgsql;

create trigger inserir_partida_v
instead of insert on partidas_v
for each row
execute function insert_partida_v();

insert into partidas_v(id, time_1, time_2, time_1_gols, time_2_gols) values(11, 1,2,2,1);

select * from insert_partida_v;


create or replace function update_partida()
returns trigger as $$
begin
    insert into log_partida(partida_id, acao) values (new.id, 'UPDATE');
    return new;
end;
$$ language plpgsql;

create trigger update_partida
after update on partida
for each row
execute procedure update_partida();

update partida set time_1_gols = 3 where id = 11;
select * from log_partida;

create or replace function update_partida() returns trigger as $$
begin 
    if old.time_1_gols is not null then
        raise exception 'Times iguais';
    end if;
    return new;
end;
$$ language plpgsql;

create trigger update_partida_c
before update on partida
for each row
execute procedure update_partida();

update partida set time_1 = 1, time_2 = 1 where id = 11;

select * from log_partida;


create or replace function delete_partida()
returns trigger as $$
begin
    raise exception 'Não pode deletar';
end;
$$ language plpgsql;

create or replace trigger delete_partida
before delete on partida
for each row
execute procedure delete_partida();

delete from partida where id = 11;

create database ex8;
