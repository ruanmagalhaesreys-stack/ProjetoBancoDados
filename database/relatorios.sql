-- =====================================================================
-- Pesquisa de Satisfação do RU da UEL
-- relatorios.sql: consultas dos 3 relatórios.
--
-- Os valores fixos (datas, centros, texto da busca, id da pesquisa) são
-- exemplos. No sistema eles vêm dos filtros da tela e entram no lugar
-- dos "?" do PreparedStatement (ver RelatorioDAO.java).
--
-- Só as respostas de escala (coluna nota, de 1 a 5) entram nas médias.
--
-- Recursos SQL pedidos no enunciado e onde aparecem:
--   JOIN ................................ relatórios 1, 2 e 3
--   LEFT JOIN ........................... relatório 3
--   COUNT, AVG, GROUP BY, HAVING ........ relatórios 1, 2 e 3 (HAVING no 1)
--   Subconsulta ......................... relatório 2 (média geral)
--   ORDER BY, FETCH FIRST, RANK() ....... relatório 2
--   WHERE com datas, IN, LIKE ........... relatórios 1 (BETWEEN e IN) e 2 (LIKE)
-- =====================================================================

SET client_encoding = 'UTF8';  -- o arquivo está em UTF-8 (acentos)


-- ---------------------------------------------------------------------
-- RELATÓRIO 1 - Satisfação média por tema
-- Filtros da tela: período (data de abertura da pesquisa) e centros.
-- Recursos: JOIN, AVG, COUNT, GROUP BY, HAVING, BETWEEN com datas, IN.
-- ---------------------------------------------------------------------
SELECT t.nome                AS tema,
       ROUND(AVG(r.nota), 2) AS media,
       COUNT(*)              AS respostas
FROM resposta r
JOIN submissao s ON s.id = r.id_submissao
JOIN pesquisa p  ON p.id = s.id_pesquisa
JOIN questao q   ON q.id = r.id_questao
JOIN tema t      ON t.id = q.id_tema
WHERE r.nota IS NOT NULL
  AND p.data_inicio BETWEEN '2024-01-01' AND '2026-12-31'
  AND s.sigla_centro IN ('CCE', 'CTU', 'CCS', 'CCH', 'CESA', 'CCB', 'CCA', 'CECA', 'CEFE')
GROUP BY t.nome
HAVING COUNT(*) >= 3
ORDER BY media DESC;


-- ---------------------------------------------------------------------
-- RELATÓRIO 2 - As 10 questões mais mal avaliadas
-- Filtro da tela: busca por um texto no enunciado (ex.: fila).
-- Recursos: JOIN, AVG, COUNT, GROUP BY, LIKE, subconsulta (média geral
-- de todas as notas), RANK() para a posição, ORDER BY e FETCH FIRST.
-- ---------------------------------------------------------------------
SELECT RANK() OVER (ORDER BY AVG(r.nota)) AS posicao,
       q.id,
       q.enunciado,
       t.nome                             AS tema,
       COUNT(*)                           AS respostas,
       ROUND(AVG(r.nota), 2)              AS media,
       (SELECT ROUND(AVG(nota), 2) FROM resposta) AS media_geral
FROM resposta r
JOIN questao q ON q.id = r.id_questao
JOIN tema t    ON t.id = q.id_tema
WHERE r.nota IS NOT NULL
  AND LOWER(q.enunciado) LIKE '%fila%'
GROUP BY q.id, q.enunciado, t.nome
ORDER BY posicao, q.id
FETCH FIRST 10 ROWS ONLY;


-- ---------------------------------------------------------------------
-- RELATÓRIO 3 - Participação por centro e quem ainda não respondeu
-- Filtro da tela: a pesquisa.
-- Recursos: LEFT JOIN (para contar também quem não respondeu), COUNT,
-- GROUP BY, ORDER BY e IS NULL.
-- ---------------------------------------------------------------------

-- 3a. Para cada centro que deve responder: alunos, quantos responderam
--     e a taxa de participação.
SELECT pc.sigla_centro                                 AS centro,
       COUNT(u.id)                                     AS alunos,
       COUNT(pa.id_aluno)                              AS responderam,
       ROUND(100.0 * COUNT(pa.id_aluno) / COUNT(u.id)) AS taxa
FROM pesquisa_centro pc
JOIN usuario u            ON u.sigla_centro = pc.sigla_centro
LEFT JOIN participacao pa ON pa.id_aluno = u.id
                         AND pa.id_pesquisa = pc.id_pesquisa
WHERE pc.id_pesquisa = 5
GROUP BY pc.sigla_centro
ORDER BY taxa DESC, centro;

-- 3b. Alunos dos centros-alvo que ainda não responderam.
SELECT u.nome, u.matricula, u.sigla_centro
FROM pesquisa_centro pc
JOIN usuario u            ON u.sigla_centro = pc.sigla_centro
LEFT JOIN participacao pa ON pa.id_aluno = u.id
                         AND pa.id_pesquisa = pc.id_pesquisa
WHERE pc.id_pesquisa = 5
  AND pa.id_aluno IS NULL
ORDER BY u.sigla_centro, u.nome;
