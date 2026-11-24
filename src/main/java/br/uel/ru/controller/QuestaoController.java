package br.uel.ru.controller;

import br.uel.ru.dao.QuestaoDAO;
import br.uel.ru.dao.TemaDAO;
import br.uel.ru.model.Questao;
import br.uel.ru.service.QuestaoService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.sql.SQLException;
import java.util.List;

// Telas do administrador para cadastrar e excluir questões (RF1).
@Controller
public class QuestaoController {

    private QuestaoDAO questaoDAO = new QuestaoDAO();
    private TemaDAO temaDAO = new TemaDAO();
    private QuestaoService questaoService = new QuestaoService();

    @GetMapping("/admin/questoes")
    public String listar(Model model) throws SQLException {
        model.addAttribute("questoes", questaoDAO.listar());
        return "questoes/lista";
    }

    @GetMapping("/admin/questoes/nova")
    public String nova(Model model) throws SQLException {
        model.addAttribute("temas", temaDAO.listar());
        return "questoes/form";
    }

    @PostMapping("/admin/questoes")
    public String salvar(@RequestParam String enunciado, @RequestParam String tipo,
                         @RequestParam int tema,
                         @RequestParam(required = false) List<String> alternativas,
                         Model model, RedirectAttributes redirect) throws SQLException {
        try {
            questaoService.cadastrar(enunciado, tipo, tema, alternativas);
        } catch (IllegalArgumentException | SQLException e) {
            // volta para o formulário com o erro (a tela mostra de novo o que foi digitado)
            model.addAttribute("erro", "Não foi possível salvar: " + e.getMessage());
            model.addAttribute("temas", temaDAO.listar());
            return "questoes/form";
        }
        // redireciona para a lista: assim um F5 não grava a questão de novo
        redirect.addFlashAttribute("msg", "Questão cadastrada.");
        return "redirect:/admin/questoes";
    }

    // Tela que pergunta se o administrador quer mesmo excluir a questão.
    @GetMapping("/admin/questoes/{id}/excluir")
    public String confirmarExclusao(@PathVariable int id, Model model,
                                    RedirectAttributes redirect) throws SQLException {
        Questao questao = questaoDAO.buscar(id);
        if (questao == null) {
            redirect.addFlashAttribute("erro", "Questão não encontrada.");
            return "redirect:/admin/questoes";
        }
        // se a questão já está em alguma pesquisa, nem mostra a confirmação
        try {
            questaoService.verificarExclusao(id);
        } catch (IllegalArgumentException e) {
            redirect.addFlashAttribute("erro", e.getMessage());
            return "redirect:/admin/questoes";
        }
        model.addAttribute("pergunta", "Excluir a questão nº " + id + ": \"" + questao.getEnunciado() + "\"?");
        model.addAttribute("acao", "/admin/questoes/" + id + "/excluir");
        model.addAttribute("voltar", "/admin/questoes");
        return "confirmar";
    }

    @PostMapping("/admin/questoes/{id}/excluir")
    public String excluir(@PathVariable int id, RedirectAttributes redirect) {
        try {
            questaoService.excluir(id);
            redirect.addFlashAttribute("msg", "Questão excluída.");
        } catch (IllegalArgumentException | SQLException e) {
            redirect.addFlashAttribute("erro", "Não foi possível excluir: " + e.getMessage());
        }
        return "redirect:/admin/questoes";
    }
}
