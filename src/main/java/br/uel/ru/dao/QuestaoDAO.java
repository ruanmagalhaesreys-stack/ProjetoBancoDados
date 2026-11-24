package br.uel.ru.dao;

import br.uel.ru.model.Alternativa;
import br.uel.ru.model.Questao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

// Acesso às tabelas questao e alternativa.
public class QuestaoDAO {

    // Todas as questões, com o nome do tema e as alternativas.
    public List<Questao> listar() throws SQLException {
        String sql = "SELECT q.id, q.enunciado, q.tipo, q.id_tema, t.nome AS nome_tema "
                   + "FROM questao q JOIN tema t ON t.id = q.id_tema "
                   + "ORDER BY q.id_tema, q.id";
        List<Questao> lista = new ArrayList<>();
        try (Connection con = Conexao.abrir();
             PreparedStatement st = con.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                lista.add(montar(rs));
            }
        }
        for (Questao q : lista) {
            q.setAlternativas(listarAlternativas(q.getId()));
        }
        return lista;
    }

    // Questões de uma pesquisa, na ordem da pesquisa.
    public List<Questao> listarPorPesquisa(int idPesquisa) throws SQLException {
        String sql = "SELECT q.id, q.enunciado, q.tipo, q.id_tema, t.nome AS nome_tema "
                   + "FROM pesquisa_questao pq "
                   + "JOIN questao q ON q.id = pq.id_questao "
                   + "JOIN tema t ON t.id = q.id_tema "
                   + "WHERE pq.id_pesquisa = ? "
                   + "ORDER BY pq.ordem";
        List<Questao> lista = new ArrayList<>();
        try (Connection con = Conexao.abrir();
             PreparedStatement st = con.prepareStatement(sql)) {
            st.setInt(1, idPesquisa);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    lista.add(montar(rs));
                }
            }
        }
        for (Questao q : lista) {
            q.setAlternativas(listarAlternativas(q.getId()));
        }
        return lista;
    }

    // Uma questão pelo id. Devolve null se ela não existir.
    public Questao buscar(int id) throws SQLException {
        String sql = "SELECT q.id, q.enunciado, q.tipo, q.id_tema, t.nome AS nome_tema "
                   + "FROM questao q JOIN tema t ON t.id = q.id_tema "
                   + "WHERE q.id = ?";
        try (Connection con = Conexao.abrir();
             PreparedStatement st = con.prepareStatement(sql)) {
            st.setInt(1, id);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return montar(rs);
                }
            }
        }
        return null;
    }

    // Títulos das pesquisas que usam a questão. Se a lista vier vazia, a questão pode ser excluída.
    public List<String> listarPesquisasQueUsam(int idQuestao) throws SQLException {
        String sql = "SELECT p.titulo FROM pesquisa_questao pq "
                   + "JOIN pesquisa p ON p.id = pq.id_pesquisa "
                   + "WHERE pq.id_questao = ? "
                   + "ORDER BY p.titulo";
        List<String> titulos = new ArrayList<>();
        try (Connection con = Conexao.abrir();
             PreparedStatement st = con.prepareStatement(sql)) {
            st.setInt(1, idQuestao);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    titulos.add(rs.getString("titulo"));
                }
            }
        }
        return titulos;
    }

    // Apaga a questão. As alternativas dela são apagadas junto, por causa do
    // ON DELETE CASCADE da tabela alternativa (veja o schema.sql).
    // Se a questão estiver em alguma pesquisa, o banco recusa o DELETE,
    // porque a chave estrangeira de pesquisa_questao não tem CASCADE.
    public void excluir(int id) throws SQLException {
        try (Connection con = Conexao.abrir();
             PreparedStatement st = con.prepareStatement("DELETE FROM questao WHERE id = ?")) {
            st.setInt(1, id);
            st.executeUpdate();
        }
    }

    public List<Alternativa> listarAlternativas(int idQuestao) throws SQLException {
        String sql = "SELECT id_questao, ordem, texto FROM alternativa WHERE id_questao = ? ORDER BY ordem";
        List<Alternativa> lista = new ArrayList<>();
        try (Connection con = Conexao.abrir();
             PreparedStatement st = con.prepareStatement(sql)) {
            st.setInt(1, idQuestao);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    lista.add(new Alternativa(rs.getInt("id_questao"), rs.getInt("ordem"), rs.getString("texto")));
                }
            }
        }
        return lista;
    }

    // Insere a questão e devolve o id gerado (RETURNING id).
    // Recebe a conexão do service, porque faz parte de uma transação.
    public int inserir(Connection con, String enunciado, String tipo, int idTema) throws SQLException {
        String sql = "INSERT INTO questao (enunciado, tipo, id_tema) VALUES (?, ?, ?) RETURNING id";
        try (PreparedStatement st = con.prepareStatement(sql)) {
            st.setString(1, enunciado);
            st.setString(2, tipo);
            st.setInt(3, idTema);
            try (ResultSet rs = st.executeQuery()) {
                rs.next();
                return rs.getInt("id");
            }
        }
    }

    public void inserirAlternativa(Connection con, int idQuestao, int ordem, String texto) throws SQLException {
        String sql = "INSERT INTO alternativa (id_questao, ordem, texto) VALUES (?, ?, ?)";
        try (PreparedStatement st = con.prepareStatement(sql)) {
            st.setInt(1, idQuestao);
            st.setInt(2, ordem);
            st.setString(3, texto);
            st.executeUpdate();
        }
    }

    private Questao montar(ResultSet rs) throws SQLException {
        Questao q = new Questao();
        q.setId(rs.getInt("id"));
        q.setEnunciado(rs.getString("enunciado"));
        q.setTipo(rs.getString("tipo"));
        q.setIdTema(rs.getInt("id_tema"));
        q.setNomeTema(rs.getString("nome_tema"));
        return q;
    }
}
