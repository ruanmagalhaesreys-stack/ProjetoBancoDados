-- =====================================================================
-- Pesquisa de Satisfação do RU da UEL
-- schema.sql: cria o banco do zero, com todas as restrições.
-- Rodar num banco vazio:  psql -U postgres -d ru_uel -f database/schema.sql
-- =====================================================================

-- O arquivo está em UTF-8 (acentos). Sem isso, o psql no Windows pode
-- ler o arquivo com outra codificação e gravar os acentos errados.
SET client_encoding = 'UTF8';
SET client_min_messages = warning;

-- Para poder rodar o script mais de uma vez, apaga o que já existir.
DROP TABLE IF EXISTS resposta, submissao, participacao, pesquisa_centro,
                     pesquisa_questao, pesquisa, alternativa, questao, tema,
                     usuario, centro CASCADE;

-- ---------------------------------------------------------------------
-- Centros de estudo da UEL (CCE, CTU, ...).
-- ---------------------------------------------------------------------
CREATE TABLE centro (
    sigla VARCHAR(5)  PRIMARY KEY,
    nome  VARCHAR(80) NOT NULL UNIQUE
);

-- ---------------------------------------------------------------------
-- Usuários: administradores (equipe do RU) e alunos, na mesma tabela.
-- O aluno tem matrícula e centro; o administrador não tem.
-- ---------------------------------------------------------------------
CREATE TABLE usuario (
    id           SERIAL       PRIMARY KEY,
    nome         VARCHAR(100) NOT NULL,
    email        VARCHAR(100) NOT NULL UNIQUE,
    senha        VARCHAR(50)  NOT NULL,
    tipo         VARCHAR(5)   NOT NULL,
    matricula    VARCHAR(12)  UNIQUE,
    sigla_centro VARCHAR(5),
    FOREIGN KEY (sigla_centro) REFERENCES centro (sigla),
    CONSTRAINT ck_usuario_tipo CHECK (tipo IN ('ADMIN', 'ALUNO')),
    CONSTRAINT ck_usuario_aluno CHECK (
        (tipo = 'ALUNO' AND matricula IS NOT NULL AND sigla_centro IS NOT NULL)
     OR (tipo = 'ADMIN' AND matricula IS NULL AND sigla_centro IS NULL)
    )
);

-- ---------------------------------------------------------------------
-- Questões, agrupadas por tema (Comida, Fila, Limpeza...).
-- ---------------------------------------------------------------------
CREATE TABLE tema (
    id   SERIAL      PRIMARY KEY,
    nome VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE questao (
    id        SERIAL       PRIMARY KEY,
    enunciado VARCHAR(300) NOT NULL,
    tipo      VARCHAR(8)   NOT NULL,
    id_tema   INT          NOT NULL,
    FOREIGN KEY (id_tema) REFERENCES tema (id),
    CONSTRAINT ck_questao_tipo CHECK (tipo IN ('ESCALA', 'MULTIPLA', 'TEXTO'))
);

-- Entidade fraca: a alternativa só existe dentro da sua questão.
-- Chave = id da questão + ordem (chave parcial).
CREATE TABLE alternativa (
    id_questao INT          NOT NULL,
    ordem      SMALLINT     NOT NULL,
    texto      VARCHAR(150) NOT NULL,
    PRIMARY KEY (id_questao, ordem),
    FOREIGN KEY (id_questao) REFERENCES questao (id) ON DELETE CASCADE,
    CONSTRAINT ck_alternativa_ordem CHECK (ordem BETWEEN 1 AND 10)
);

-- ---------------------------------------------------------------------
-- Pesquisas, suas questões e os centros que devem responder.
-- ---------------------------------------------------------------------
CREATE TABLE pesquisa (
    id          SERIAL       PRIMARY KEY,
    titulo      VARCHAR(120) NOT NULL UNIQUE,
    descricao   VARCHAR(500),
    data_inicio DATE         NOT NULL,
    data_fim    DATE         NOT NULL,
    id_admin    INT          NOT NULL,
    FOREIGN KEY (id_admin) REFERENCES usuario (id),
    CONSTRAINT ck_pesquisa_datas CHECK (data_fim >= data_inicio)
);

-- N:M pesquisa x questão: a mesma questão pode estar em várias pesquisas.
CREATE TABLE pesquisa_questao (
    id_pesquisa INT      NOT NULL,
    id_questao  INT      NOT NULL,
    ordem       SMALLINT NOT NULL,
    PRIMARY KEY (id_pesquisa, id_questao),
    UNIQUE (id_pesquisa, ordem),
    FOREIGN KEY (id_pesquisa) REFERENCES pesquisa (id) ON DELETE CASCADE,
    FOREIGN KEY (id_questao)  REFERENCES questao (id)
);

-- N:M pesquisa x centro: quais centros devem responder cada pesquisa.
CREATE TABLE pesquisa_centro (
    id_pesquisa  INT        NOT NULL,
    sigla_centro VARCHAR(5) NOT NULL,
    PRIMARY KEY (id_pesquisa, sigla_centro),
    FOREIGN KEY (id_pesquisa)  REFERENCES pesquisa (id) ON DELETE CASCADE,
    FOREIGN KEY (sigla_centro) REFERENCES centro (sigla)
);

-- ---------------------------------------------------------------------
-- ANONIMATO: "quem respondeu" e "o que foi respondido" ficam em tabelas
-- separadas, sem nenhuma chave ligando uma à outra.
-- ---------------------------------------------------------------------

-- QUEM respondeu. A chave (aluno, pesquisa) impede responder duas vezes.
CREATE TABLE participacao (
    id_aluno    INT  NOT NULL,
    id_pesquisa INT  NOT NULL,
    data        DATE NOT NULL DEFAULT CURRENT_DATE,
    PRIMARY KEY (id_aluno, id_pesquisa),
    FOREIGN KEY (id_aluno)    REFERENCES usuario (id),
    FOREIGN KEY (id_pesquisa) REFERENCES pesquisa (id)
);

-- O QUE foi respondido: um questionário preenchido, SEM o aluno.
-- Guarda só o centro (para comparar grupos) e a data.
CREATE TABLE submissao (
    id           SERIAL     PRIMARY KEY,
    id_pesquisa  INT        NOT NULL,
    sigla_centro VARCHAR(5) NOT NULL,
    data         DATE       NOT NULL DEFAULT CURRENT_DATE,
    FOREIGN KEY (id_pesquisa)  REFERENCES pesquisa (id),
    FOREIGN KEY (sigla_centro) REFERENCES centro (sigla)
);

-- Resposta de cada questão: só uma das três colunas é preenchida,
-- conforme o tipo da questão (nota, alternativa ou texto).
CREATE TABLE resposta (
    id_submissao INT           NOT NULL,
    id_questao   INT           NOT NULL,
    nota         SMALLINT,
    alternativa  SMALLINT,
    texto        VARCHAR(1000),
    PRIMARY KEY (id_submissao, id_questao),
    FOREIGN KEY (id_submissao) REFERENCES submissao (id) ON DELETE CASCADE,
    FOREIGN KEY (id_questao)   REFERENCES questao (id),
    FOREIGN KEY (id_questao, alternativa) REFERENCES alternativa (id_questao, ordem),
    CONSTRAINT ck_resposta_nota CHECK (nota BETWEEN 1 AND 5),
    CONSTRAINT ck_resposta_um_valor CHECK (num_nonnulls(nota, alternativa, texto) = 1)
);
