<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="titulo" value="Novo administrador" />
<%@ include file="/WEB-INF/jsp/fragmentos/header.jsp" %>

<h1>Novo administrador</h1>
<p>Só quem já é administrador consegue abrir esta tela.</p>

<form method="post" action="/admin/administradores" novalidate>
    <label>Nome <input type="text" name="nome" value="${param.nome}"></label>
    <label>Email <input type="email" name="email" value="${param.email}"></label>
    <label>Senha (mínimo 6 caracteres) <input type="password" name="senha"></label>
    <button type="submit">Cadastrar</button>
    <a href="/admin" class="botao">Cancelar</a>
</form>

<%@ include file="/WEB-INF/jsp/fragmentos/footer.jsp" %>
