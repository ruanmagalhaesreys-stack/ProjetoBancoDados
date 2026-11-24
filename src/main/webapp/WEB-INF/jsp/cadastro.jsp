<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="titulo" value="Cadastro de aluno" />
<%@ include file="/WEB-INF/jsp/fragmentos/header.jsp" %>

<h1>Cadastro de aluno</h1>
<p>Só alunos da UEL respondem as pesquisas. As respostas são sempre anônimas.</p>

<form method="post" action="/cadastro" novalidate>
    <label>Nome <input type="text" name="nome" value="${param.nome}"></label>
    <label>Email <input type="email" name="email" value="${param.email}"></label>
    <label>Matrícula (só números)
        <input type="text" name="matricula" value="${param.matricula}">
    </label>
    <label>Centro
        <select name="centro">
            <option value="">Escolha o seu centro</option>
            <c:forEach var="c" items="${centros}">
                <option value="${c.sigla}" ${c.sigla == param.centro ? 'selected' : ''}>
                    ${c.sigla} - ${c.nome}
                </option>
            </c:forEach>
        </select>
    </label>
    <label>Senha (mínimo 6 caracteres) <input type="password" name="senha"></label>
    <button type="submit">Cadastrar</button>
    <a href="/login" class="botao">Voltar</a>
</form>

<%@ include file="/WEB-INF/jsp/fragmentos/footer.jsp" %>
