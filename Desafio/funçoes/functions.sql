CREATE TABLE Produtos(
    Id SERIAL NOT NULL PRIMARY KEY,
    Nome VARCHAR(255),
    Tipo VARCHAR(255),
    Preco_Unitario DECIMAL(10,2),
    Unidade_de_Medida DECIMAL(10,2)
);

CREATE TABLE Clientes(
    Id SERIAL NOT NULL PRIMARY KEY,
    Nome VARCHAR(255),
    CPF_CNPJ VARCHAR(255),
    Telefone VARCHAR(255),
    Endereco TEXT
);

CREATE TABLE Fornecedores(
    Id SERIAL NOT NULL PRIMARY KEY,
    Nome VARCHAR(255),
    CNPJ VARCHAR(255),
    Telefone VARCHAR(255),
    Endereco TEXT
);

CREATE TABLE Vendas(
    Id SERIAL NOT NULL PRIMARY KEY,
    Cliente_Id INTEGER,
    Produto_Id INTEGER,
    Quantidade INTEGER,
    Data_Venda DATE,
    Total_Venda DECIMAL(10,2),
    FOREIGN KEY (Cliente_Id) REFERENCES Clientes(Id),
    FOREIGN KEY (Produto_Id) REFERENCES Produtos(Id)
);

CREATE TABLE Compras(
    Id SERIAL NOT NULL PRIMARY KEY,
    Fornecedor_Id INTEGER,
    Produto_Id INTEGER,
    Quantidade INTEGER,
    Data_Compra DATE,
    Valor_Total DECIMAL(10,2),
    FOREIGN KEY (Fornecedor_Id) REFERENCES Fornecedores(Id),
    FOREIGN KEY (Produto_Id) REFERENCES Produtos(Id)
);

CREATE TABLE Estoque(
    Id SERIAL NOT NULL PRIMARY KEY,
    Produto_Id INTEGER,
    Quantidade INTEGER,
    Data_Ultima_Atualizacao TIMESTAMP DEFAULT current_timestamp,
    FOREIGN KEY (Produto_Id) REFERENCES Produtos(Id)
);




create  or replace procedure sp_register_compra(
    p_fornecedor_id integer,
    p_cliente_id integer,
    p_produto_id integer,
    p_quantidade integer,
    p_data_compra date,
    p_valor_total decimal
) as $$
declare
    v_produto_id integer;
    v_quantidade integer;
    v_valor_total decimal;
begin
    select id, quantidade into v_produto_id, v_quantidade from estoque where produto_id = p_produto_id;
    if v_produto_id is null then
        raise exception 'Produto não encontrado no estoque';
    end if;
    if v_quantidade < p_quantidade then
        raise exception 'Quantidade insuficiente no estoque';
    end if;
    update estoque set quantidade = quantidade - p_quantidade where produto_id = p_produto_id;
    insert into compras(fornecedor_id, produto_id, quantidade, data_compra, valor_total) values(p_fornecedor_id, p_produto_id, p_quantidade, p_data_compra, p_valor_total);
    insert into vendas (cliente_id, produto_id, quantidade, data_venda, total_venda) values(p_cliente_id, p_produto_id, p_quantidade, p_data_compra, p_valor_total);
end;
$$ language plpgsql;

call sp_register_compra(1, 1, 1, 100, '2023-10-01', 550.00);
select * from vendas;


create or replace function fn_calcular_valor_vendas(quantidade integer, preco decimal(10,2)) returns decimal(10,2) as $$
declare
    v_valor_total decimal;
begin
    v_valor_total := quantidade * preco;
    return v_valor_total;
end;
$$ language plpgsql;

select fn_calcular_valor_vendas(100, 5.50);



create or replace  function fn_percentual_vendas_produto(p_produto_id integer) returns decimal(10,2) as $$
declare
    v_total_vendas decimal;
    v_total_vendas_produto decimal;
    v_percentual_vendas decimal;
begin
    select sum(total_venda) into v_total_vendas from vendas;
    select sum(total_venda) into v_total_vendas_produto from vendas where produto_id = p_produto_id;
    v_percentual_vendas := round((v_total_vendas_produto / v_total_vendas) * 100, 2);
    return v_percentual_vendas;
end;
$$ language plpgsql;

select fn_percentual_vendas_produto(1);











create  or replace procedure sp_register_compra(
    p_fornecedor_id integer,
    p_cliente_id integer,
    p_produto_id integer[],
    p_quantidade integer[],
    p_data_compra date,
    p_valor_total decimal
) as $$
declare
    v_produto_id integer;
    v_quantidade integer;
    v_valor_total decimal;
    i integer;
begin
    for i in array_lower(p_produto_id, 1) .. array_upper(p_produto_id, 1) loop
        select id, quantidade into v_produto_id, v_quantidade from estoque where produto_id = p_produto_id[i];
        if v_produto_id is null then
            raise exception 'Produto não encontrado no estoque';
        end if;
        if v_quantidade < p_quantidade[i] then
            raise exception 'Quantidade insuficiente no estoque';
        end if;
        update estoque set quantidade = quantidade - p_quantidade[i] where produto_id = p_produto_id[i];
        insert into compras(fornecedor_id, produto_id, quantidade, data_compra, valor_total) values(p_fornecedor_id, p_produto_id[i], p_quantidade[i], p_data_compra, p_valor_total);
        insert into vendas (cliente_id, produto_id, quantidade, data_venda, total_venda) values(p_cliente_id, p_produto_id[i], p_quantidade[i], p_data_compra, p_valor_total);
    end loop;
end;
$$ language plpgsql;

call sp_register_compra(1, 1, array[1, 2, 3], array[100, 200, 150], '2023-10-01', 550.00);
select * from vendas;