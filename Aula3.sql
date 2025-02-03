create table empregados (
    nome varchar(50),
    endereco varchar(50),
    cpf int primary key not null,
    datanasc date,
    sexo varchar(1),
    carttrab int,
    salario float,
    numdep int,
    cpfsuper int,
    constraint fk_cpfsuper foreign key(cpfsuper) references empregados(cpf)
);

create table departamentos (
    nomedep varchar(50),
    numdep int primary key not null,
    cpfger int,
    datainicioger date,
    constraint fk_cpfger foreign key(cpfger) references empregados(cpf)
);

create table projetos (
    nomeproj varchar(50),
    numproj int primary key not null,
    localizacao varchar(50),
    numd int,
    constraint fk_numd foreign key(numd) references departamentos(numdep)
);

create table dependentes (
    iddep int primary key not null,
    cpfe int,
    nomedep varchar(50),
    sexo varchar(1),
    parentesco varchar(50),
    constraint fk_cpfe foreign key(cpfe) references empregados(cpf)
);

create table trabalha_em (
    cpfe int,
    numproj int,
    horas float,
    constraint fk_cpfe foreign key(cpfe) references empregados(cpf),
    constraint fk_numproj foreign key(numproj) references projetos(numproj)
);

drop table empregados, departamentos, projetos, dependentes, trabalha_em;

alter table empregados 
add constraint fk_numdep
foreign key (numdep) references departamentos(numdep);

select * from empregados;

insert into departamentos values ('Dep1', 1, null, '1990-01-01'), ('Dep2', 2, null, '1990-01-01'), ('Dep3', 3, null, '1990-01-01');

insert into empregados values ('Joao', 'Rua 1', 123, '1990-01-01', 'M', 123, 1000.00, 1, null), ('Maria', 'Rua 2', 456, '1990-01-01', 'F', 456, 2000.00, 2, null), ('Jose', 'Rua 3', 101, '1990-01-01', 'M', 101, 4000.00, 3, null);

update departamentos set cpfger = 123 WHERE numdep = 1;
update departamentos set cpfger = 456 WHERE numdep = 2;
update departamentos set cpfger = 101 WHERE numdep = 3;

insert into projetos values ('Proj1', 1, 'Local1', 1), ('Proj2', 2, 'Local2', 2), ('Proj3', 3, 'Local3', 3);

insert into dependentes values (1, 123, 'Dep1', 'M', 'Filho'), (2, 456, 'Dep2', 'F', 'Filha'), (3, 101, 'Dep3', 'M', 'Filho');

insert into trabalha_em values (123, 1, 40), (456, 2, 40), (101, 3, 40);

select * from trabalha_em, departamentos, dependentes, projetos, empregados;

select nomeproj from projetos where nomeproj like 'P____';

select e.nome from empregados e where e.nome like  'J%';
select "nome" from empregados where "nome" like 'J%';

select e.nome, e.salario * 1.1 as SalarioAtualizado from empregados e;

select distinct e.nome, e.cpf from empregados e, trabalha_em t where e.cpf = t.cpfe;

(select distinct p.numproj from projetos p, departamentos d, empregados e where p.numd = d.numdep and d.cpfger = e.cpf and e.nome = 'Joao')
UNION
(select p.numproj from projetos p, empregados e, trabalha_em t where p.numproj = t.numproj and t.cpfe = e.cpf and e.nome = 'Joao');

select e.nome from empregados e
intersect
select e.nome from empregados e, departamentos d where d.cpfger = e.cpf;

select e.nome from empregados e where e.cpfsuper is null;
select e.nome from empregados e where e.cpfsuper is not null;

select AVG(salario) from empregados;

select MAX(salario) from empregados;

SELECT MIN(salario) FROM empregados;

select SUM(salario) from empregados;


(select e.cpf from empregados e
 inner join trabalha_em t on e.cpf = t.cpfe
 inner join projetos p on e.numdep = p.numd and t.numproj = p.numproj)

UNION

(select e.cpf 
 from empregados e
 inner join trabalha_em t on e.cpf = t.cpfe
 where t.horas = (select t.horas from trabalha_em t where t.cpfe = 123));


select distinct cpfe
from trabalha_em
where (numproj, horas) in
(select numproj, horas from trabalha_em where cpfe = 123);


select distinct nome
from empregados e
where (salario > (select salario from empregados where numdep = 2));

select nome from empregados
where salario > all (select salario from empregados where numdep = 2);




--------------------------------MYSQL------------------------------------------
create database escola;

create table alunos(
	id int primary key not null auto_increment,
    nome varchar(50),
    turma int,
    constraint fk_turma foreign key(turma) references turmas(id)
);

create table turmas(
	id int primary key not null auto_increment,
    serie int,
    variacao char(1)
);

insert into turmas (serie,variacao) values (1,'A'), (1,'B'),(1,'C'),(2,'A'),(1,'B'),(1,'C');

insert into alunos (nome, turma)
values
('João Silva', 1),
('Maria Souza', 2),
('Carlos Pereira', 3),
('Ana Lima', 4),
('Felipe Costa', 5);