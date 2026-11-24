package br.uel.ru.controller;

import br.uel.ru.dao.CentroDAO;
import br.uel.ru.dao.PesquisaDAO;
import br.uel.ru.dao.QuestaoDAO;
import br.uel.ru.model.Pesquisa;
import br.uel.ru.model.Usuario;
import br.uel.ru.service.PesquisaService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

// Telas do administrador para montar, editar e excluir pesquisas (RF2, RF3 e RF4).
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

    // Formulário vazio, para uma pesquisa nova.
    @GetMapping("/admin/pesquisas/nova")
    public String nova(Model model) throws SQLException {
        return mostrarFormulario(new Pesquisa(), null, null, model);
    }

    @PostMapping("/admin/pesquisas")
    public String salvar(@RequestParam String titulo, @RequestParam String descricao,
                         @RequestParam String inicio, @RequestParam String fim,
                         @RequestParam(required = false) List<Integer> questoes,
                         @RequestParam(required = false) List<String> centros,
                         HttpSession session, Model model, RedirectAttributes redirect) throws SQLException {
        Usuario admin = (Usuario) session.getAttribute("usuario");
        try {
            pesquisaService.cadastrar(titulo, descricao, lerData(inicio), lerData(fim),
                                      admin.getId(), questoes, centros);
        } catch (IllegalArgumentException | SQLException e) {
            // volta para o formulário com o erro e com o que já foi digitado e marcado
            model.addAttribute("erro", "Não foi possível salvar: " + e.getMessage());
            Pesquisa p = new Pesquisa();
            preencher(p, titulo, descricao, inicio, fim);
            return mostrarFormulario(p, questoes, centros, model);
        }
        redirect.addFlashAttribute("msg", "Pesquisa cadastrada.");
        return "redirect:/admin/pesquisas";
    }

    // Formulário já preenchido com os dados da pesquisa, para editar.
    @GetMapping("/admin/pesquisas/{id}/editar")
    public String editar(@PathVariable int id, Model model, RedirectAttributes redirect) throws SQLException {
        Pesquisa p = pesquisaDAO.buscar(id);
        if (p == null) {
            redirect.addFlashAttribute("erro", "Pesquisa não encontrada.");
            return "redirect:/admin/pesquisas";
        }
        return mostrarFormulario(p, pesquisaDAO.listarIdsQuestoes(id), pesquisaDAO.listarCentros(id), model);
    }

    @PostMapping("/admin/pesquisas/{id}")
    public String atualizar(@PathVariable int id, @RequestParam String titulo, @RequestParam String descricao,
                            @RequestParam String inicio, @RequestParam String fim,
                            @RequestParam(required = false) List<Integer> questoes,
                            @RequestParam(required = false) List<String> centros,
                            Model model, RedirectAttributes redirect) throws SQLException {
        Pesquisa p = pesquisaDAO.buscar(id);
        if (p == null) {
            redirect.addFlashAttribute("erro", "Pesquisa não encontrada.");
            return "redirect:/admin/pesquisas";
        }
        try {
            pesquisaService.atualizar(id, titulo, descricao, lerData(inicio), lerData(fim), questoes, centros);
        } catch (IllegalArgumentException | SQLException e) {
            model.addAttribute("erro", "Não foi possível salvar: " + e.getMessage());
            preencher(p, titulo, descricao, inicio, fim);
            if (p.getQtdRespostas() > 0) {
                // com respostas, as questões e os centros não mudam: mostra os que estão gravados
                questoes = pesquisaDAO.listarIdsQuestoes(id);
                centros = pesquisaDAO.listarCentros(id);
            }
            return mostrarFormulario(p, questoes, centros, model);
        }
        redirect.addFlashAttribute("msg", "Pesquisa alterada.");
        return "redirect:/admin/pesquisas";
    }

    // Tela que pergunta se o administrador quer mesmo excluir a pesquisa.
    // Se a pesquisa já tem respostas, avisa que elas também serão apagadas.
    @GetMapping("/admin/pesquisas/{id}/excluir")
    public String confirmarExclusao(@PathVariable int id, Model model,
                                    RedirectAttributes redirect) throws SQLException {
        Pesquisa p = pesquisaDAO.buscar(id);
        if (p == null) {
            redirect.addFlashAttribute("erro", "Pesquisa não encontrada.");
            return "redirect:/admin/pesquisas";
        }
        model.addAttribute("pergunta", "Excluir a pesquisa \"" + p.getTitulo() + "\"?");
        if (p.getQtdRespostas() > 0) {
            model.addAttribute("aviso", "Esta pesquisa já tem " + p.getQtdRespostas() + " resposta(s). "
                    + "Ao excluir, todas as respostas dela também serão apagadas e vão sumir dos relatórios. "
                    + "Isso não pode ser desfeito.");
        }
        model.addAttribute("acao", "/admin/pesquisas/" + id + "/excluir");
        model.addAttribute("voltar", "/admin/pesquisas");
        return "confirmar";
    }

    @PostMapping("/admin/pesquisas/{id}/excluir")
    public String excluir(@PathVariable int id, RedirectAttributes redirect) {
        try {
            pesquisaService.excluir(id);
            redirect.addFlashAttribute("msg", "Pesquisa excluída.");
        } catch (SQLException e) {
            redirect.addFlashAttribute("erro", "Não foi possível excluir: " + e.getMessage());
        }
        return "redirect:/admin/pesquisas";
    }

    // Abre o formulário de pesquisa (o mesmo para nova e para editar).
    private String mostrarFormulario(Pesquisa p, List<Integer> questoesEscolhidas,
                                     List<String> centrosEscolhidos, Model model) throws SQLException {
        model.addAttribute("pesquisa", p);
        model.addAttribute("questoesEscolhidas", questoesEscolhidas);
        model.addAttribute("centrosEscolhidos", centrosEscolhidos);
        model.addAttribute("questoes", questaoDAO.listar());
        model.addAttribute("centros", centroDAO.listar());
        return "pesquisas/form";
    }

    // Coloca na pesquisa o que foi digitado, para o formulário mostrar de novo.
    private void preencher(Pesquisa p, String titulo, String descricao, String inicio, String fim) {
        p.setTitulo(titulo);
        p.setDescricao(descricao);
        p.setDataInicio(lerData(inicio));
        p.setDataFim(lerData(fim));
    }

    // As datas chegam do formulário como texto, ex.: "2026-11-30". Vazio vira null.
    private LocalDate lerData(String texto) {
        if (texto.isBlank()) {
            return null;
        }
        return LocalDate.parse(texto);
    }
}
