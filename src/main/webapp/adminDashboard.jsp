<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Dashboard Administrateur</title>
    <style>
        /* General Styles */
        body {
            font-family: 'Roboto', Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f8f9fa;
            color: #333;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        /* Header */
        header {
            background-color: #007bff;
            color: white;
            padding: 20px 40px; /* Space for wider nav */
            position: fixed;
            top: 0;
            width: 100%;
            height: 100px; /* Fixed height for easier alignment */
            display: flex;
            align-items: center;
            justify-content: center; /* Centers "Dashboard Administrateur" */
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        header h1 {
            margin: 0;
            font-size: 1.8rem;
            position: absolute; /* Allows absolute centering */
            left: 50%; /* Start positioning at the middle of the header */
            transform: translate(-50%, 0); /* Center horizontally */
        }

        header .logout {
            text-decoration: none;
            color: white;
            font-weight: bold;
            padding: 8px 15px;
            border-radius: 5px;
            border: 1px solid white;
            position: absolute;
            right: 20px; /* Moves it slightly inward from the right */
            transition: background-color 0.3s ease, color 0.3s ease;
            right: 80px; 
        }

        header .logout:hover {
            background-color: white;
            color: #007bff;
        }

        /* Dashboard Content */
        .dashboard {
            margin-top: 150px; /* To account for the fixed header */
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            max-width: 1000px;
            width: 90%;
            text-align: center;
        }

        .dashboard a {
            text-decoration: none;
            color: #333;
        }

        /* Card Styles */
        .dashboard .card {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 20px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .dashboard .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.2);
        }

        .dashboard .card h2 {
            font-size: 1.3rem;
            margin: 0 0 10px;
            color: #007bff;
        }

        .dashboard .card p {
            font-size: 0.95rem;
            color: #555;
        }

        /* Footer */
        footer {
            background-color: #333;
            color: white;
            text-align: center;
            padding: 10px 0;
            margin-top: 20px;
            font-size: 0.9rem;
        }

    </style>
</head>
<body>
    <header>
        <h1>Dashboard Administrateur</h1>
        <a href="logout" class="logout">Se Déconnecter</a>
    </header>
    <div class="dashboard">
        <a href="productlist.jsp">
            <div class="card">
                <h2>Gestion des Produits</h2>
                <p>Ajoutez, modifiez ou supprimez des produits facilement.</p>
            </div>
        </a>
        <a href="commandes.jsp">
            <div class="card">
                <h2>Gestion des Commandes</h2>
                <p>Suivez et gérez toutes les commandes de vos clients.</p>
            </div>
        </a>
        <a href="user_list.jsp">
            <div class="card">
                <h2>Gestion des Utilisateurs</h2>
                <p>Visualisez et administrez les comptes utilisateurs.</p>
            </div>
        </a>
    </div>
</body>
</html>
