<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Détails du Produit</title>
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css"
    />
    <style>
        .product-img {
            max-height: 400px;
            object-fit: cover;
        }
    </style>
</head>
<body>
    <div class="container py-5">
        <h1 class="mb-4">Détails du Produit</h1>
        <div class="row">
            <% 
                String url = "jdbc:postgresql://localhost:5432/ecommerce";
                String username = "postgres";
                String password = "123456";

                String productId = request.getParameter("id");
                boolean isEditing = "true".equals(request.getParameter("edit"));

                if (productId != null) {
                    try {
                        Class.forName("org.postgresql.Driver");
                        Connection conn = DriverManager.getConnection(url, username, password);

                        String sql = "SELECT p.nom, p.description, p.prix, p.image, p.stock, c.nom AS category_name " +
                                    "FROM public.products p " +
                                    "INNER JOIN public.categorie c ON p.categorie_id = c.id " +
                                    "WHERE p.id = ?";
                        PreparedStatement ps = conn.prepareStatement(sql);
                        ps.setInt(1, Integer.parseInt(productId));
                        ResultSet rs = ps.executeQuery();

                        if (rs.next()) {
                            String name = rs.getString("nom");
                            String description = rs.getString("description");
                            double price = rs.getDouble("prix");
                            String image = rs.getString("image");
                            int stock = rs.getInt("stock");
                            String category = rs.getString("category_name");

                            // Construire le chemin complet pour l'image
                            String fullImagePath = request.getContextPath() + "/" + image;
            %>
            <!-- Détails du Produit -->
            <div class="col-md-6">
                <img
                    src="<%= fullImagePath %>"
                    alt="<%= name %>"
                    class="product-img rounded w-100 h-auto"
                />
            </div>
            <div class="col-md-6">
                <h2 class="mb-3"><%= name %></h2>
                <p class="product-description"><strong>Description :</strong> <%= description %></p>
                <p class="mb-1"><strong>Prix :</strong> <%= String.format("%.2f", price) %> €</p>
                <p class="mb-1"><strong>Stock :</strong> <%= stock %> unités</p>
                <p class="mb-1"><strong>Catégorie :</strong> <%= category %></p>

                <% if (isEditing) { %>
                <!-- Formulaire de modification -->
                <form action="EditProductServlet" method="post" class="mt-4">
                    <input type="hidden" name="id" value="<%= productId %>" />

                    <div class="mb-3">
                        <label for="description" class="form-label">Description</label>
                        <textarea class="form-control" id="description" name="description" rows="3"><%= description %></textarea>
                    </div>

                    <div class="mb-3">
                        <label for="price" class="form-label">Prix</label>
                        <input type="number" step="0.01" class="form-control" id="price" name="price" value="<%= price %>" />
                    </div>

                    <div class="mb-3">
                        <label for="stock" class="form-label">Stock</label>
                        <input type="number" class="form-control" id="stock" name="stock" value="<%= stock %>" />
                    </div>

                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i> Enregistrer les modifications
                    </button>
                    <a href="product_detail.jsp?id=<%= productId %>" class="btn btn-secondary">
                        <i class="fas fa-times"></i> Annuler
                    </a>
                </form>
                <% } else { %>
                <!-- Boutons Modifier et Supprimer -->
                <div class="mt-4">
                    <a href="product_detail.jsp?id=<%= productId %>&edit=true" class="btn btn-warning me-2">
                        <i class="fas fa-edit"></i> Modifier
                    </a>
                    <a href="supprimer_produit.jsp?id=<%= productId %>" class="btn btn-danger">
                        <i class="fas fa-trash"></i> Supprimer
                    </a>
                </div>
                <% } %>
            </div>
            <% 
                        } else {
                            out.println("<p class='text-danger'>Produit non trouvé.</p>");
                        }
                        rs.close();
                        ps.close();
                        conn.close();
                    } catch (SQLException | ClassNotFoundException e) {
                        e.printStackTrace();
                        out.print("<p class='text-danger'>Erreur lors de la récupération des détails du produit.</p>");
                    }
                } else {
                    out.println("<p class='text-danger'>ID du produit manquant.</p>");
                }
            %>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
