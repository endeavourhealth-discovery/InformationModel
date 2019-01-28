package org.endeavourhealth.im.logic;

import org.junit.Before;
import org.junit.Test;

import java.io.File;
import java.util.Scanner;

public class ModellingLanguageParserTest {
    private ModellingLanguageParser parser;

    @Before
    public void setUp() throws Exception {
        parser = new ModellingLanguageParser();
    }

    @Test
    public void execute() throws Exception {
        parser.execute(new Scanner2(new File("example.dml")));
    }
}
