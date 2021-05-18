package sample;

public class Value {
    private String code;
    private String term;
    private String nationalCode;
    private String nationalTerm;

    public String getCode() {
        return code;
    }

    public Value setCode(String code) {
        this.code = code;
        return this;
    }

    public String getTerm() {
        return term;
    }

    public Value setTerm(String term) {
        this.term = term;
        return this;
    }

    public String getNationalCode() {
        return nationalCode;
    }

    public Value setNationalCode(String nationalCode) {
        this.nationalCode = nationalCode;
        return this;
    }

    public String getNationalTerm() {
        return nationalTerm;
    }

    public Value setNationalTerm(String nationalTerm) {
        this.nationalTerm = nationalTerm;
        return this;
    }
}
