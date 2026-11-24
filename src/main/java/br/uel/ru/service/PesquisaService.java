package br.uel.ru.service;

import br.uel.ru.dao.Conexao;
import br.uel.ru.dao.PesquisaDAO;
import br.uel.ru.dao.RespostaDAO;

import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

// Cadastro, edição e exclusão de pesquisas (RF2, RF3 e RF4).
public class PesquisaService {

    private PesquisaDAO pesquisaDAO = new PesquisaDAO();
    private RespostaDAO respostaDAO = new RespostaDAO();

    // Grava a pesquisa, as questões escolhidas e os centros que devem
    // responder. São três tabelas, então tudo roda numa transação.
    public void cadastrar(String titulo, String descricao, LocalDate inicio, LocalDate fim,
                          int idAdmin, List<Integer> questoes, List<String> centros) throws SQLException {
        validarDados(0, titulo, descricao, inicio, fim);
        validarEscolhas(questoes, centros);

        Connection con = Conexao.abrir();
        try {
            con.setAutoCommit(false); // começa a transação

            int idPesquisa = pesquisaDAO.inserir(con, titulo.trim(), descricao, inicio, fim, idAdmin);
            gravarEscolhas(con, idPesquisa, questoes, centros);

            con.commit(); // grava tudo
        } catch (SQLException e) {
            con.rollback(); // desfaz tudo
            throw e;
        } finally {
            con.close();
        }
    }

    // Muda uma pesquisa que já existe.
    // Título, descrição e datas podem mudar sempre (por exemplo, para prorrogar o prazo).
    // Questões e centros só podem mudar enquanto ninguém respondeu: depois disso,
    // mudar as questões deixaria as respostas antigas sem sentido.
    public void atualizar(int id, String titulo, String descricao, LocalDate inicio, LocalDate fim,
                          List<Integer> questoes, List<String> centros) throws SQLException {
        boolean temRespostas = pesquisaDAO.buscar(id).getQtdRespostas() > 0;
        validarDados(id, titulo, descricao, inicio, fim);
        if (!temRespostas) {
            validarEscolhas(questoes, centros);
        }

        Connection con = Conexao.abrir();
        try {
            con.setAutoCommit(false); // começa a transação

            pesquisaDAO.atualizar(con, id, titulo.trim(), descricao, inicio, fim);
            if (!temRespostas) {
                // apaga as escolhas antigas e grava as novas
                pesquisaDAO.removerQuestoes(con, id);
                pesquisaDAO.removerCentros(con, id);
                gravarEscolhas(con, id, questoes, centros);
            }

            con.commit(); // grava tudo
        } catch (SQLException e) {
            con.rollback(); // desfaz tudo
            throw e;
        } finally {
            con.close();
        }
    }

    // Exclui a pesquisa e todas as respostas dela, numa transação:
    // 1. apaga quem respondeu (participacao);
    // 2. apaga os questionários (submissao), e as respostas vão junto pelo CASCADE;
    // 3. apaga a pesquisa, e as questões escolhidas e os centros vão junto pelo CASCADE.
    // Se algum passo falhar, nada é apagado.
    public void excluir(int id) throws SQLException {
        Connection con = Conexao.abrir();
        try {
            con.setAutoCommit(false); // começa a transação

            respostaDAO.excluirParticipacoes(con, id);
            respostaDAO.excluirSubmissoes(con, id);
            pesquisaDAO.excluir(con, id);

            con.commit(); // apaga tudo
        } catch (SQLException e) {
            con.rollback(); // desfaz tudo
            throw e;
        } finally {
            con.close();
        }
    }

    // Confere título, descrição e datas.
    // idPesquisa é 0 num cadastro novo, ou o id da pesquisa que está sendo editada.
    private void validarDados(int idPesquisa, String titulo, String descricao,
                              LocalDate inicio, LocalDate fim) throws SQLException {
        if (titulo.isBlank() || titulo.trim().length() > 120) {
            throw new IllegalArgumentException("Informe o título da pesquisa (até 120 letras).");
        }
        if (descricao.length() > 500) {
            throw new IllegalArgumentException("A descrição pode ter até 500 letras.");
        }
        if (inicio == null || fim == null) {
            throw new IllegalArgumentException("Informe as datas de abertura e de fechamento.");
        }
        if (fim.isBefore(inicio)) {
            throw new IllegalArgumentException("A data de fim não pode ser antes da data de início.");
        }
        if (pesquisaDAO.existeTitulo(titulo.trim(), idPesquisa)) {
            throw new IllegalArgumentException("Já existe uma pesquisa com este título.");
        }
    }

    // Confere se foi escolhida pelo menos uma questão e um centro.
    private void validarEscolhas(List<Integer> questoes, List<String> centros) {
        if (questoes == null || questoes.isEmpty()) {
            throw new IllegalArgumentException("Escolha pelo menos uma questão.");
        }
        if (centros == null || centros.isEmpty()) {
            throw new IllegalArgumentException("Escolha pelo menos um centro.");
        }
    }

    // Grava as questões (na ordem escolhida) e os centros da pesquisa.
    private void gravarEscolhas(Connection con, int idPesquisa, List<Integer> questoes,
                                List<String> centros) throws SQLException {
        int ordem = 1;
        for (int idQuestao : questoes) {
            pesquisaDAO.inserirQuestao(con, idPesquisa, idQuestao, ordem);
            ordem++;
        }
        for (String centro : centros) {
            pesquisaDAO.inserirCentro(con, idPesquisa, centro);
        }
    }
}
