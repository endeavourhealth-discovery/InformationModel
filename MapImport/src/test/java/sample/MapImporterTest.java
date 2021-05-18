package sample;

import org.junit.Before;
import org.junit.Test;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import static org.junit.Assert.*;

public class MapImporterTest {
    MapImporter importer;

    @Before
    public void setup() {
        importer = new MapImporter();
    }

    @Test
    public void executeNode() throws Exception {
        MapData mapData = new MapData()
            .setContext("/CM_Org_Imperial/CM_Sys_Cerner/admission_method_code")
            .setTarget("/CDS/INPTNT/ADMSSN_MTHD")
            .setTargetIsNode(true)
            .setCodeScheme("ImperialCerner")
            .setValues(getValues());

        importer.execute(mapData);
    }

    @Test(expected = IllegalStateException.class)
    public void executeProperty() throws Exception {
        // Already maps to "/CDS/INPTNT/ADMSSN_MTHD"
        MapData mapData = new MapData()
            .setContext("/CM_Org_Imperial/CM_Sys_Cerner/admission_method_code")
            .setTarget("DM_methodOfAdmssion")
            .setTargetIsNode(false)
            .setCodeScheme("ImperialCerner")
            .setValues(getValues());

        importer.execute(mapData);
    }

    @Test
    public void executeNodeFullContext() throws Exception {
        MapData mapData = new MapData()
            .setContext("/CM_Org_Imperial/CM_Sys_Cerner/HL7v2/A01/admission_method_code")
            .setTarget("/IMPRL/CRNR/HL7V2/A01/ADMSSN_MTHD_CD")
            .setTargetIsNode(true)
            .setCodeScheme("ImperialCerner")
            .setValues(getValues());

        importer.execute(mapData);
    }

    @Test
    public void executePropertyFullContext() throws Exception {
        MapData mapData = new MapData()
            .setContext("/CM_Org_Imperial/CM_Sys_Cerner/HL7v2/A01/admission_method_code")
            .setTarget("DM_methodOfAdmssion")
            .setTargetIsNode(false)
            .setCodeScheme("ImperialCerner")
            .setValues(getValues());

        importer.execute(mapData);
    }

    @Test(expected = IllegalStateException.class)
    public void executeNodeFullContextWrongNode() throws Exception {
        MapData mapData = new MapData()
            .setContext("/CM_Org_Imperial/CM_Sys_Cerner/HL7v2/A01/admission_method_code")
            .setTarget("/CDS/INPTNT/ADMSSN_MTHD")
            .setTargetIsNode(true)
            .setCodeScheme("ImperialCerner")
            .setValues(getValues());

        importer.execute(mapData);
    }

    @Test
    public void executePropertyFullContextWrongNode() throws Exception {
        MapData mapData = new MapData()
            .setContext("/CM_Org_Imperial/CM_Sys_Cerner/HL7v2/A01/admission_method_code")
            .setTarget("DM_methodOfAdmssion")
            .setTargetIsNode(false)
            .setCodeScheme("ImperialCerner")
            .setValues(getValues());

        importer.execute(mapData);
    }


    private List<Value> getValues() {
        String data = "12\tBooked\t12\tElective admission - Booked\n" +
            "13\tPlanned\t13\tElective admission - Admission\n" +
            "11\tWaiting List\t11\tElective admission - Waiting list\n" +
            "23\tEmergency-Bed Bureau\t23\tEmergency Admission: Bed bureau\n" +
            "2A\tEmergency-ED (Other Provider)\t2A\tEmergency Admission: Emergency Care Department of another provider where the patient had not been admitted\n" +
            "21\tEmergency-ED/Dental\t21\tEmergency Admission: Emergency Care Department or dental casualty department of the Health Care Provider  \n" +
            "22\tEmergency-GP\t22\tEmergency Admission: general practitioner after a request for immediate admission has been made direct to a Hospital Provider, i.e. not through a Bed bureau, by a general practitioner or deputy\n" +
            "24\tEmergency-O/P Clinic\t24\tEmergency Admission: Consultant Clinic, of this or another Health Care Provider  \n" +
            "2D\tEmergency-Other\t2D\tEmergency Admission: Other emergency admission\n" +
            "31\tMaternity - Ante Partum\t31\tMaternity Admission: Admitted ante Partum\n" +
            "32\tMaternity-Post Partum\t32\tMaternity Admission: Admitted post partum\n" +
            "81\tTransfer From Other Provider (not Emerge\t81\tOther Admission: Transfer of any admitted patient from other Hospital Provider other than in an emergency\n" +
            "2B\tTransfer From Other Provider(Not ED)\t2B\tEmergency Admission: Transfer of an admitted patient from another Hospital Provider in an emergency\n" +
            "2C\tBaby Born at Home as intended\t2C\tEmergency Admission: Baby born at home as intended\n" +
            "82\tBaby Born in Hospital\t82\tOther Admission: The birth of a baby in this Health Care Provider\n" +
            "83\tBaby Born Outside Hospital\t83\tOther Admission: Baby born outside the Health Care Provider except when born at home as intended\n";

        return Arrays.stream(data.split("\n"))
            .map(row -> {
                String[] cells = row.split("\t");
                Value v = new Value()
                    .setCode(cells[0])
                    .setTerm(cells[1]);

                if (cells.length == 4) {
                    v.setNationalCode(cells[2])
                        .setNationalTerm(cells[3]);
                }
                return v;
            })
            .collect(Collectors.toList());
    }
}
