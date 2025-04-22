/**
 * Admin Dashboard JavaScript functionality
 */

// Handle sidebar active state if not handled by JSP
document.addEventListener('DOMContentLoaded', function() {
    // Get the current URL path
    const path = window.location.pathname;
    
    // Find all sidebar links
    const sidebarLinks = document.querySelectorAll('.sidebar-menu a');
    
    // Loop through each link and check if its href matches the current path
    sidebarLinks.forEach(link => {
        const href = link.getAttribute('href');
        if (path.includes(href) && !link.classList.contains('active')) {
            // Remove any existing active classes
            sidebarLinks.forEach(l => l.classList.remove('active'));
            // Add active class to the current link
            link.classList.add('active');
        }
    });
}); 