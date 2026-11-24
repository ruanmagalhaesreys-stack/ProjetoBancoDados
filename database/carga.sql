-- Pesquisa de Satisfação do RU da UEL
-- Este arquivo coloca os dados de teste no banco. Rode logo depois do schema.sql.
-- Para rodar: psql -U postgres -d ru_uel -f database/carga.sql
-- A senha de todos os usuários é ruuel2026.
--
-- O schema.sql cria as tabelas vazias, então os ids gerados pelo SERIAL
-- começam em 1 e seguem a ordem dos INSERT abaixo.
-- INSERT INTO coloca linhas na tabela; cada parêntese depois de VALUES é uma linha.

-- Avisa o banco que o arquivo está em UTF-8, para os acentos ficarem certos.
SET client_encoding = 'UTF8';

-- Centros da UEL.
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

-- Temas das questões (ids 1 a 5).
INSERT INTO tema (nome) VALUES
    ('Comida'),                  -- 1
    ('Fila e Tempo de Espera'),  -- 2
    ('Limpeza'),                 -- 3
    ('Atendimento'),             -- 4
    ('Cardápio e Preço');        -- 5

-- Usuários: 2 administradores (ids 1 e 2) e 20 alunos (ids 3 a 22).
-- O administrador fica sem matrícula e sem centro (NULL quer dizer vazio).
-- ana.demo e bruno.demo são contas para a demonstração e nunca responderam nada.
INSERT INTO usuario (nome, email, senha, tipo, matricula, sigla_centro) VALUES
    ('Marta Oliveira',     'admin@uel.br',               'ruuel2026', 'ADMIN', NULL, NULL),         -- 1
    ('Carlos Pereira',     'carlos.ru@uel.br',           'ruuel2026', 'ADMIN', NULL, NULL),         -- 2
    ('Ana Souza (demo)',   'ana.demo@uel.br',            'ruuel2026', 'ALUNO', '202600001', 'CCE'),  -- 3
    ('Lucas Almeida',      'lucas.almeida@uel.br',       'ruuel2026', 'ALUNO', '202300101', 'CCE'),  -- 4
    ('Mariana Costa',      'mariana.costa@uel.br',       'ruuel2026', 'ALUNO', '202400102', 'CCE'),  -- 5
    ('Pedro Santos',       'pedro.santos@uel.br',        'ruuel2026', 'ALUNO', '202200103', 'CCE'),  -- 6
    ('Felipe Araujo',      'felipe.araujo@uel.br',       'ruuel2026', 'ALUNO', '202300201', 'CTU'),  -- 7
    ('Isabela Moreira',    'isabela.moreira@uel.br',     'ruuel2026', 'ALUNO', '202200202', 'CTU'),  -- 8
    ('Matheus Barbosa',    'matheus.barbosa@uel.br',     'ruuel2026', 'ALUNO', '202400203', 'CTU'),  -- 9
    ('Bruno Lima (demo)',  'bruno.demo@uel.br',          'ruuel2026', 'ALUNO', '202600002', 'CCS'),  -- 10
    ('Fernanda Pinto',     'fernanda.pinto@uel.br',      'ruuel2026', 'ALUNO', '202300302', 'CCS'),  -- 11
    ('Diego Fernandes',    'diego.fernandes@uel.br',     'ruuel2026', 'ALUNO', '202400303', 'CCS'),  -- 12
    ('Sofia Batista',      'sofia.batista@uel.br',       'ruuel2026', 'ALUNO', '202400402', 'CCH'),  -- 13
    ('Caio Vieira',        'caio.vieira@uel.br',         'ruuel2026', 'ALUNO', '202500403', 'CCH'),  -- 14
    ('Bianca Moura',       'bianca.moura@uel.br',        'ruuel2026', 'ALUNO', '202300501', 'CESA'), -- 15
    ('Rodrigo Nascimento', 'rodrigo.nascimento@uel.br',  'ruuel2026', 'ALUNO', '202200502', 'CESA'), -- 16
    ('Alice Peixoto',      'alice.peixoto@uel.br',       'ruuel2026', 'ALUNO', '202400602', 'CCB'),  -- 17
    ('Murilo Andrade',     'murilo.andrade@uel.br',      'ruuel2026', 'ALUNO', '202500603', 'CCB'),  -- 18
    ('Valentina Borges',   'valentina.borges@uel.br',    'ruuel2026', 'ALUNO', '202400701', 'CCA'),  -- 19
    ('Pietro Fonseca',     'pietro.fonseca@uel.br',      'ruuel2026', 'ALUNO', '202300702', 'CCA'),  -- 20
    ('Livia Coelho',       'livia.coelho@uel.br',        'ruuel2026', 'ALUNO', '202500802', 'CECA'), -- 21
    ('Davi Medeiros',      'davi.medeiros@uel.br',       'ruuel2026', 'ALUNO', '202300902', 'CEFE'); -- 22

