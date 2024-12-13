package Servlets;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.util.*;

@WebServlet("/RetirerDuPanierServlet")
public class RetirerDuPanierServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Récupérer l'ID du produit depuis la requête
        String productId = request.getParameter("id");
        System.out.println("Tentative de suppression du produit avec l'ID : " + productId);

        // Récupérer le panier depuis la session
        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<String[]> panier = (List<String[]>) session.getAttribute("panier");

        // Vérifier si le panier n'est pas nul et que productId est valide
        if (panier != null && productId != null) {
            boolean removed = false;

            // Vérifier si le panier contient un seul produit
            if (panier.size() == 1) {
                // Si le panier contient un seul produit, on le vide complètement
                panier.clear();
                removed = true;
                System.out.println("Panier vidé, un seul produit dans le panier.");
            } else {
                // Sinon, procéder à la suppression du produit spécifié
                System.out.println("Panier actuel : " + panier);

                for (int i = 0; i < panier.size(); i++) {
                    String[] produit = panier.get(i);
                    String cartProductId = produit[0];  // Supposons que le premier élément est l'ID du produit
                    System.out.println("Vérification du produit avec l'ID : " + cartProductId);

                    if (cartProductId.equals(productId)) {
                        // Si le produit correspond, on le retire du panier
                        panier.remove(i);
                        removed = true;
                        System.out.println("Produit supprimé : " + productId);
                        break;
                    }
                }
            }

            // Si un produit a été retiré, on met à jour la session
            if (removed) {
                session.setAttribute("panier", panier);  // Met à jour le panier dans la session
                System.out.println("Panier mis à jour après suppression.");
            } else {
                System.out.println("Produit avec l'ID " + productId + " non trouvé dans le panier.");
            }
        } else {
            System.out.println("ID produit invalide ou panier est nul.");
        }

        // Rediriger vers la page du panier après la suppression du produit
        response.sendRedirect("panier.jsp");
    }
}
