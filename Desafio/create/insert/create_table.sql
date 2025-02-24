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