-- Questões (ids 1 a 30): 25 de escala, 3 de múltipla escolha e 2 de texto livre.
-- O último número de cada linha é o tema (1 = Comida até 5 = Cardápio e Preço).
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

-- Alternativas das questões de múltipla escolha: (questão, ordem, texto).
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

-- Pesquisas (ids 1 a 5): 4 já encerradas e 1 aberta até 30/11/2026.
-- As pesquisas de semestre repetem as mesmas questões, para comparar os períodos.
-- O último número de cada linha é o id do administrador que criou a pesquisa.
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

-- Centros que devem responder cada pesquisa: (pesquisa, centro).
INSERT INTO pesquisa_centro (id_pesquisa, sigla_centro) VALUES
    (1, 'CCA'), (1, 'CCB'), (1, 'CCE'), (1, 'CCH'), (1, 'CCS'), (1, 'CECA'), (1, 'CEFE'), (1, 'CESA'), (1, 'CTU'),
    (2, 'CCA'), (2, 'CCB'), (2, 'CCE'), (2, 'CCH'), (2, 'CCS'), (2, 'CECA'), (2, 'CEFE'), (2, 'CESA'), (2, 'CTU'),
    (3, 'CCA'), (3, 'CCB'), (3, 'CCE'), (3, 'CCH'), (3, 'CCS'), (3, 'CECA'), (3, 'CEFE'), (3, 'CESA'), (3, 'CTU'),
    (4, 'CCA'), (4, 'CCB'), (4, 'CCE'), (4, 'CCH'), (4, 'CCS'), (4, 'CECA'), (4, 'CEFE'), (4, 'CESA'), (4, 'CTU'),
    (5, 'CCE'), (5, 'CTU'), (5, 'CESA'), (5, 'CCB'), (5, 'CCA');

-- Respostas de teste. Cada pesquisa tem três partes:
-- participacao guarda quem respondeu (aluno e pesquisa);
-- submissao guarda cada questionário respondido, sem o aluno (só o centro);
-- resposta guarda, para cada questionário, a nota, a alternativa ou o texto de cada questão.
-- As submissões estão numa ordem diferente das participações, como aconteceria
-- no sistema, então não dá para saber de quem é cada uma.
-- As notas vão de 1 (muito ruim) a 5 (muito bom).

-- Pesquisa 1: Satisfação com o RU - 2º semestre 2024 (10 respostas)
INSERT INTO participacao (id_aluno, id_pesquisa, data) VALUES
    (6, 1, '2024-11-14'),
    (7, 1, '2024-11-21'),
    (8, 1, '2024-11-13'),
    (11, 1, '2024-11-11'),
    (13, 1, '2024-11-09'),
    (14, 1, '2024-11-06'),
    (15, 1, '2024-11-10'),
    (19, 1, '2024-11-14'),
    (20, 1, '2024-11-18'),
    (22, 1, '2024-11-19');

-- Questionários desta pesquisa (submissões 1 a 10).
INSERT INTO submissao (id_pesquisa, sigla_centro, data) VALUES
    (1, 'CCA', '2024-11-14'),
    (1, 'CESA', '2024-11-10'),
    (1, 'CCS', '2024-11-11'),
    (1, 'CCA', '2024-11-18'),
    (1, 'CEFE', '2024-11-19'),
    (1, 'CTU', '2024-11-13'),
    (1, 'CTU', '2024-11-21'),
    (1, 'CCH', '2024-11-06'),
    (1, 'CCE', '2024-11-14'),
    (1, 'CCH', '2024-11-09');

