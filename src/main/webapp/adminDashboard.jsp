<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Dashboard Administrateur</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
        }
        header {
            background-color: #333;
            color: white;
            padding: 10px;
            text-align: center;
        }
        nav {
            margin: 20px auto;
            text-align: center;
        }
        nav a {
            margin: 0 15px;
            text-decoration: none;
            color: #333;
            font-weight: bold;
        }
        nav a:hover {
            color: #007bff;
        }
        .content {
            margin: 20px;
            text-align: center;
        }
    </style>
</head>
<body>
    <header>
        <h1>Dashboard Administrateur</h1>
    </header>
    <nav>
        <a href="productlist.jsp">Gestion des Produits</a>
        <a href="commandes.jsp">Gestion des Commandes</a>
        <a href="user_list.jsp">Gestion des Utilisateurs</a>
        <a href="logout">Se déconnecter</a>
    </nav>
    <div class="content">
        <h2>Bienvenue, Administrateur</h2>
        <p>Utilisez les liens ci-dessus pour accéder aux différentes fonctionnalités de gestion.</p>
    </div>
</body>
</html>
