package br.uel.ru.model;

// Resposta de uma questão. Não tem o aluno: fica ligada só a uma
// submissão anônima. Só um dos três valores é preenchido.
public class Resposta {

    private int idQuestao;
    private Integer nota;        // questão de escala (1 a 5)
    private Integer alternativa; // questão de múltipla escolha (ordem da alternativa)
    private String texto;        // questão de texto livre

    public int getIdQuestao() { return idQuestao; }
    public void setIdQuestao(int idQuestao) { this.idQuestao = idQuestao; }

    public Integer getNota() { return nota; }
    public void setNota(Integer nota) { this.nota = nota; }

    public Integer getAlternativa() { return alternativa; }
    public void setAlternativa(Integer alternativa) { this.alternativa = alternativa; }

    public String getTexto() { return texto; }
    public void setTexto(String texto) { this.texto = texto; }
}
