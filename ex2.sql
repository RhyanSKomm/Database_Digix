create table filme(
	idFilme int primary key auto_increment,
    nomeBR varchar(45),
    nomeEN varchar(45),
    anoLancamento int,
    diretor_idDiretor int,
    sinopse text,
    genero_idGenero int,
    foreign key (diretor_idDiretor) references diretor(idDiretor),
    foreign key (genero_idGenero) references genero(idGenero)
);

create table diretor(
	idDiretor int primary key auto_increment,
    nome varchar(45)
);

create table genero(
    idGenero int primary key auto_increment,
    nome varchar(45)
);

create table filme_has_premiacao(
    filme_idFilme int,
    premiacao_idPremiacao int,
    ganhou boolean,
    foreign key (filme_idFilme) references filme(idFilme),
    foreign key (premiacao_idPremiacao) references premiacao(idPremiacao)
);

create table premiacao(
    idPremiacao int primary key auto_increment,
    nome varchar(45),
    ano int
);

create table filme_exibido_sala(
    filme_idFilme int,
    sala_idSala int,
    horario_idHorario int,
    foreign key (filme_idFilme) references filme(idFilme),
    foreign key (sala_idSala) references sala(idSala)
);

create table sala(
    idSala int primary key auto_increment,
    nome varchar(45),
    capacidade int
);

create table horario(
    idHorario int primary key auto_increment,
    horario time
);

create table horario_trabalho_funcionario(
    horario_idHorario int,
    funcionario_idFuncionario int,
    funcao_idFuncao int,
    foreign key (horario_idHorario) references horario(idHorario),
    foreign key (funcionario_idFuncionario) references funcionario(idFuncionario),
    foreign key (funcao_idFuncao) references funcao(idFuncao)
);

create table funcionario(
    idFuncionario int primary key auto_increment,
    nome varchar(45),
    carteiraTrabalho int,
    dataContratacao date,
    salario float
);

create table funcao(
    idFuncao int primary key auto_increment,
    nome varchar(45)
);


INSERT INTO diretor (nome) 
VALUES 
('Steven Spielberg'),
('Martin Scorsese'),
('Christopher Nolan'),
('Quentin Tarantino'),
('Ridley Scott');

INSERT INTO genero (nome)
VALUES
('Ação'),
('Drama'),
('Ficção Científica'),
('Terror'),
('Comédia');

INSERT INTO premiacao (nome, ano)
VALUES
('Oscar de Melhor Filme', 2023),
('Golden Globe de Melhor Diretor', 2022),
('Cannes Film Festival', 2021),
('BAFTA de Melhor Filme', 2023),
('Sundance Film Festival', 2022);

INSERT INTO sala (nome, capacidade)
VALUES
('Sala 1', 200),
('Sala 2', 150),
('Sala 3', 180),
('Sala 4', 120),
('Sala 5', 300);

INSERT INTO horario (horario)
VALUES
('10:00:00'),
('12:30:00'),
('15:00:00'),
('18:30:00'),
('21:00:00');

INSERT INTO filme (nomeBR, nomeEN, anoLancamento, diretor_idDiretor, sinopse, genero_idGenero)
VALUES
('Jurassic Park', 'Jurassic Park', 1993, 1, 'Um parque temático de dinossauros enfrenta um colapso de segurança quando os dinossauros começam a escapar.', 1),
('O Lobo de Wall Street', 'The Wolf of Wall Street', 2013, 2, 'A história de um corretor de ações que sobe ao topo da Wall Street com práticas fraudulentas.', 2),
('Interstellar', 'Interstellar', 2014, 3, 'Exploradores viajam por um buraco de minhoca em uma missão para salvar a Terra da extinção.', 3),
('Pulp Fiction', 'Pulp Fiction', 1994, 4, 'Histórias entrelaçadas de criminosos, drogas e violência em Los Angeles.', 4),
('Blade Runner', 'Blade Runner', 1982, 5, 'Um policial futurista é encarregado de caçar replicantes em um futuro distópico.', 3);

INSERT INTO filme_has_premiacao (filme_idFilme, premiacao_idPremiacao, ganhou)
VALUES
(1, 1, true),
(2, 2, false),
(3, 3, true),
(4, 4, true),
(5, 5, false);

