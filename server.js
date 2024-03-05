require('dotenv').config(); // Keep this for local development
const express = require('express');
const { Pool } = require('pg');
const multer = require('multer'); // Make sure multer is required at the top

const app = express();
const port = process.env.PORT || 3000;

// Parse JSON bodies (as sent by API clients)
app.use(express.json());

// Configure multer for file uploads
const upload = multer({ dest: 'uploads/' });

// Heroku provides DATABASE_URL for Postgres add-on users. Use that if available.
const pool = new Pool({
  connectionString: process.env.DATABASE_URL, // Use DATABASE_URL directly
  ssl: {
    rejectUnauthorized: false // Necessary for Heroku's default Postgres setup
  }
});

app.listen(port, () => {
    console.log(`Server running on port ${port}`); // Corrected to "port" variable
});

// Your API endpoints remain unchanged...

// Example endpoint:
app.get('/recipes', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM Recipes');
    res.json(result.rows);
  } catch (err) {
    res.status(500).send(err.message);
  }
});

// GET /recipes - Retrieves a list of all recipes.
app.get('/recipes', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM Recipes'); // Query to select all recipes
    res.json(result.rows); // Send all recipes as JSON
  } catch (err) {
    res.status(500).send(err.message); // Handle any errors
  }
});

// GET /recipes/:id - Retrieves detailed information about a specific recipe by its ID.
app.get('/recipes/:id', async (req, res) => {
  const { id } = req.params; // Extract the recipe ID from the request URL
  try {
    const result = await pool.query('SELECT * FROM Recipes WHERE RecipeID = $1', [id]); // Query to find the recipe by ID
    if (result.rows.length > 0) {
      res.json(result.rows[0]); // Send the found recipe as JSON
    } else {
      res.status(404).send('Recipe not found'); // Send a 404 error if no recipe is found
    }
  } catch (err) {
    res.status(500).send(err.message); // Handle any errors
  }
});


// POST /recipes - Creates a new recipe with details provided in the request body.
app.post('/recipes', async (req, res) => {
  const { title, description, instructions, preparationTime, cookingTime, servings } = req.body; // Extract recipe details from the request body
  try {
    const result = await pool.query(
      'INSERT INTO Recipes (Title, Description, Instructions, PreparationTime, CookingTime, Servings) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *',
      [title, description, instructions, preparationTime, cookingTime, servings] // Insert the new recipe into the database
    );
    res.status(201).json(result.rows[0]); // Send the created recipe as JSON
  } catch (err) {
    res.status(500).send(err.message); // Handle any errors
  }
});


// PUT /recipes/:id - Updates an existing recipe identified by its ID with new details provided in the request body.
app.put('/recipes/:id', async (req, res) => {
  const { id } = req.params; // Extract the recipe ID from the request URL
  const { title, description, instructions, preparationTime, cookingTime, servings } = req.body; // Extract new recipe details from the request body
  try {
    const result = await pool.query(
      'UPDATE Recipes SET Title = $1, Description = $2, Instructions = $3, PreparationTime = $4, CookingTime = $5, Servings = $6 WHERE RecipeID = $7 RETURNING *',
      [title, description, instructions, preparationTime, cookingTime, servings, id] // Update the recipe in the database
    );
    if (result.rows.length > 0) {
      res.json(result.rows[0]); // Send the updated recipe as JSON
    } else {
      res.status(404).send('Recipe not found'); // Send a 404 error if no recipe is found
    }
  } catch (err) {
    res.status(500).send(err.message); // Handle any errors
  }
});


// DELETE /recipes/:id - Deletes a specific recipe by its ID.
app.delete('/recipes/:id', async (req, res) => {
  const { id } = req.params; // Extract the recipe ID from the request URL
  try {
    const deleteResult = await pool.query('DELETE FROM Recipes WHERE RecipeID = $1 RETURNING *', [id]); // Delete the recipe from the database
    if (deleteResult.rowCount > 0) {
      res.json({ message: 'Recipe deleted' }); // Confirm deletion
    } else {
      res.status(404).send('Recipe not found'); // Send a 404 error if no recipe is found
    }
  } catch (err) {
    res.status(500).send(err.message); // Handle any errors
  }
});

// GET /ingredients - Retrieves a list of all ingredients
app.get('/ingredients', async (req, res) => {
  try {
    // Execute SQL query to select all ingredients from the database
    const result = await pool.query('SELECT * FROM Ingredients');
    // Send the retrieved rows as JSON
    res.json(result.rows);
  } catch (err) {
    // Send a 500 status code if there's a server error
    res.status(500).send(err.message);
  }
});

// POST /ingredients - Adds a new ingredient with details provided in the request body
app.post('/ingredients', async (req, res) => {
  const { name, description } = req.body; // Extract name and description from the request body

  try {
    // Execute SQL query to insert a new ingredient into the database
    const result = await pool.query(
      'INSERT INTO Ingredients (Name, Description) VALUES ($1, $2) RETURNING *',
      [name, description]
    );
    // Send the newly added ingredient as JSON
    res.status(201).json(result.rows[0]);
  } catch (err) {
    // Send a 500 status code if there's a server error
    res.status(500).send(err.message);
  }
});

// PUT /ingredients/:id - Updates an existing ingredient identified by its ID with new details
app.put('/ingredients/:id', async (req, res) => {
  const { id } = req.params; // Extract the ID from the request parameters
  const { name, description } = req.body; // Extract the new name and description from the request body

  try {
    // Execute SQL query to update the ingredient with the specified ID
    const result = await pool.query(
      'UPDATE Ingredients SET Name = $1, Description = $2 WHERE IngredientID = $3 RETURNING *',
      [name, description, id]
    );

    if (result.rows.length > 0) {
      // If the ingredient was found and updated, send it as JSON
      res.json(result.rows[0]);
    } else {
      // If no ingredient was found with the specified ID, send a 404 status code
      res.status(404).send('Ingredient not found');
    }
  } catch (err) {
    // Send a 500 status code if there's a server error
    res.status(500).send(err.message);
  }
});