INSERT INTO resposta (id_submissao, id_questao, nota) VALUES
    (1, 1, 5), (1, 3, 5), (1, 7, 3), (1, 9, 3), (1, 12, 3), (1, 17, 3), (1, 22, 5),
    (2, 1, 4), (2, 3, 4), (2, 7, 4), (2, 9, 3), (2, 12, 3), (2, 17, 3), (2, 22, 4),
    (3, 1, 4), (3, 3, 1), (3, 7, 3), (3, 9, 2), (3, 12, 4), (3, 17, 4), (3, 22, 3),
    (4, 1, 3), (4, 3, 2), (4, 7, 3), (4, 9, 4), (4, 12, 4), (4, 17, 4), (4, 22, 3),
    (5, 1, 3), (5, 3, 4), (5, 7, 5), (5, 9, 4), (5, 12, 5), (5, 17, 5), (5, 22, 3),
    (6, 1, 2), (6, 3, 3), (6, 7, 2), (6, 9, 2), (6, 12, 3), (6, 17, 5), (6, 22, 4),
    (7, 1, 2), (7, 3, 2), (7, 7, 3), (7, 9, 2), (7, 12, 3), (7, 17, 4), (7, 22, 3),
    (8, 1, 2), (8, 3, 4), (8, 7, 4), (8, 9, 2), (8, 12, 4), (8, 17, 3), (8, 22, 3),
    (9, 1, 3), (9, 3, 3), (9, 7, 3), (9, 9, 2), (9, 12, 5), (9, 17, 5), (9, 22, 3),
    (10, 1, 5), (10, 3, 4), (10, 7, 2), (10, 9, 3), (10, 12, 4), (10, 17, 5), (10, 22, 4);

INSERT INTO resposta (id_submissao, id_questao, alternativa) VALUES
    (1, 26, 2),
    (2, 26, 3),
    (3, 26, 4),
    (4, 26, 2),
    (5, 26, 1),
    (6, 26, 3),
    (7, 26, 4),
    (8, 26, 1),
    (9, 26, 1),
    (10, 26, 2);

INSERT INTO resposta (id_submissao, id_questao, texto) VALUES
    (5, 29, 'A comida poderia vir mais quente.'),
    (6, 29, 'Menos sal no feijão.'),
    (9, 29, 'A comida poderia vir mais quente.');

-- Pesquisa 2: Satisfação com o RU - 1º semestre 2025 (12 respostas)
INSERT INTO participacao (id_aluno, id_pesquisa, data) VALUES
    (4, 2, '2025-05-17'),
    (5, 2, '2025-05-18'),
    (6, 2, '2025-05-05'),
    (9, 2, '2025-05-21'),
    (11, 2, '2025-05-15'),
    (13, 2, '2025-05-20'),
    (15, 2, '2025-05-20'),
    (17, 2, '2025-05-05'),
    (18, 2, '2025-05-16'),
    (19, 2, '2025-05-06'),
    (21, 2, '2025-05-13'),
    (22, 2, '2025-05-12');

-- Questionários desta pesquisa (submissões 11 a 22).
INSERT INTO submissao (id_pesquisa, sigla_centro, data) VALUES
    (2, 'CTU', '2025-05-21'),
    (2, 'CECA', '2025-05-13'),
    (2, 'CESA', '2025-05-20'),
    (2, 'CEFE', '2025-05-12'),
    (2, 'CCS', '2025-05-15'),
    (2, 'CCB', '2025-05-16'),
    (2, 'CCE', '2025-05-18'),
    (2, 'CCB', '2025-05-05'),
    (2, 'CCE', '2025-05-05'),
    (2, 'CCH', '2025-05-20'),
    (2, 'CCE', '2025-05-17'),
    (2, 'CCA', '2025-05-06');

INSERT INTO resposta (id_submissao, id_questao, nota) VALUES
    (11, 1, 5), (11, 3, 4), (11, 7, 2), (11, 9, 4), (11, 12, 3), (11, 17, 5), (11, 22, 1),
    (12, 1, 4), (12, 3, 3), (12, 7, 4), (12, 9, 3), (12, 12, 4), (12, 17, 3), (12, 22, 4),
    (13, 1, 4), (13, 3, 4), (13, 7, 4), (13, 9, 4), (13, 12, 4), (13, 17, 2), (13, 22, 4),
    (14, 1, 4), (14, 3, 2), (14, 7, 3), (14, 9, 3), (14, 12, 3), (14, 17, 4), (14, 22, 3),
    (15, 1, 3), (15, 3, 4), (15, 7, 3), (15, 9, 2), (15, 12, 3), (15, 17, 4), (15, 22, 4),
    (16, 1, 3), (16, 3, 4), (16, 7, 3), (16, 9, 4), (16, 12, 3), (16, 17, 4), (16, 22, 3),
    (17, 1, 4), (17, 3, 4), (17, 7, 3), (17, 9, 3), (17, 12, 5), (17, 17, 4), (17, 22, 3),
    (18, 1, 3), (18, 3, 3), (18, 7, 1), (18, 9, 3), (18, 12, 2), (18, 17, 4), (18, 22, 2),
    (19, 1, 4), (19, 3, 4), (19, 7, 3), (19, 9, 3), (19, 12, 5), (19, 17, 4), (19, 22, 5),
    (20, 1, 3), (20, 3, 3), (20, 7, 4), (20, 9, 3), (20, 12, 4), (20, 17, 4), (20, 22, 3),
    (21, 1, 3), (21, 3, 4), (21, 7, 2), (21, 9, 3), (21, 12, 4), (21, 17, 4), (21, 22, 3),
    (22, 1, 4), (22, 3, 4), (22, 7, 2), (22, 9, 3), (22, 12, 5), (22, 17, 3), (22, 22, 5);

