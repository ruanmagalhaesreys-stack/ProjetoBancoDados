<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="titulo" value="Painel" />
<%@ include file="/WEB-INF/jsp/fragmentos/header.jsp" %>

<h1>Painel do administrador</h1>
<p>Olá, ${sessionScope.usuario.nome}.</p>

<h3>Cadastros</h3>
<ul>
    <li><a href="/admin/questoes">Questões</a>: escala de 1 a 5, múltipla escolha e texto livre</li>
    <li><a href="/admin/pesquisas">Pesquisas</a>: escolher as questões e os centros que respondem</li>
    <li><a href="/admin/administradores/novo">Novo administrador</a></li>
</ul>

<h3>Relatórios</h3>
<ul>
    <li><a href="/admin/relatorios/temas">1. Satisfação por tema</a></li>
    <li><a href="/admin/relatorios/ranking">2. Questões mais mal avaliadas</a></li>
    <li><a href="/admin/relatorios/participacao">3. Participação por centro</a></li>
</ul>

<%@ include file="/WEB-INF/jsp/fragmentos/footer.jsp" %>
