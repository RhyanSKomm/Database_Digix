create  table usuarios (
    id_usuario serial primary key not null,
    password varchar(50) not null,
    nome_usuario varchar (50) not null,
    ramal int not null,
    especialidade varchar(50) not null
);

create table maquinas (
    id_maquina serial primary key not null,
    tipo varchar(50),
    velocidade varchar(50),
    hard_disk int,
    placa_rede int,
    memoria_ram int
);

create table software (
    id_software serial primary key not null,
    produto varchar(50),
    hard_disk int,
    memoria_ram int
);

create table possuem (
    id_usuario int not null,
    id_maquina int not null,
    constraint fk_usuario foreign key(id_usuario) references usuarios(id_usuario),
    constraint fk_maquina foreign key(id_maquina) references maquinas(id_maquina)
);

create table contem (
    id_maquina int not null,
    id_software int not null,
    constraint fk_maquina foreign key(id_maquina) references maquinas(id_maquina),
    constraint fk_software foreign key(id_software) references software(id_software)
);

INSERT INTO usuarios (password, nome_usuario, ramal, especialidade)
VALUES ('senha123', 'João Silva', 101, 'Desenvolvimento'), ('abc456', 'Maria Oliveira', 102, 'Suporte Técnico'), ('qwerty', 'Carlos Souza', 103, 'Redes'), ('admin123', 'Ana Costa', 104, 'Banco de Dados'), ('teste321', 'Pedro Rocha', 105, 'Segurança');

INSERT INTO maquinas (tipo, velocidade, hard_disk, placa_rede, memoria_ram)
VALUES ('Desktop', 'Core i5', 1000, 1000, 16), ('Notebook', 'Core i7', 500, 1200, 8), ('Servidor', 'Xeon E5', 2000, 10000, 64), ('Workstation', 'Core i9', 1500, 1000, 32), ('Pentium', 'Core II', 1000, 600, 16);

INSERT INTO software (produto, hard_disk, memoria_ram)
VALUES ('Windows 11', 20, 4), ('C++', 5, 8), ('C++', 10, 16),('Visual Studio Code', 1, 2), ('Google Chrome', 2, 4);

INSERT INTO possuem (id_usuario, id_maquina) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5);

INSERT INTO contem (id_maquina, id_software) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5);

--1
select from usuarios where especialidade = 'técnico';

--2
select m.tipo, m.velocidade from maquinas m;

--3
select m.tipo, m.velocidade from maquinas m where velocidade = 'Core II' and tipo = 'Pentium';

--4
select m.id_maquina, m.tipo, m.placa_rede from maquinas m where placa_rede < 1000;

--5
select u.nome_usuario from possuem p
inner join usuarios u on u.id_usuario = p.id_usuario
inner join maquinas m on m.id_maquina = p.id_maquina
where m.velocidade = 'Core i9' or m.velocidade = 'Core V';

--6
select m.id_maquina from contem C
inner join maquinas m on m.id_maquina = c.id_maquina
inner join software s on s.id_software = c.id_software
where s.produto = 'C++';

--7
select m.id_maquina, m.memoria_ram, s.produto, s.memoria_ram from contem c
inner join maquinas m on m.id_maquina = c.id_maquina
inner join software s on s.id_software = c.id_software
where s.memoria_ram > m.memoria_ram;

--8
select u.nome_usuario, m.velocidade from possuem p
inner join usuarios u on u.id_usuario = p.id_usuario
inner join maquinas m on m.id_maquina = p.id_maquina;

--9
select u.id_usuario, u.nome_usuario from possuem p
inner join usuarios u on u.id_usuario = p.id_usuario
inner join maquinas m on m.id_maquina = p.id_maquina
where u.id_usuario < ( select u.id_usuario from usuarios u where u.nome_usuario = 'Maria Oliveira');

--10
select count(m.id_maquina) from maquinas m where hard_disk > 1000;

--11
select count(u.id_usuario) from possuem p
inner join usuarios u on u.id_usuario = p.id_usuario
inner join maquinas m on m.id_maquina = p.id_maquina
where p.id_usuario = p.id_maquina;

--12
select count(u.id_usuario) from possuem p
inner join usuarios u on u.id_usuario = p.id_usuario
inner join maquinas m on m.id_maquina = p.id_maquina
group by p.id_maquina;

--13
select count(u.id_usuario) from possuem p
inner join usuarios u on u.id_usuario = p.id_usuario
inner join maquinas m on m.id_maquina = p.id_maquina
where m.tipo = 'Desktop';

--14
select count(m.hard_disk) from maquinas m where m.hard_disk > 1000;

--15
select s.hard_disk from contem c
inner join software s on s.id_software = c.id_software
inner join maquinas m on m.id_maquina = c.id_maquina;

--16
select m.hard_disk / s.hard_disk from contem c
inner join software s on s.id_software = c.id_software
inner join maquinas m on m.id_maquina = c.id_maquina;

--17
select count(m.id_maquina) from maquinas m group by m.tipo;

--18
select count(s.produto) from software s where s.hard_disk > 5 and s.hard_disk < 15;

--19
select s.id_software, s.produto from software s where s.produto like '%o%';

--20
select s.produto, m.hard_disk from contem c
inner join software s on s.id_software = c.id_software
inner join maquinas m on m.id_maquina = c.id_maquina

--21
select s.produto from contem c
inner join software s on s.id_software = c.id_software
inner join maquinas m on m.id_maquina = c.id_maquina
where s.id_software = m.id_maquina
limit 1;