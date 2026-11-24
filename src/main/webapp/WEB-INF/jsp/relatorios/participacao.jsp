<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="titulo" value="Participação" />
<%@ include file="/WEB-INF/jsp/fragmentos/header.jsp" %>

<h1>3. Participação por centro</h1>
<p>Conta todos os alunos dos centros que devem responder, inclusive quem ainda não respondeu.
   A lista mostra só QUEM falta, nunca o que cada um respondeu.</p>

<form method="get">
    <label>Pesquisa
        <select name="pesquisa">
            <c:forEach var="p" items="${pesquisas}">
                <option value="${p.id}" ${p.id == pesquisaEscolhida ? 'selected' : ''}>${p.titulo}</option>
            </c:forEach>
        </select>
    </label>
    <button type="submit">Ver</button>
</form>

<%-- Gráfico de barras feito com HTML: a largura da barra é a taxa de participação, de 0 a 100%. --%>
<table>
    <tr><th>Centro</th><th>Alunos</th><th>Responderam</th><th>Taxa</th><th style="width:40%">Gráfico</th></tr>
    <c:forEach var="l" items="${linhas}">
        <tr>
            <td>${l.centro}</td>
            <td>${l.alunos}</td>
            <td>${l.responderam}</td>
            <td>${l.taxa}%</td>
            <td>
                <div class="barra-fundo">
                    <div class="barra" style="width: ${l.taxa}%">&nbsp;</div>
                </div>
            </td>
        </tr>
    </c:forEach>
</table>

<h2>Alunos que ainda não responderam (${faltam.size()})</h2>
<table>
    <tr><th>Nome</th><th>Matrícula</th><th>Centro</th></tr>
    <c:forEach var="a" items="${faltam}">
        <tr><td>${a.nome}</td><td>${a.matricula}</td><td>${a.centro}</td></tr>
    </c:forEach>
</table>

<%@ include file="/WEB-INF/jsp/fragmentos/footer.jsp" %>