INSERT INTO funcionario (nome, carteiraTrabalho, dataContratacao, salario)
VALUES
('João Silva', 123456, '2022-05-10', 2500.00),
('Maria Oliveira', 789012, '2021-08-15', 3000.00),
('Carlos Souza', 345678, '2020-11-20', 2200.00),
('Ana Costa', 901234, '2023-01-05', 2800.00),
('Pedro Lima', 567890, '2019-06-30', 3500.00);

INSERT INTO funcao (nome)
VALUES
('Atendente'),
('Gerente'),
('Vendedor'),
('Segurança'),
('Supervisor');

INSERT INTO horario_trabalho_funcionario (horario_idHorario, funcionario_idFuncionario, funcao_idFuncao)
VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5);

INSERT INTO filme_exibido_sala (filme_idFilme, sala_idSala, horario_idHorario)
VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5);


--1

select AVG(salario) from funcionario;

--2
select f.nome as Funcionario, ff.nome as Funçao from horario_trabalho_funcionario
inner join funcionario f on idFuncionario = funcionario_idFuncionario
inner join funcao ff on idFuncao = funcao_idFuncao;

--3
select f.nome
from funcionario f
where f.idFuncionario IN (
    select htf.funcionario_idFuncionario
    from horario_trabalho_funcionario htf
    where htf.horario_idHorario = (
        select htf2.horario_idHorario
        from horario_trabalho_funcionario htf2
        where htf2.funcionario_idFuncionario = f.idFuncionario
        limit 1
    )
);


--4
select f.nomeBR
from filme_exibido_sala fes
join filme f on f.idFilme = fes.filme_idFilme
where fes.sala_idSala != (
    select fes2.sala_idSala
    from filme_exibido_sala fes2
    where fes2.filme_idFilme = f.idFilme
    limit 1
);


--5
select distinct f.nomeBR, g.nome from filme f
inner join genero g on f.genero_idGenero = g.idGenero;

--6
select f.nomeBR
from filme_exibido_sala fes
inner join filme f on f.idFilme = fes.filme_idFilme
inner join filme_has_premiacao fhp on f.idFilme = fhp.filme_idFilme
inner join premiacao p on fhp.premiacao_idPremiacao = p.idPremiacao
inner join sala s on s.idSala = fes.sala_idSala
where fhp.ganhou = true
and fes.sala_idSala = s.idSala;

--7
select f.nomeBR from filme F
inner join filme_has_premiacao fhp on f.idFilme = fhp.filme_idFilme
where fhp.ganhou = false;

--8
select d.nome
from diretor d
inner join filme f on d.idDiretor = f.diretor_idDiretor
group by d.idDiretor
having count(f.idFilme) > 1;

--9
select f.nome, h.horario from horario_trabalho_funcionario htf
inner join funcionario f on f.idFuncionario = htf.funcionario_idFuncionario
inner join horario h on h.idHorario = htf.horario_idHorario
order by h.horario asc

--10
select f.nomeBR
from filme_exibido_sala fes
inner join filme f on f.idFilme = fes.filme_idFilme
inner join sala s on s.idSala = fes.sala_idSala
inner join horario h on h.idHorario = fes.horario_idHorario
where fes.sala_idSala = s.idSala
and fes.horario_idHorario != h.idHorario;

--11
create view ver_funcionarios as
select d.nome from diretor d

UNION

select f.nome from funcionario f;

select * from ver_funcionarios;

--12
select ff.nome, count(htf.funcionario_idFuncionario) as Quantidade
from horario_trabalho_funcionario htf
inner join funcao ff on ff.idFuncao = htf.funcao_idFuncao
group by ff.nome;

--13
select f.nomeBR, s.nome, s.capacidade
from filme_exibido_sala fes
inner join filme f on f.idFilme = fes.filme_idFilme
inner join sala s on s.idSala = fes.sala_idSala
where s.capacidade > (select AVG(s.capacidade) from sala s);

--14
select f.salario * 12 as SalarioAnual, f.nome from funcionario f;

--15
select s.nome as sala, s.capacidade, count(fes.filme_idFilme) as QuantidadeFilmes, count(fes.filme_idfilme)/nullif(s.capacidade, 0) as FilmePorCapacidade from sala s
inner join filme_exibido_sala fes on s.idSala = fes.sala_idSala
group by s.idSala, s.capacidade;