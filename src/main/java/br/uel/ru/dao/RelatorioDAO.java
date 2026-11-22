package br.uel.ru.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Consultas dos 3 relatórios (as mesmas de database/relatorios.sql).
 * Cada linha do resultado vira um Map: nome da coluna -> valor.
 * Na JSP, ${linha.media} lê o valor guardado com a chave "media".
 */
public class RelatorioDAO {

    /** Relatório 1: média de cada tema, no período e nos centros escolhidos. */
    public List<Map<String, Object>> satisfacaoPorTema(LocalDate inicio, LocalDate fim,
                                                       List<String> centros) throws SQLException {
        // Um "?" para cada centro escolhido: IN (?, ?, ?)
        String interrogacoes = "";
        for (int i = 0; i < centros.size(); i++) {
            interrogacoes += (i == 0 ? "?" : ", ?");
        }

        String sql = "SELECT t.nome AS tema, ROUND(AVG(r.nota), 2) AS media, COUNT(*) AS respostas "
                   + "FROM resposta r "
                   + "JOIN submissao s ON s.id = r.id_submissao "
                   + "JOIN pesquisa p  ON p.id = s.id_pesquisa "
                   + "JOIN questao q   ON q.id = r.id_questao "
                   + "JOIN tema t      ON t.id = q.id_tema "
                   + "WHERE r.nota IS NOT NULL "
                   + "  AND p.data_inicio BETWEEN ? AND ? "
                   + "  AND s.sigla_centro IN (" + interrogacoes + ") "
                   + "GROUP BY t.nome "
                   + "HAVING COUNT(*) >= 3 "
                   + "ORDER BY media DESC";

        List<Map<String, Object>> linhas = new ArrayList<>();
        try (Connection con = Conexao.abrir();
             PreparedStatement st = con.prepareStatement(sql)) {
            st.setDate(1, Date.valueOf(inicio));
            st.setDate(2, Date.valueOf(fim));
            for (int i = 0; i < centros.size(); i++) {
                st.setString(3 + i, centros.get(i));
            }
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> linha = new HashMap<>();
                    linha.put("tema", rs.getString("tema"));
                    linha.put("media", rs.getBigDecimal("media"));
                    linha.put("respostas", rs.getInt("respostas"));
                    linhas.add(linha);
                }
            }
        }
        return linhas;
    }

    /** Relatório 2: as 10 questões com pior média, com busca por texto. */
    public List<Map<String, Object>> rankingQuestoes(String busca) throws SQLException {
        String sql = "SELECT RANK() OVER (ORDER BY AVG(r.nota)) AS posicao, "
                   + "       q.id, q.enunciado, t.nome AS tema, COUNT(*) AS respostas, "
                   + "       ROUND(AVG(r.nota), 2) AS media, "
                   + "       (SELECT ROUND(AVG(nota), 2) FROM resposta) AS media_geral "
                   + "FROM resposta r "
                   + "JOIN questao q ON q.id = r.id_questao "
                   + "JOIN tema t    ON t.id = q.id_tema "
                   + "WHERE r.nota IS NOT NULL "
                   + "  AND LOWER(q.enunciado) LIKE ? "
                   + "GROUP BY q.id, q.enunciado, t.nome "
                   + "ORDER BY posicao, q.id "
                   + "FETCH FIRST 10 ROWS ONLY";

        List<Map<String, Object>> linhas = new ArrayList<>();
        try (Connection con = Conexao.abrir();
             PreparedStatement st = con.prepareStatement(sql)) {
            st.setString(1, "%" + busca.toLowerCase() + "%");
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> linha = new HashMap<>();
                    linha.put("posicao", rs.getInt("posicao"));
                    linha.put("id", rs.getInt("id"));
                    linha.put("enunciado", rs.getString("enunciado"));
                    linha.put("tema", rs.getString("tema"));
                    linha.put("respostas", rs.getInt("respostas"));
                    linha.put("media", rs.getBigDecimal("media"));
                    linha.put("mediaGeral", rs.getBigDecimal("media_geral"));
                    linhas.add(linha);
                }
            }
        }
        return linhas;
    }

    /** Relatório 3a: alunos de cada centro-alvo e quantos responderam. */
    public List<Map<String, Object>> participacaoPorCentro(int idPesquisa) throws SQLException {
        String sql = "SELECT pc.sigla_centro AS centro, "
                   + "       COUNT(u.id) AS alunos, "
                   + "       COUNT(pa.id_aluno) AS responderam, "
                   + "       ROUND(100.0 * COUNT(pa.id_aluno) / COUNT(u.id)) AS taxa "
                   + "FROM pesquisa_centro pc "
                   + "JOIN usuario u ON u.sigla_centro = pc.sigla_centro "
                   + "LEFT JOIN participacao pa ON pa.id_aluno = u.id "
                   + "                         AND pa.id_pesquisa = pc.id_pesquisa "
                   + "WHERE pc.id_pesquisa = ? "
                   + "GROUP BY pc.sigla_centro "
                   + "ORDER BY taxa DESC, centro";

        List<Map<String, Object>> linhas = new ArrayList<>();
        try (Connection con = Conexao.abrir();
             PreparedStatement st = con.prepareStatement(sql)) {
            st.setInt(1, idPesquisa);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> linha = new HashMap<>();
                    linha.put("centro", rs.getString("centro"));
                    linha.put("alunos", rs.getInt("alunos"));
                    linha.put("responderam", rs.getInt("responderam"));
                    linha.put("taxa", rs.getInt("taxa"));
                    linhas.add(linha);
                }
            }
        }
        return linhas;
    }

    /** Relatório 3b: alunos dos centros-alvo que ainda não responderam. */
    public List<Map<String, Object>> alunosQueNaoResponderam(int idPesquisa) throws SQLException {
        String sql = "SELECT u.nome, u.matricula, u.sigla_centro "
                   + "FROM pesquisa_centro pc "
                   + "JOIN usuario u ON u.sigla_centro = pc.sigla_centro "
                   + "LEFT JOIN participacao pa ON pa.id_aluno = u.id "
                   + "                         AND pa.id_pesquisa = pc.id_pesquisa "
                   + "WHERE pc.id_pesquisa = ? "
                   + "  AND pa.id_aluno IS NULL "
                   + "ORDER BY u.sigla_centro, u.nome";

        List<Map<String, Object>> linhas = new ArrayList<>();
        try (Connection con = Conexao.abrir();
             PreparedStatement st = con.prepareStatement(sql)) {
            st.setInt(1, idPesquisa);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> linha = new HashMap<>();
                    linha.put("nome", rs.getString("nome"));
                    linha.put("matricula", rs.getString("matricula"));
                    linha.put("centro", rs.getString("sigla_centro"));
                    linhas.add(linha);
                }
            }
        }
        return linhas;
    }
}
