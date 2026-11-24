<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="titulo" value="Nova questão" />
<%@ include file="/WEB-INF/jsp/fragmentos/header.jsp" %>

<h1>Nova questão</h1>

<%-- Se der erro, a página volta com o que foi digitado.
     param guarda o que veio do formulário. --%>
<form method="post" action="/admin/questoes" novalidate>
    <label>Enunciado <textarea name="enunciado">${param.enunciado}</textarea></label>

    <label>Tipo
        <select name="tipo">
            <option value="ESCALA">Escala de 1 a 5</option>
            <option value="MULTIPLA" ${param.tipo == 'MULTIPLA' ? 'selected' : ''}>Múltipla escolha</option>
            <option value="TEXTO" ${param.tipo == 'TEXTO' ? 'selected' : ''}>Texto livre</option>
        </select>
    </label>

    <label>Tema
        <select name="tema">
            <c:forEach var="t" items="${temas}">
                <option value="${t.id}" ${t.id == param.tema ? 'selected' : ''}>${t.nome}</option>
            </c:forEach>
        </select>
    </label>

    <p>Alternativas (só para múltipla escolha; deixe em branco as que não usar):</p>
    <input type="text" name="alternativas" placeholder="Alternativa 1" value="${paramValues.alternativas[0]}">
    <input type="text" name="alternativas" placeholder="Alternativa 2" value="${paramValues.alternativas[1]}">
    <input type="text" name="alternativas" placeholder="Alternativa 3" value="${paramValues.alternativas[2]}">
    <input type="text" name="alternativas" placeholder="Alternativa 4" value="${paramValues.alternativas[3]}">

    <button type="submit">Salvar</button>
    <a href="/admin/questoes" class="botao">Cancelar</a>
</form>

<%@ include file="/WEB-INF/jsp/fragmentos/footer.jsp" %>
