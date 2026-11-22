<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="titulo" value="Questões mais mal avaliadas" />
<%@ include file="/WEB-INF/jsp/fragmentos/header.jsp" %>

<h1>2. As 10 questões mais mal avaliadas</h1>
<p>Considera todas as pesquisas. Empates ficam na mesma posição.</p>

<form method="get">
    <label>Buscar no enunciado (ex.: fila, comida, limpeza)
        <input type="text" name="busca" value="${busca}">
    </label>
    <button type="submit">Buscar</button>
</form>

<c:if test="${not empty linhas}">
    <p>Média geral de todas as notas: <b>${linhas[0].mediaGeral}</b></p>
</c:if>

<table>
    <tr><th>Posição</th><th>Questão</th><th>Tema</th><th style="width:35%">Média</th></tr>
    <c:forEach var="l" items="${linhas}">
        <tr>
            <td>${l.posicao}º</td>
            <td>${l.enunciado}</td>
            <td>${l.tema}</td>
            <td>
                <div class="barra-fundo">
                    <div class="barra ${l.media < l.mediaGeral ? 'ruim' : ''}" style="width: ${l.media * 20}%">${l.media}</div>
                </div>
            </td>
        </tr>
    </c:forEach>
</table>
<p><i>Barra vermelha = abaixo da média geral.</i></p>

<%@ include file="/WEB-INF/jsp/fragmentos/footer.jsp" %>
