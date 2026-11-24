package br.uel.ru.controller;

import br.uel.ru.dao.PesquisaDAO;
import br.uel.ru.dao.QuestaoDAO;
import br.uel.ru.model.Pesquisa;
import br.uel.ru.model.Usuario;
import br.uel.ru.service.RespostaService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.sql.SQLException;
import java.util.Map;

/** Área do aluno: ver as pesquisas abertas e responder (RF5). */
@Controller
public class AlunoController {

    private PesquisaDAO pesquisaDAO = new PesquisaDAO();
    private QuestaoDAO questaoDAO = new QuestaoDAO();
    private RespostaService respostaService = new RespostaService();

    @GetMapping("/aluno/pesquisas")
    public String minhasPesquisas(HttpSession session, Model model) throws SQLException {
        Usuario aluno = (Usuario) session.getAttribute("usuario");
        model.addAttribute("pesquisas", pesquisaDAO.listarAbertasParaAluno(aluno.getId(), aluno.getSiglaCentro()));
        return "aluno/pesquisas";
    }

    @GetMapping("/aluno/pesquisas/{id}")
    public String formulario(@PathVariable int id, HttpSession session, Model model) throws SQLException {
        Usuario aluno = (Usuario) session.getAttribute("usuario");
        try {
            respostaService.verificar(aluno, id);
        } catch (IllegalArgumentException e) {
            model.addAttribute("erro", e.getMessage());
            return minhasPesquisas(session, model);
        }
        Pesquisa pesquisa = pesquisaDAO.buscar(id);
        pesquisa.setQuestoes(questaoDAO.listarPorPesquisa(id));
        model.addAttribute("pesquisa", pesquisa);
        return "aluno/responder";
    }

    @PostMapping("/aluno/pesquisas/{id}")
    public String responder(@PathVariable int id, @RequestParam Map<String, String> valores,
                            HttpSession session, Model model, RedirectAttributes redirect) throws SQLException {
        Usuario aluno = (Usuario) session.getAttribute("usuario");
        try {
            respostaService.verificar(aluno, id);
        } catch (IllegalArgumentException e) {
            // já respondeu ou a pesquisa não é para o centro dele: volta para a lista
            redirect.addFlashAttribute("erro", e.getMessage());
            return "redirect:/aluno/pesquisas";
        }
        try {
            respostaService.responder(aluno, id, valores);
        } catch (IllegalArgumentException | SQLException e) {
            // faltou alguma resposta: volta para o formulário, com o que já foi marcado
            model.addAttribute("erro", "Não foi possível registrar: " + e.getMessage());
            return formulario(id, session, model);
        }
        redirect.addFlashAttribute("msg", "Obrigado! Suas respostas foram registradas de forma anônima.");
        return "redirect:/aluno/pesquisas";
    }
}
