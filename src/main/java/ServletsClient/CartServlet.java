package ServletsClient;


import jakarta.servlet.ServletException;


import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import Models.Product;
import Models.Utilisateur;
import DAO.ProductDAO;
import DAO.OrderDAO;

import util.DataBaseHelper;

import java.io.IOException;
import java.sql.Connection;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private ProductDAO productDAO;
    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        try {
            Connection connection = DataBaseHelper.getConnection();
            productDAO = new ProductDAO(connection);
            orderDAO = new OrderDAO(connection);
        } catch (Exception e) {
            throw new ServletException("Failed to initialize CartServlet", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("addToCart".equals(action)) {
            addToCart(request, response);
        } else if ("placeOrder".equals(action)) {
            placeOrder(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("viewCart".equals(action)) {
            viewCart(request, response);
        } else if ("removeFromCart".equals(action)) {
            removeFromCart(request, response);
        }
    }

    private void addToCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        
        // Get the cart from session or create a new one if it doesn't exist
        @SuppressWarnings("unchecked")
		Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
        if (cart == null) {
            cart = new HashMap<>();
            session.setAttribute("cart", cart);  // Set the cart in session if it's a new cart
        }

        // Retrieve the product ID and quantity from the request
        String productIdStr = request.getParameter("productId");
        String quantityStr = request.getParameter("quantity");

        if (productIdStr == null || quantityStr == null || productIdStr.isEmpty() || quantityStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Product ID or quantity is missing.");
            return;
        }

        int productId = Integer.parseInt(productIdStr);
        int quantity = Integer.parseInt(quantityStr);

        // Add the product to the cart, incrementing quantity if the product already exists
        cart.put(productId, cart.getOrDefault(productId, 0) + quantity);

        // Redirect to the cart page to view updated cart
        response.sendRedirect("CartServlet?action=viewCart");
    }



    private void viewCart(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        @SuppressWarnings("unchecked")
        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
        
        Map<Product, Integer> cartDetails = new HashMap<>();
        double totalAmount = 0.0;
        
        if (cart != null) {
            // Retrieve product details for each item in the cart
            for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
                int productId = entry.getKey();
                int quantity = entry.getValue();

                try {
                    // Retrieve the product details from the database using productDAO
                    Product product = productDAO.getProductById(productId);
                    cartDetails.put(product, quantity);
                    
                    // Calculate total amount
                    double productPrice = product.getPrix();  // Assuming 'getPrix()' gives product price
                    totalAmount += productPrice * quantity;
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }

        // Set the cart and total amount as attributes for the JSP
        request.setAttribute("cartDetails", cartDetails);
        request.setAttribute("totalAmount", totalAmount);

        // Forward to the cart.jsp page
        request.getRequestDispatcher("cart.jsp").forward(request, response);
    }

       

    private void removeFromCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");

        if (cart != null) {
            int productId = Integer.parseInt(request.getParameter("productId"));
            cart.remove(productId);
        }

        response.sendRedirect("CartServlet?action=viewCart");
    }

    private void placeOrder(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            request.setAttribute("error", "Votre panier est vide.");
            request.getRequestDispatcher("cart.jsp").forward(request, response);
            return;
        }

        Utilisateur user = (Utilisateur) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            // Save the order
            int orderId = orderDAO.createOrder(user.getId(), cart);

            // Clear the cart
            session.removeAttribute("cart");

            // Redirect to the confirmation page
            response.sendRedirect("OrderServlet?action=confirmation&orderId=" + orderId);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Une erreur s'est produite lors du passage de la commande.");
            request.getRequestDispatcher("cart.jsp").forward(request, response);
        }
    }
    
    
}


