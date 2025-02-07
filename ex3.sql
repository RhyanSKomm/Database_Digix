create database escola;

create table turma(
    idturma int primary key auto_increment,
    nome varchar(45),
    horario time,
    duracao int,
    dataInicio date,
    dataFim date,
    atividade_idatividade int,
    instrutor_idinstrutor int,
    foreign key (atividade_idatividade) references atividade(idatividade),
    foreign key (instrutor_idinstrutor) references instrutor(idinstrutor)
);

create table atividade(
    idatividade int primary key auto_increment,
    nome varchar(100)
);

create table instrutor(
    idinstrutor int primary key auto_increment,
    RG int,
    nome varchar(45),
    nascimento date,
    titulacao int
);

create table telefone_instrutor (
    idtelefone int primary key auto_increment,
    numero int,
    tipo varchar(45),
    instrutor_idinstrutor int,
    foreign key (instrutor_idinstrutor) references instrutor(idinstrutor)
);

create table aluno(
    codMatricula int primary key auto_increment,
    turma_idturma int,
    dataMatricula date,
    nome varchar(45),
    endereco text,
    telefone int,
    dataNascimento date,
    altura float,
    peso int,
    foreign key (turma_idturma) references turma(idturma)
);


create table chamada(
    idchamada int primary key auto_increment,
    data date,
    presente boolean,
    aluno_codMatricula int,
    turma_idturma int,
    foreign key (aluno_codMatricula) references aluno(codMatricula),
    foreign key (turma_idturma) references turma(idturma)
);


insert into atividade (nome) values 
('matemática'),
('física'),
('história'),
('química'),
('biologia');

insert into instrutor (RG, nome, nascimento, titulacao) values 
(123456789, 'carlos silva', '1980-02-15', 3),
(987654321, 'fernanda lima', '1985-06-25', 2),
(112233445, 'joão souza', '1975-08-10', 1),
(998877665, 'mariana pereira', '1990-11-05', 4),
(556677889, 'josé costa', '1982-03-20', 3);

insert into turma (nome, horario, duracao, dataInicio, dataFim, atividade_idatividade, instrutor_idinstrutor) values 
('Matemática Básica', '08:00:00', 120, '2025-02-01', '2025-06-01', 1, 1),
('Física Experimental', '10:00:00', 90, '2025-02-01', '2025-06-01', 2, 2),
('História do Brasil', '14:00:00', 110, '2025-02-01', '2025-06-01', 3, 3),
('Química Orgânica', '16:00:00', 100, '2025-02-01', '2025-06-01', 4, 4),
('Biologia Molecular', '18:00:00', 105, '2025-02-01', '2025-06-01', 5, 5);


insert into telefone_instrutor (numero, tipo, instrutor_idinstrutor) values 
(987654321, 'celular', 1),
(912345678, 'residencial', 2),
(998877665, 'celular', 3),
(955566443, 'residencial', 4),
(944322110, 'celular', 5);

insert into aluno (turma_idturma, dataMatricula, nome, endereco, telefone, dataNascimento, altura, peso) values 
(1, '2025-02-05', 'ana costa', 'rua das flores, 123', 912345678, '2000-07-10', 1.65, 55),
(2, '2025-02-06', 'lucas santos', 'av. paulista, 456', 988877665, '1998-03-22', 1.70, 68),
(3, '2025-02-07', 'maria oliveira', 'rua dos lírios, 789', 987654321, '1999-11-15', 1.60, 50),
(4, '2025-02-08', 'pedro alves', 'rua dos jacarandás, 101', 922334455, '1997-05-30', 1.75, 75),
(5, '2025-02-09', 'juliana pereira', 'av. liberdade, 202', 933445566, '1996-01-12', 1.58, 60);

insert into chamada (data, presente, aluno_codMatricula, turma_idturma) values 
('2025-02-05', true, 1, 1),
('2025-02-06', false, 2, 2),
('2025-02-07', true, 3, 3),
('2025-02-08', true, 4, 4),
('2025-02-09', false, 5, 5);




drop table turma, atividade, instrutor, telefone_instrutor, aluno, matricula, chamada;


select * from turma;
select * from atividade;
select * from instrutor;
select * from telefone_instrutor;
select * from aluno;
select * from matricula;
select * from chamada;

--1
select a.nome, t.nome as turma from aluno a
inner join turma t on idturma = turma_idturma;

--2
select t.nome as turma, count(a.turma_idturma) as quantidade_alunos from aluno a
inner join turma t on idturma = turma_idturma
group by t.nome;

--3
select avg(a.turma_idturma) as media_alunos_por_turma, datediff(t.dataFim, t.dataInicio) as duracao_turma from aluno a
inner join turma t on idturma = turma_idturma
group by t.nome, t.dataInicio, t.dataFim;

--4
select t.nome from aluno a
inner join turma t on idturma = turma_idturma
group by t.nome
having count(a.turma_idturma) > 3
order by t.nome;

--5
select i.nome , count (t.instrutor_idinstrutor) as quantidade_turmas from turma t
inner join instrutor i on idinstrutor = instrutor_idinstrutor
group by i.nome;

--6
select a.nome, count(c.aluno_codMatricula/ nullif(c.presente, 0))  from aluno a
inner join chamada c on codMatricula = aluno_codMatricula
where c.presente = true
group by a.nome;

--7
select i.nome, t.nome as turma from turma t
inner join instrutor i on i.idinstrutor = t.instrutor_idinstrutor
where t.nome = 'Matemática Básica' or t.nome = 'Química Orgânica';

---8
select a.nome, count(a.turma_idturma) 
from aluno a
group by a.nome
having count(a.turma_idturma) > 1;

--9
select t.nome, count(a.codMatricula) as quantidade_alunos from turma t
inner join aluno a on idturma = turma_idturma
group by t.nome
order by count(a.codMatricula) desc
limit 1;

--10
select a.nome, c.presente as faltas from chamada c
inner join aluno a on codMatricula = aluno_codMatricula
where c.presente = false not in (select c.presente from chamada c where c.presente = true);