create table Predio(
    idPredio int primary key auto_increment,
    nome varchar(45),
    apPorAndar int,
    edificacao int,
    foreign key (edificacao) references Edificacao(idEdificacao)
    );

create table Casa(
    idCasa int primary key auto_increment,
    condominio boolean,
    edificacao int,
    foreign key (edificacao) references Edificacao(idEdificacao)
);

create table CasaSobrado(
    idCasaSobrado int primary  auto_increment,
    numAndares int,
    idCasa int,
    foreign key (idCasa) references Casa(idCasa)
);

create table Edificacao(
    idEdificacao int primary key auto_increment,
    metraemTotal float,
    endereco text,
    responsavel int,
    idUnidades int,
    foreign key (responsavel) references Engenheiro(crea)
);

create table Engenheiro(
    crea int primary key,
    cpf int,
    foreign key (cpf) references Pessoa(cpf)
);

create table Pessoa(
    nome varchar(45),
    cpf int primary key
);

create table UnidadeResidencial(
    idUnidadeResidencial int primary key auto_increment,
    numQuartos int,
    numBanheiros int,
    idEdificacao int,
    proprietario int,
    foreign key (idEdificacao) references Edificacao(idEdificacao),
    foreign key (proprietario) references Pessoa(cpf)
);

insert into pessoa (nome, cpf) values 
('Carlos Silva', 1234),
('Maria Oliveira', 9876),
('João Souza', 5558);

insert into engenheiro (crea, cpf) values 
(1001, 1234),
(1002, 9876),
(1003, 5558);

insert into edificacao (metraemTotal, endereco, responsavel, idUnidades) values 
(500.0, 'Rua A, 123', 1001, 1),
(750.5, 'Avenida B, 456', 1002, 2),
(600.75, 'Praça C, 789', 1003, 3);

insert into predio (nome, apPorAndar, edificacao) values 
('Predio Alpha', 5, 1),
('Predio Beta', 4, 2),
('Predio Gamma', 6, 3);

insert into casa (condominio, edificacao) values 
(true, 1),
(false, 2),
(true, 3);

insert into casasobrado (numAndares, idCasa) values 
(2, 1),
(3, 2),
(2, 3);

insert into unidaderesidencial (numQuartos, numBanheiros, idEdificacao, proprietario) values 
(3, 2, 1, 1234),
(4, 3, 2, 9876),
(2, 1, 3, 5558);


alter table Edificacao add foreign key (unidades) references UnidadeResidencial(idUnidadeResidencial);


select u.idUnidadeResidencial, p.nome, e.endereco from UnidadeResidencial u
join Pessoa p on u.proprietario = p.cpf
join Edificacao e on u.idEdificacao = e.idEdificacao
order by e.metraemTotal desc;