<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Dashboard Administrateur</title>
    <style>
    /* General form styling */
form {
    background-color: #f9f9f9;
    padding: 20px;
    border-radius: 8px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    width: 500px;
    margin: 0 auto;
    font-family: 'Arial', sans-serif;
}

form label {
    font-size: 14px;
    color: #333;
    display: block;
    margin-bottom: 8px;
    font-weight: bold;
}

form input, form textarea, form select, form button {
    width: 100%;
    padding: 10px;
    margin: 10px 0;
    border: 1px solid #ccc;
    border-radius: 6px;
    font-size: 14px;
}

form input[type="text"], form input[type="number"], form select, form textarea {
    background-color: #fff;
    color: #333;
}

form textarea {
    height: 120px;
    resize: vertical;
}

/* Image file input */
form input[type="file"] {
    padding: 6px;
}

/* Button styling */
form button {
    background-color: #007BFF;
    color: white;
    border: none;
    cursor: pointer;
    font-size: 16px;
    font-weight: bold;
    transition: background-color 0.3s ease;
}

form button:hover {
    background-color: #0056b3;
}

/* Fieldset Styling (for grouping) */
form fieldset {
    border: none;
    margin-bottom: 10px;
    padding: 0;
}

form fieldset legend {
    font-size: 16px;
    font-weight: bold;
    color: #007BFF;
    margin-bottom: 10px;
}

/* Styling for error messages */
.error {
    color: red;
    font-size: 14px;
    margin-bottom: 10px;
}

form input:focus, form select:focus, form textarea:focus {
    border-color: #007BFF;
    outline: none;
}

/* Add responsiveness */
@media (max-width: 600px) {
    form {
        width: 90%;
    }
}
    </style>
    </head>
    <body>

<form action="ProductServlet" method="post" enctype="multipart/form-data">
    <input type="hidden" name="action" value="add">

    <!-- Name Field -->
    <label for="name">Name:</label>
    <input type="text" id="name" name="name" required><br>

    <!-- Description Field -->
    <label for="description">Description:</label>
    <textarea id="description" name="description" required></textarea><br>

    <!-- Price Field -->
    <label for="price">Price:</label>
    <input type="number" id="price" name="price" step="0.01" required><br>

    <!-- Stock Field -->
    <label for="stock">Stock:</label>
    <input type="number" id="stock" name="stock" required><br>

    <!-- Category Dropdown -->
    <label for="category_id">Category:</label>
    <select id="category_id" name="category_id">
        <option value="1">Electronique</option>
        <option value="2">Vetements</option>
        <option value="3">Livres</option>
        <option value="4">Alimentation</option>
    </select><br>

    <!-- Image Field -->
    <label for="image">Image:</label>
    <input type="file" name="image"><br>

    <!-- Submit Button -->
    <button type="submit">Add Product</button>
</form>
</body>
</html>
