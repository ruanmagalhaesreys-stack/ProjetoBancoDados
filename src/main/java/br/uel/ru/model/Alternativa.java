package br.uel.ru.model;

// Alternativa de uma questão de múltipla escolha (entidade fraca).
public class Alternativa {

    private int idQuestao;
    private int ordem;
    private String texto;

    public Alternativa() { }

    public Alternativa(int idQuestao, int ordem, String texto) {
        this.idQuestao = idQuestao;
        this.ordem = ordem;
        this.texto = texto;
    }

    public int getIdQuestao() { return idQuestao; }
    public void setIdQuestao(int idQuestao) { this.idQuestao = idQuestao; }

    public int getOrdem() { return ordem; }
    public void setOrdem(int ordem) { this.ordem = ordem; }

    public String getTexto() { return texto; }
    public void setTexto(String texto) { this.texto = texto; }
}
