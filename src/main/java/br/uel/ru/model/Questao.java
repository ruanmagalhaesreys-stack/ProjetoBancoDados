package br.uel.ru.model;

import java.util.ArrayList;
import java.util.List;

// Questão: de escala (1 a 5), de múltipla escolha ou de texto livre.
public class Questao {

    private int id;
    private String enunciado;
    private String tipo; // "ESCALA", "MULTIPLA" ou "TEXTO"
    private int idTema;
    private String nomeTema;
    private List<Alternativa> alternativas = new ArrayList<>();

    // Nome do tipo para mostrar na tela.
    public String getTipoDescricao() {
        if (tipo.equals("ESCALA")) return "Escala de 1 a 5";
        if (tipo.equals("MULTIPLA")) return "Múltipla escolha";
        return "Texto livre";
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getEnunciado() { return enunciado; }
    public void setEnunciado(String enunciado) { this.enunciado = enunciado; }

    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }

    public int getIdTema() { return idTema; }
    public void setIdTema(int idTema) { this.idTema = idTema; }

    public String getNomeTema() { return nomeTema; }
    public void setNomeTema(String nomeTema) { this.nomeTema = nomeTema; }

    public List<Alternativa> getAlternativas() { return alternativas; }
    public void setAlternativas(List<Alternativa> alternativas) { this.alternativas = alternativas; }
}
