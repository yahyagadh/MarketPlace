<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Liste des produits</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
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

        .logout {
            text-decoration: none;
            color: #007bff;
            font-weight: bold;
            padding: 8px 15px;
            border: 2px solid #007bff;
            border-radius: 5px;
            transition: background-color 0.3s ease, color 0.3s ease;
            background-color: white;
        }

        .logout:hover {
            background-color: #007bff;
            color: white;
        }

        body {
            background-color: #f8f9fa;
            font-family: 'Arial', sans-serif;
        }

        .card {
            height: 400px;
            width: 300px;
            border-radius: 15px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .card:hover {
            transform: scale(1.05);
            box-shadow: 0 15px 20px rgba(0, 0, 0, 0.3);
            background-color: #f4f6f8;
        }

        .card-img-top {
            height: 250px;
            object-fit: cover;
            border-top-left-radius: 15px;
            border-top-right-radius: 15px;
            transition: transform 0.3s ease;
        }

        .card:hover .card-img-top {
            transform: scale(1.1);
        }

        .product-container {
            margin-top: 30px;
        }

        .btn-custom {
            width: 48%;
            font-size: 0.9rem;
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

        .top-buttons {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-bottom: 20px;
        }

        .products-wrapper {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            margin-left: 270px;
            margin-top: 40px;
            justify-content: center;
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

    <div class="container product-container">
        <div class="top-buttons">
            <a href="add_product.jsp" class="logout">Ajouter un nouveau produit</a>
            <a href="LogoutServlet" class="logout">Se Déconnecter</a>
        </div>

        <div class="products-wrapper">
            <%
                String url = "jdbc:postgresql://localhost:5432/ecommerce";
                String username = "postgres";
                String password = "123456";

                try {
                    Class.forName("org.postgresql.Driver"); 
                    Connection conn = DriverManager.getConnection(url, username, password);

                    String sql = "SELECT id, nom, prix, image FROM public.products";
                    PreparedStatement ps = conn.prepareStatement(sql);
                    ResultSet rs = ps.executeQuery();

                    while (rs.next()) {
                        int productId = rs.getInt("id");
                        String name = rs.getString("nom");
                        double price = rs.getDouble("prix");
                        String imagePath = rs.getString("image");

                        String fullImagePath = request.getContextPath() + "/" + imagePath;
            %>
            <div>
                <div class="card shadow-sm">
                    <a href="product_detail.jsp?id=<%= productId %>" class="text-decoration-none">
                        <img src="<%= fullImagePath %>" class="card-img-top" alt="<%= name %>">
                        <div class="card-body text-center">
                            <h5 class="card-title text-dark"><%= name %></h5>
                            <h6 class="card-text text-primary"><%= String.format("%.2f", price) %> €</h6>
                        </div>
                    </a>
                    <div class="d-flex justify-content-between p-3">
                        <a href="product_detail.jsp?id=<%= productId %>" class="btn btn-modern btn-edit btn-custom">Modifier</a>
                        <a href="SupprimerProduitServlet?action=delete&id=<%= productId %>" class="btn btn-modern btn-delete btn-custom" onclick="return confirm('Êtes-vous sûr de vouloir supprimer ce produit ?')">Supprimer</a>
                    </div>
                </div>
            </div>
            <%
                    }
                    rs.close();
                    ps.close();
                } catch (SQLException | ClassNotFoundException e) {
                    e.printStackTrace();
                    out.print("Erreur de connexion à la base de données.");
                }
            %>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
