INSERT INTO Produtos (Nome, Tipo, Preco_Unitario, Unidade_de_Medida) VALUES
('Gasolina Comum', 'Combustível', 5.50, 1.00),
('Etanol', 'Combustível', 3.80, 1.00),
('Diesel S10', 'Combustível', 4.20, 1.00),
('Óleo Lubrificante 15W40', 'Lubrificante', 25.00, 1.00),
('Aditivo para Combustível', 'Aditivo', 15.00, 0.50),
('Gasolina Aditivada', 'Combustível', 6.00, 1.00),
('Querosene de Aviação', 'Combustível', 8.50, 1.00),
('Óleo Lubrificante 20W50', 'Lubrificante', 30.00, 1.00),
('Aditivo para Diesel', 'Aditivo', 18.00, 0.50),
('Gás Natural Veicular (GNV)', 'Combustível', 3.00, 1.00);

INSERT INTO Clientes (Nome, CPF_CNPJ, Telefone, Endereco) VALUES
('João Silva', '123.456.789-00', '(11) 9999-8888', 'Rua A, 123 - São Paulo, SP'),
('Posto do Zé', '12.345.678/0001-99', '(11) 7777-6666', 'Av. B, 456 - Rio de Janeiro, RJ'),
('Maria Oliveira', '987.654.321-00', '(11) 5555-4444', 'Rua C, 789 - Belo Horizonte, MG'),
('Auto Posto Legal', '98.765.432/0001-11', '(11) 3333-2222', 'Av. D, 101 - Curitiba, PR'),
('Carlos Souza', '111.222.333-44', '(11) 1111-2222', 'Rua E, 202 - Porto Alegre, RS'),
('Posto Bom Combustível', '23.456.789/0001-22', '(11) 2222-3333', 'Av. F, 303 - Salvador, BA'),
('Ana Pereira', '222.333.444-55', '(11) 4444-5555', 'Rua G, 404 - Recife, PE'),
('Posto Estrela', '34.567.890/0001-33', '(11) 6666-7777', 'Av. H, 505 - Brasília, DF'),
('Fernando Costa', '333.444.555-66', '(11) 8888-9999', 'Rua I, 606 - Fortaleza, CE'),
('Posto Central', '45.678.901/0001-44', '(11) 0000-1111', 'Av. J, 707 - Manaus, AM');

INSERT INTO Fornecedores (Nome, CNPJ, Telefone, Endereco) VALUES
('Petrobras', '33.000.167/0001-01', '(21) 3224-1515', 'Av. República do Chile, 65 - Rio de Janeiro, RJ'),
('Shell Brasil', '33.412.080/0001-56', '(11) 4004-0000', 'Praça do Patriarca, 24 - São Paulo, SP'),
('BR Distribuidora', '34.274.233/0001-02', '(61) 3214-0000', 'SIA Trecho 5, 945 - Brasília, DF'),
('Ipiranga', '33.000.118/0001-36', '(51) 3218-2000', 'Av. Getúlio Vargas, 1101 - Porto Alegre, RS'),
('Castrol Brasil', '61.990.888/0001-24', '(11) 4003-5544', 'Av. das Nações Unidas, 12901 - São Paulo, SP');

INSERT INTO Vendas (Cliente_Id, Produto_Id, Quantidade, Data_Venda, Total_Venda) VALUES
(1, 1, 100, '2023-10-01', 550.00),
(2, 2, 200, '2023-10-02', 760.00),
(3, 3, 150, '2023-10-03', 630.00),
(4, 4, 50, '2023-10-04', 1250.00),
(5, 5, 30, '2023-10-05', 450.00),
(6, 6, 80, '2023-10-06', 480.00),
(7, 7, 120, '2023-10-07', 1020.00),
(8, 8, 60, '2023-10-08', 1800.00),
(9, 9, 40, '2023-10-09', 720.00),
(10, 10, 200, '2023-10-10', 600.00);

INSERT INTO Compras (Fornecedor_Id, Produto_Id, Quantidade, Data_Compra, Valor_Total) VALUES
(1, 1, 1000, '2023-09-25', 5500.00),
(2, 4, 500, '2023-09-26', 12500.00),
(3, 5, 300, '2023-09-27', 4500.00),
(4, 7, 800, '2023-09-28', 6800.00),
(5, 10, 1000, '2023-09-29', 3000.00);

INSERT INTO Estoque (Produto_Id, Quantidade) VALUES
(1, 1000),
(2, 2000),
(3, 1500),
(4, 500),
(5, 300),
(6, 800),
(7, 1200),
(8, 600),
(9, 400),
(10, 2000);
