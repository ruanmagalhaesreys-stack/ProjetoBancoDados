<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- Página de erro do sistema. O Spring Boot abre esta tela (view "error")
     sempre que algo dá errado: página que não existe, endereço com dado inválido
     ou uma exceção no servidor. ${status} é o código HTTP do erro. --%>
<c:set var="titulo" value="Erro" />
<%@ include file="/WEB-INF/jsp/fragmentos/header.jsp" %>

<h1>Ops! Algo deu errado.</h1>

<div class="erro">
    <c:choose>
        <c:when test="${status == 404}">A página que você procurou não existe.</c:when>
        <c:when test="${status == 400}">O endereço ou o formulário veio com algum dado inválido.</c:when>
        <c:when test="${status == 403 or status == 405}">Esta ação não é permitida.</c:when>
        <c:otherwise>Aconteceu um erro inesperado no sistema. Tente de novo daqui a pouco.</c:otherwise>
    </c:choose>
</div>

<p>Código do erro: ${status}</p>
<a href="/" class="botao">Voltar ao início</a>

<%@ include file="/WEB-INF/jsp/fragmentos/footer.jsp" %>
