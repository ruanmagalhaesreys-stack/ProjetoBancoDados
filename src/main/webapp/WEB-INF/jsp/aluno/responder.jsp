<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="titulo" value="Responder pesquisa" />
<%@ include file="/WEB-INF/jsp/fragmentos/header.jsp" %>

<h1>${pesquisa.titulo}</h1>
<p>${pesquisa.descricao}</p>
<p><i>Suas respostas são anônimas. Nas questões de escala, 1 = muito ruim e 5 = muito bom.</i></p>

<form method="post" action="/aluno/pesquisas/${pesquisa.id}">
    <c:forEach var="q" items="${pesquisa.questoes}" varStatus="s">
        <p><b>${s.count}. ${q.enunciado}</b></p>

        <%-- o nome do campo é "q" + id da questão, ex.: q12 --%>
        <c:if test="${q.tipo == 'ESCALA'}">
            <c:forEach begin="1" end="5" var="n">
                <input type="radio" name="q${q.id}" value="${n}" required> ${n} &nbsp;
            </c:forEach>
        </c:if>

        <c:if test="${q.tipo == 'MULTIPLA'}">
            <c:forEach var="a" items="${q.alternativas}">
                <input type="radio" name="q${q.id}" value="${a.ordem}" required> ${a.texto} &nbsp;
            </c:forEach>
        </c:if>

        <c:if test="${q.tipo == 'TEXTO'}">
            <textarea name="q${q.id}" maxlength="1000" placeholder="Opcional"></textarea>
        </c:if>
    </c:forEach>

    <br>
    <button type="submit">Enviar respostas</button>
    <a href="/aluno/pesquisas" class="botao">Voltar</a>
</form>

<%@ include file="/WEB-INF/jsp/fragmentos/footer.jsp" %>
