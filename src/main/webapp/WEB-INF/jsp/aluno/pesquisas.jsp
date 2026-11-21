<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="titulo" value="Minhas pesquisas" />
<%@ include file="/WEB-INF/jsp/fragmentos/header.jsp" %>

<h1>Olá, ${sessionScope.usuario.nome}!</h1>
<p>Centro: ${sessionScope.usuario.siglaCentro} - Matrícula: ${sessionScope.usuario.matricula}</p>

<h2>Pesquisas abertas para você</h2>
<c:if test="${empty pesquisas}">
    <p>Não há nenhuma pesquisa aberta para você agora.</p>
</c:if>
<c:if test="${not empty pesquisas}">
    <table>
        <tr><th>Pesquisa</th><th>Período</th><th></th></tr>
        <c:forEach var="p" items="${pesquisas}">
            <tr>
                <td>${p.titulo}</td>
                <td>${p.periodo}</td>
                <td><a href="/aluno/pesquisas/${p.id}" class="botao">Responder</a></td>
            </tr>
        </c:forEach>
    </table>
</c:if>

<%@ include file="/WEB-INF/jsp/fragmentos/footer.jsp" %>
