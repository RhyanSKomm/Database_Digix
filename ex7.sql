CREATE TABLE Maquina (
Id_Maquina INT PRIMARY KEY NOT NULL,
Tipo VARCHAR(255),
Velocidade INT,
HardDisk INT,
Placa_Rede INT,
Memoria_Ram INT,
Fk_Usuario INT,
FOREIGN KEY(Fk_Usuario) REFERENCES Usuarios(ID_Usuario)
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
FOREIGN KEY(Fk_Maquina) REFERENCES Maquina(Id_Maquina)
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


--1
create or replace function Espaco_Disponivel(Id_Maqui integer, Id_Soft integer) returns boolean as $$
declare
    espaco_maquina integer;
    espaco_software integer;
begin
    select m.HardDisk, s.HardDisk into espaco_maquina, espaco_software from Software s
    join Maquina m on m.Id_Maquina = s.Fk_Maquina
    where m.Id_Maquina = Id_Maqui and s.Id_Software = Id_Soft;
    if espaco_maquina >= espaco_software then
        return True;
    else
        return False;
    end if;
end;
$$ language plpgsql;

SELECT * from Espaco_Disponivel(2,2);

--2
create or replace procedure Instalar_Software

--3
create or replace function Maquinas_Do_Usuario(u_id integer) returns void as $$
declare
    maquina varchar(255);
begin
    select m.Tipo into maquina from maquina m
    join usuarios u on  u.id_usuario = m.fk_usuario
    where u.id_usuario = u_id;
    RAISE NOTICE 'Machine type: %', maquina;
end;
$$ language plpgsql;

SELECT * FROM Maquinas_Do_Usuario(1);

--4
create procedure Atualizar_Recurso_Maquina(m_id integer, qnt_memoria integer) as $$
begin
    update maquina
    set Memoria_Ram = qnt_memoria
    where Id_Maquina = m_id;
end;
$$ language plpgsql;


call Atualizar_Recurso_Maquina(2, 8);

select * from maquina

--5
create or replace procedure Transferir_Software(s_id integer, m_id integer) as $$
declare
    espaco_maquina integer;
    espaco_software integer;
begin
    select s.HardDisk, m.harddisk into espaco_software, espaco_maquina from software s
    join maquina m on m.id_maquina = s.fk_maquina
    where m.id_maquina = m_id and s.id_software = s_id;
    if espaco_maquina >= espaco_software then
        update software
        set Fk_Maquina = m_id
        where id_software = s_id;
    else   
        raise notice 'Espaço insuficiente';
    end if;
end;
$$ language plpgsql;

call Transferir_Software (2,3)

select * from software;

--6
create or replace function Media_Recursos() returns float as $$
declare
    media_memoria float;
    media_espaco float;
begin
    select AVG(Memoria_Ram), AVG(HardDisk) into media_memoria, media_espaco from maquina;
    RETURN (media_memoria + media_espaco) / 2;
end;
$$ language plpgsql;

SELECT * from  Media_Recursos()

--7
create or replace procedure Diagnostico_Maquina(Id_Maquina1 integer) as $$
declare
    Total_Ram_Requerida integer;
    Total_HardDisk_Requerido integer;
    HardDisk_Atual integer;
    Ram_Atual integer;
    Ram_Upgrade integer;
    HardDisk_Upgrade integer;
begin
    select
        coalesce(sum(Memoria_Ram), 0),
        coalesce(sum(HardDisk), 0)
    into
        Total_Ram_Requerida,
        Total_HardDisk_Requerido
    from 
        Software s
    where
        fk_maquina = Id_Maquina1;
    

    select
        Memoria_Ram,
        HardDisk
    into
        Ram_Atual,
        HardDisk_Atual
    from
        Maquina
    where
        Id_Maquina = id_maquina1;

    if not found then
        raise notice 'Maquina não encontrada';
    end if;

    if Ram_Atual >= Total_HardDisk_Requerido and HardDisk_Atual >= Total_HardDisk_Requerido then
        raise notice 'Maquina % tem recursos suficientes e não precisa de upgrade', Id_Maquina1;
        else 
            Ram_Upgrade := greatest(0, Total_Ram_Requerida - Ram_Atual);
            HardDisk_Upgrade := greatest(0, Total_HardDisk_Requerido - HardDisk_Atual);

            raise notice 'Maquina % precisa de upgrade',Id_Maquina1;

            if Ram_Upgrade > 0 then
                raise notice 'Upgrade de % GB de memoria RAM', Ram_Upgrade;
            end if;

            if HardDisk_Upgrade > 0 then
                raise notice 'Upgrade de % GB de HardDisk', HardDisk_Upgrade;
            end if;
    end if;
end;
$$ language plpgsql;
    

drop procedure Diagnostico_Maquina;
call Diagnostico_Maquina(2);

create database trigger;