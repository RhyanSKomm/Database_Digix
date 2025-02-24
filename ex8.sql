CREATE TABLE Maquina (
Id_Maquina INT PRIMARY KEY NOT NULL,
Tipo VARCHAR(255),
Velocidade INT,
HardDisk INT,
Placa_Rede INT,
Memoria_Ram INT,
Fk_Usuario INT,
FOREIGN KEY(Fk_Usuario) REFERENCES Usuarios(ID_Usuario) on delete cascade
);
CREATE TABLE Usuarios (
ID_Usuario INT PRIMARY KEY NOT NULL,
Password VARCHAR(255),
Nome_Usuario VARCHAR(255),
Ramal INT,
Especialidade VARCHAR(255)
);
CREATE TABLE Software (
Id_Software INT PRIMARY KEY NOT NULL,
Produto VARCHAR(255),
HardDisk INT,
Memoria_Ram INT,
Fk_Maquina INT,
FOREIGN KEY(Fk_Maquina) REFERENCES Maquina(Id_Maquina) on delete cascade
);

insert into Maquina values (1, 'Desktop', 2, 500, 1, 4, 1);
insert into Maquina values (2, 'Notebook', 1, 250, 1, 2, 2);
insert into Maquina values (3, 'Desktop', 3, 1000, 1, 8, 3);
insert into Maquina values (4, 'Notebook', 2, 500, 1, 4, 4);
insert into Usuarios values (1, '123', 'Joao', 123, 'TI');
insert into Usuarios values (2, '456', 'Maria', 456, 'RH');
insert into Usuarios values (3, '789', 'Jose', 789, 'Financeiro');
insert into Usuarios values (4, '101', 'Ana', 101, 'TI');
insert into Software values (1, 'Windows', 100, 2, 1);
insert into Software values (2, 'Linux', 50, 1, 2);
insert into Software values (3, 'Windows', 200, 4, 3);
insert into Software values (4, 'Linux', 100, 2, 4);

create table log_maquina(
    id serial primary key,
    Id_Maquina integer,
    acao varchar(20),
    data timestamp default current_timestamp
);
create table log_usuario(
    id serial primary key,
    Id_Maquina integer,
    acao varchar(20),
    data timestamp default current_timestamp
);
create table log_software(
    id serial primary key,
    Id_Maquina integer,
    acao varchar(20),
    data timestamp default current_timestamp
);


--1
create or replace function excluir_maquina()
returns trigger as $$
begin
    insert into log_maquina(Id_Maquina, acao) values (old.Id_Maquina, 'delete');
    return old;
end;
$$ language plpgsql;

create trigger excluir_maquina
after delete on Maquina
for each row
execute procedure excluir_maquina();


delete from Maquina where Id_Maquina = 1;

select * from maquina


--2
create or replace function senha_fraca()
returns trigger as $$
begin
    if length(new.Password) < 8 then
        insert into log_usuario(Id_Maquina, acao) values (new.ID_Usuario, 'Senha fraca');
    end if;
    return new;
end;
$$ language plpgsql;

create trigger senha_fraca
before insert on Usuarios
for each row
execute function senha_fraca();

insert into Usuarios values (5, '123', 'Joao', 123, 'TI');
insert into Usuarios values (6, '456', 'Maria', 456, 'RH');

select * from log_usuario;

--3
create or replace function atualizar_contagem_de_software()
returns trigger as $$
begin
    insert into log_software(Id_Maquina, acao) values (new.Id_Software, 'update');
    return new;
end;
$$ language plpgsql;

create trigger atualizar_contagem_de_software
after update on Software
for each row
execute procedure atualizar_contagem_de_software();

update Software set Produto = 'Windows' where Id_Software = 1;

select * from log_software;

--4
create or replace function evitar_remocao_usuario()
returns trigger as $$
begin
    insert into log_usuario(Id_Maquina, acao) values (old.ID_Usuario, 'delete');
    raise exception 'Não é possível excluir usuário';
    return old;
end;
$$ language plpgsql;

create trigger evitar_remocao_usuario
before delete on Usuarios
for each row
execute procedure evitar_remocao_usuario();

delete from Usuarios where ID_Usuario = 2;

SELECT * FROM log_usuario;

select * from Usuarios;

--5
create table Memoria_Ram_Maquina(
    Id_Maquina integer,
    Memoria_Ram integer,
    acao varchar(20),
    data timestamp default current_timestamp
);

create or replace function calcular_memoria_maquina_after()
returns trigger as $$
begin

    update Maquina set Memoria_Ram = Memoria_Ram + new.Memoria_Ram where Id_Maquina = new.Fk_Maquina;
    insert into Memoria_Ram_Maquina(Id_Maquina, Memoria_Ram, acao) values (new.Fk_Maquina, new.Memoria_Ram, 'update');
    return new;
end;
$$ language plpgsql;

create trigger
calcular_memoria_maquina_after
after insert on Software
for each row
execute procedure calcular_memoria_maquina_after();

insert into Software values (6, 'Windows', 100, 2, 3);

select * from Memoria_Ram_Maquina;

create or replace function calcular_memoria_maquina_before_delete()
returns trigger as $$
begin
    update Maquina set Memoria_Ram = Memoria_Ram - old.Memoria_Ram where Id_Maquina = old.Fk_Maquina;
    insert into Memoria_Ram_Maquina(Id_Maquina, Memoria_Ram, acao) values (old.Fk_Maquina, old.Memoria_Ram, 'delete');
    return old;
end;
$$ language plpgsql;

create trigger
calcular_memoria_maquina_before_delete
before delete on Software
for each row
execute procedure calcular_memoria_maquina_before_delete();

delete from Software where Id_Software = 2;

select * from Memoria_Ram_Maquina;

--5 RESPOSTA

create or replace function atualizar_memoraria_ram()
returns trigger as $$
begin
    update Maquina set Memoria_Ram = (select coalesce(sum(Memoria_Ram), 0) from Software where Fk_Maquina = coalesce(new.Fk_Maquina, old.Fk_Maquina))
    where Id_Maquina = coalesce(new.Fk_Maquina, old.Fk_Maquina);
    return new;
end;
$$ language plpgsql;

create trigger atualizar_memoraria_ram
after insert or delete on Software
for each row
execute function atualizar_memoraria_ram();

insert into Software values (7, 'Windows', 100, 2, 3);

--6
create or replace function registrar_alteracao_especialidade()
returns trigger as $$
begin
    insert into log_usuario(Id_Maquina, acao) values (new.ID_Usuario, 'update');
    return new;
end;
$$ language plpgsql;

create trigger registrar_alteracao_especialidade
before update of Especialidade on Usuarios
for each row
execute procedure registrar_alteracao_especialidade();

update Usuarios set Especialidade = 'TI' where ID_Usuario = 3;

select * from log_usuario;

--7
create or replace function impedir_exclusao_software()
returns trigger as $$
begin
    raise exception 'Não é possível excluir software';
    return null;
end;
$$ language plpgsql;

create trigger impedir_exclusao_software
before delete on Software
for each row
execute procedure impedir_exclusao_software();

delete from Software where Id_Software = 3;

create database DesafioBD