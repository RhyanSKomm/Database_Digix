create table aluno(
    idt_aluno int primary key not null,
    des_nome varchar(100),
    num_grau int
);

create table amigo(
    idt_aluno1 int not null,
    idt_aluno2 int not null,
    constraint fk_aluno1 foreign key(idt_aluno1) references aluno(idt_aluno),
    constraint fk_aluno2 foreign key(idt_aluno2) references aluno(idt_aluno)
);

create table curtida(
    idt_aluno1 int not null,
    idt_aluno2 int not null,
    constraint fk_aluno1 foreign key(idt_aluno1) references aluno(idt_aluno),
    constraint fk_aluno2 foreign key(idt_aluno2) references aluno(idt_aluno)
);

insert into aluno values (1, 'João', 1);
insert into aluno values (2, 'Maria', 2);

select * from aluno;

select * from aluno inner join curtida on aluno.idt_aluno = curtida.idt_aluno1;
select * from aluno left join amigo on aluno.idt_aluno = amigo.idt_aluno2;

drop table amigo;
drop table curtida;