<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
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
        body {
            background-color: #f8f9fa;
        }

        .btn-custom {
            width: 48%;
            font-size: 1.1rem;
        }

        .btn-modern {
            border: none;
            font-weight: bold;
            transition: transform 0.2s ease;
        }

        .btn-modern:hover {
            transform: scale(1.05);
        }

        .btn-edit {
            background-color: #5a99d4;
            color: white;
        }

        .btn-edit:hover {
            background-color: #447db3;
        }

        .btn-delete {
            background-color: #e57373;
            color: white;
        }

        .btn-delete:hover {
            background-color: #d84343;
        }

        .logout {
            text-decoration: none;
            color: #007bff;
            font-weight: bold;
            padding: 8px 15px;
            border: 2px solid #007bff;
            border-radius: 5px;
            transition: background-color 0.3s ease, color 0.3s ease;
            background-color: white;
            position: absolute;
            top: 20px;
            right: 20px;
        }

        .logout:hover {
            background-color: #007bff;
            color: white;
        }

        .sidebar {
            width: 250px;
            background-color: #007bff;
            color: white;
            display: flex;
            flex-direction: column;
            padding: 20px 0;
            height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            font-family: 'Arial', sans-serif;
        }

        .sidebar a {
            text-decoration: none;
            color: white;
            padding: 15px 20px;
            font-size: 1.2rem;
            font-weight: bold;
            display: block;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }

        .sidebar a:hover {
            background-color: #0056b3;
            transform: translateX(10px);
        }

        .sidebar h2 {
            text-align: center;
            margin-bottom: 30px;
            font-weight: bold;
            font-size: 1.5rem;
        }

        .product-img {
            max-height: 500px;
            object-fit: cover;
            border-radius: 10px;
        }

        .content {
            font-size: 1.2rem;
            line-height: 1.6;
        }
    </style>
</head>
<body>
    <div class="sidebar">
        <h2>Navigation</h2>
        <a href="adminDashboard.jsp">Dashboard</a>
        <a href="productlist.jsp">Produits</a>
        <a href="commandes.jsp">Commandes</a>
        <a href="user_list.jsp">Utilisateurs</a>
    </div>

    <a href="LogoutServlet" class="logout">Se Déconnecter</a>

    <div class="container d-flex align-items-center justify-content-center min-vh-100 py-5">
        <div class="row align-items-center w-100" style="max-width: 900px;">
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

                            String fullImagePath = request.getContextPath() + "/" + image;
            %>
            <!-- Product Details -->
            <div class="col-md-6">
                <img
                    src="<%= fullImagePath %>"
                    alt="<%= name %>"
                    class="product-img w-100 h-auto"
                />
            </div>
            <div class="col-md-6 content">
                <h2 class="mb-4"><%= name %></h2>
                <p><strong>Description :</strong> <%= description %></p>
                <p><strong>Prix :</strong> <%= String.format("%.2f", price) %> €</p>
                <p><strong>Stock :</strong> <%= stock %> unités</p>
                <p><strong>Catégorie :</strong> <%= category %></p>

                <% if (isEditing) { %>
                <!-- Edit Form -->
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
                <!-- Buttons for Modify and Delete -->
                <div class="mt-4">
                    <a href="product_detail.jsp?id=<%= productId %>&edit=true" class="btn btn-modern btn-edit btn-custom">
                        <i class="fas fa-edit"></i> Modifier
                    </a>
                    <a href="SupprimerProduitServlet?id=<%= productId %>" class="btn btn-modern btn-delete btn-custom" onclick="return confirm('Êtes-vous sûr de vouloir supprimer ce produit ?')">
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
