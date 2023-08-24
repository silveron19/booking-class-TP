menuItems.forEach(function(menuItem) {
      menuItem.addEventListener('click', function() {
        var popupMenu = document.querySelector('.popup-menu');
        var hamburgerIcon = document.querySelector('.hamburger-icon');
    
        popupMenu.classList.remove('active');
        hamburgerIcon.classList.remove('close');
        document.removeEventListener('click', closeMenuOutside);
      });
    });

    function enableProfilePictureUpload() {
      const profilePictureInput = document.getElementById('profile-picture');
      const profileImage = document.getElementById('profile-image');
  
      profilePictureInput.addEventListener('change', function (event) {
          const file = event.target.files[0];
  
          if (file) {
              const reader = new FileReader();
              reader.addEventListener('load', function () {
                  profileImage.src = reader.result;
              });
              reader.readAsDataURL(file);
          }
      });
  }
  
  document.addEventListener('DOMContentLoaded', enableProfilePictureUpload);
  
  