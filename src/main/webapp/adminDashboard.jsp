<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Administrateur</title>
    <style>
        /* General Styles */
        body {
            font-family: 'Roboto', Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f5f7;
            color: #333;
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
        /* Logout Button */
        .logout {
            position: absolute;
            top: 10px;
            right: 10px;
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

        /* Main Content */
        .main-content {
            margin-left: 250px;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh; /* Full viewport height for centering */
        }

        .cards-container {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px; /* Space between cards */
            justify-items: center;
        }

        .main-content .card {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            padding: 40px;
            text-align: center;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            display: flex;
            flex-direction: column;
            align-items: center;
            width: 300px;
            height: 200px;
        }

        .main-content .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.2);
        }

        .main-content .card h2 {
            font-size: 1.6rem;
            margin-bottom: 20px;
            color: #007bff;
        }

        .main-content .card p {
            font-size: 2rem;
            font-weight: bold;
            color: #333;
        }

        .main-content .card img {
            width: 60px;
            height: 60px;
            margin-bottom: 20px;
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

    <div class="main-content">
        <div class="cards-container">
            <%
                // Database Connection Parameters
                String dbURL = "jdbc:postgresql://localhost:5432/ecommerce";
                String dbUser = "postgres";
                String dbPassword = "123456";

                // Query Variables
                int userCount = 0;
                int productCount = 0;
                int pendingOrderCount = 0;
                int deliveredOrderCount = 0;

                try {
                    // Establish Connection
                    Class.forName("org.postgresql.Driver");
                    Connection connection = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                    // Query to Count Users
                    Statement stmt = connection.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM public.utilisateurs");
                    if (rs.next()) {
                        userCount = rs.getInt(1);
                    }

                    // Query to Count Products
                    rs = stmt.executeQuery("SELECT COUNT(*) FROM public.products");
                    if (rs.next()) {
                        productCount = rs.getInt(1);
                    }

                    // Query to Count Pending Orders
                    rs = stmt.executeQuery("SELECT COUNT(*) FROM public.orders WHERE statut = 'en cours'");
                    if (rs.next()) {
                        pendingOrderCount = rs.getInt(1);
                    }

                    // Query to Count Delivered Orders
                    rs = stmt.executeQuery("SELECT COUNT(*) FROM public.orders WHERE statut = 'livré'");
                    if (rs.next()) {
                        deliveredOrderCount = rs.getInt(1);
                    }

                    connection.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            %>
            <!-- Cards -->
            <div class="card">
                <h2>Nombre d'Utilisateurs</h2>
                <p><%= userCount %></p>
            </div>
            <div class="card">
                <h2>Nombre de Produits</h2>
                <p><%= productCount %></p>
            </div>
            <div class="card">
                <h2>Commandes en Attente</h2>
                <p><%= pendingOrderCount %></p>
            </div>
            <div class="card">
                <h2>Commandes Livrées</h2>
                <p><%= deliveredOrderCount %></p>
            </div>
        </div>
    </div>
</body>
</html>
