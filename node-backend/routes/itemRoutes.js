const router = require("express").Router();
const {
  getItemsController,
  addItemController,
  deleteItemController,
} = require("../controllers/itemController");

router.get("/items", getItemsController);
router.post("/items", addItemController);
router.delete("/items/:id", deleteItemController);

module.exports = router;
