package Servlets;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;

@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Récupérer la session actuelle
        HttpSession session = request.getSession(false);  // false pour ne pas créer une nouvelle session si elle n'existe pas

        if (session != null) {
            // Invalider la session existante pour supprimer tous les attributs et les informations de l'utilisateur
            session.invalidate();
        }

        // Rediriger l'utilisateur vers la page de connexion
        response.sendRedirect("Connexion.jsp");
    }
}
