// app/assets/javascripts/mobile_navigation.js

document.addEventListener('DOMContentLoaded', function() {
    // Mobile menu elements
    const mobileMenuButton = document.getElementById('mobile-menu-button');
    const mobileMenu = document.getElementById('mobile-menu');
    const mobileMenuOverlay = document.getElementById('mobile-menu-overlay');
    const body = document.body;
    
    // Check if elements exist
    if (!mobileMenuButton || !mobileMenu || !mobileMenuOverlay) {
      console.warn('Mobile menu elements not found');
      return;
    }
    
    // State management
    let isMenuOpen = false;
    
    // Functions to manage menu state
    function openMobileMenu() {
      isMenuOpen = true;
      mobileMenu.classList.add('active');
      mobileMenuOverlay.classList.add('active');
      mobileMenuButton.classList.add('active');
      body.classList.add('mobile-menu-open');
      
      // Change icon to X
      const icon = mobileMenuButton.querySelector('i');
      if (icon) {
        icon.classList.remove('fa-bars');
        icon.classList.add('fa-times');
      }
      
      // Prevent background scrolling
      body.style.overflow = 'hidden';
    }
    
    function closeMobileMenu() {
      isMenuOpen = false;
      mobileMenu.classList.remove('active');
      mobileMenuOverlay.classList.remove('active');
      mobileMenuButton.classList.remove('active');
      body.classList.remove('mobile-menu-open');
      
      // Change icon back to hamburger
      const icon = mobileMenuButton.querySelector('i');
      if (icon) {
        icon.classList.remove('fa-times');
        icon.classList.add('fa-bars');
      }
      
      // Restore background scrolling
      body.style.overflow = '';
    }
    
    function toggleMobileMenu() {
      if (isMenuOpen) {
        closeMobileMenu();
      } else {
        openMobileMenu();
      }
    }
    
    // Event listeners
    
    // Toggle menu when button is clicked
    mobileMenuButton.addEventListener('click', function(e) {
      e.preventDefault();
      e.stopPropagation();
      toggleMobileMenu();
    });
    
    // Close menu when overlay is clicked
    mobileMenuOverlay.addEventListener('click', function(e) {
      e.preventDefault();
      e.stopPropagation();
      closeMobileMenu();
    });
    
    // Close menu when menu links are clicked (except buttons)
    const menuLinks = mobileMenu.querySelectorAll('a:not(.mobile-logout-button)');
    menuLinks.forEach(link => {
      link.addEventListener('click', function(e) {
        // Allow the link to work, but close the menu
        closeMobileMenu();
      });
    });
    
    // Handle form submissions in mobile menu (like logout)
    const menuForms = mobileMenu.querySelectorAll('form');
    menuForms.forEach(form => {
      form.addEventListener('submit', function(e) {
        // Allow the form to submit, but close the menu
        closeMobileMenu();
      });
    });
    
    // Close menu when clicking outside (only on mobile)
    document.addEventListener('click', function(e) {
      // Only handle on mobile screens
      if (window.innerWidth >= 768) return;
      
      const isClickInsideMenu = mobileMenu.contains(e.target);
      const isClickOnButton = mobileMenuButton.contains(e.target);
      const isClickOnOverlay = mobileMenuOverlay.contains(e.target);
      
      // Close menu if clicking outside menu area
      if (isMenuOpen && !isClickInsideMenu && !isClickOnButton && !isClickOnOverlay) {
        closeMobileMenu();
      }
    });
    
    // Close menu on escape key
    document.addEventListener('keydown', function(e) {
      if (e.key === 'Escape' && isMenuOpen) {
        closeMobileMenu();
      }
    });
    
    // Handle window resize
    window.addEventListener('resize', function() {
      // Close mobile menu if window is resized to desktop
      if (window.innerWidth >= 768 && isMenuOpen) {
        closeMobileMenu();
      }
    });
    
    // Handle orientation change on mobile devices
    window.addEventListener('orientationchange', function() {
      if (isMenuOpen) {
        // Close menu on orientation change to prevent layout issues
        closeMobileMenu();
      }
    });
    
    // Prevent menu from interfering with desktop dropdowns
    const desktopDropdowns = document.querySelectorAll('.group');
    desktopDropdowns.forEach(dropdown => {
      dropdown.addEventListener('mouseenter', function() {
        // Only close mobile menu if on desktop
        if (window.innerWidth >= 768 && isMenuOpen) {
          closeMobileMenu();
        }
      });
    });
  });
  
  // Function to scroll to menu section (for menu link)
  function scrollToMenu(event) {
    // Check if we are on the categories page (root page)
    if (window.location.pathname === '/' || window.location.pathname === '/categories') {
      event.preventDefault();
      
      // Look for menu section - could be categories grid or menu items
      const menuSection = document.querySelector('#menu-section') || 
                         document.querySelector('.categories-grid') || 
                         document.querySelector('[data-menu-section]') ||
                         document.querySelector('main');
      
      if (menuSection) {
        menuSection.scrollIntoView({ 
          behavior: 'smooth',
          block: 'start'
        });
      }
    }
    // If not on categories page, let the link work normally to navigate there
  }