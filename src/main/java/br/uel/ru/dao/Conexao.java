package br.uel.ru.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

// Abre a conexão com o banco PostgreSQL usando JDBC.
// Todos os DAOs chamam Conexao.abrir() para falar com o banco.
public class Conexao {

    // Endereço do banco: servidor na própria máquina (localhost), porta 5432, banco ru_uel.
    // Se o seu PostgreSQL tiver outra senha, troque aqui.
    private static final String URL = "jdbc:postgresql://localhost:5432/ru_uel";
    private static final String USUARIO = "postgres";
    private static final String SENHA = "postgres";

    // DriverManager usa o driver do PostgreSQL para abrir a conexão.
    public static Connection abrir() throws SQLException {
        return DriverManager.getConnection(URL, USUARIO, SENHA);
    }
}
