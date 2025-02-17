create table Empregado (
Nome varchar(50),
Endereco varchar(500),
CPF int primary key not null,
DataNasc date,
Sexo char(10),
CartTrab int,
Salario float,
NumDep int,
CPFSup int
);
alter table Empregado add foreign key (NumDep) references Departamento(NumDep);


create table Departamento (
NomeDep varchar(50),
NumDep int primary key not null,
CPFGer int,
DataInicioGer date,
foreign key (CPFGer) references Empregado(CPF)
);


create table Projeto (
NomeProj varchar(50),
NumProj int primary key not null,
Localizacao varchar(50),
NumDep int,
foreign key (NumDep) references Departamento(NumDep)
);


create table Dependente (
idDependente int primary key not null,
CPFE int,
NomeDep varchar(50),
Sexo char(10),
Parentesco varchar(50)
);


create table Trabalha_Em (
CPF int,
NumProj int,
HorasSemana int,
foreign key (CPF) references Empregado(CPF),
foreign key (NumProj) references Projeto(NumProj)
);

alter table Dependente add foreign key (CPFE) references Empregado(CPF);

-- Inserir os dados
insert into Departamento values ('Dep1', 1, null, '1990-01-01');
insert into Departamento values ('Dep2', 2, null, '1990-01-01');
insert into Departamento values ('Dep3', 3, null, '1990-01-01');
insert into Empregado values ('Joao', 'Rua 1', 123, '1990-01-01', 'M', 123, 1000, 1, null);
insert into Empregado values ('Maria', 'Rua 2', 456, '1990-01-01', 'F', 456, 2000, 2, null);
insert into Empregado values ('Jose', 'Rua 3', 789, '1990-01-01', 'M', 789, 3000, 3, null);
update Departamento set CPFGer = 123 where NumDep = 1;
update Departamento set CPFGer = 456 where NumDep = 2;
update Departamento set CPFGer = 789 where NumDep = 3;
insert into Projeto values ('Proj1', 1, 'Local1', 1);
insert into Projeto values ('Proj2', 2, 'Local2', 2);
insert into Projeto values ('Proj3', 3, 'Local3', 3);
insert into Dependente values (1, 123, 'Dep1', 'M', 'Filho');
insert into Dependente values (2, 456, 'Dep2', 'F', 'Filha');
insert into Dependente values (3, 789, 'Dep3', 'M', 'Filho');
insert into Trabalha_Em values (123, 1, 40);
insert into Trabalha_Em values (456, 2, 40);
insert into Trabalha_Em values (789, 3, 40);

--1
create or replace function salario(CPF int) returns float as $$
declare
    sal float;
begin
    select Salario into sal from Empregado;
    return sal;
end;
$$ language plpgsql;

select salario(123);

--2
create or replace function nomeDepartamento(NumDp int) returns varchar as $$
declare
    nome varchar(50);
begin
    select NomeDep into nome from Departamento where NumDep = NumDp;
    return nome;
end;
$$ language plpgsql;

select nomeDepartamento(1);

--3
create or replace function nomeGerente(NumDpp int) returns varchar as $$
declare
    nomeG varchar(50);
begin
    select Empregado.Nome into nomeG from Departamento
    inner join Empregado on Departamento.CPFGer = Empregado.CPF
    where Departamento.NumDep = NumDpp;
    return nomeG; 
end;
$$ language plpgsql;

select nomeGerente(1);

--4
create or replace function nomeProjeto(cpfpk int) returns varchar as $$
declare
    nomeP varchar(50);
begin 
    select Projeto.NomeProj into nomeP from Empregado
    inner join Trabalha_Em on Empregado.CPF = Trabalha_Em.CPF
    inner join Projeto on Trabalha_Em.NumProj = Projeto.NumProj
    where Empregado.CPF = cpfpk;
    return nomeP;
end;
$$ language plpgsql;

select nomeProjeto(123);

--5
create or replace function nomeDependente(cpfpk int) returns varchar as $$
declare
    nomeD varchar(50);
begin
    select Dependente.NomeDep into nomeD from Empregado
    inner join Dependente on Empregado.CPF = Dependente.CPFE
    where Empregado.CPF = cpfpk;
    return nomeD;
end;
$$ language plpgsql;

select nomeDependente(123);

--6
create or replace function nomeGerenteDoEmpregado(cpfpk int) returns varchar as $$
declare
    nomeG varchar(50);
begin
    select Empregado.Nome into nomeG from Departamento
    join Empregado on Departamento.CPFGer = Empregado.CPF
    join Empregado E on Departamento.NumDep = Empregado.NumDep
    join Empregado G on Departamento.CPFGer = Empregado.CPF
    where E.CPF = cpfpk and G.NumDep = E.NumDep;
    return nomeG;
end;
$$ language plpgsql;

select nomeGerenteDoEmpregado(123);

--7
create or replace function horasTrabalhadas(cpfpk int) returns int as $$
declare
    horas int;
begin
    select HorasSemana into horas from Empregado 
    join Trabalha_Em on Empregado.CPF = Trabalha_Em.CPF
    where Empregado.CPF = cpfpk;
    return horas;
end;
$$ language plpgsql;

select horasTrabalhadas(123);

--8 
create or replace function salarioEmpregado(cpfpk int) returns float as $$
declare
    sal float;
begin
    begin
        select Salario into sal from Empregado where CPF = cpfpk;
        
        if salario is null then
            raise notice 'Empregado não encontrado';
        end if;
    exception
        when others then
            raise notice 'Erro ao buscar salario';
    end;
    return sal;
end;
$$ language plpgsql;

select salarioEmpregado(11423);

drop