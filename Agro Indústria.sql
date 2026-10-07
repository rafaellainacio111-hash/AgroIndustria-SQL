CREATE DATABASE agroindustria_db;
GO
-- Exclui o banco caso ele já exista
IF DB_ID('agroindustria_db') IS NOT NULL
BEGIN
    ALTER DATABASE agroindustria_db
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

    DROP DATABASE agroindustria_db;
END;
GO
-- Seleciona o banco
USE agroindustria_db;
GO

-- Cria a tabela de setores
CREATE TABLE setor (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nome VARCHAR(40) NOT NULL,
    descricao VARCHAR(500)
);
GO

-- Cria a tabela de medidas
CREATE TABLE medidas (
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_setor INT NOT NULL,
    data_hora DATETIME NOT NULL,
    variavel VARCHAR(20) NOT NULL,
    valor DECIMAL(10,2) NOT NULL,

    CONSTRAINT FK_medidas_setor
        FOREIGN KEY (id_setor)
        REFERENCES setor(id)
);
GO

USE agroindustria_db;
GO

-- Cadastro dos setores
INSERT INTO setor (nome, descricao) VALUES
('Moagem', 'Responsável pela extração do caldo da cana-de-açúcar.'),
('Clarificação', 'Remove impurezas do caldo e ajusta pH.'),
('Evaporação', 'Concentra o caldo por remoção de água.'),
('Fermentação', 'Converte açúcares em etanol através de leveduras.'),
('Destilação', 'Separa o etanol produzido na fermentação.'),
('Caldeira', 'Gera vapor para os processos industriais.');
GO

-- Registro das medidas coletadas
INSERT INTO medidas (id_setor, data_hora, variavel, valor) VALUES
(1, '2025-10-09 08:00:00', 'VAZÃO', 210.50),
(1, '2025-10-09 08:10:00', 'TEMP', 32.80),
(2, '2025-10-09 08:20:00', 'PH', 6.45),
(2, '2025-10-09 08:30:00', 'BRIX', 13.20),
(3, '2025-10-09 08:40:00', 'TEMP', 78.50),
(3, '2025-10-09 08:50:00', 'BRIX', 36.70),
(4, '2025-10-09 09:00:00', 'PH', 4.60),
(4, '2025-10-09 09:10:00', 'TEMP', 33.90),
(5, '2025-10-09 09:20:00', 'ETOH', 92.10),
(6, '2025-10-09 09:30:00', 'PRESSÃO', 17.80);
GO

USE agroindustria_db;
GO

SELECT * FROM setor;

SELECT * FROM medidas;

SELECT id, variavel, valor, data_hora
FROM medidas
ORDER BY data_hora DESC;

SELECT id, variavel, valor, data_hora
FROM medidas
WHERE variavel = 'TEMP'
ORDER BY valor DESC;

SELECT id, variavel, valor, data_hora
FROM medidas
WHERE variavel = 'BRIX'
  AND valor BETWEEN 30 AND 80
ORDER BY valor ASC;

SELECT
    variavel,
    COUNT(*) AS quantidade_medidas
FROM medidas
WHERE variavel IN ('VAZÃO', 'TEMP', 'PH', 'BRIX', 'ETOH')
GROUP BY variavel
ORDER BY quantidade_medidas DESC;

SELECT
    variavel,
    AVG(valor) AS valor_medio
FROM medidas
WHERE variavel IN ('VAZÃO', 'TEMP', 'PH', 'BRIX', 'ETOH')
GROUP BY variavel
ORDER BY valor_medio DESC;

SELECT
    variavel,
    CAST(AVG(valor) AS DECIMAL(10,2)) AS valor_medio
FROM medidas
WHERE variavel IN ('VAZÃO', 'TEMP', 'PH', 'BRIX', 'ETOH')
GROUP BY variavel
ORDER BY valor_medio DESC;

SELECT
    variavel,
    MIN(valor) AS valor_minimo,
    MAX(valor) AS valor_maximo
