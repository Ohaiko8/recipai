require('dotenv').config();
const express = require('express');
const { Pool } = require('pg');
const multer = require('multer');

const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());

// Create a new pool using DATABASE_URL
const pool = new Pool({
    connectionString: process.env.DATABASE_URL,
    ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false
});

app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});

// Create a new recipe
app.post('/recipes', async (req, res) => {
    const { title, image_path, cooking_time, ingredients, instructions } = req.body;
    try {
        const result = await pool.query(
            'INSERT INTO recipeslist (title, image_path, cooking_time, ingredients, instructions, creation_date) VALUES ($1, $2, $3, $4, $5, NOW()) RETURNING *',
            [title, image_path, cooking_time, ingredients, instructions]
        );
        res.status(201).json(result.rows[0]);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Fetch all recipes
app.get('/recipes', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM recipeslist');
        res.json(result.rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Fetch a single recipe by ID
app.get('/recipes/:id', async (req, res) => {
    const { id } = req.params;
    try {
        const result = await pool.query('SELECT * FROM recipeslist WHERE recipe_id = $1', [id]);
        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Recipe not found' });
        }
        res.json(result.rows[0]);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Update a recipe
app.put('/recipes/:id', async (req, res) => {
    const { id } = req.params;
    const { name, image_path, cooking_time, ingredients, instructions } = req.body;
    try {
        const result = await pool.query(
            'UPDATE recipeslist SET title = $1, image_path = $2, cooking_time = $3, ingredients = $4, instructions = $5 WHERE recipe_id = $6 RETURNING *',
            [title, image_path, cooking_time, ingredients, instructions, id]
        );
        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Recipe not found' });
        }
        res.json(result.rows[0]);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Delete a recipe
app.delete('/recipes/:id', async (req, res) => {
    const { id } = req.params;
    try {
        const result = await pool.query('DELETE FROM recipeslist WHERE recipe_id = $1 RETURNING *', [id]);
        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Recipe not found' });
        }
        res.status(204).send();
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

//test



