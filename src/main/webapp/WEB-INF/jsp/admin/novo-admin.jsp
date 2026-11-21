<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="titulo" value="Novo administrador" />
<%@ include file="/WEB-INF/jsp/fragmentos/header.jsp" %>

<h1>Novo administrador</h1>
<p>Só quem já é administrador consegue abrir esta tela.</p>

<form method="post" action="/admin/administradores">
    <label>Nome <input type="text" name="nome" value="${nome}" required></label>
    <label>Email <input type="email" name="email" value="${email}" required></label>
    <label>Senha <input type="password" name="senha" minlength="6" required></label>
    <button type="submit">Cadastrar</button>
    <a href="/admin" class="botao">Cancelar</a>
</form>

<%@ include file="/WEB-INF/jsp/fragmentos/footer.jsp" %>
