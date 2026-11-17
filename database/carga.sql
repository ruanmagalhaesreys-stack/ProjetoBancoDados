-- =====================================================================
-- Pesquisa de Satisfação do RU da UEL
-- carga.sql: dados de teste. Rodar logo depois do schema.sql:
--   psql -U postgres -d ru_uel -f database/carga.sql
-- Senha de todos os usuários: 123456
--
-- O banco é criado do zero pelo schema.sql, então os ids gerados pelo
-- SERIAL começam em 1 e seguem a ordem dos INSERTs abaixo.
-- =====================================================================

SET client_encoding = 'UTF8';  -- o arquivo está em UTF-8 (acentos)

-- ---------------------------------------------------------------------
-- 1. Centros da UEL
-- ---------------------------------------------------------------------
INSERT INTO centro (sigla, nome) VALUES
    ('CCA',  'Centro de Ciências Agrárias'),
    ('CCB',  'Centro de Ciências Biológicas'),
    ('CCE',  'Centro de Ciências Exatas'),
    ('CCH',  'Centro de Letras e Ciências Humanas'),
    ('CCS',  'Centro de Ciências da Saúde'),
    ('CECA', 'Centro de Educação, Comunicação e Artes'),
    ('CEFE', 'Centro de Educação Física e Esporte'),
    ('CESA', 'Centro de Estudos Sociais Aplicados'),
    ('CTU',  'Centro de Tecnologia e Urbanismo');

-- ---------------------------------------------------------------------
-- 2. Temas das questões (ids 1 a 5)
-- ---------------------------------------------------------------------
INSERT INTO tema (nome) VALUES
    ('Comida'),                  -- 1
    ('Fila e Tempo de Espera'),  -- 2
    ('Limpeza'),                 -- 3
    ('Atendimento'),             -- 4
    ('Cardápio e Preço');        -- 5

-- ---------------------------------------------------------------------
-- 3. Usuários: 2 administradores (ids 1 e 2) e 20 alunos (ids 3 a 22).
-- ana.demo e bruno.demo são contas para a demonstração: nunca
-- responderam nenhuma pesquisa.
-- ---------------------------------------------------------------------
INSERT INTO usuario (nome, email, senha, tipo, matricula, sigla_centro) VALUES
    ('Marta Oliveira',     'admin@uel.br',               '123456', 'ADMIN', NULL, NULL),         -- 1
    ('Carlos Pereira',     'carlos.ru@uel.br',           '123456', 'ADMIN', NULL, NULL),         -- 2
    ('Ana Souza (demo)',   'ana.demo@uel.br',            '123456', 'ALUNO', '202600001', 'CCE'),  -- 3
    ('Lucas Almeida',      'lucas.almeida@uel.br',       '123456', 'ALUNO', '202300101', 'CCE'),  -- 4
    ('Mariana Costa',      'mariana.costa@uel.br',       '123456', 'ALUNO', '202400102', 'CCE'),  -- 5
    ('Pedro Santos',       'pedro.santos@uel.br',        '123456', 'ALUNO', '202200103', 'CCE'),  -- 6
    ('Felipe Araujo',      'felipe.araujo@uel.br',       '123456', 'ALUNO', '202300201', 'CTU'),  -- 7
    ('Isabela Moreira',    'isabela.moreira@uel.br',     '123456', 'ALUNO', '202200202', 'CTU'),  -- 8
    ('Matheus Barbosa',    'matheus.barbosa@uel.br',     '123456', 'ALUNO', '202400203', 'CTU'),  -- 9
    ('Bruno Lima (demo)',  'bruno.demo@uel.br',          '123456', 'ALUNO', '202600002', 'CCS'),  -- 10
    ('Fernanda Pinto',     'fernanda.pinto@uel.br',      '123456', 'ALUNO', '202300302', 'CCS'),  -- 11
    ('Diego Fernandes',    'diego.fernandes@uel.br',     '123456', 'ALUNO', '202400303', 'CCS'),  -- 12
    ('Sofia Batista',      'sofia.batista@uel.br',       '123456', 'ALUNO', '202400402', 'CCH'),  -- 13
    ('Caio Vieira',        'caio.vieira@uel.br',         '123456', 'ALUNO', '202500403', 'CCH'),  -- 14
    ('Bianca Moura',       'bianca.moura@uel.br',        '123456', 'ALUNO', '202300501', 'CESA'), -- 15
    ('Rodrigo Nascimento', 'rodrigo.nascimento@uel.br',  '123456', 'ALUNO', '202200502', 'CESA'), -- 16
    ('Alice Peixoto',      'alice.peixoto@uel.br',       '123456', 'ALUNO', '202400602', 'CCB'),  -- 17
    ('Murilo Andrade',     'murilo.andrade@uel.br',      '123456', 'ALUNO', '202500603', 'CCB'),  -- 18
    ('Valentina Borges',   'valentina.borges@uel.br',    '123456', 'ALUNO', '202400701', 'CCA'),  -- 19
    ('Pietro Fonseca',     'pietro.fonseca@uel.br',      '123456', 'ALUNO', '202300702', 'CCA'),  -- 20
    ('Livia Coelho',       'livia.coelho@uel.br',        '123456', 'ALUNO', '202500802', 'CECA'), -- 21
    ('Davi Medeiros',      'davi.medeiros@uel.br',       '123456', 'ALUNO', '202300902', 'CEFE'); -- 22
