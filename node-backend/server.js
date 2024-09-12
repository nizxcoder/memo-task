const app = require("express")();
const bodyParser = require("body-parser");
const fs = require("fs");
const port = 3000;
const itemsRoutes = require("./routes/itemRoutes");

app.use(bodyParser.json());

app.get("/", (req, res) => {
  res.send("Hello Memo");
});

app.use("/api", itemsRoutes);

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
