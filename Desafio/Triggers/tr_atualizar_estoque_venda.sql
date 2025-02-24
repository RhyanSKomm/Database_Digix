CREATE OR REPLACE FUNCTION adicionar_estoque()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Estoque
    SET Quantidade = Quantidade + NEW.Quantidade
    WHERE Produto_Id = NEW.Produto_Id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER tr_atualizar_estoque_compra
BEFORE INSERT ON Compras
FOR EACH ROW
EXECUTE FUNCTION adicionar_estoque();