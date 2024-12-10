<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Add Product</title>
</head>
<body>
    <h2>Add Product</h2>
    <form action="ProductServlet" method="post" enctype="multipart/form-data">
        <!-- Action to be handled by the backend when the form is submitted -->
        <input type="hidden" name="action" value="add">

        <!-- Name Field -->
        <label for="name">Name:</label>
        <input type="text" id="name" name="name" value="" required><br>

        <!-- Description Field -->
        <label for="description">Description:</label>
        <textarea id="description" name="description" required></textarea><br>

        <!-- Price Field -->
        <label for="price">Price:</label>
        <input type="number" id="price" name="price" value="" step="0.01" required><br>

        <!-- Stock Field -->
        <label for="stock">Stock:</label>
        <input type="number" id="stock" name="stock" value="" required><br>

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
