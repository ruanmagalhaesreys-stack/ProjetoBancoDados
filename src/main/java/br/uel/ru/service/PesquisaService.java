package br.uel.ru.service;

import br.uel.ru.dao.Conexao;
import br.uel.ru.dao.PesquisaDAO;

import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

/** Cadastro de pesquisas (RF2, RF3 e RF4). */
public class PesquisaService {

    private PesquisaDAO pesquisaDAO = new PesquisaDAO();

    /**
     * Grava a pesquisa, as questões escolhidas e os centros que devem
     * responder. São três tabelas, então tudo roda numa transação.
     */
    public void cadastrar(String titulo, String descricao, LocalDate inicio, LocalDate fim,
                          int idAdmin, List<Integer> questoes, List<String> centros) throws SQLException {
        if (titulo.isBlank() || titulo.trim().length() > 120) {
            throw new IllegalArgumentException("Informe o título da pesquisa (até 120 letras).");
        }
        if (descricao.length() > 500) {
            throw new IllegalArgumentException("A descrição pode ter até 500 letras.");
        }
        if (fim.isBefore(inicio)) {
            throw new IllegalArgumentException("A data de fim não pode ser antes da data de início.");
        }
        if (questoes == null || questoes.isEmpty()) {
            throw new IllegalArgumentException("Escolha pelo menos uma questão.");
        }
        if (centros == null || centros.isEmpty()) {
            throw new IllegalArgumentException("Escolha pelo menos um centro.");
        }
        if (pesquisaDAO.existeTitulo(titulo.trim())) {
            throw new IllegalArgumentException("Já existe uma pesquisa com este título.");
        }

        Connection con = Conexao.abrir();
        try {
            con.setAutoCommit(false); // começa a transação

            int idPesquisa = pesquisaDAO.inserir(con, titulo.trim(), descricao, inicio, fim, idAdmin);
            int ordem = 1;
            for (int idQuestao : questoes) {
                pesquisaDAO.inserirQuestao(con, idPesquisa, idQuestao, ordem);
                ordem++;
            }
            for (String centro : centros) {
                pesquisaDAO.inserirCentro(con, idPesquisa, centro);
            }

            con.commit(); // grava tudo
        } catch (SQLException e) {
            con.rollback(); // desfaz tudo
            throw e;
        } finally {
            con.close();
        }
    }
}
