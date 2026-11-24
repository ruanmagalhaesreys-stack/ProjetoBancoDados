package br.uel.ru.dao;

import br.uel.ru.model.Centro;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

// Acesso à tabela centro.
// Todos os DAOs seguem o mesmo jeito de consultar, explicado aqui.
public class CentroDAO {

    // Devolve a lista de todos os centros, em ordem de sigla.
    public List<Centro> listar() throws SQLException {
        List<Centro> lista = new ArrayList<>();
        String sql = "SELECT sigla, nome FROM centro ORDER BY sigla";
        // O try (...) fecha sozinho a conexão, o comando e o resultado no final.
        // prepareStatement prepara o SQL e executeQuery roda a consulta.
        // O ResultSet guarda as linhas que o banco devolveu.
        try (Connection con = Conexao.abrir();
             PreparedStatement st = con.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            // rs.next() passa para a próxima linha; quando acabam as linhas, devolve false.
            while (rs.next()) {
                lista.add(new Centro(rs.getString("sigla"), rs.getString("nome")));
            }
        }
        return lista;
    }
}
