# Esquema relacional

DER: [DER.png](DER.png), na notação de Chen. O SQL completo está em [../database/schema.sql](../database/schema.sql).

Notação: **PK em negrito**, `→ tabela` indica chave estrangeira, *itálico* indica UNIQUE.

| Relação | Atributos | Passo do mapeamento (aula 07) |
|---|---|---|
| Centro | (**sigla**, *nome*) | passo 1: entidade |
| Usuario | (**id**, nome, *email*, senha, tipo, *matricula*, sigla_centro → Centro) | passo 1 + passo 4 (Usuário N:1 Centro, FK no lado N; nula para administradores) |
| Tema | (**id**, *nome*) | passo 1 |
| Questao | (**id**, enunciado, tipo, id_tema → Tema) | passo 1 + passo 4 (Questão N:1 Tema) |
| Alternativa | (**id_questao** → Questao, **ordem**, texto) | passo 2: entidade fraca (chave do dono + chave parcial) |
| Pesquisa | (**id**, *titulo*, descricao, data_inicio, data_fim, id_admin → Usuario) | passo 1 + passo 4 (Usuário 1:N Pesquisa) |
| Pesquisa_Questao | (**id_pesquisa** → Pesquisa, **id_questao** → Questao, ordem) | passo 5: N:M "contém" |
| Pesquisa_Centro | (**id_pesquisa** → Pesquisa, **sigla_centro** → Centro) | passo 5: N:M "destinada a" |
| Participacao | (**id_aluno** → Usuario, **id_pesquisa** → Pesquisa, data) | passo 5: N:M "participa" |
| Submissao | (**id**, id_pesquisa → Pesquisa, sigla_centro → Centro, data) | passo 1 + passo 4 ("refere-se" e "vem de") |
| Resposta | (**id_submissao** → Submissao, **id_questao** → Questao, nota, alternativa, texto); (id_questao, alternativa) → Alternativa | passo 5: N:M "Resposta" |

## Principais restrições

- **CHECK**:
  - `tipo` do usuário (ADMIN ou ALUNO). O aluno precisa ter matrícula e centro, e o administrador não tem nenhum dos dois.
  - `tipo` da questão (ESCALA, MULTIPLA ou TEXTO).
  - `data_fim >= data_inicio` na pesquisa.
  - `nota BETWEEN 1 AND 5`.
  - Em cada resposta, exatamente um dos valores (`nota`, `alternativa`, `texto`) é preenchido.
- **UNIQUE**: email, matrícula, nome do centro e do tema, título da pesquisa e (pesquisa, ordem) em Pesquisa_Questao.
- **ON DELETE CASCADE**: apagar uma pesquisa apaga as suas questões escolhidas e os seus centros; apagar uma questão apaga as suas alternativas. Nas demais FKs vale o padrão: o banco recusa apagar o que está sendo usado.

## Anonimato (particularidade)

`Participacao` guarda **quem** respondeu e `Submissao`/`Resposta` guardam **o que** foi respondido. Não existe nenhuma chave estrangeira entre as duas partes. A submissão guarda apenas o centro (para os relatórios compararem grupos) e a data.

## Dependências funcionais e 3FN

| Relação | Dependências funcionais |
|---|---|
| Centro | sigla → nome |
| Usuario | id → nome, email, senha, tipo, matricula, sigla_centro; email → id; matricula → id |
| Tema | id → nome |
| Questao | id → enunciado, tipo, id_tema |
| Alternativa | (id_questao, ordem) → texto |
| Pesquisa | id → titulo, descricao, data_inicio, data_fim, id_admin |
| Pesquisa_Questao | (id_pesquisa, id_questao) → ordem |
| Participacao | (id_aluno, id_pesquisa) → data |
| Submissao | id → id_pesquisa, sigla_centro, data |
| Resposta | (id_submissao, id_questao) → nota, alternativa, texto |

**Justificativa da 3FN:** todos os atributos são atômicos (1FN). Em todas as relações, o lado esquerdo de cada dependência funcional é uma chave candidata. Então nenhum atributo depende de parte da chave (2FN) nem de outro atributo que não seja chave (3FN). O nome do centro e o do tema ficam em tabelas próprias, em vez de se repetirem nos usuários e nas questões.

O centro guardado em `Submissao` não é redundância: a submissão não tem ligação com o aluno, então o centro não pode ser obtido de outro lugar. É um fato da própria submissão.
