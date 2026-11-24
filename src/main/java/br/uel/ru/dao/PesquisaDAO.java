package br.uel.ru.dao;

import br.uel.ru.model.Pesquisa;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

// Acesso às tabelas pesquisa, pesquisa_questao e pesquisa_centro.
public class PesquisaDAO {

    // Colunas usadas nas listagens. As duas subconsultas trazem os centros
    // da pesquisa (ex.: "CCE, CTU") e quantas pessoas já responderam.
    private static final String SELECT_PESQUISA =
            "SELECT p.id, p.titulo, p.descricao, p.data_inicio, p.data_fim, "
          + "  (SELECT string_agg(pc.sigla_centro, ', ' ORDER BY pc.sigla_centro) "
          + "     FROM pesquisa_centro pc WHERE pc.id_pesquisa = p.id) AS centros, "
          + "  (SELECT COUNT(*) FROM participacao pa WHERE pa.id_pesquisa = p.id) AS qtd_respostas "
          + "FROM pesquisa p ";

    // Todas as pesquisas, das mais recentes para as mais antigas.
    public List<Pesquisa> listar() throws SQLException {
        List<Pesquisa> lista = new ArrayList<>();
        try (Connection con = Conexao.abrir();
             PreparedStatement st = con.prepareStatement(SELECT_PESQUISA + "ORDER BY p.data_inicio DESC");
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                lista.add(montar(rs));
            }
        }
        return lista;
    }

    public Pesquisa buscar(int id) throws SQLException {
        try (Connection con = Conexao.abrir();
             PreparedStatement st = con.prepareStatement(SELECT_PESQUISA + "WHERE p.id = ?")) {
            st.setInt(1, id);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return montar(rs);
                }
            }
        }
        return null;
    }

    // Pesquisas que o aluno pode responder agora: abertas hoje, destinadas
    // ao centro dele e que ele ainda não respondeu.
    public List<Pesquisa> listarAbertasParaAluno(int idAluno, String siglaCentro) throws SQLException {
        String sql = SELECT_PESQUISA
                + "WHERE CURRENT_DATE BETWEEN p.data_inicio AND p.data_fim "
                + "  AND EXISTS (SELECT 1 FROM pesquisa_centro pc "
                + "              WHERE pc.id_pesquisa = p.id AND pc.sigla_centro = ?) "
                + "  AND NOT EXISTS (SELECT 1 FROM participacao pa "
                + "                  WHERE pa.id_pesquisa = p.id AND pa.id_aluno = ?) "
                + "ORDER BY p.data_fim";
        List<Pesquisa> lista = new ArrayList<>();
        try (Connection con = Conexao.abrir();
             PreparedStatement st = con.prepareStatement(sql)) {
            st.setString(1, siglaCentro);
            st.setInt(2, idAluno);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    lista.add(montar(rs));
                }
            }
        }
        return lista;
    }

    public boolean existeTitulo(String titulo) throws SQLException {
        try (Connection con = Conexao.abrir();
             PreparedStatement st = con.prepareStatement("SELECT 1 FROM pesquisa WHERE titulo = ?")) {
            st.setString(1, titulo);
            try (ResultSet rs = st.executeQuery()) {
                return rs.next();
            }
        }
    }

    // Insere a pesquisa e devolve o id gerado. Faz parte de uma transação.
    public int inserir(Connection con, String titulo, String descricao,
                       LocalDate inicio, LocalDate fim, int idAdmin) throws SQLException {
        String sql = "INSERT INTO pesquisa (titulo, descricao, data_inicio, data_fim, id_admin) "
                   + "VALUES (?, ?, ?, ?, ?) RETURNING id";
        try (PreparedStatement st = con.prepareStatement(sql)) {
            st.setString(1, titulo);
            st.setString(2, descricao);
            st.setDate(3, Date.valueOf(inicio));
            st.setDate(4, Date.valueOf(fim));
            st.setInt(5, idAdmin);
            try (ResultSet rs = st.executeQuery()) {
                rs.next();
                return rs.getInt("id");
            }
        }
    }

    public void inserirQuestao(Connection con, int idPesquisa, int idQuestao, int ordem) throws SQLException {
        String sql = "INSERT INTO pesquisa_questao (id_pesquisa, id_questao, ordem) VALUES (?, ?, ?)";
        try (PreparedStatement st = con.prepareStatement(sql)) {
            st.setInt(1, idPesquisa);
            st.setInt(2, idQuestao);
            st.setInt(3, ordem);
            st.executeUpdate();
        }
    }

    public void inserirCentro(Connection con, int idPesquisa, String siglaCentro) throws SQLException {
        String sql = "INSERT INTO pesquisa_centro (id_pesquisa, sigla_centro) VALUES (?, ?)";
        try (PreparedStatement st = con.prepareStatement(sql)) {
            st.setInt(1, idPesquisa);
            st.setString(2, siglaCentro);
            st.executeUpdate();
        }
    }

    private Pesquisa montar(ResultSet rs) throws SQLException {
        Pesquisa p = new Pesquisa();
        p.setId(rs.getInt("id"));
        p.setTitulo(rs.getString("titulo"));
        p.setDescricao(rs.getString("descricao"));
        p.setDataInicio(rs.getDate("data_inicio").toLocalDate());
        p.setDataFim(rs.getDate("data_fim").toLocalDate());
        p.setCentros(rs.getString("centros"));
        p.setQtdRespostas(rs.getInt("qtd_respostas"));
        return p;
    }
}
