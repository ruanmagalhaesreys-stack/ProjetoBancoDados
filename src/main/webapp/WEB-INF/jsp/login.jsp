<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="titulo" value="Entrar" />
<%@ include file="/WEB-INF/jsp/fragmentos/header.jsp" %>

<h1>Pesquisa de Satisfação do RU</h1>
<h2>Entrar</h2>

<form method="post" action="/login">
    <label>Email <input type="email" name="email" value="${email}" required></label>
    <label>Senha <input type="password" name="senha" required></label>
    <button type="submit">Entrar</button>
</form>

<p>É aluno e ainda não tem cadastro? <a href="/cadastro">Cadastre-se</a></p>

<%@ include file="/WEB-INF/jsp/fragmentos/footer.jsp" %>
