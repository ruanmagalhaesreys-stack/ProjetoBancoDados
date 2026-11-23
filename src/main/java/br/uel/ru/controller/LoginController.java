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
        if (email.isBlank() || senha.isBlank()) {
            model.addAttribute("erro", "Informe o email e a senha.");
            return "login";
        }
        Usuario usuario = usuarioDAO.autenticar(email.trim().toLowerCase(), senha);
        if (usuario == null) {
            model.addAttribute("erro", "Email ou senha incorretos.");
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
        nome = nome.trim();
        email = email.trim().toLowerCase();
        matricula = matricula.trim();

        // confere os campos no servidor; o erro aparece na própria tela
        String erro = null;
        if (nome.isEmpty() || nome.length() > 100) {
            erro = "Informe o seu nome (até 100 letras).";
        } else if (!email.contains("@") || email.length() > 100) {
            erro = "Informe um email válido.";
        } else if (!matricula.matches("[0-9]{6,12}")) {
            erro = "A matrícula deve ter de 6 a 12 números.";
        } else if (centro.isBlank()) {
            erro = "Escolha o seu centro.";
        } else if (senha.length() < 6 || senha.length() > 50) {
            erro = "A senha deve ter de 6 a 50 caracteres.";
        } else if (usuarioDAO.existeEmail(email)) {
            erro = "Já existe um cadastro com este email.";
        } else if (usuarioDAO.existeMatricula(matricula)) {
            erro = "Já existe um cadastro com esta matrícula.";
        }

        if (erro != null) {
            // volta para o formulário com o erro (a tela mostra de novo o que foi digitado)
            model.addAttribute("erro", erro);
            model.addAttribute("centros", centroDAO.listar());
            return "cadastro";
        }

        usuarioDAO.inserirAluno(nome, email, senha, matricula, centro);
        redirect.addFlashAttribute("msg", "Cadastro feito! Agora é só entrar.");
        return "redirect:/login";
    }
}
