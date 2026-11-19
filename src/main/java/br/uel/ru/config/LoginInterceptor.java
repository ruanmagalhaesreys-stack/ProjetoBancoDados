package br.uel.ru.config;

import br.uel.ru.model.Usuario;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

/**
 * Roda antes de cada página protegida:
 *  - sem login, manda para a tela de login;
 *  - /admin/** só para administradores;
 *  - /aluno/** só para alunos.
 */
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
