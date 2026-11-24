<%@ page pageEncoding="UTF-8" %>
<%-- Topo de todas as páginas. As outras telas incluem este arquivo com include.
     Cada tela define o seu titulo antes de incluir. --%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>${titulo} - RU UEL</title>
    <link rel="stylesheet" href="/css/style.css">
</head>
<body>
<header>
    <b>RU UEL</b>
    <c:if test="${not empty sessionScope.usuario}">
        <c:if test="${sessionScope.usuario.admin}">
            <a href="/admin">Painel</a>
            <a href="/admin/questoes">Questões</a>
            <a href="/admin/pesquisas">Pesquisas</a>
        </c:if>
        <c:if test="${sessionScope.usuario.aluno}">
            <a href="/aluno/pesquisas">Minhas pesquisas</a>
        </c:if>
        <a href="/logout">Sair (${sessionScope.usuario.nome})</a>
    </c:if>
</header>
<main>
    <c:if test="${not empty msg}"><div class="msg">${msg}</div></c:if>
    <c:if test="${not empty erro}"><div class="erro">${erro}</div></c:if>
