# Pesquisa de Satisfação do RU — UEL

Projeto da disciplina **Banco de Dados I** (UEL, 2026) — Prof. Dr. Anderson Paulo Avila Santos.

## Integrantes

- Ruan Magalhães
- Gabriel Soares

## Natureza do sistema

**Pesquisa de satisfação** do Restaurante Universitário (RU) da UEL.

A equipe do RU (administradores) cadastra questões, montadas em pesquisas, e escolhe quais centros da
UEL devem responder cada pesquisa. As questões são de escala de 1 a 5, múltipla escolha ou texto livre,
separadas por tema: Comida, Fila, Limpeza, Atendimento, Cardápio e Preço. Os alunos entram com login,
informando matrícula e centro, e respondem as pesquisas abertas para o seu centro.

## Particularidade

**Todas as respostas são anônimas.** O sistema guarda em lugares separados:

- `participacao`: **quem** já respondeu cada pesquisa, para ninguém responder duas vezes;
- `submissao` + `resposta`: **o que** foi respondido, sem nenhuma ligação com o aluno. Fica guardado
  apenas o centro, para os relatórios compararem grupos.

Ou seja: o sistema sabe que o aluno respondeu, mas não sabe o que ele respondeu.
Os relatórios comparam **temas**, **períodos** e **centros**.
