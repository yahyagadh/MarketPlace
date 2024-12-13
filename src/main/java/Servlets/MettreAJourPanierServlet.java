package Servlets;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.util.*;

@WebServlet("/MettreAJourPanierServlet")
public class MettreAJourPanierServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Récupérer le panier depuis la session
        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
		List<String[]> panier = (List<String[]>) session.getAttribute("panier");

        if (panier != null && !panier.isEmpty()) {
            // Parcourir chaque produit du panier
            for (String[] produit : panier) {
                String productId = produit[0];  // L'ID du produit
                String quantiteParam = request.getParameter("quantite_" + productId);  // Récupérer la nouvelle quantité

                if (quantiteParam != null) {
                    try {
                        // Convertir la quantité en entier
                        int newQuantity = Integer.parseInt(quantiteParam);

                        // Mettre à jour la quantité du produit dans le panier
                        produit[3] = String.valueOf(newQuantity);
                    } catch (NumberFormatException e) {
                        // En cas d'erreur de format, afficher un message d'erreur (optionnel)
                        e.printStackTrace();
                        response.sendRedirect("errorPage.jsp");
                        return;
                    }
                }
            }

            // Mettre à jour le panier dans la session
            session.setAttribute("panier", panier);
        }

        // Rediriger vers la page du panier après la mise à jour
        response.sendRedirect("panier.jsp");
    }
}