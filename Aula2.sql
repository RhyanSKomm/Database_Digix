select cargo.nome from cargo;

select cargo.id from cargo;

select c.id from cargo c;

select c.nome as cargo, u.nome from cargo c, usuario u;

select c.nome from cargo c where id = 1;

select u.nome from usuario u where u.id = 1 or u.id = 2;

select u.nome from usuario u where u.id = 1 and u.id = 2;

select u.nome from usuario u where id in (1,2,3);

select u.nome from usuario u where id not in (1,2,3);

select u.id from usuario u where nome between 'ciclano' and 'fulano';

select u.id, u.nome from usuario u where nome like '%no';

select u.id, u.nome from usuario u where id > 1;

select u.id, u.nome from usuario u where id > 1 and id < 3;

select u.id, u.nome from usuario u order by id asc;

select u.id, u.nome from usuario u order by id desc;

select u.id, u.nome from usuario u order by nome desc;

select * from usuario limit 1;

select c.nome, u.id, count(c.id) from usuario u, cargo c
where u.id = c.fk_usuario group by c.nome, u.id;