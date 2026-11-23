package br.uel.ru.service;

import br.uel.ru.dao.Conexao;
import br.uel.ru.dao.QuestaoDAO;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/** Cadastro de questões (RF1). */
public class QuestaoService {

    private QuestaoDAO questaoDAO = new QuestaoDAO();

    /**
     * Grava a questão e, se for de múltipla escolha, as alternativas.
     * São duas tabelas, então tudo roda numa transação:
     * ou grava tudo (commit), ou nada (rollback).
     */
    public void cadastrar(String enunciado, String tipo, int idTema, List<String> alternativas)
            throws SQLException {
        // só as alternativas preenchidas contam
        List<String> preenchidas = new ArrayList<>();
        if (alternativas != null) {
            for (String a : alternativas) {
                if (!a.isBlank()) preenchidas.add(a.trim());
            }
        }
        if (enunciado.isBlank() || enunciado.trim().length() > 300) {
            throw new IllegalArgumentException("Escreva o enunciado da questão (até 300 letras).");
        }
        for (String a : preenchidas) {
            if (a.length() > 150) {
                throw new IllegalArgumentException("Cada alternativa pode ter até 150 letras.");
            }
        }
        if (tipo.equals("MULTIPLA") && preenchidas.size() < 2) {
            throw new IllegalArgumentException("Uma questão de múltipla escolha precisa de pelo menos 2 alternativas.");
        }

        Connection con = Conexao.abrir();
        try {
            con.setAutoCommit(false); // começa a transação

            int idQuestao = questaoDAO.inserir(con, enunciado.trim(), tipo, idTema);
            if (tipo.equals("MULTIPLA")) {
                for (int i = 0; i < preenchidas.size(); i++) {
                    questaoDAO.inserirAlternativa(con, idQuestao, i + 1, preenchidas.get(i));
                }
            }

            con.commit(); // grava tudo
        } catch (SQLException e) {
            con.rollback(); // desfaz tudo
            throw e;
        } finally {
            con.close();
        }
    }
}
