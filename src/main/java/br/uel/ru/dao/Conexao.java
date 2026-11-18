package br.uel.ru.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/** Abre conexões com o banco PostgreSQL (JDBC puro). */
public class Conexao {

    // Se o seu PostgreSQL tiver outra senha, troque aqui.
    private static final String URL = "jdbc:postgresql://localhost:5432/ru_uel";
    private static final String USUARIO = "postgres";
    private static final String SENHA = "postgres";

    public static Connection abrir() throws SQLException {
        return DriverManager.getConnection(URL, USUARIO, SENHA);
    }
}
