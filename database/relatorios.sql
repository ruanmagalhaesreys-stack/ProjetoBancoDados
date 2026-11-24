-- Pesquisa de Satisfação do RU da UEL
-- Consultas dos 3 relatórios do sistema.
--
-- As datas, os centros, o texto da busca e o número da pesquisa usados aqui são exemplos.
-- No sistema, esses valores vêm dos filtros da tela (veja RelatorioDAO.java).
-- Só as questões de escala (coluna nota, de 1 a 5) entram nas médias.

-- Avisa o banco que o arquivo está em UTF-8, para os acentos ficarem certos.
SET client_encoding = 'UTF8';


-- Relatório 1: satisfação média por tema.
-- Mostra a média das notas de cada tema, nas pesquisas de um período e nos centros escolhidos.
-- Os JOIN juntam a resposta com a submissão, a pesquisa, a questão e o tema.
-- AVG calcula a média, COUNT conta as respostas e GROUP BY faz uma linha por tema.
-- ROUND(valor, 2) arredonda a média para duas casas depois da vírgula.
-- BETWEEN filtra o período e IN filtra os centros escolhidos.
-- HAVING mostra só os temas com pelo menos 3 respostas.
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


-- Relatório 2: as 10 questões mais mal avaliadas.
-- Mostra as questões com a menor média, com uma busca por texto no enunciado.
-- LIKE '%fila%' procura enunciados que tenham a palavra "fila" em qualquer lugar.
-- RANK() dá a posição de cada questão, da pior média para a melhor.
-- A subconsulta (o SELECT entre parênteses) calcula a média geral, para comparar.
-- FETCH FIRST 10 ROWS ONLY mostra só as 10 primeiras linhas.
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


-- Relatório 3: participação por centro e quem ainda não respondeu.
-- Usa duas consultas sobre a pesquisa escolhida na tela.

-- Primeira consulta: para cada centro da pesquisa, quantos alunos existem,
-- quantos responderam e a taxa de participação em porcentagem.
-- O LEFT JOIN traz também os alunos que não responderam (sem participação).
-- COUNT(pa.id_aluno) conta só quem tem participação, ou seja, quem respondeu.
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

-- Segunda consulta: a lista dos alunos que ainda não responderam.
-- É o mesmo LEFT JOIN, mas fica só com quem não tem participação (IS NULL).
SELECT u.nome, u.matricula, u.sigla_centro
FROM pesquisa_centro pc
JOIN usuario u            ON u.sigla_centro = pc.sigla_centro
LEFT JOIN participacao pa ON pa.id_aluno = u.id
                         AND pa.id_pesquisa = pc.id_pesquisa
WHERE pc.id_pesquisa = 5
  AND pa.id_aluno IS NULL
ORDER BY u.sigla_centro, u.nome;
