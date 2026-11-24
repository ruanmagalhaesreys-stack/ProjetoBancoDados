package br.uel.ru.service;

import br.uel.ru.dao.Conexao;
import br.uel.ru.dao.QuestaoDAO;
import br.uel.ru.dao.RespostaDAO;
import br.uel.ru.model.Questao;
import br.uel.ru.model.Resposta;
import br.uel.ru.model.Usuario;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

// O aluno responde uma pesquisa (RF5) de forma anônima (RF6).
public class RespostaService {

    private RespostaDAO respostaDAO = new RespostaDAO();
    private QuestaoDAO questaoDAO = new QuestaoDAO();

    // Confere se o aluno pode responder a pesquisa agora.
    public void verificar(Usuario aluno, int idPesquisa) throws SQLException {
        if (!respostaDAO.abertaParaCentro(idPesquisa, aluno.getSiglaCentro())) {
            throw new IllegalArgumentException("Esta pesquisa não está aberta para o seu centro.");
        }
        if (respostaDAO.jaRespondeu(aluno.getId(), idPesquisa)) {
            throw new IllegalArgumentException("Você já respondeu esta pesquisa.");
        }
    }

    // Grava as respostas do aluno numa transação, em três passos:
    // primeiro a participacao (quem respondeu), depois a submissao (o questionário,
    // sem o aluno, só com o centro) e por fim cada resposta, ligada à submissão.
    // Se qualquer passo falhar, nada fica gravado.
    // O mapa valores tem o que veio do formulário, por exemplo "q12" com a resposta da questão 12.
    public void responder(Usuario aluno, int idPesquisa, Map<String, String> valores) throws SQLException {
        verificar(aluno, idPesquisa);

        // Monta a lista de respostas a partir do formulário.
        List<Resposta> respostas = new ArrayList<>();
        for (Questao q : questaoDAO.listarPorPesquisa(idPesquisa)) {
            String valor = valores.get("q" + q.getId());
            Resposta r = new Resposta();
            r.setIdQuestao(q.getId());

            if (q.getTipo().equals("TEXTO")) {
                if (valor == null || valor.isBlank()) {
                    continue; // texto livre é opcional
                }
                if (valor.trim().length() > 1000) {
                    throw new IllegalArgumentException("O comentário pode ter até 1000 letras.");
                }
                r.setTexto(valor.trim());
            } else {
                if (valor == null || valor.isBlank()) {
                    throw new IllegalArgumentException("Responda a questão: " + q.getEnunciado());
                }
                if (q.getTipo().equals("ESCALA")) {
                    r.setNota(Integer.parseInt(valor));
                } else {
                    r.setAlternativa(Integer.parseInt(valor));
                }
            }
            respostas.add(r);
        }

        Connection con = Conexao.abrir();
        try {
            con.setAutoCommit(false); // começa a transação

            respostaDAO.inserirParticipacao(con, aluno.getId(), idPesquisa);
            int idSubmissao = respostaDAO.inserirSubmissao(con, idPesquisa, aluno.getSiglaCentro());
            for (Resposta r : respostas) {
                respostaDAO.inserirResposta(con, idSubmissao, r);
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
