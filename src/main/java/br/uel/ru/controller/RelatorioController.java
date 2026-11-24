package br.uel.ru.controller;

import br.uel.ru.dao.CentroDAO;
import br.uel.ru.dao.PesquisaDAO;
import br.uel.ru.dao.RelatorioDAO;
import br.uel.ru.model.Centro;
import br.uel.ru.model.Pesquisa;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

// Os 3 relatórios: cada um com filtros, tabela e gráfico de barras.
@Controller
public class RelatorioController {

    private RelatorioDAO relatorioDAO = new RelatorioDAO();
    private CentroDAO centroDAO = new CentroDAO();
    private PesquisaDAO pesquisaDAO = new PesquisaDAO();

    // Relatório 1: satisfação média por tema.
    @GetMapping("/admin/relatorios/temas")
    public String temas(@RequestParam(defaultValue = "2024-01-01") String inicio,
                        @RequestParam(defaultValue = "2026-12-31") String fim,
                        @RequestParam(required = false) List<String> centros,
                        Model model) throws SQLException {
        List<Centro> todos = centroDAO.listar();
        if (centros == null || centros.isEmpty()) {
            // nenhum centro marcado: usa todos
            centros = new ArrayList<>();
            for (Centro c : todos) centros.add(c.getSigla());
        }
        model.addAttribute("linhas",
                relatorioDAO.satisfacaoPorTema(LocalDate.parse(inicio), LocalDate.parse(fim), centros));
        model.addAttribute("inicio", inicio);
        model.addAttribute("fim", fim);
        model.addAttribute("todosCentros", todos);
        model.addAttribute("centrosEscolhidos", centros);
        return "relatorios/temas";
    }

    // Relatório 2: as 10 questões mais mal avaliadas.
    @GetMapping("/admin/relatorios/ranking")
    public String ranking(@RequestParam(defaultValue = "") String busca, Model model) throws SQLException {
        model.addAttribute("linhas", relatorioDAO.rankingQuestoes(busca.trim()));
        model.addAttribute("busca", busca);
        return "relatorios/ranking";
    }

    // Relatório 3: participação por centro e quem ainda não respondeu.
    @GetMapping("/admin/relatorios/participacao")
    public String participacao(@RequestParam(required = false) Integer pesquisa, Model model) throws SQLException {
        List<Pesquisa> pesquisas = pesquisaDAO.listar();
        if (pesquisa == null && !pesquisas.isEmpty()) {
            pesquisa = pesquisas.get(0).getId(); // a mais recente
        }
        if (pesquisa == null) {
            pesquisa = 0; // não há nenhuma pesquisa: o relatório fica vazio
        }
        model.addAttribute("pesquisas", pesquisas);
        model.addAttribute("pesquisaEscolhida", pesquisa);
        model.addAttribute("linhas", relatorioDAO.participacaoPorCentro(pesquisa));
        model.addAttribute("faltam", relatorioDAO.alunosQueNaoResponderam(pesquisa));
        return "relatorios/participacao";
    }
}
