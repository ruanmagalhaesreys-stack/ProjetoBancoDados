<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="titulo" value="Questões" />
<%@ include file="/WEB-INF/jsp/fragmentos/header.jsp" %>

<h1>Questões</h1>
<a href="/admin/questoes/nova" class="botao">+ Nova questão</a>

<table>
    <tr><th>#</th><th>Enunciado</th><th>Tipo</th><th>Tema</th><th>Ações</th></tr>
    <c:forEach var="q" items="${questoes}">
        <tr>
            <td>${q.id}</td>
            <td>
                ${q.enunciado}
                <c:forEach var="a" items="${q.alternativas}">
                    <br>&nbsp;&nbsp;${a.ordem}) ${a.texto}
                </c:forEach>
            </td>
            <td>${q.tipoDescricao}</td>
            <td>${q.nomeTema}</td>
            <td><a href="/admin/questoes/${q.id}/excluir">Excluir</a></td>
        </tr>
    </c:forEach>
</table>

<%@ include file="/WEB-INF/jsp/fragmentos/footer.jsp" %>
