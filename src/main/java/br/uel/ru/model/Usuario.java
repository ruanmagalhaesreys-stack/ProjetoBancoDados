package br.uel.ru.model;

// Usuário do sistema: administrador ou aluno.
public class Usuario {

    private int id;
    private String nome;
    private String email;
    private String tipo;        // "ADMIN" ou "ALUNO"
    private String matricula;   // só aluno
    private String siglaCentro; // só aluno

    public boolean isAdmin() {
        return "ADMIN".equals(tipo);
    }

    public boolean isAluno() {
        return "ALUNO".equals(tipo);
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }

    public String getMatricula() { return matricula; }
    public void setMatricula(String matricula) { this.matricula = matricula; }

    public String getSiglaCentro() { return siglaCentro; }
    public void setSiglaCentro(String siglaCentro) { this.siglaCentro = siglaCentro; }
}
