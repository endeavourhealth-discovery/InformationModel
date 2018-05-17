USE im;

INSERT INTO transaction_action
  (id, action)
VALUES
  (0, "Create"),
  (1, "Update"),
  (2, "Delete");

INSERT INTO transaction_table
  (id, `table`)
VALUES
  (0, "Concept"),
  (1, "Message"),
  (2, "Task"),
  (3, "Record Type"),
  (4, "Term Mapping");

INSERT INTO task_type
  (id, name)
VALUES
  (0, "Attribute Model"),
  (1, "Value Model"),
  (2, "Unmapped message"),
  (3, "Unmapped terms");