FROM medidas
WHERE variavel IN ('VAZÃO', 'TEMP', 'PH', 'BRIX', 'ETOH')
GROUP BY variavel
ORDER BY variavel ASC;

SELECT
    s.nome AS setor,
    CAST(AVG(m.valor) AS DECIMAL(10,2)) AS temperatura_media
FROM setor s
INNER JOIN medidas m
    ON s.id = m.id_setor
WHERE m.variavel = 'TEMP'
GROUP BY s.nome
ORDER BY temperatura_media DESC;

SELECT
    s.nome AS setor,
    MIN(m.valor) AS etoh_minimo,
    MAX(m.valor) AS etoh_maximo
FROM setor s
INNER JOIN medidas m
    ON s.id = m.id_setor
WHERE m.variavel = 'ETOH'
GROUP BY s.nome
ORDER BY s.nome ASC;

SELECT
    s.nome AS setor,
    COUNT(m.id) AS total_medicoes
FROM setor s
LEFT JOIN medidas m
    ON s.id = m.id_setor
GROUP BY s.nome
ORDER BY total_medicoes DESC;

USE agroindustria_db;
GO

-- Consultas básicas
SELECT * FROM setor;
SELECT * FROM medidas;


-- 1. Medições da mais recente para a mais antiga
SELECT id, variavel, valor, data_hora
FROM medidas
ORDER BY data_hora DESC;


-- 2. Medições de TEMP do maior para o menor
SELECT id, variavel, valor, data_hora
FROM medidas
WHERE variavel = 'TEMP'
ORDER BY valor DESC;


-- 3. BRIX entre 30 e 80
SELECT id, variavel, valor, data_hora
FROM medidas
WHERE variavel = 'BRIX'
  AND valor BETWEEN 30 AND 80
ORDER BY valor ASC;


-- 4. Quantidade de medidas por variável
SELECT
    variavel,
    COUNT(*) AS quantidade_medidas
FROM medidas
WHERE variavel IN ('VAZÃO', 'TEMP', 'PH', 'BRIX', 'ETOH')
GROUP BY variavel
ORDER BY quantidade_medidas DESC;


-- 5. Valor médio de cada variável
SELECT
    variavel,
    CAST(AVG(valor) AS DECIMAL(10,2)) AS valor_medio
FROM medidas
WHERE variavel IN ('VAZÃO', 'TEMP', 'PH', 'BRIX', 'ETOH')
GROUP BY variavel
ORDER BY valor_medio DESC;


-- 6. Menor e maior valor de cada variável
SELECT
    variavel,
    MIN(valor) AS valor_minimo,
    MAX(valor) AS valor_maximo
FROM medidas
WHERE variavel IN ('VAZÃO', 'TEMP', 'PH', 'BRIX', 'ETOH')
GROUP BY variavel
ORDER BY variavel ASC;


-- 7. Média de TEMP por setor
SELECT
    s.nome AS setor,
    CAST(AVG(m.valor) AS DECIMAL(10,2)) AS temperatura_media
FROM setor s
INNER JOIN medidas m
    ON s.id = m.id_setor
WHERE m.variavel = 'TEMP'
GROUP BY s.nome
ORDER BY temperatura_media DESC;


-- 8. Maior e menor ETOH por setor
SELECT
    s.nome AS setor,
    MIN(m.valor) AS etoh_minimo,
    MAX(m.valor) AS etoh_maximo
FROM setor s
INNER JOIN medidas m
    ON s.id = m.id_setor
WHERE m.variavel = 'ETOH'
GROUP BY s.nome
ORDER BY s.nome ASC;


-- 9. Total de medições por setor
SELECT
    s.nome AS setor,
    COUNT(m.id) AS total_medicoes
FROM setor s
LEFT JOIN medidas m
    ON s.id = m.id_setor
GROUP BY s.nome
ORDER BY total_medicoes DESC;