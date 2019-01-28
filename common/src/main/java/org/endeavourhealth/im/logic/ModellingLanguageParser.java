package org.endeavourhealth.im.logic;

import org.apache.commons.lang3.StringUtils;

import java.util.InputMismatchException;

public class ModellingLanguageParser {
    private static final String DELIMITER = "(\\s*(,|=|\\(|\\))\\s*)|(\\s+)";
    public boolean execute(String script) {
        Scanner2 scanner = new Scanner2(script);
        return execute(scanner);
    }

    public boolean execute(Scanner2 scanner) {
        scanner.useDelimiter(DELIMITER);

        System.out.println();

        try {
            return parseDocument(scanner);
        } catch (InputMismatchException e) {
            String nextLine = scanner.next();
            System.err.println(nextLine);
            System.err.println("^ Parsing error");
            throw e;
        }
    }

    private boolean parseDocument(Scanner2 scanner) {
        String token = scanner.next().toLowerCase();
        do {
            if ("modelinformation".equals(token)) processModelInformation(scanner);
            else if ("concept".equals(token)) processConcept(scanner);
            else if ("structure".equals(token)) processStructure(scanner);
            else if ("definition".equals(token)) processDefinition(scanner);
            else if ("pattern".equals(token)) processPattern(scanner);
            else
                throw new InputMismatchException("Unknown document token: [" + token + "]");
            token = scanner.next().toLowerCase();
        } while (!token.isEmpty());

        return true;
    }

    private void processModelInformation(Scanner2 scanner) {
        System.out.println("Processing Model Information");
        do {
            String token = scanner.next().toLowerCase();
            if ("model_document".equals(token)) System.out.println("\tModelDocument:" + getValue(scanner));
             else if ("version".equals(token)) System.out.println("\tVersion:" + getValue(scanner));
             else if ("release_date".equals(token)) System.out.println("\tRelease:" + getValue(scanner));
             else if ("import".equals(token)) System.out.println("\tImport:" + getValue(scanner));
             else if ("use".equals(token)) System.out.println("\tUse:" + getValue(scanner));
             else if ("supported_language".equals(token)) processModelInformationLanguage(scanner);
             else if ("prefix".equals(token)) processModelInformationPrefix(scanner);
             else
                 throw new InputMismatchException("Unknown model information token: [" + token + "]");
        } while (",".equals(scanner.lastMatch()));
        System.out.println("End");
    }

    private void processModelInformationLanguage(Scanner2 scanner) {
        System.out.println("\tProcessing Model Information Language");
        do {
            String token = scanner.next().toLowerCase();
            if ("language".equals(token)) System.out.println("\t\tModelDocumentLanguageLanguage:" + getValue(scanner));
            else if ("version".equals(token)) System.out.println("\t\tModelDocumentLanguageVersion:" + getValue(scanner));
            else
                throw new InputMismatchException("Unknown language token: [" + token + "]");
         } while (",".equals(scanner.lastMatch()));
        scanner.next();
        System.out.println("\tEnd");
    }

    private void processModelInformationPrefix(Scanner2 scanner) {
        System.out.println("\tProcessing Model Information Prefix");
        do {
            String token = scanner.next().toLowerCase();
            if ("prefix".equals(token)) System.out.println("\t\tModelDocumentPrefixPrefix:" + getValue(scanner));
            else if ("iri".equals(token)) System.out.println("\t\tModelDocumentPrefixIri:" + getValue(scanner));
            else
                throw new InputMismatchException("Unknown prefix token: [" + token + "]");
        } while (",".equals(scanner.lastMatch()));
        scanner.next();
        System.out.println("\tEnd");
    }

    private void processConcept(Scanner2 scanner) {
        System.out.println("Processing Concept");
        String token = scanner.next();
        System.out.println("\tConcept: " + token);
        do {
            token = scanner.next().toLowerCase();
            if ("id".equals(token)) System.out.println("\t\tId:" + getValue(scanner));
            else if ("status".equals(token)) System.out.println("\t\tStatus:" + getValue(scanner));
            else if ("name".equals(token)) System.out.println("\t\tName:" + getValue(scanner));
            else if ("description".equals(token)) System.out.println("\t\tDesc:" + getValue(scanner));
            else if ("short".equals(token)) System.out.println("\t\tShort:" + getValue(scanner));
            else if ("version".equals(token)) System.out.println("\t\tVersion:" + getValue(scanner));
            else if ("code_scheme".equals(token)) System.out.println("\t\tScheme:" + getValue(scanner));
            else if ("code".equals(token)) System.out.println("\t\tCode:" + getValue(scanner));
            else
                throw new InputMismatchException("Unknown concept token: [" + token + "]");
        } while (",".equals(scanner.lastMatch()));
        System.out.println("End");
    }

