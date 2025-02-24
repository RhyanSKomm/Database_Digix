CREATE OR REPLACE FUNCTION verificar_e_atualizar_estoque()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Estoque
    SET Quantidade = Quantidade + NEW.Quantidade
    WHERE Produto_Id = NEW.Produto_Id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
