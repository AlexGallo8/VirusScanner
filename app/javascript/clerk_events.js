document.addEventListener('DOMContentLoaded', () => {
    if (window.Clerk) {
      Clerk.addListener('user', (user) => {
        if (user) {
          // Utente autenticato
          const userButton = document.getElementById('user-button');
          const loginButtons = document.querySelector('.login-buttons');
          
          if (userButton) userButton.style.display = 'block';
          if (loginButtons) loginButtons.style.display = 'none';
        } else {
          // Utente non autenticato
          const userButton = document.getElementById('user-button');
          const loginButtons = document.querySelector('.login-buttons');
          
          if (userButton) userButton.style.display = 'none';
          if (loginButtons) loginButtons.style.display = 'block';
        }
      });
    }
  });