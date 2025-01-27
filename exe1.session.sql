create table ex1.aluno(
    idt_aluno int primary key not null,
    des_nome varchar(100),
    num_grau int
);

create table ex1.amigo(
    idt_aluno1 int not null,
    idt_aluno2 int not null,
    constraint fk_aluno1 foreign key(idt_aluno1) references ex1.aluno(idt_aluno),
    constraint fk_aluno2 foreign key(idt_aluno2) references ex1.aluno(idt_aluno)
);

create table ex1.curtida(
    idt_aluno1 int not null,
    idt_aluno2 int not null,
    constraint fk_aluno1 foreign key(idt_aluno1) references ex1.aluno(idt_aluno),
    constraint fk_aluno2 foreign key(idt_aluno2) references ex1.aluno(idt_aluno)
);

insert into ex1.aluno values (1, 'João', 1);
insert into ex1.aluno values (2, 'Maria', 2);

select * from ex1.aluno;

select * from ex1.aluno inner join ex1.curtida on aluno.id = curtida.idt_aluno1;
select * from ex1.aluno left join ex1.amigo on ex1.aluno.id = ex1.amigo.idt_aluno2;