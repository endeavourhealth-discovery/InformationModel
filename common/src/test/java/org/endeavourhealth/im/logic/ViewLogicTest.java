package org.endeavourhealth.im.logic;

import org.endeavourhealth.im.dal.ViewMockDAL;
import org.junit.Before;
import org.junit.Test;

import static org.junit.Assert.*;

public class ViewLogicTest {
    private ViewLogic viewLogic;
    private ViewMockDAL viewMockDAL;

    @Before
    public void setUp() {
        viewMockDAL = new ViewMockDAL();
        viewLogic = new ViewLogic(viewMockDAL);
    }

    @Test
    public void getViewContents_Auto() throws Exception {
        viewLogic.getViewContents(1L, null);

        assertTrue(viewMockDAL.getSubTypes_Called);
    }

    @Test
    public void getViewContents_Standard() throws Exception {
        viewLogic.getViewContents(2L, null);

        assertTrue(viewMockDAL.getViewContents_Called);
    }

}