    private void processStructure(Scanner2 scanner) {
        System.out.println("Processing Structure");
        String token = scanner.next();
        System.out.println("\tStructure: " + token);
        do {
            token = scanner.next().toLowerCase();
            if ("id".equals(token)) System.out.println("\t\tId:" + getValue(scanner));
            else if ("cardinality".equals(token)) System.out.println("\t\tCardinality:" + getValue(scanner));
            else if ("property".equals(token)) System.out.println("\t\tProperty:" + getValue(scanner));
            else if ("has_one".equals(token)) System.out.println("\t\t(1:1):" + scanner.next());
            else if ("has_up_to_one".equals(token)) System.out.println("\t\t(0:1):" + scanner.next());
            else if ("has_many".equals(token)) System.out.println("\t\t(1:*):" + scanner.next());
            else if ("has_up_to_many".equals(token)) System.out.println("\t\t(0:*):" + scanner.next());
            else
                throw new InputMismatchException("Unknown structure token: [" + token + "]");
        } while (",".equals(scanner.lastMatch()));
        System.out.println("End");
    }

    private void processDefinition(Scanner2 scanner) {
        System.out.println("Processing Definition");
        String token = scanner.next();
        System.out.println("\tDefinition: " + token);
        do {
            token = scanner.next().toLowerCase();
            // if (scanner.hasNext("=")) System.out.println("\t\t" + token + ":" + getValue(scanner));
            if ("is_equivalent_to".equals(token)) processEquivalence(scanner);
//            // else if (scanner.hasNext("\\(")) processExpression(token, scanner, 1);
            else
                System.out.println("\t\t[" + scanner.lastMatch() + "] -> " + token + ":" + scanner.next());
        } while (",".equals(scanner.lastMatch()));
        System.out.println("End");
    }

    private void processEquivalence(Scanner2 scanner) {
        System.out.println("\t\tIs equivalent to : ");
        do {
            String token = scanner.next().toLowerCase();
            // if (scanner.hasNext("=")) System.out.println("\t\t" + token + ":" + getValue(scanner));
            if ("is_intersection_of".equals(token)) processIntersection(scanner);
            // else if (scanner.hasNext("\\(")) processExpression(token, scanner, 1);
            else
                System.out.println("\t\t[" + scanner.lastMatch() + "] -> " + token + ":" + scanner.next());
        } while (",".equals(scanner.lastMatch()));
        System.out.println("End");
    }

    private void processIntersection(Scanner2 scanner) {
        System.out.println("\t\tIntersection of : ");
        do {
            String token = scanner.next().toLowerCase();
            // if (scanner.hasNext("=")) System.out.println("\t\t" + token + ":" + getValue(scanner));
            if ("is_intersection_of".equals(token)) processIntersection(scanner);
            else if ("(".equals(scanner.lastMatch())) processExpression(token, scanner, 1);
            else
                System.out.println("\t\tConcept: " + token);
        } while (",".equals(scanner.lastMatch()));
        System.out.println("End");
    }

    private void processExpression(String name, Scanner2 scanner, int depth) {
        System.out.print(StringUtils.repeat("\t", depth));
        System.out.println("\t(Exp: " + name + ") : ");
        do {
            String token = scanner.next().toLowerCase();
            if ("=".equals(scanner.lastMatch())) System.out.println(StringUtils.repeat("\t", depth) + "\t" + token + ":" + getValue(scanner));
            else if ("(".equals(scanner.lastMatch())) processExpression(token, scanner, depth + 1);
            else
                System.out.println(StringUtils.repeat("\t", depth) + "\t" + token + ":" + scanner.next());
        } while (",".equals(scanner.lastMatch()));
        System.out.println(StringUtils.repeat("\t", depth) + "End");
    }

    private void processPattern(Scanner2 scanner) {
        System.out.println("Processing Pattern");
        String token = scanner.next();
        System.out.println("\tPatter: " + token);
//        token = scanner.next();
//        while (!token.equals(")")) {
//            if ("key".equals(token.toLowerCase())) System.out.println("\t\tKey:" + getValue(scanner));
//            else if ("count".equals(token.toLowerCase())) System.out.println("\t\tCount:" + getValue(scanner));
//            else if (scanner.hasNext("\\(")) processStructurePattern(token, scanner);
//            else
//                throw new InputMismatchException("Unknown pattern token: [" + token + "]");
//            token = scanner.next().toLowerCase();
//        }
        System.out.println("End");
    }

    private void processStructurePattern(String name, Scanner2 scanner) {
        System.out.println("Processing Structure Pattern");
        System.out.println("\tStructure Pattern: " + name);
        String token = scanner.next();
        while (!token.equals(")")) {
            processStructurePatternPath(token, scanner);
            token = scanner.next().toLowerCase();
        }
        System.out.println("End");
    }

    private void processStructurePatternPath(String name, Scanner2 scanner) {
        System.out.println("\t\tStructure Pattern Path: " + name);
        String token = scanner.next();
        while (!token.equals(")")) {
            System.out.println("\t\t\t" + token.toLowerCase() + " = " + getValue(scanner));
            token = scanner.next();
        }
        System.out.println("End");

    }

    private String getValue(Scanner2 scanner) {
//        scanner.skip("(\\s|\t|\n)*=(\\s|\t|\n)*");
        String value = scanner.next(); //  "";
//        scanner.useDelimiter("");
//        int b = 0;
//
//        do {
//            String s = scanner.next(); //Pattern.compile("."));
//            if ("(".equals(s)) b++;
//            if (")".equals(s)) b--;
//            value += s;
//        } while (b > 0 || !scanner.hasNext("\\)|,"));
//
//        scanner.useDelimiter(DELIMITER);

        return value;
    }
}
