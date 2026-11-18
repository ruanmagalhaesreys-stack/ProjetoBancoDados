package br.uel.ru.dao;

import br.uel.ru.model.Centro;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/** Acesso à tabela centro. */
public class CentroDAO {

    public List<Centro> listar() throws SQLException {
        List<Centro> lista = new ArrayList<>();
        String sql = "SELECT sigla, nome FROM centro ORDER BY sigla";
        try (Connection con = Conexao.abrir();
             PreparedStatement st = con.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                lista.add(new Centro(rs.getString("sigla"), rs.getString("nome")));
            }
        }
        return lista;
    }
}