INSERT INTO resposta (id_submissao, id_questao, alternativa) VALUES
    (11, 26, 1),
    (12, 26, 1),
    (13, 26, 3),
    (14, 26, 4),
    (15, 26, 1),
    (16, 26, 3),
    (17, 26, 2),
    (18, 26, 1),
    (19, 26, 3),
    (20, 26, 4),
    (21, 26, 1),
    (22, 26, 4);

INSERT INTO resposta (id_submissao, id_questao, texto) VALUES
    (13, 29, 'Mais variedade de saladas.'),
    (15, 29, 'A comida poderia vir mais quente.'),
    (20, 29, 'Mais opções de proteína no almoço.');

-- Pesquisa 3: Satisfação com o RU - 2º semestre 2025 (13 respostas)
INSERT INTO participacao (id_aluno, id_pesquisa, data) VALUES
    (4, 3, '2025-10-28'),
    (8, 3, '2025-11-06'),
    (9, 3, '2025-11-09'),
    (12, 3, '2025-11-04'),
    (13, 3, '2025-11-09'),
    (14, 3, '2025-11-02'),
    (16, 3, '2025-11-11'),
    (17, 3, '2025-11-06'),
    (18, 3, '2025-11-05'),
    (19, 3, '2025-11-07'),
    (20, 3, '2025-11-03'),
    (21, 3, '2025-11-06'),
    (22, 3, '2025-11-10');

-- Questionários desta pesquisa (submissões 23 a 35).
INSERT INTO submissao (id_pesquisa, sigla_centro, data) VALUES
    (3, 'CCA', '2025-11-03'),
    (3, 'CCE', '2025-10-28'),
    (3, 'CCH', '2025-11-02'),
    (3, 'CESA', '2025-11-11'),
    (3, 'CTU', '2025-11-09'),
    (3, 'CTU', '2025-11-06'),
    (3, 'CCB', '2025-11-05'),
    (3, 'CCA', '2025-11-07'),
    (3, 'CCS', '2025-11-04'),
    (3, 'CEFE', '2025-11-10'),
    (3, 'CCH', '2025-11-09'),
    (3, 'CECA', '2025-11-06'),
    (3, 'CCB', '2025-11-06');

INSERT INTO resposta (id_submissao, id_questao, nota) VALUES
    (23, 1, 3), (23, 3, 4), (23, 7, 2), (23, 9, 2), (23, 12, 3), (23, 17, 4), (23, 22, 2),
    (24, 1, 4), (24, 3, 3), (24, 7, 2), (24, 9, 4), (24, 12, 5), (24, 17, 4), (24, 22, 5),
    (25, 1, 4), (25, 3, 3), (25, 7, 3), (25, 9, 2), (25, 12, 5), (25, 17, 5), (25, 22, 3),
    (26, 1, 4), (26, 3, 3), (26, 7, 2), (26, 9, 2), (26, 12, 3), (26, 17, 5), (26, 22, 4),
    (27, 1, 2), (27, 3, 2), (27, 7, 1), (27, 9, 1), (27, 12, 4), (27, 17, 5), (27, 22, 4),
    (28, 1, 3), (28, 3, 2), (28, 7, 3), (28, 9, 3), (28, 12, 4), (28, 17, 5), (28, 22, 3),
    (29, 1, 4), (29, 3, 3), (29, 7, 2), (29, 9, 2), (29, 12, 4), (29, 17, 5), (29, 22, 3),
    (30, 1, 4), (30, 3, 3), (30, 7, 3), (30, 9, 3), (30, 12, 4), (30, 17, 3), (30, 22, 5),
    (31, 1, 1), (31, 3, 3), (31, 7, 2), (31, 9, 2), (31, 12, 1), (31, 17, 2), (31, 22, 4),
    (32, 1, 4), (32, 3, 4), (32, 7, 2), (32, 9, 3), (32, 12, 5), (32, 17, 4), (32, 22, 3),
    (33, 1, 3), (33, 3, 3), (33, 7, 2), (33, 9, 3), (33, 12, 5), (33, 17, 5), (33, 22, 2),
    (34, 1, 4), (34, 3, 3), (34, 7, 4), (34, 9, 1), (34, 12, 5), (34, 17, 3), (34, 22, 4),
    (35, 1, 3), (35, 3, 4), (35, 7, 2), (35, 9, 3), (35, 12, 4), (35, 17, 5), (35, 22, 4);

