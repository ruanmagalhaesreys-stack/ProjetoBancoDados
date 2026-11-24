-- Pesquisa de Satisfação do RU da UEL
-- Este arquivo cria todas as tabelas do banco, com as suas restrições.
-- Para rodar: psql -U postgres -d ru_uel -f database/schema.sql

-- Avisa o banco que o arquivo está em UTF-8, para os acentos ficarem certos.
SET client_encoding = 'UTF8';
-- Esconde os avisos do PostgreSQL e mostra só os erros.
SET client_min_messages = warning;

-- Apaga as tabelas, se já existirem, para o script poder rodar de novo.
-- O CASCADE apaga junto as chaves estrangeiras que apontam para elas.
DROP TABLE IF EXISTS resposta, submissao, participacao, pesquisa_centro,
                     pesquisa_questao, pesquisa, alternativa, questao, tema,
                     usuario, centro CASCADE;

-- Centros de estudo da UEL, como CCE e CTU.
-- PRIMARY KEY é a chave da tabela: não repete e não pode ficar vazia.
-- UNIQUE impede dois centros com o mesmo nome.
CREATE TABLE centro (
    sigla VARCHAR(5)  PRIMARY KEY,
    nome  VARCHAR(80) NOT NULL UNIQUE
);

-- Usuários do sistema: administradores (equipe do RU) e alunos, na mesma tabela.
-- SERIAL faz o banco gerar o id sozinho (1, 2, 3...).
-- NOT NULL obriga a preencher a coluna.
-- O CHECK do aluno garante que ele tem matrícula e centro, e que o administrador não tem.
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

-- Temas que agrupam as questões, como Comida, Fila e Limpeza.
CREATE TABLE tema (
    id   SERIAL      PRIMARY KEY,
    nome VARCHAR(50) NOT NULL UNIQUE
);

-- Questões. O tipo pode ser escala (nota de 1 a 5), múltipla escolha ou texto livre.
-- FOREIGN KEY liga a questão a um tema que existe na tabela tema.
CREATE TABLE questao (
    id        SERIAL       PRIMARY KEY,
    enunciado VARCHAR(300) NOT NULL,
    tipo      VARCHAR(8)   NOT NULL,
    id_tema   INT          NOT NULL,
    FOREIGN KEY (id_tema) REFERENCES tema (id),
    CONSTRAINT ck_questao_tipo CHECK (tipo IN ('ESCALA', 'MULTIPLA', 'TEXTO'))
);

-- Alternativas das questões de múltipla escolha.
-- É uma entidade fraca: a alternativa só existe dentro da sua questão.
-- Por isso a chave é o id da questão junto com a ordem da alternativa.
-- ON DELETE CASCADE: se a questão for apagada, as alternativas dela também são.
CREATE TABLE alternativa (
    id_questao INT          NOT NULL,
    ordem      SMALLINT     NOT NULL,
    texto      VARCHAR(150) NOT NULL,
    PRIMARY KEY (id_questao, ordem),
    FOREIGN KEY (id_questao) REFERENCES questao (id) ON DELETE CASCADE,
    CONSTRAINT ck_alternativa_ordem CHECK (ordem BETWEEN 1 AND 10)
);

-- Pesquisas, com o período em que ficam abertas e o administrador que criou.
-- O CHECK não deixa a data de fim ser antes da data de início.
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

-- Questões de cada pesquisa (relacionamento N:M).
-- A mesma questão pode estar em várias pesquisas.
-- A ordem diz em que posição a questão aparece para o aluno.
CREATE TABLE pesquisa_questao (
    id_pesquisa INT      NOT NULL,
    id_questao  INT      NOT NULL,
    ordem       SMALLINT NOT NULL,
    PRIMARY KEY (id_pesquisa, id_questao),
    UNIQUE (id_pesquisa, ordem),
    FOREIGN KEY (id_pesquisa) REFERENCES pesquisa (id) ON DELETE CASCADE,
    FOREIGN KEY (id_questao)  REFERENCES questao (id)
);

-- Centros que devem responder cada pesquisa (relacionamento N:M).
CREATE TABLE pesquisa_centro (
    id_pesquisa  INT        NOT NULL,
    sigla_centro VARCHAR(5) NOT NULL,
    PRIMARY KEY (id_pesquisa, sigla_centro),
    FOREIGN KEY (id_pesquisa)  REFERENCES pesquisa (id) ON DELETE CASCADE,
    FOREIGN KEY (sigla_centro) REFERENCES centro (sigla)
);

-- As três tabelas abaixo garantem o anonimato.
-- Quem respondeu fica na tabela participacao.
-- O que foi respondido fica nas tabelas submissao e resposta.
-- Não existe nenhuma chave ligando uma parte à outra.

-- Guarda quem já respondeu cada pesquisa.
-- A chave (aluno, pesquisa) impede o aluno de responder duas vezes.
-- DEFAULT CURRENT_DATE preenche a data de hoje quando ela não é informada.
CREATE TABLE participacao (
    id_aluno    INT  NOT NULL,
    id_pesquisa INT  NOT NULL,
    data        DATE NOT NULL DEFAULT CURRENT_DATE,
    PRIMARY KEY (id_aluno, id_pesquisa),
    FOREIGN KEY (id_aluno)    REFERENCES usuario (id),
    FOREIGN KEY (id_pesquisa) REFERENCES pesquisa (id)
);

-- Um questionário respondido, sem o aluno.
-- Guarda só o centro (para comparar os grupos nos relatórios) e a data.
CREATE TABLE submissao (
    id           SERIAL     PRIMARY KEY,
    id_pesquisa  INT        NOT NULL,
    sigla_centro VARCHAR(5) NOT NULL,
    data         DATE       NOT NULL DEFAULT CURRENT_DATE,
    FOREIGN KEY (id_pesquisa)  REFERENCES pesquisa (id),
    FOREIGN KEY (sigla_centro) REFERENCES centro (sigla)
);

-- A resposta de cada questão dentro de um questionário.
-- Só uma das três colunas é preenchida, conforme o tipo da questão:
-- nota (escala), alternativa (múltipla escolha) ou texto (texto livre).
-- num_nonnulls conta quantas colunas estão preenchidas; o CHECK exige exatamente uma.
-- A chave estrangeira dupla garante que a alternativa escolhida existe naquela questão.
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
