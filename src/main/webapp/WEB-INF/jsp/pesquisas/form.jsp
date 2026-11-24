<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="titulo" value="Nova pesquisa" />
<%@ include file="/WEB-INF/jsp/fragmentos/header.jsp" %>

<h1>Nova pesquisa</h1>

<%-- Se der erro, a página volta com o que foi digitado (${param...}) e marcado --%>
<form method="post" action="/admin/pesquisas" novalidate>
    <label>Título <input type="text" name="titulo" value="${param.titulo}"></label>
    <label>Descrição <textarea name="descricao">${param.descricao}</textarea></label>
    <label>Abre em <input type="date" name="inicio" value="${param.inicio}"></label>
    <label>Fecha em <input type="date" name="fim" value="${param.fim}"></label>

    <h3>Quais centros devem responder?</h3>
    <c:forEach var="c" items="${centros}">
        <label>
            <input type="checkbox" name="centros" value="${c.sigla}"
                   ${not empty centrosEscolhidos and centrosEscolhidos.contains(c.sigla) ? 'checked' : ''}>
            ${c.sigla} - ${c.nome}
        </label>
    </c:forEach>

    <h3>Questões (aparecem para o aluno nesta ordem)</h3>
    <c:forEach var="q" items="${questoes}">
        <label>
            <input type="checkbox" name="questoes" value="${q.id}"
                   ${not empty questoesEscolhidas and questoesEscolhidas.contains(q.id) ? 'checked' : ''}>
            [${q.nomeTema}] ${q.enunciado} (${q.tipoDescricao})
        </label>
    </c:forEach>

    <button type="submit">Salvar pesquisa</button>
    <a href="/admin/pesquisas" class="botao">Cancelar</a>
</form>

<%@ include file="/WEB-INF/jsp/fragmentos/footer.jsp" %>
