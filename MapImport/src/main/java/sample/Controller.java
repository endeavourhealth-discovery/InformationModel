package sample;

import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.*;
import javafx.stage.Stage;

import java.net.URL;
import java.util.ResourceBundle;

public class Controller implements Initializable {
    private Stage stage;

    @FXML
    private ChoiceBox cmbNodeType;
    @FXML
    private TextField edtContext;
    @FXML
    private TextField edtNode;
    @FXML
    private TextArea edtValueData;
    @FXML
    private TextField edtCodeScheme;


    public void setStage(Stage stage) {
        this.stage = stage;
    }

    public void initialize(URL location, ResourceBundle resource) {
        cmbNodeType.getItems().clear();
        cmbNodeType.getItems().addAll("Existing node", "With property");
        cmbNodeType.getSelectionModel().select("Existing node");
    }

    public void importMaps() {
        try {
            validateInputs();
            System.out.println("Importing...");
            MapData mapData = getContext();
            new MapImporter().execute(mapData);
            alert("Done!", "Import complete", "Successfully imported mappings");
        } catch (Exception e) {
            alert("Exception!", "Error importing map", e.getMessage());
        }
    }

    private void validateInputs() {
        if (edtContext.getText().isEmpty())
            throw new IllegalStateException("Mapping context is not set");

        if (edtNode.getText().isEmpty())
            throw new IllegalStateException("Mapping target is not set");

        if (edtValueData.getText().isEmpty())
            throw new IllegalStateException("Value data is not set");
    }

    private MapData getContext() {
        MapData mapData = new MapData()
            .setContext(edtContext.getText())
            .setTargetIsNode(cmbNodeType.getSelectionModel().isSelected(0))
            .setTarget(edtNode.getText())
            .setCodeScheme(edtCodeScheme.getText());

        String valueData = edtValueData.getText();
        String[] rows = valueData.split("\n");

        if (rows.length == 0)
            throw new IllegalStateException("Unable to maps into rows");

        for(String row : rows) {
            String[] cells = row.split("\t");
            if (cells.length == 0)
                throw new IllegalStateException("Unable to parse row in to cells");

            if (cells.length != 2 && cells.length != 4)
                throw new IllegalStateException("Each row must contain either 2 (local code/term) or 4 (additional national code/term) cells");

            Value v = new Value()
                .setCode(cells[0])
                .setTerm(cells[1]);

            if (cells.length == 4) {
                v.setNationalCode(cells[2])
                    .setNationalTerm(cells[3]);
            }

            mapData.addValue(v);
        }

        System.out.println("Identified " + mapData.getValues().size() + " value maps");
        return mapData;
    }

    private void alert(String title, String header, String message) {
        Alert alert = new Alert(Alert.AlertType.INFORMATION);
        alert.setTitle(title);
        alert.setHeaderText(header);
        alert.setContentText(message);
        alert.showAndWait().ifPresent(rs -> {
            if (rs == ButtonType.OK) {
                System.out.println("Pressed OK.");
            }
        });
    }
}