INSERT INTO resposta (id_submissao, id_questao, alternativa) VALUES
    (23, 26, 1),
    (24, 26, 2),
    (25, 26, 2),
    (26, 26, 4),
    (27, 26, 1),
    (28, 26, 2),
    (29, 26, 1),
    (30, 26, 4),
    (31, 26, 1),
    (32, 26, 1),
    (33, 26, 2),
    (34, 26, 1),
    (35, 26, 2);

INSERT INTO resposta (id_submissao, id_questao, texto) VALUES
    (25, 29, 'Menos sal no feijão.'),
    (34, 29, 'Melhorou bastante depois da troca de fornecedor.');

-- Pesquisa 4: Satisfação com o RU - 1º semestre 2026 (14 respostas)
INSERT INTO participacao (id_aluno, id_pesquisa, data) VALUES
    (4, 4, '2026-05-11'),
    (5, 4, '2026-05-08'),
    (6, 4, '2026-05-13'),
    (7, 4, '2026-05-20'),
    (9, 4, '2026-05-20'),
    (11, 4, '2026-05-12'),
    (12, 4, '2026-05-16'),
    (13, 4, '2026-05-09'),
    (14, 4, '2026-05-14'),
    (16, 4, '2026-05-21'),
    (18, 4, '2026-05-08'),
    (19, 4, '2026-05-07'),
    (20, 4, '2026-05-20'),
    (21, 4, '2026-05-11');

-- Questionários desta pesquisa (submissões 36 a 49).
INSERT INTO submissao (id_pesquisa, sigla_centro, data) VALUES
    (4, 'CTU', '2026-05-20'),
    (4, 'CCS', '2026-05-12'),
    (4, 'CCE', '2026-05-11'),
    (4, 'CCB', '2026-05-08'),
    (4, 'CCA', '2026-05-07'),
    (4, 'CCS', '2026-05-16'),
    (4, 'CCE', '2026-05-08'),
    (4, 'CCH', '2026-05-09'),
    (4, 'CESA', '2026-05-21'),
    (4, 'CCH', '2026-05-14'),
    (4, 'CECA', '2026-05-11'),
    (4, 'CTU', '2026-05-20'),
    (4, 'CCA', '2026-05-20'),
    (4, 'CCE', '2026-05-13');

INSERT INTO resposta (id_submissao, id_questao, nota) VALUES
    (36, 1, 4), (36, 3, 5), (36, 7, 2), (36, 9, 2), (36, 12, 3), (36, 17, 5), (36, 22, 3),
    (37, 1, 3), (37, 3, 3), (37, 7, 1), (37, 9, 1), (37, 12, 1), (37, 17, 5), (37, 22, 2),
    (38, 1, 3), (38, 3, 4), (38, 7, 3), (38, 9, 1), (38, 12, 4), (38, 17, 4), (38, 22, 3),
    (39, 1, 5), (39, 3, 5), (39, 7, 3), (39, 9, 1), (39, 12, 4), (39, 17, 4), (39, 22, 3),
    (40, 1, 4), (40, 3, 3), (40, 7, 2), (40, 9, 1), (40, 12, 4), (40, 17, 4), (40, 22, 3),
    (41, 1, 5), (41, 3, 4), (41, 7, 1), (41, 9, 2), (41, 12, 3), (41, 17, 3), (41, 22, 3),
    (42, 1, 4), (42, 3, 4), (42, 7, 2), (42, 9, 2), (42, 12, 4), (42, 17, 4), (42, 22, 4),
    (43, 1, 3), (43, 3, 4), (43, 7, 2), (43, 9, 3), (43, 12, 5), (43, 17, 4), (43, 22, 3),
    (44, 1, 4), (44, 3, 4), (44, 7, 3), (44, 9, 2), (44, 12, 5), (44, 17, 5), (44, 22, 4),
    (45, 1, 4), (45, 3, 5), (45, 7, 3), (45, 9, 4), (45, 12, 4), (45, 17, 4), (45, 22, 5),
    (46, 1, 5), (46, 3, 3), (46, 7, 2), (46, 9, 3), (46, 12, 4), (46, 17, 4), (46, 22, 5),
    (47, 1, 4), (47, 3, 3), (47, 7, 2), (47, 9, 1), (47, 12, 4), (47, 17, 2), (47, 22, 5),
    (48, 1, 4), (48, 3, 4), (48, 7, 2), (48, 9, 3), (48, 12, 5), (48, 17, 3), (48, 22, 4),
    (49, 1, 3), (49, 3, 4), (49, 7, 2), (49, 9, 1), (49, 12, 4), (49, 17, 4), (49, 22, 4);

