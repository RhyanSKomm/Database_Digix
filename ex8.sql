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
    maquina_id integer,
    acao varchar(20),
    data timestamp default current_timestamp
);
create table log_usuario(
    id serial primary key,
    maquina_id integer,
    acao varchar(20),
    data timestamp default current_timestamp
);
create table log_software(
    id serial primary key,
    maquina_id integer,
    acao varchar(20),
    data timestamp default current_timestamp
);

create or replace function excluir_maquina()
returns trigger as $$
begin
    delete from Software where Fk_Maquina = old.Id_Maquina;
    insert into log_maquina(maquina_id, acao) values (old.Id_Maquina, 'DELETE');
    insert into log_software(maquina_id, acao) values (old.Id_Maquina, 'DELETE');
    return old;
end;
$$ language plpgsql;

create trigger excluir_maquina
after delete on Maquina
for each row
execute function excluir_maquina();

delete from Maquina where Id_Maquina = 1;

