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

-- ---------------------------------------------------------------------
-- 4. Questões (ids 1 a 30): 25 de escala, 3 de múltipla escolha e 2 de
-- texto livre. O último número é o tema (1 = Comida ... 5 = Cardápio).
-- ---------------------------------------------------------------------
INSERT INTO questao (enunciado, tipo, id_tema) VALUES
    ('Como você avalia o sabor da comida servida no RU?',                'ESCALA',   1),  -- 1
    ('Como você avalia a temperatura em que a comida é servida?',        'ESCALA',   1),  -- 2
    ('Como você avalia a variedade das opções do dia?',                  'ESCALA',   1),  -- 3
    ('Como você avalia a qualidade da opção vegetariana?',               'ESCALA',   1),  -- 4
    ('Como você avalia o tamanho das porções?',                          'ESCALA',   1),  -- 5
    ('Como você avalia o frescor das saladas e frutas?',                 'ESCALA',   1),  -- 6
    ('Como você avalia o tempo de espera na fila do almoço?',            'ESCALA',   2),  -- 7
    ('Como você avalia o tempo de espera na fila do jantar?',            'ESCALA',   2),  -- 8
    ('Como você avalia a organização da fila?',                          'ESCALA',   2),  -- 9
    ('Como você avalia a rapidez na reposição dos alimentos no buffet?', 'ESCALA',   2),  -- 10
    ('Como você avalia a facilidade de encontrar mesa livre?',           'ESCALA',   2),  -- 11
    ('Como você avalia a limpeza das mesas e cadeiras?',                 'ESCALA',   3),  -- 12
    ('Como você avalia a limpeza das bandejas e talheres?',              'ESCALA',   3),  -- 13
    ('Como você avalia a limpeza dos banheiros do RU?',                  'ESCALA',   3),  -- 14
    ('Como você avalia a higiene na área do buffet?',                    'ESCALA',   3),  -- 15
    ('Como você avalia a separação do lixo e das sobras?',               'ESCALA',   3),  -- 16
    ('Como você avalia a cordialidade dos funcionários?',                'ESCALA',   4),  -- 17
    ('Como você avalia a agilidade na catraca e no caixa?',              'ESCALA',   4),  -- 18
    ('Como você avalia a disposição da equipe para tirar dúvidas?',      'ESCALA',   4),  -- 19
    ('Como você avalia o atendimento a quem tem restrição alimentar?',   'ESCALA',   4),  -- 20
    ('Como você avalia o uso de touca e luvas pelos funcionários?',      'ESCALA',   4),  -- 21
    ('Como você avalia o preço da refeição em relação à qualidade?',     'ESCALA',   5),  -- 22
    ('Como você avalia a divulgação do cardápio com antecedência?',      'ESCALA',   5),  -- 23
    ('Como você avalia a informação nutricional disponível?',            'ESCALA',   5),  -- 24
    ('Como você avalia o horário de funcionamento do RU?',               'ESCALA',   5),  -- 25
    ('Qual refeição você faz com mais frequência no RU?',                'MULTIPLA', 1),  -- 26
    ('Quanto tempo você costuma esperar na fila?',                       'MULTIPLA', 2),  -- 27
    ('Quantas vezes por semana você come no RU?',                        'MULTIPLA', 5),  -- 28
    ('O que você mudaria na comida do RU?',                              'TEXTO',    1),  -- 29
    ('Deixe um elogio ou uma reclamação sobre o atendimento.',           'TEXTO',    4);  -- 30

-- Alternativas das questões de múltipla escolha (entidade fraca).
INSERT INTO alternativa (id_questao, ordem, texto) VALUES
    (26, 1, 'Café da manhã'),
    (26, 2, 'Almoço'),
    (26, 3, 'Jantar'),
    (26, 4, 'Almoço e jantar'),
    (27, 1, 'Até 10 minutos'),
    (27, 2, 'De 10 a 20 minutos'),
    (27, 3, 'De 20 a 40 minutos'),
    (27, 4, 'Mais de 40 minutos'),
    (28, 1, '1 ou 2 vezes'),
    (28, 2, '3 ou 4 vezes'),
    (28, 3, '5 vezes ou mais');

