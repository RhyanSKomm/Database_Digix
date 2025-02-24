
-- View 1: vw_relatorio_vendas
CREATE OR REPLACE VIEW vw_relatorio_vendas AS
SELECT
    c.Nome AS Nome_Cliente,
    p.Nome AS Nome_Produto,
    v.Quantidade AS Quantidade_Comprada,
    v.Data_Venda,
    v.Total_Venda AS Valor_Total_Venda
FROM Vendas v
INNER JOIN Clientes c ON v.Cliente_Id = c.Id
INNER JOIN Produtos p ON v.Produto_Id = p.Id;

-- View 2: vw_estoque_atual
CREATE OR REPLACE VIEW vw_estoque_atual AS
SELECT
    p.Nome AS Nome_Produto,
    e.Quantidade AS Quantidade_Atual
FROM Estoque e
INNER JOIN Produtos p ON e.Produto_Id = p.Id;