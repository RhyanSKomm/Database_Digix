CREATE TABLE usuario(
    id integer primary key NOT NULL,
    nome varchar(50),
    email varchar(50)
);

create table cargo(
	id int not null,
	nome varchar(50),
	primary key(id),
	fk_usuario int,
	constraint fk_cargo_usuario foreign key(fk_usuario) 
	references usuario(id)
);

alter table cargo add column salario decimal(10,2);
alter table cargo alter column nome type varchar(100);
alter table cargo drop column salario;

drop table cargo;
drop table usuario;

insert into usuario values (1,'João','jao@gmail.com');
insert into usuario values (2,'Maria','ma@gmail.com');
insert into usuario values (3,'fulano','ma@gmail.com');

alter table cargo add column salario decimal(10,2);
insert into cargo values (1,'Analista', 1, 5000.00);
insert into cargo values (2,'Analista', 1, 5000.00);
insert into cargo values (3,'Analista', 2, 5000.00);

update cargo set salario = 6500 where id=1; 
update usuario set nome = 'ciclano' where id = 1;

delete from usuario where id=3;

select * from cargo;
select * from usuario;

select * from usuario left join cargo on usuario.id = cargo.fk_usuario;


select * from usuario right join cargo on usuario.id = cargo.fk_usuario;

select * from usuario inner join cargo on usuario.id = cargo.fk_usuario;