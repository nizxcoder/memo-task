const fs = require("fs");
const path = require("path");
const itemSchema = require("../models/item");

const filePath = path.join(__dirname, "../data/items.json");
let items = [];

// Load items from items.json
const loadItems = () => {
  try {
    const data = fs.readFileSync(filePath, "utf-8");
    items = JSON.parse(data);
  } catch (err) {
    console.error("Error reading items.json:", err);
    items = []; // fallback to an empty array if reading fails
  }
};

loadItems(); // Load the items when the app starts

// Save items to items.json
const saveItems = () => {
  try {
    fs.writeFileSync(filePath, JSON.stringify(items, null, 3)); // null, 2 for readable formatting
  } catch (err) {
    console.error("Error saving items to items.json:", err);
  }
};

// Get items from items.json
const getItemsController = (req, res) => {
  if (!items || items.length === 0) {
    return res.status(404).json({ message: "No items found" });
  }
  res.status(200).send(items);
};

// Add item to items.json
const addItemController = (req, res) => {
  const data = req.body;

  // Validate if data exists and is not empty
  if (!data || Object.keys(data).length === 0) {
    return res.status(400).json({ message: "Invalid data format" });
  }

  const error = itemSchema.validate(data).error;
  if (error) {
    return res.status(400).json({ message: error.details[0].message });
  }

  // Ensure unique ID (handle the case when the items list is empty)
  const newItem = {
    id: items.length ? items[items.length - 1].id + 1 : 1,
    ...data,
  };

  items.push(newItem);
  saveItems();
  res.status(201).json(newItem);
};

// Delete item from items.json
const deleteItemController = (req, res) => {
  const id = req.params.id;

  // Convert id to a number and validate if it's a valid number
  const numericId = parseInt(id, 10);
  if (isNaN(numericId)) {
    return res.status(400).json({ message: "Invalid ID format" });
  }

  const index = items.findIndex((item) => item.id === numericId);
  if (index === -1) {
    return res.status(404).json({ message: "Item not found" });
  }

  items.splice(index, 1);
  saveItems();
  res.status(200).json({ message: "Item deleted" });
};

module.exports = {
  getItemsController,
  addItemController,
  deleteItemController,
};
