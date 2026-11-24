<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="titulo" value="Satisfação por tema" />
<%@ include file="/WEB-INF/jsp/fragmentos/header.jsp" %>

<h1>1. Satisfação média por tema</h1>
<p>Média das notas (1 a 5) de cada tema, nas pesquisas abertas no período e nos centros escolhidos.</p>

<form method="get">
    <label>De <input type="date" name="inicio" value="${inicio}"></label>
    <label>Até <input type="date" name="fim" value="${fim}"></label>
    <p>Centros:
        <c:forEach var="c" items="${todosCentros}">
            <input type="checkbox" name="centros" value="${c.sigla}"
                   ${centrosEscolhidos.contains(c.sigla) ? 'checked' : ''}> ${c.sigla} &nbsp;
        </c:forEach>
    </p>
    <button type="submit">Filtrar</button>
</form>

<%-- Gráfico de barras feito com HTML: a nota 5 ocupa 100% da largura,
     então a largura da barra é a média vezes 20. --%>
<table>
    <tr><th style="width:30%">Tema</th><th>Média</th><th style="width:12%">Respostas</th></tr>
    <c:forEach var="l" items="${linhas}">
        <tr>
            <td>${l.tema}</td>
            <td>
                <div class="barra-fundo">
                    <div class="barra ${l.media < 3 ? 'ruim' : ''}" style="width: ${l.media * 20}%">${l.media}</div>
                </div>
            </td>
            <td>${l.respostas}</td>
        </tr>
    </c:forEach>
</table>
<c:if test="${empty linhas}"><p>Nenhuma resposta com esses filtros.</p></c:if>

<%@ include file="/WEB-INF/jsp/fragmentos/footer.jsp" %>
