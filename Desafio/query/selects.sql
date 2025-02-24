-- 4.1 - Selecione todos os produtos disponíveis no estoque com suas respectivas quantidades.
SELECT P.Nome, E.Quantidade FROM Estoque E INNER JOIN Produtos AS P ON E.Produto_Id = P.Id;
-- 4.2 - Liste todas as compras feitas de um fornecedor específico dentro de um determinado período.
SELECT C.*, P.Nome AS Produto_Nome, F.Nome AS Fornecedor_Nome
FROM Compras C
LEFT JOIN Produtos P ON C.Produto_Id = P.Id
LEFT JOIN Fornecedores F ON C.Fornecedor_Id = F.Id
WHERE F.Id = 1 AND C.Data_Compra BETWEEN '2023-07-01' AND '2023-12-31';

-- 4.3 Exiba os Clientes que mais compraram combustível nos últimos 2 anos
SELECT 
    cl.Nome,
    SUM(vend.Quantidade) AS Total_Quantidade
FROM
    Clientes cl
JOIN Vendas vend ON cl.Id = vend.Cliente_Id
WHERE
    vend.Data_Venda >= DATE_TRUNC('year', CURRENT_DATE) - INTERVAL '2 year'
AND
    vend.Data_Venda < DATE_TRUNC('year', CURRENT_DATE)
GROUP BY
    cl.Nome
ORDER BY
    Total_Quantidade DESC;


-- 4.4 Calcule o valor total das vendas de cada tipo de combustível nos últimos 5 dias.
SELECT
    pr.Tipo,
    SUM(vend.Total_Venda) as Valor_Total_Vendas
FROM
    Produtos pr
JOIN Vendas vend ON pr.Id = vend.Produto_Id
WHERE
    vend.Data_Venda >= '2023-10-10'::DATE - INTERVAL '5 days'
AND
    vend.Data_Venda < '2023-10-10'::DATE
GROUP BY
    pr.Tipo
ORDER BY
    Valor_Total_Vendas DESC;

-- 4.5 Identifique os produtos que estão abaixo de um estoque mínimo definido (1000 Litros).
SELECT
    pr.Nome, est.Quantidade
FROM
    Produtos pr
JOIN Estoque est on pr.Id = est.Produto_Id
WHERE
    est.Quantidade < 1000