INSERT INTO resposta (id_submissao, id_questao, alternativa) VALUES
    (36, 26, 4),
    (37, 26, 3),
    (38, 26, 1),
    (39, 26, 3),
    (40, 26, 3),
    (41, 26, 4),
    (42, 26, 2),
    (43, 26, 3),
    (44, 26, 2),
    (45, 26, 1),
    (46, 26, 4),
    (47, 26, 3),
    (48, 26, 3),
    (49, 26, 4);

INSERT INTO resposta (id_submissao, id_questao, texto) VALUES
    (37, 29, 'Melhorou bastante depois da troca de fornecedor.'),
    (38, 29, 'A comida poderia vir mais quente.'),
    (45, 29, 'Melhorou bastante depois da troca de fornecedor.'),
    (48, 29, 'Melhorou bastante depois da troca de fornecedor.');

-- Pesquisa 5: Jantar do RU - novembro/2026 (6 respostas)
INSERT INTO participacao (id_aluno, id_pesquisa, data) VALUES
    (4, 5, '2026-11-22'),
    (6, 5, '2026-11-22'),
    (7, 5, '2026-11-23'),
    (9, 5, '2026-11-14'),
    (17, 5, '2026-11-21'),
    (20, 5, '2026-11-11');

-- Questionários desta pesquisa (submissões 50 a 55).
INSERT INTO submissao (id_pesquisa, sigla_centro, data) VALUES
    (5, 'CCE', '2026-11-22'),
    (5, 'CCA', '2026-11-11'),
    (5, 'CCB', '2026-11-21'),
    (5, 'CTU', '2026-11-23'),
    (5, 'CCE', '2026-11-22'),
    (5, 'CTU', '2026-11-14');

INSERT INTO resposta (id_submissao, id_questao, nota) VALUES
    (50, 1, 4), (50, 2, 3), (50, 8, 3), (50, 10, 2), (50, 11, 1), (50, 18, 5), (50, 20, 4), (50, 24, 3), (50, 25, 4),
    (51, 1, 4), (51, 2, 4), (51, 8, 3), (51, 10, 3), (51, 11, 3), (51, 18, 4), (51, 20, 4), (51, 24, 4), (51, 25, 3),
    (52, 1, 4), (52, 2, 3), (52, 8, 1), (52, 10, 2), (52, 11, 1), (52, 18, 3), (52, 20, 5), (52, 24, 5), (52, 25, 4),
    (53, 1, 5), (53, 2, 5), (53, 8, 1), (53, 10, 2), (53, 11, 1), (53, 18, 4), (53, 20, 4), (53, 24, 4), (53, 25, 3),
    (54, 1, 5), (54, 2, 3), (54, 8, 2), (54, 10, 2), (54, 11, 1), (54, 18, 4), (54, 20, 5), (54, 24, 3), (54, 25, 5),
    (55, 1, 4), (55, 2, 5), (55, 8, 1), (55, 10, 2), (55, 11, 2), (55, 18, 4), (55, 20, 4), (55, 24, 4), (55, 25, 3);

INSERT INTO resposta (id_submissao, id_questao, alternativa) VALUES
    (50, 28, 2),
    (51, 28, 3),
    (52, 28, 2),
    (53, 28, 3),
    (54, 28, 3),
    (55, 28, 1);
