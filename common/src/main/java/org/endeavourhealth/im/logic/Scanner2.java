package org.endeavourhealth.im.logic;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Scanner2 {
    private String string = null;
    private Pattern pattern = null;
    private Matcher matcher = null;
    private int pos = 0;
    private String match = null;
    private String token = null;

    public Scanner2(File file) throws FileNotFoundException {
        try (Scanner t = new Scanner(file)) {
            string = t.useDelimiter("\\A").next();
        }
    }

    public Scanner2(String string) {
        this.string = string;
    }

    public void useDelimiter(String regex) {
        pattern = Pattern.compile(regex);
        matcher = pattern.matcher(string);
    }

    public String next() {
        if (matcher.find(pos)) {
            token = string.substring(pos, matcher.start());
            match = matcher.group();
            pos = matcher.end();

            while (token.startsWith("\"") && !token.endsWith("\"") && matcher.find(pos)) {
                token += match + string.substring(pos, matcher.start());
                match = matcher.group();
                pos = matcher.end();
            }

            return token;
        } else {
            return null;
        }
    }

    public String lastMatch() {
        return match.trim();
    }
}
