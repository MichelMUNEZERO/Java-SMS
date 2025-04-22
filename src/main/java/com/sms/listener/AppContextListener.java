package com.sms.listener;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

import com.mysql.cj.jdbc.AbandonedConnectionCleanupThread;

/**
 * Application lifecycle listener implementation
 * Handles cleanup of resources when the application is stopped
 */
@WebListener
public class AppContextListener implements ServletContextListener {

    /**
     * @see ServletContextListener#contextInitialized(ServletContextEvent)
     */
    public void contextInitialized(ServletContextEvent sce) {
        // Application startup
        sce.getServletContext().log("School Management System is starting up");
    }

    /**
     * @see ServletContextListener#contextDestroyed(ServletContextEvent)
     */
    public void contextDestroyed(ServletContextEvent sce) {
        // Application shutdown - clean up resources
        sce.getServletContext().log("School Management System is shutting down - cleaning up resources");
        
        try {
            // Explicitly deregister MySQL driver to prevent memory leaks
            AbandonedConnectionCleanupThread.checkedShutdown();
        } catch (Exception e) {
            sce.getServletContext().log("Error during MySQL driver cleanup", e);
        }
    }
} 