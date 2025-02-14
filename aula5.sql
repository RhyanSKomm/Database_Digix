CREATE TABLE time (
id INTEGER PRIMARY KEY,
nome VARCHAR(50)
);
CREATE TABLE partida (
id INTEGER PRIMARY KEY,
time_1 INTEGER,
time_2 INTEGER,
time_1_gols INTEGER,
time_2_gols INTEGER,
FOREIGN KEY(time_1) REFERENCES time(id),
FOREIGN KEY(time_2) REFERENCES time(id)
);
INSERT INTO time(id, nome) VALUES
(1,'CORINTHIANS'),
(2,'SÃO PAULO'),
(3,'CRUZEIRO'),
(4,'ATLETICO MINEIRO'),
(5,'PALMEIRAS');
INSERT INTO partida(id, time_1, time_2, time_1_gols, time_2_gols)
VALUES
(1,4,1,0,4),
(2,3,2,0,1),
(3,1,3,3,0),
(4,3,4,0,1),
(5,1,2,0,0),
(6,2,4,2,2),
(7,1,5,1,2),
(8,5,2,1,2);



--Função


-- Função 
-- Função são blocos de codigo que podem ser chamados para executar uma tarefa especifica.
-- As funções aceitam parametros.
-- As funções podem ser definidas pelo o usuario ou podem chamada as funções embutidas
-- Funções são as que estão diponiveis no banco da dados
-- São 3 tipos de funções: Matematicas, as Datas e as de String

-- Funções Matematicas
-- Exemplos:
select abs(-10); -- ela retorna o valor absoluto do numero
select round(10.5); -- ele redondao numero mais proximo possivel 
select trunc (12.7); -- ele só pega parte inteira (somente no postgres)
select truncate (12.7,2); -- ele vai selecionar quantas casas decimais (somente no mysql)
select power(2, 3); -- retorna os valores exponencial delimitado
select ln(4); -- retorna o logaritmo natural de numero
select cos(30); -- retorna o cosseno do angulo radiano
select atan(0.5); -- retorna o arco da tangente 
select asinh(0.5); -- retorna o arco do seno hiperbolico (postgres)
select sign(-50); -- retorna o sinal do numero

-- Funções embutidas de Manipução de String
select concat('afasf', 'fas'); -- vai concatena as 2 strings
select length('afasf'); -- retorna o comprimento
select lower('GSD'); -- deixa tudo em minusculo
select upper('dga'); -- deixa tudo em maiusculo
select ltrim(' egadg'); -- excluir os espaços
select rtrim('egadg ');
select lpad('egadg ', 10, '*'); -- prenche uma string com as caracteres apresentadas
select rpad('egadg ', 10, '*'); -- prenche uma string com as caracteres apresentadas
select reverse('fagfas'); -- inverte

-- Função da Data
select current_date;
select extract(day from current_date);
select age ('2025-01-01', '2025-02-02'); -- mostr  a diferença entre as duas datas
select interval '1 day';


-- Fuções definda pelo usuario:
-- Isso no postgres
create function soma(a integer, b integer) returns integer as $$ --declaro, coloco parametros, e o que retornar
begin -- começo a funão
    -- corpo da função
    return a + b;
end;
$$ language plpgsql;

-- No mysql é assim:
CREATE FUNCTION soma(a INT, b INT) RETURNS INT
DETERMINISTIC -- é uma clausula opcional, que incia que a função retorna o mesmo resultado para os mesmos argumentos de entrada
BEGIN
  RETURN a + b;
END 

-- Chamar a função
select soma(10, 20);

-- Operação de Insert nas funções
-- Mysql 
-- No Mysql funções que alteram o estado do banco dados, como Insert, update, delete e Crate não podem ser usadas
CREATE FUNCTION insere_partida(time_1 INT, time_2 INT, time_1_gols INT, time_2_gols INT) RETURNS VOID as
BEGIN
    INSERT INTO partida(time_1, time_2, time_1_gols, time_2_gols) VALUES (time_1, time_2, time_1_gols, time_2_gols);
END

-- Chamando
select insere_partida(1,2,1,2);

-- Função de consulta
create or replace funcion consulta_time() returns setof time as $$ -- setof indica que a função retorna um conjunto de registros
begin
  return query select * from time;
end;
$$ language plpgsql;

-- Chamando 
select * from consulta();

-- Função com variavel interna
-- postgres
create or replace function consulta_vencedor_por_time(id_time integer) returns varchar(50) as $$
declare
    vencedor varchar(50);
begin
    select case 
      when time_1_gols > time_2_gols then (select nome from time where id = time_1)
      when time_1_gols < time_2_gols then (select nome from time where id = time_2)
        else 'Empate'
      end into vencedor
      from partida
      where time_1 = id_time or time_2 = id_time;
      return vencedor; 
end;


$$ language plpgsql;
create Temp table temp_time as select * from time;

select * from temp_time;

truncate table temp_time;