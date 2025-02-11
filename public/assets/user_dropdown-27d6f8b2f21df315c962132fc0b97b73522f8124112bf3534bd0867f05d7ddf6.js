document.addEventListener('DOMContentLoaded', () => {
    const userMenuButton = document.getElementById("user-menu-button");
    const userDropdown = document.getElementById("user-dropdown");
  
    if (userMenuButton && userDropdown) {
      // Toggle dropdown visibility on button click
      userMenuButton.addEventListener('click', (e) => {
        e.stopPropagation(); // Prevent this click from triggering the document click listener
        userDropdown.classList.toggle('hidden');
      });
  
      // Close dropdown when clicking outside and not on the button
      document.addEventListener('click', (e) => {
        if (!userMenuButton.contains(e.target)) {
          userDropdown.classList.add('hidden');
        }
      });
  
      // Prevent dropdown from closing when clicking inside it
      userDropdown.addEventListener('click', (e) => {
        e.stopPropagation();
      });
    }
  });
