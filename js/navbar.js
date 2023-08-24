function handleMenuClick() {
    const menuItems = document.querySelectorAll('.menu ul li');
    menuItems.forEach(item => {
      item.addEventListener('click', function() {
    
        menuItems.forEach(item => {
          item.classList.remove('active');
        });
    
        this.classList.add('active');
      });
    });
    }
    
    function showNotificationPopup() {
      var notificationPopup = document.getElementById('notificationPopup');
      notificationPopup.classList.toggle('show');
    
    }
    
    function hideNotificationPopup() {
      var notificationPopup = document.getElementById('notificationPopup');
      notificationPopup.classList.remove('show');
    }
    
    function toggleNotificationPopup() {
      var notificationPopup = document.getElementById('notificationPopup');
      notificationPopup.classList.toggle('show');
    }
    
    window.addEventListener('mousedown', function (event) {
      var notificationPopup = document.getElementById('notificationPopup');
      if (!notificationPopup.contains(event.target) && !event.target.matches('.notification-icon img')) {
        hideNotificationPopup();
      }
    });
    
    function showmenuPopup(element) {
      var popup = element.querySelector('.menu-popup');
      var isPopupVisible = popup.style.display === 'block';
    
      if (isPopupVisible) {
        popup.style.display = 'none';
      } else {
        popup.style.display = 'block';
        document.addEventListener('click', closePopupOutside);
      }
    
      function closePopupOutside(event) {
        var target = event.target;
        var isInsidePopup = popup.contains(target) || target === element || element.contains(target);
    
        if (!isInsidePopup) {
          popup.style.display = 'none';
          document.removeEventListener('click', closePopupOutside);
        }
      }
    }
    
    function toggleMenu() {
      var popupMenu = document.querySelector('.popup-menu');
      var hamburgerIcon = document.querySelector('.hamburger-icon');
      
    
    
      popupMenu.classList.toggle('active');
      hamburgerIcon.classList.toggle('close');
    
      if (popupMenu.classList.contains('active')) {
        document.addEventListener('click', closeMenuOutside);
      } else {
        document.removeEventListener('click', closeMenuOutside);
      }
    
      function closeMenuOutside(event) {
        var target = event.target;
        var isInsideMenu = popupMenu.contains(target) || target === hamburgerIcon;
    
        if (!isInsideMenu) {
          popupMenu.classList.remove('active');
          hamburgerIcon.classList.remove('close');
          document.removeEventListener('click', closeMenuOutside);
        }
      }
    }
    
    function closePopup() {
      var popupMenu = document.querySelector('.popup-menu');
      var menuOverlay = document.querySelector('.menu-overlay');
      var hamburgerIcon = document.querySelector('.hamburger-icon');
      var clickedMenuItem = document.querySelector('.popup-menu li a.clicked');
    
      popupMenu.classList.remove('active');
      hamburgerIcon.classList.toggle('close');
    
      if (clickedMenuItem) {
        clickedMenuItem.classList.remove('clicked');
      }
    }
    
    
    document.addEventListener('DOMContentLoaded', function() {
      var menuItems = document.querySelectorAll('.popup-menu li a');
      var clickedMenuItem = null;
    
      for (var i = 0; i < menuItems.length; i++) {
        menuItems[i].addEventListener('click', function() {
          if (clickedMenuItem) {
            clickedMenuItem.style.color = '';
          }
    
          this.style.color = '#cccccc';
          clickedMenuItem = this;
    
          closePopup();
        });
      }
    });
    
    menuItems.forEach(function(menuItem) {
      menuItem.addEventListener('click', function() {
        var popupMenu = document.querySelector('.popup-menu');
        var hamburgerIcon = document.querySelector('.hamburger-icon');
    
        popupMenu.classList.remove('active');
        hamburgerIcon.classList.remove('close');
        document.removeEventListener('click', closeMenuOutside);
      });
    });