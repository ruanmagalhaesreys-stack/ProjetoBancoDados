<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="titulo" value="Cadastro de aluno" />
<%@ include file="/WEB-INF/jsp/fragmentos/header.jsp" %>

<h1>Cadastro de aluno</h1>
<p>Só alunos da UEL respondem as pesquisas. As respostas são sempre anônimas.</p>

<form method="post" action="/cadastro">
    <label>Nome <input type="text" name="nome" value="${nome}" required></label>
    <label>Email <input type="email" name="email" value="${email}" required></label>
    <label>Matrícula (só números)
        <input type="text" name="matricula" value="${matricula}" pattern="[0-9]{6,12}" required>
    </label>
    <label>Centro
        <select name="centro" required>
            <option value="">Escolha o seu centro</option>
            <c:forEach var="c" items="${centros}">
                <option value="${c.sigla}" ${c.sigla == centroEscolhido ? 'selected' : ''}>
                    ${c.sigla} - ${c.nome}
                </option>
            </c:forEach>
        </select>
    </label>
    <label>Senha <input type="password" name="senha" minlength="6" required></label>
    <button type="submit">Cadastrar</button>
    <a href="/login" class="botao">Voltar</a>
</form>

<%@ include file="/WEB-INF/jsp/fragmentos/footer.jsp" %>
