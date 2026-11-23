package br.uel.ru.controller;

import br.uel.ru.dao.UsuarioDAO;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.sql.SQLException;

/**
 * Painel do administrador e cadastro de novos administradores.
 * Tudo em /admin só abre para quem já é administrador (LoginInterceptor).
 */
@Controller
public class AdminController {

    private UsuarioDAO usuarioDAO = new UsuarioDAO();

    @GetMapping("/admin")
    public String painel() {
        return "admin/painel";
    }

    @GetMapping("/admin/administradores/novo")
    public String telaNovoAdmin() {
        return "admin/novo-admin";
    }

    @PostMapping("/admin/administradores")
    public String cadastrarAdmin(@RequestParam String nome, @RequestParam String email,
                                 @RequestParam String senha, Model model,
                                 RedirectAttributes redirect) throws SQLException {
        nome = nome.trim();
        email = email.trim().toLowerCase();

        String erro = null;
        if (nome.isEmpty() || nome.length() > 100) {
            erro = "Informe o nome (até 100 letras).";
        } else if (!email.contains("@") || email.length() > 100) {
            erro = "Informe um email válido.";
        } else if (senha.length() < 6 || senha.length() > 50) {
            erro = "A senha deve ter de 6 a 50 caracteres.";
        } else if (usuarioDAO.existeEmail(email)) {
            erro = "Já existe um usuário com este email.";
        }

        if (erro != null) {
            model.addAttribute("erro", erro);
            return "admin/novo-admin";
        }
        usuarioDAO.inserirAdmin(nome, email, senha);
        redirect.addFlashAttribute("msg", "Administrador " + nome + " cadastrado.");
        return "redirect:/admin";
    }
}
