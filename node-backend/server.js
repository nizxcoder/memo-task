const app = require("express")();
const bodyParser = require("body-parser");
const fs = require("fs");
const itemsRoutes = require("./routes/itemRoutes");
const port = 3000;

app.use(bodyParser.json());

// Home route
app.get("/", (req, res) => {
  res.send("Hello Memo");
});

// Item routes
app.use("/api", itemsRoutes);

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
