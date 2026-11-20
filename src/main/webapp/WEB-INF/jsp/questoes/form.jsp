<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="titulo" value="Nova questão" />
<%@ include file="/WEB-INF/jsp/fragmentos/header.jsp" %>

<h1>Nova questão</h1>

<form method="post" action="/admin/questoes">
    <label>Enunciado <textarea name="enunciado" maxlength="300" required>${enunciado}</textarea></label>

    <label>Tipo
        <select name="tipo">
            <option value="ESCALA">Escala de 1 a 5</option>
            <option value="MULTIPLA">Múltipla escolha</option>
            <option value="TEXTO">Texto livre</option>
        </select>
    </label>

    <label>Tema
        <select name="tema">
            <c:forEach var="t" items="${temas}">
                <option value="${t.id}">${t.nome}</option>
            </c:forEach>
        </select>
    </label>

    <p>Alternativas (só para múltipla escolha; deixe em branco as que não usar):</p>
    <input type="text" name="alternativas" placeholder="Alternativa 1">
    <input type="text" name="alternativas" placeholder="Alternativa 2">
    <input type="text" name="alternativas" placeholder="Alternativa 3">
    <input type="text" name="alternativas" placeholder="Alternativa 4">

    <button type="submit">Salvar</button>
    <a href="/admin/questoes" class="botao">Cancelar</a>
</form>

<%@ include file="/WEB-INF/jsp/fragmentos/footer.jsp" %>
