package br.uel.ru.dao;

import br.uel.ru.model.Tema;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/** Acesso à tabela tema. */
public class TemaDAO {

    public List<Tema> listar() throws SQLException {
        List<Tema> lista = new ArrayList<>();
        String sql = "SELECT id, nome FROM tema ORDER BY id";
        try (Connection con = Conexao.abrir();
             PreparedStatement st = con.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                lista.add(new Tema(rs.getInt("id"), rs.getString("nome")));
            }
        }
        return lista;
    }
}
