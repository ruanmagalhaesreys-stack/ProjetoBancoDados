package br.uel.ru.dao;

import br.uel.ru.model.Usuario;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

// Acesso à tabela usuario (administradores e alunos).
public class UsuarioDAO {

    // Procura o usuário pelo email e senha. Devolve null se não achar.
    public Usuario autenticar(String email, String senha) throws SQLException {
        String sql = "SELECT id, nome, email, tipo, matricula, sigla_centro "
                   + "FROM usuario WHERE email = ? AND senha = ?";
        try (Connection con = Conexao.abrir();
             PreparedStatement st = con.prepareStatement(sql)) {
            st.setString(1, email);
            st.setString(2, senha);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    Usuario u = new Usuario();
                    u.setId(rs.getInt("id"));
                    u.setNome(rs.getString("nome"));
                    u.setEmail(rs.getString("email"));
                    u.setTipo(rs.getString("tipo"));
                    u.setMatricula(rs.getString("matricula"));
                    u.setSiglaCentro(rs.getString("sigla_centro"));
                    return u;
                }
            }
        }
        return null;
    }

    public boolean existeEmail(String email) throws SQLException {
        return existe("SELECT 1 FROM usuario WHERE email = ?", email);
    }

    public boolean existeMatricula(String matricula) throws SQLException {
        return existe("SELECT 1 FROM usuario WHERE matricula = ?", matricula);
    }

    private boolean existe(String sql, String valor) throws SQLException {
        try (Connection con = Conexao.abrir();
             PreparedStatement st = con.prepareStatement(sql)) {
            st.setString(1, valor);
            try (ResultSet rs = st.executeQuery()) {
                return rs.next();
            }
        }
    }

    public void inserirAluno(String nome, String email, String senha,
                             String matricula, String siglaCentro) throws SQLException {
        String sql = "INSERT INTO usuario (nome, email, senha, tipo, matricula, sigla_centro) "
                   + "VALUES (?, ?, ?, 'ALUNO', ?, ?)";
        try (Connection con = Conexao.abrir();
             PreparedStatement st = con.prepareStatement(sql)) {
            st.setString(1, nome);
            st.setString(2, email);
            st.setString(3, senha);
            st.setString(4, matricula);
            st.setString(5, siglaCentro);
            st.executeUpdate();
        }
    }

    public void inserirAdmin(String nome, String email, String senha) throws SQLException {
        String sql = "INSERT INTO usuario (nome, email, senha, tipo) VALUES (?, ?, ?, 'ADMIN')";
        try (Connection con = Conexao.abrir();
             PreparedStatement st = con.prepareStatement(sql)) {
            st.setString(1, nome);
            st.setString(2, email);
            st.setString(3, senha);
            st.executeUpdate();
        }
    }
}
