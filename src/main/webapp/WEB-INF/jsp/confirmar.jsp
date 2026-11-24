<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- Tela de confirmação, usada antes de excluir uma questão ou uma pesquisa.
     O controller manda a pergunta, um aviso (opcional), o endereço que exclui (acao)
     e o endereço para voltar sem excluir. --%>
<c:set var="titulo" value="Confirmar exclusão" />
<%@ include file="/WEB-INF/jsp/fragmentos/header.jsp" %>

<h1>Confirmar exclusão</h1>

<p><b>${pergunta}</b></p>
<c:if test="${not empty aviso}"><div class="erro">${aviso}</div></c:if>

<form method="post" action="${acao}">
    <button type="submit">Confirmar exclusão</button>
    <a href="${voltar}" class="botao">Cancelar</a>
</form>

<%@ include file="/WEB-INF/jsp/fragmentos/footer.jsp" %>
