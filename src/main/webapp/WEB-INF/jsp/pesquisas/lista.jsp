<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="titulo" value="Pesquisas" />
<%@ include file="/WEB-INF/jsp/fragmentos/header.jsp" %>

<h1>Pesquisas</h1>
<a href="/admin/pesquisas/nova" class="botao">+ Nova pesquisa</a>

<table>
    <tr><th>Título</th><th>Período</th><th>Centros</th><th>Respostas</th><th>Situação</th></tr>
    <c:forEach var="p" items="${pesquisas}">
        <tr>
            <td>${p.titulo}</td>
            <td>${p.periodo}</td>
            <td>${p.centros}</td>
            <td>${p.qtdRespostas}</td>
            <td>${p.aberta ? 'aberta' : 'fechada'}</td>
        </tr>
    </c:forEach>
</table>

<%@ include file="/WEB-INF/jsp/fragmentos/footer.jsp" %>
