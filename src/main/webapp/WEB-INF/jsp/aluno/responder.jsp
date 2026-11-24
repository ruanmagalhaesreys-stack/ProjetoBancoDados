<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="titulo" value="Responder pesquisa" />
<%@ include file="/WEB-INF/jsp/fragmentos/header.jsp" %>

<h1>${pesquisa.titulo}</h1>
<p>${pesquisa.descricao}</p>
<p><i>Suas respostas são anônimas. Nas questões de escala, 1 = muito ruim e 5 = muito bom.</i></p>

<%-- Se faltar alguma resposta, a página volta com o aviso e com o que já foi marcado (${param[campo]}) --%>
<form method="post" action="/aluno/pesquisas/${pesquisa.id}" novalidate>
    <c:forEach var="q" items="${pesquisa.questoes}" varStatus="s">
        <%-- o nome do campo é "q" + id da questão, ex.: q12 --%>
        <c:set var="campo" value="q${q.id}" />
        <p><b>${s.count}. ${q.enunciado}</b></p>

        <c:if test="${q.tipo == 'ESCALA'}">
            <c:forEach begin="1" end="5" var="n">
                <input type="radio" name="${campo}" value="${n}" ${param[campo] == n ? 'checked' : ''}> ${n} &nbsp;
            </c:forEach>
        </c:if>

        <c:if test="${q.tipo == 'MULTIPLA'}">
            <c:forEach var="a" items="${q.alternativas}">
                <input type="radio" name="${campo}" value="${a.ordem}" ${param[campo] == a.ordem ? 'checked' : ''}> ${a.texto} &nbsp;
            </c:forEach>
        </c:if>

        <c:if test="${q.tipo == 'TEXTO'}">
            <textarea name="${campo}" placeholder="Opcional">${param[campo]}</textarea>
        </c:if>
    </c:forEach>

    <br>
    <button type="submit">Enviar respostas</button>
    <a href="/aluno/pesquisas" class="botao">Voltar</a>
</form>

<%@ include file="/WEB-INF/jsp/fragmentos/footer.jsp" %>
