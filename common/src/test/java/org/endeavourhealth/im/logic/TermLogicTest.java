package org.endeavourhealth.im.logic;

import org.endeavourhealth.im.dal.ConceptMockDAL;
import org.endeavourhealth.im.dal.TaskMockDAL;
import org.endeavourhealth.im.dal.TermMockDAL;
import org.endeavourhealth.im.models.Concept;
import org.endeavourhealth.im.models.Term;
import org.junit.Before;
import org.junit.Test;

import static org.junit.Assert.*;

public class TermLogicTest {
    private ConceptMockDAL conceptMockDAL;
    private ConceptLogic conceptLogic;
    private TaskMockDAL taskMockDAL;
    private TermMockDAL termMockDAL;
    private TermLogic termLogic;

    @Before
    public void setUp() {
        taskMockDAL = new TaskMockDAL();
        conceptMockDAL = new ConceptMockDAL();
        conceptLogic = new ConceptLogic(conceptMockDAL, taskMockDAL);
        termMockDAL = new TermMockDAL();
        termLogic = new TermLogic(termMockDAL, taskMockDAL, conceptMockDAL);
    }

    @Test
    public void getTerm_Mapped() throws Exception {
        termMockDAL.getConceptId_Result = 12345L;
        conceptMockDAL.get_Result = new Concept()
            .setId(54321L);

        Term result = termLogic.getTerm("04860a6d-65c5-4f21-8148-5ec33e331235", "Observation", "SNOMED", "195967001", "Asthma");
        assertTrue(termMockDAL.getConceptId_Called);
        assertTrue(conceptMockDAL.get_Called);
        assertEquals(termMockDAL.getConceptId_Result, conceptMockDAL.get_Value);
        assertTrue(conceptMockDAL.saveConcept_Called);
        assertEquals(conceptMockDAL.get_Result, conceptMockDAL.saveConcept_Value);
        assertNotNull(result);
        assertEquals(1L, (long) conceptMockDAL.saveConcept_Value.getUseCount());
    }

    @Test
    public void getTerm_Unmapped_Known() throws Exception {
        termMockDAL.getConceptId_Result = null;
        conceptMockDAL.getConceptByContext_Result = new Concept()
            .setId(54321L);

        Term result = termLogic.getTerm("04860a6d-65c5-4f21-8148-5ec33e331235", "Observation", "SNOMED", "195967001", "Asthma");
        assertTrue(termMockDAL.getConceptId_Called);
        assertTrue(conceptMockDAL.getConceptByContext_Called);
        assertEquals("Term.SNOMED.195967001", conceptMockDAL.getConceptByContext_Value);
        assertTrue(termMockDAL.createTermMap_Called);
    }

    @Test
    public void getTerm_Unmapped_Unknown_OfficialExists() throws Exception {
        termMockDAL.getConceptId_Result = null;
        termMockDAL.getSnomedTerm_Result = "Asthma (disorder)";

        Term result = termLogic.getTerm("04860a6d-65c5-4f21-8148-5ec33e331235", "Observation", "SNOMED", "195967001", "Asthma");

        assertTrue(termMockDAL.getConceptId_Called);
        assertTrue(conceptMockDAL.getConceptByContext_Called);
        assertEquals("Term.SNOMED.195967001", conceptMockDAL.getConceptByContext_Value);
        assertTrue(termMockDAL.getSnomedTerm_Called);
        assertTrue(conceptMockDAL.saveConcept_Called);
        assertFalse(taskMockDAL.createTask_Called);
        assertTrue(termMockDAL.createTermMap_Called);
    }


    @Test
    public void getTerm_Unmapped_Unknown_OfficialUnknown() throws Exception {
        termMockDAL.getConceptId_Result = null;
        termMockDAL.getSnomedTerm_Result = null;

        Term result = termLogic.getTerm("04860a6d-65c5-4f21-8148-5ec33e331235", "Observation", "SNOMED", "195967001", "Asthma");

        assertTrue(termMockDAL.getConceptId_Called);
        assertTrue(conceptMockDAL.getConceptByContext_Called);
        assertEquals("Term.SNOMED.195967001", conceptMockDAL.getConceptByContext_Value);
        assertTrue(termMockDAL.getSnomedTerm_Called);
        assertTrue(conceptMockDAL.saveConcept_Called);
        assertTrue(taskMockDAL.createTask_Called);
        assertTrue(termMockDAL.createTermMap_Called);
    }
}