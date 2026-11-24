<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- Mesmo formulário para pesquisa nova (id 0) e para editar uma pesquisa que já existe. --%>
<c:set var="editando" value="${pesquisa.id != 0}" />
<c:set var="titulo" value="${editando ? 'Editar pesquisa' : 'Nova pesquisa'}" />
<%@ include file="/WEB-INF/jsp/fragmentos/header.jsp" %>

<h1>${titulo}</h1>

<%-- Pesquisa nova grava em /admin/pesquisas; edição grava em /admin/pesquisas/id. --%>
<c:set var="acao" value="/admin/pesquisas" />
<c:if test="${editando}"><c:set var="acao" value="/admin/pesquisas/${pesquisa.id}" /></c:if>

<%-- Com respostas, as questões e os centros ficam travados (disabled). --%>
<c:set var="travado" value="${pesquisa.qtdRespostas > 0}" />

<form method="post" action="${acao}" novalidate>
    <label>Título <input type="text" name="titulo" value="${pesquisa.titulo}"></label>
    <label>Descrição <textarea name="descricao">${pesquisa.descricao}</textarea></label>
    <label>Abre em <input type="date" name="inicio" value="${pesquisa.dataInicio}"></label>
    <label>Fecha em <input type="date" name="fim" value="${pesquisa.dataFim}"></label>

    <c:if test="${travado}">
        <div class="erro">Esta pesquisa já tem ${pesquisa.qtdRespostas} resposta(s).
            Dá para mudar o título, a descrição e as datas, mas não as questões nem os centros.</div>
    </c:if>

    <h3>Quais centros devem responder?</h3>
    <c:forEach var="c" items="${centros}">
        <label>
            <input type="checkbox" name="centros" value="${c.sigla}" ${travado ? 'disabled' : ''}
                   ${not empty centrosEscolhidos and centrosEscolhidos.contains(c.sigla) ? 'checked' : ''}>
            ${c.sigla} - ${c.nome}
        </label>
    </c:forEach>

    <h3>Questões (aparecem para o aluno nesta ordem)</h3>
    <c:forEach var="q" items="${questoes}">
        <label>
            <input type="checkbox" name="questoes" value="${q.id}" ${travado ? 'disabled' : ''}
                   ${not empty questoesEscolhidas and questoesEscolhidas.contains(q.id) ? 'checked' : ''}>
            [${q.nomeTema}] ${q.enunciado} (${q.tipoDescricao})
        </label>
    </c:forEach>

    <button type="submit">Salvar pesquisa</button>
    <a href="/admin/pesquisas" class="botao">Cancelar</a>
</form>

<%@ include file="/WEB-INF/jsp/fragmentos/footer.jsp" %>
