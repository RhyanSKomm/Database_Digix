CREATE OR REPLACE FUNCTION registrar_log_geral()
RETURNS TRIGGER AS $$
BEGIN
    
    IF TG_OP = 'INSERT' THEN
        INSERT INTO monitoramento_banco (Tabela, Acao, Registro_Id, Usuario_Responsavel)
        VALUES (TG_TABLE_NAME, 'INSERT', NEW.Id, CURRENT_USER);
    
   
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO monitoramento_banco (Tabela, Acao, Registro_Id, Usuario_Responsavel)
        VALUES (TG_TABLE_NAME, 'UPDATE', NEW.Id, CURRENT_USER);
    
    
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO monitoramento_banco (Tabela, Acao, Registro_Id, Usuario_Responsavel)
        VALUES (TG_TABLE_NAME, 'DELETE', OLD.Id, CURRENT_USER);
    END IF;

    RETURN NULL; 
END;
$$ LANGUAGE plpgsql;



CREATE TRIGGER trigger_log_vendas
AFTER INSERT OR UPDATE OR DELETE ON Vendas
FOR EACH ROW
EXECUTE FUNCTION registrar_log_geral();

CREATE TRIGGER trigger_log_produtos
AFTER INSERT OR UPDATE OR DELETE ON Produtos
FOR EACH ROW
EXECUTE FUNCTION registrar_log_geral();

CREATE TRIGGER trigger_log_clientes
AFTER INSERT OR UPDATE OR DELETE ON Clientes
FOR EACH ROW
EXECUTE FUNCTION registrar_log_geral();

CREATE TRIGGER trigger_log_compras
AFTER INSERT OR UPDATE OR DELETE ON Compras
FOR EACH ROW
EXECUTE FUNCTION registrar_log_geral();

CREATE TRIGGER trigger_log_estoques
AFTER INSERT OR UPDATE OR DELETE ON Estoque
FOR EACH ROW
EXECUTE FUNCTION registrar_log_geral();

CREATE TRIGGER trigger_log_fornecedores
AFTER INSERT OR UPDATE OR DELETE ON Fornecedores
FOR EACH ROW
EXECUTE FUNCTION registrar_log_geral();



CREATE TABLE Monitoramento_Banco (
    Id SERIAL PRIMARY KEY,
    Acao VARCHAR(10), 
    Tabela VARCHAR(50),
    Registro_Id INTEGER, 
    Usuario_Responsavel VARCHAR(255), 
    Data_Alteracao TIMESTAMP DEFAULT current_timestamp
);