-- ---------------------------------------------------------------------
-- 5. Pesquisas (ids 1 a 5): 4 encerradas e 1 aberta até 30/11/2026.
-- As de semestre repetem as mesmas questões, para comparar períodos.
-- ---------------------------------------------------------------------
INSERT INTO pesquisa (titulo, descricao, data_inicio, data_fim, id_admin) VALUES
    ('Satisfação com o RU - 2º semestre 2024',
     'Pesquisa semestral sobre comida, fila, limpeza, atendimento e preço.',
     '2024-11-04', '2024-11-22', 1),                                        -- 1
    ('Satisfação com o RU - 1º semestre 2025',
     'Pesquisa semestral sobre comida, fila, limpeza, atendimento e preço.',
     '2025-05-05', '2025-05-23', 1),                                        -- 2
    ('Satisfação com o RU - 2º semestre 2025',
     'Pesquisa semestral sobre comida, fila, limpeza, atendimento e preço.',
     '2025-10-27', '2025-11-14', 1),                                        -- 3
    ('Satisfação com o RU - 1º semestre 2026',
     'Primeira pesquisa depois da troca da empresa que fornece as refeições.',
     '2026-05-04', '2026-05-22', 2),                                        -- 4
    ('Jantar do RU - novembro/2026',
     'Avaliação do jantar, para os centros com mais cursos noturnos.',
     '2026-11-09', '2026-11-30', 1);                                        -- 5

-- Questões de cada pesquisa: (pesquisa, questão, ordem na pesquisa).
-- As 4 semestrais têm as mesmas 9 questões.
INSERT INTO pesquisa_questao (id_pesquisa, id_questao, ordem) VALUES
    (1, 1, 1), (1, 3, 2), (1, 7, 3), (1, 9, 4), (1, 12, 5), (1, 17, 6), (1, 22, 7), (1, 26, 8), (1, 29, 9),
    (2, 1, 1), (2, 3, 2), (2, 7, 3), (2, 9, 4), (2, 12, 5), (2, 17, 6), (2, 22, 7), (2, 26, 8), (2, 29, 9),
    (3, 1, 1), (3, 3, 2), (3, 7, 3), (3, 9, 4), (3, 12, 5), (3, 17, 6), (3, 22, 7), (3, 26, 8), (3, 29, 9),
    (4, 1, 1), (4, 3, 2), (4, 7, 3), (4, 9, 4), (4, 12, 5), (4, 17, 6), (4, 22, 7), (4, 26, 8), (4, 29, 9),
    (5, 1, 1), (5, 2, 2), (5, 8, 3), (5, 10, 4), (5, 11, 5), (5, 18, 6), (5, 20, 7), (5, 24, 8), (5, 25, 9), (5, 28, 10);

-- Centros que devem responder cada pesquisa.
INSERT INTO pesquisa_centro (id_pesquisa, sigla_centro) VALUES
    (1, 'CCA'), (1, 'CCB'), (1, 'CCE'), (1, 'CCH'), (1, 'CCS'), (1, 'CECA'), (1, 'CEFE'), (1, 'CESA'), (1, 'CTU'),
    (2, 'CCA'), (2, 'CCB'), (2, 'CCE'), (2, 'CCH'), (2, 'CCS'), (2, 'CECA'), (2, 'CEFE'), (2, 'CESA'), (2, 'CTU'),
    (3, 'CCA'), (3, 'CCB'), (3, 'CCE'), (3, 'CCH'), (3, 'CCS'), (3, 'CECA'), (3, 'CEFE'), (3, 'CESA'), (3, 'CTU'),
    (4, 'CCA'), (4, 'CCB'), (4, 'CCE'), (4, 'CCH'), (4, 'CCS'), (4, 'CECA'), (4, 'CEFE'), (4, 'CESA'), (4, 'CTU'),
    (5, 'CCE'), (5, 'CTU'), (5, 'CESA'), (5, 'CCB'), (5, 'CCA');
