package br.uel.ru.model;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

// Pesquisa de satisfação: um conjunto de questões, aberto num período.
public class Pesquisa {

    private int id;
    private String titulo;
    private String descricao;
    private LocalDate dataInicio;
    private LocalDate dataFim;
    private String centros;    // ex.: "CCE, CTU" (para as listagens)
    private int qtdRespostas;  // quantas pessoas já responderam
    private List<Questao> questoes = new ArrayList<>();

    // A pesquisa está aberta hoje?
    public boolean isAberta() {
        LocalDate hoje = LocalDate.now();
        return !hoje.isBefore(dataInicio) && !hoje.isAfter(dataFim);
    }

    // Período para mostrar na tela, ex.: "09/11/2026 a 30/11/2026".
    public String getPeriodo() {
        DateTimeFormatter formato = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        return dataInicio.format(formato) + " a " + dataFim.format(formato);
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitulo() { return titulo; }
    public void setTitulo(String titulo) { this.titulo = titulo; }

    public String getDescricao() { return descricao; }
    public void setDescricao(String descricao) { this.descricao = descricao; }

    public LocalDate getDataInicio() { return dataInicio; }
    public void setDataInicio(LocalDate dataInicio) { this.dataInicio = dataInicio; }

    public LocalDate getDataFim() { return dataFim; }
    public void setDataFim(LocalDate dataFim) { this.dataFim = dataFim; }

    public String getCentros() { return centros; }
    public void setCentros(String centros) { this.centros = centros; }

    public int getQtdRespostas() { return qtdRespostas; }
    public void setQtdRespostas(int qtdRespostas) { this.qtdRespostas = qtdRespostas; }

    public List<Questao> getQuestoes() { return questoes; }
    public void setQuestoes(List<Questao> questoes) { this.questoes = questoes; }
}
