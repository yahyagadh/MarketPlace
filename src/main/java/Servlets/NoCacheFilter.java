package Servlets;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.*;

@WebFilter("/*") // Appliquer ce filtre à toutes les pages du site
public class NoCacheFilter implements Filter {

    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialisation du filtre (si nécessaire)
    }

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // Ajouter les en-têtes pour éviter la mise en cache des pages
        httpResponse.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        httpResponse.setHeader("Pragma", "no-cache");
        httpResponse.setDateHeader("Expires", 0);

        // Continuer le traitement de la requête
        chain.doFilter(request, response);
    }

    public void destroy() {
        // Libération des ressources (si nécessaire)
    }
}
