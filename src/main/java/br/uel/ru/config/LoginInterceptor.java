package br.uel.ru.config;

import br.uel.ru.model.Usuario;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

// Roda antes de abrir qualquer página de administrador ou de aluno.
// Quem não fez login vai para a tela de login.
// As páginas que começam com /admin só abrem para administradores,
// e as que começam com /aluno só abrem para alunos.
@Component
public class LoginInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response,
                             Object handler) throws Exception {
        Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
        String caminho = request.getRequestURI();

        if (usuario == null) {
            response.sendRedirect("/login");
            return false;
        }
        if (caminho.startsWith("/admin") && !usuario.isAdmin()) {
            response.sendRedirect("/aluno/pesquisas");
            return false;
        }
        if (caminho.startsWith("/aluno") && !usuario.isAluno()) {
            response.sendRedirect("/admin");
            return false;
        }
        return true;
    }
}
