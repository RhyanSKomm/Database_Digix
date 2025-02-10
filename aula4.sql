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

create or replace view aluno_turma as
select a.nome as aluno, count(distinct t.idturma) as qtd_turmas
from aluno a
join chamada c on a.codMatricula = c.aluno_codMatricula
join turma t on c.turma_idturma = t.idturma
group by a.codMatricula, a.nome
having count(distinct t.idturma) > 1;

select * from aluno_aluno;
select aluno from aluno_aluno;

drop view aluno_aluno;


create view maior_turma as
select t.nome, count(a.codMatricula) as quantidade_alunos from turma t
inner join aluno a on idturma = turma_idturma
group by t.nome
order by count(a.codMatricula) desc
limit 1;

create table mv_total_presencas(
    aluno varchar(200),
    idade numeric
);

insert into mv_total_presencas
select t.nome ,round(avg(datediff(now(), a.dataNascimento) / 365)) as media_idade from aluno a
inner join turma t on idturma = turma_idturma