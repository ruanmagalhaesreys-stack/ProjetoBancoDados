package br.uel.ru.controller;

import br.uel.ru.dao.CentroDAO;
import br.uel.ru.dao.UsuarioDAO;
import br.uel.ru.model.Usuario;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.sql.SQLException;

/** Login, logout e cadastro de aluno. */
@Controller
public class LoginController {

    private UsuarioDAO usuarioDAO = new UsuarioDAO();
    private CentroDAO centroDAO = new CentroDAO();

    /** Página inicial: manda cada usuário para a sua área. */
    @GetMapping("/")
    public String inicio(HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        if (usuario == null) {
            return "redirect:/login";
        }
        if (usuario.isAdmin()) {
            return "redirect:/admin";
        }
        return "redirect:/aluno/pesquisas";
    }

    @GetMapping("/login")
    public String telaLogin() {
        return "login";
    }

    @PostMapping("/login")
    public String entrar(@RequestParam String email, @RequestParam String senha,
                         HttpSession session, Model model) throws SQLException {
        Usuario usuario = usuarioDAO.autenticar(email.trim().toLowerCase(), senha);
        if (usuario == null) {
            model.addAttribute("erro", "Email ou senha incorretos.");
            model.addAttribute("email", email);
            return "login";
        }
        session.setAttribute("usuario", usuario); // guarda quem está logado
        return "redirect:/";
    }

    @GetMapping("/logout")
    public String sair(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }

    @GetMapping("/cadastro")
    public String telaCadastro(Model model) throws SQLException {
        model.addAttribute("centros", centroDAO.listar());
        return "cadastro";
    }

    @PostMapping("/cadastro")
    public String cadastrar(@RequestParam String nome, @RequestParam String email,
                            @RequestParam String matricula, @RequestParam String centro,
                            @RequestParam String senha, Model model,
                            RedirectAttributes redirect) throws SQLException {
        email = email.trim().toLowerCase();
        String erro = null;
        if (usuarioDAO.existeEmail(email)) {
            erro = "Já existe um cadastro com este email.";
        } else if (usuarioDAO.existeMatricula(matricula.trim())) {
            erro = "Já existe um cadastro com esta matrícula.";
        }

        if (erro != null) {
            // volta para o formulário com o erro e o que já foi digitado
            model.addAttribute("erro", erro);
            model.addAttribute("nome", nome);
            model.addAttribute("email", email);
            model.addAttribute("matricula", matricula);
            model.addAttribute("centroEscolhido", centro);
            model.addAttribute("centros", centroDAO.listar());
            return "cadastro";
        }

        usuarioDAO.inserirAluno(nome.trim(), email, senha, matricula.trim(), centro);
        redirect.addFlashAttribute("msg", "Cadastro feito! Agora é só entrar.");
        return "redirect:/login";
    }
}