// DELETE /ingredients/:id - Deletes a specific ingredient by its ID
app.delete('/ingredients/:id', async (req, res) => {
  const { id } = req.params; // Extract the ID from the request parameters

  try {
    // Execute SQL query to delete the ingredient with the specified ID
    const result = await pool.query('DELETE FROM Ingredients WHERE IngredientID = $1 RETURNING *', [id]);

    if (result.rowCount > 0) {
      // If the ingredient was found and deleted, confirm deletion
      res.json({ message: 'Ingredient deleted' });
    } else {
      // If no ingredient was found with the specified ID, send a 404 status code
      res.status(404).send('Ingredient not found');
    }
  } catch (err) {
    // Send a 500 status code if there's a server error
    res.status(500).send(err.message);
  }
});

// GET /recipes/:recipeId/ingredients
// Retrieves a list of ingredients for a specific recipe.
app.get('/recipes/:recipeId/ingredients', async (req, res) => {
  const { recipeId } = req.params;

  try {
    const result = await pool.query(
      'SELECT i.IngredientID, i.Name, i.Description, ri.Quantity, ri.Unit FROM Ingredients i INNER JOIN RecipeIngredients ri ON i.IngredientID = ri.IngredientID WHERE ri.RecipeID = $1',
      [recipeId]
    );
    res.json(result.rows);
  } catch (err) {
    res.status(500).send(err.message);
  }
});

// POST /recipes/:recipeId/ingredients
// Adds an ingredient to a recipe with details like quantity and unit.
app.post('/recipes/:recipeId/ingredients', async (req, res) => {
  const { recipeId } = req.params;
  const { ingredientId, quantity, unit } = req.body;

  try {
    const result = await pool.query(
      'INSERT INTO RecipeIngredients (RecipeID, IngredientID, Quantity, Unit) VALUES ($1, $2, $3, $4) RETURNING *',
      [recipeId, ingredientId, quantity, unit]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    res.status(500).send(err.message);
  }
});

// PUT /recipes/:recipeId/ingredients/:ingredientId
// Updates the quantity or unit of an ingredient within a specific recipe.
app.put('/recipes/:recipeId/ingredients/:ingredientId', async (req, res) => {
  const { recipeId, ingredientId } = req.params;
  const { quantity, unit } = req.body;

  try {
    const result = await pool.query(
      'UPDATE RecipeIngredients SET Quantity = $1, Unit = $2 WHERE RecipeID = $3 AND IngredientID = $4 RETURNING *',
      [quantity, unit, recipeId, ingredientId]
    );

    if (result.rows.length > 0) {
      res.json(result.rows[0]);
    } else {
      res.status(404).send('Ingredient not found in this recipe');
    }
  } catch (err) {
    res.status(500).send(err.message);
  }
});

// DELETE /recipes/:recipeId/ingredients/:ingredientId
// Removes a specific ingredient from a recipe.
app.delete('/recipes/:recipeId/ingredients/:ingredientId', async (req, res) => {
  const { recipeId, ingredientId } = req.params;

  try {
    const result = await pool.query(
      'DELETE FROM RecipeIngredients WHERE RecipeID = $1 AND IngredientID = $2 RETURNING *',
      [recipeId, ingredientId]
    );

    if (result.rowCount > 0) {
      res.json({ message: 'Ingredient removed from recipe' });
    } else {
      res.status(404).send('Ingredient not found in this recipe');
    }
  } catch (err) {
    res.status(500).send(err.message);
  }
});

// GET /recipes/:recipeId/images
// Retrieves all user-uploaded images for a specific recipe.
app.get('/recipes/:recipeId/images', async (req, res) => {
  const { recipeId } = req.params;
  try {
    const result = await pool.query(
      'SELECT * FROM UserImages WHERE RecipeID = $1',
      [recipeId]
    );
    res.json(result.rows);
  } catch (err) {
    res.status(500).send(err.message);
  }
});

const multer = require('multer');
const upload = multer({ dest: 'uploads/' }); // configure multer, using 'uploads/' as the storage location

// POST /recipes/:recipeId/images
// Allows uploading an image for a recipe, storing the image path and upload time.
app.post('/recipes/:recipeId/images', upload.single('image'), async (req, res) => {
  const { recipeId } = req.params;
  const imagePath = req.file.path; // Using multer, the path where the image is saved
  try {
    const result = await pool.query(
      'INSERT INTO UserImages (RecipeID, ImagePath, UploadTime) VALUES ($1, $2, CURRENT_TIMESTAMP) RETURNING *',
      [recipeId, imagePath]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    res.status(500).send(err.message);
  }
});

// DELETE /images/:imageId
// Deletes a specific user-uploaded image.
app.delete('/images/:imageId', async (req, res) => {
  const { imageId } = req.params;
  try {
    // Optional: Add logic to delete the file from the filesystem or cloud storage
    const deleteResult = await pool.query(
      'DELETE FROM UserImages WHERE ImageID = $1 RETURNING *',
      [imageId]
    );

    if (deleteResult.rowCount > 0) {
      // Here you could add logic to also remove the file from storage based on deleteResult.rows[0].ImagePath
      res.json({ message: 'Image deleted' });
    } else {
      res.status(404).send('Image not found');
    }
  } catch (err) {
    res.status(500).send(err.message);
  }
});



