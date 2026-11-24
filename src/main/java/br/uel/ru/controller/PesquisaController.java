package br.uel.ru.controller;

import br.uel.ru.dao.CentroDAO;
import br.uel.ru.dao.PesquisaDAO;
import br.uel.ru.dao.QuestaoDAO;
import br.uel.ru.model.Usuario;
import br.uel.ru.service.PesquisaService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

// Telas do administrador para montar pesquisas (RF2, RF3 e RF4).
@Controller
public class PesquisaController {

    private PesquisaDAO pesquisaDAO = new PesquisaDAO();
    private QuestaoDAO questaoDAO = new QuestaoDAO();
    private CentroDAO centroDAO = new CentroDAO();
    private PesquisaService pesquisaService = new PesquisaService();

    @GetMapping("/admin/pesquisas")
    public String listar(Model model) throws SQLException {
        model.addAttribute("pesquisas", pesquisaDAO.listar());
        return "pesquisas/lista";
    }

    @GetMapping("/admin/pesquisas/nova")
    public String nova(Model model) throws SQLException {
        model.addAttribute("questoes", questaoDAO.listar());
        model.addAttribute("centros", centroDAO.listar());
        return "pesquisas/form";
    }

    @PostMapping("/admin/pesquisas")
    public String salvar(@RequestParam String titulo, @RequestParam String descricao,
                         @RequestParam String inicio, @RequestParam String fim,
                         @RequestParam(required = false) List<Integer> questoes,
                         @RequestParam(required = false) List<String> centros,
                         HttpSession session, Model model, RedirectAttributes redirect) throws SQLException {
        Usuario admin = (Usuario) session.getAttribute("usuario");
        try {
            if (inicio.isBlank() || fim.isBlank()) {
                throw new IllegalArgumentException("Informe as datas de abertura e de fechamento.");
            }
            // as datas chegam do formulário como texto "2026-11-30"
            pesquisaService.cadastrar(titulo, descricao, LocalDate.parse(inicio), LocalDate.parse(fim),
                                      admin.getId(), questoes, centros);
        } catch (IllegalArgumentException | SQLException e) {
            // volta para o formulário com o erro e com as escolhas já marcadas
            model.addAttribute("erro", "Não foi possível salvar: " + e.getMessage());
            model.addAttribute("questoesEscolhidas", questoes);
            model.addAttribute("centrosEscolhidos", centros);
            return nova(model);
        }
        redirect.addFlashAttribute("msg", "Pesquisa cadastrada.");
        return "redirect:/admin/pesquisas";
    }
}
