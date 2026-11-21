package br.uel.ru.dao;

import br.uel.ru.model.Resposta;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

/**
 * Acesso às tabelas participacao, submissao e resposta.
 *
 * ANONIMATO: participacao guarda QUEM respondeu; submissao e resposta
 * guardam O QUE foi respondido. A submissão nunca recebe o id do aluno.
 */
public class RespostaDAO {

    /** O aluno já respondeu esta pesquisa? */
    public boolean jaRespondeu(int idAluno, int idPesquisa) throws SQLException {
        String sql = "SELECT 1 FROM participacao WHERE id_aluno = ? AND id_pesquisa = ?";
        try (Connection con = Conexao.abrir();
             PreparedStatement st = con.prepareStatement(sql)) {
            st.setInt(1, idAluno);
            st.setInt(2, idPesquisa);
            try (ResultSet rs = st.executeQuery()) {
                return rs.next();
            }
        }
    }

    /** A pesquisa está aberta hoje e é destinada a este centro? */
    public boolean abertaParaCentro(int idPesquisa, String siglaCentro) throws SQLException {
        String sql = "SELECT 1 FROM pesquisa p "
                   + "JOIN pesquisa_centro pc ON pc.id_pesquisa = p.id "
                   + "WHERE p.id = ? AND pc.sigla_centro = ? "
                   + "  AND CURRENT_DATE BETWEEN p.data_inicio AND p.data_fim";
        try (Connection con = Conexao.abrir();
             PreparedStatement st = con.prepareStatement(sql)) {
            st.setInt(1, idPesquisa);
            st.setString(2, siglaCentro);
            try (ResultSet rs = st.executeQuery()) {
                return rs.next();
            }
        }
    }

    // ---- gravações: recebem a conexão do service (transação) ----

    /** Registra QUEM respondeu. */
    public void inserirParticipacao(Connection con, int idAluno, int idPesquisa) throws SQLException {
        String sql = "INSERT INTO participacao (id_aluno, id_pesquisa) VALUES (?, ?)";
        try (PreparedStatement st = con.prepareStatement(sql)) {
            st.setInt(1, idAluno);
            st.setInt(2, idPesquisa);
            st.executeUpdate();
        }
    }

    /** Cria a submissão anônima (só pesquisa e centro) e devolve o id. */
    public int inserirSubmissao(Connection con, int idPesquisa, String siglaCentro) throws SQLException {
        String sql = "INSERT INTO submissao (id_pesquisa, sigla_centro) VALUES (?, ?) RETURNING id";
        try (PreparedStatement st = con.prepareStatement(sql)) {
            st.setInt(1, idPesquisa);
            st.setString(2, siglaCentro);
            try (ResultSet rs = st.executeQuery()) {
                rs.next();
                return rs.getInt("id");
            }
        }
    }

    /** Grava a resposta de uma questão dentro da submissão. */
    public void inserirResposta(Connection con, int idSubmissao, Resposta r) throws SQLException {
        String sql = "INSERT INTO resposta (id_submissao, id_questao, nota, alternativa, texto) "
                   + "VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement st = con.prepareStatement(sql)) {
            st.setInt(1, idSubmissao);
            st.setInt(2, r.getIdQuestao());
            // só um dos três valores existe; os outros vão como NULL
            if (r.getNota() != null) st.setInt(3, r.getNota()); else st.setNull(3, Types.SMALLINT);
            if (r.getAlternativa() != null) st.setInt(4, r.getAlternativa()); else st.setNull(4, Types.SMALLINT);
            st.setString(5, r.getTexto());
            st.executeUpdate();
        }
    }
}
