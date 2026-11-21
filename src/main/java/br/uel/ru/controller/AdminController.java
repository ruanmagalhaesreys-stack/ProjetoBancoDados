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
        email = email.trim().toLowerCase();
        if (usuarioDAO.existeEmail(email)) {
            model.addAttribute("erro", "Já existe um usuário com este email.");
            model.addAttribute("nome", nome);
            model.addAttribute("email", email);
            return "admin/novo-admin";
        }
        usuarioDAO.inserirAdmin(nome.trim(), email, senha);
        redirect.addFlashAttribute("msg", "Administrador " + nome.trim() + " cadastrado.");
        return "redirect:/admin";
    }
}
