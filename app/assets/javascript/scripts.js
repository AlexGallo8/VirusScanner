document.addEventListener('DOMContentLoaded', () => {
    const mobileMenuButton = document.getElementById('mobile-menu-button');
    const mobileMenu = document.getElementById('mobile-menu');

    mobileMenuButton.addEventListener('click', () => {
        mobileMenu.classList.toggle('hidden');
        mobileMenu.classList.toggle('animate-slide-down');
    });
});

document.addEventListener('DOMContentLoaded', () => {
    // Gestori per entrambi i pulsanti modali
    ['registration', 'session'].forEach(modalType => {
        const modal = document.getElementById(`${modalType}-modal`);
        const openButton = document.getElementById(`open-${modalType}-modal`);
        const closeButton = document.getElementById(`close-${modalType}-modal`);
        const backdrop = modal.querySelector('.modal-backdrop');

        function openModal() {
        modal.classList.remove('hidden');
        document.body.style.overflow = 'hidden';
        }

        function closeModal() {
        modal.classList.add('hidden');
        document.body.style.overflow = 'auto';
        }

        openButton.addEventListener('click', openModal);
        closeButton.addEventListener('click', closeModal);
        backdrop.addEventListener('click', closeModal);

        // Previene la chiusura quando si clicca sul contenuto del modal
        modal.querySelector('.modal-content').addEventListener('click', e => {
        e.stopPropagation();
        });
    });

// Gestisce la chiusura con il tasto ESC per entrambi i modali
    document.addEventListener('keydown', e => {
        if (e.key === 'Escape') {
            ['registration', 'session'].forEach(modalType => {
                const modal = document.getElementById(`${modalType}-modal`);
                if (!modal.classList.contains('hidden')) {
                modal.classList.add('hidden');
                document.body.style.overflow = 'auto';
                }
            });
        }
    });
});

// Dropdown Menu
document.addEventListener('DOMContentLoaded', () => {
    const userMenuButton = document.getElementById('user-menu-button');
    const userDropdown = document.getElementById('user-dropdown');
  
    if (userMenuButton && userDropdown) {
      userMenuButton.addEventListener('click', () => {
        userDropdown.classList.toggle('hidden');
      });
  
      document.addEventListener('click', (e) => {
        if (!userDropdown.contains(e.target) && e.target !== userMenuButton) {
          userDropdown.classList.add('hidden');
        }
      });
    }
});
  
// Drive Picker
function openDrivePicker() {
  fetch('/virus_total/pick_from_drive', {
    headers: {
      'Accept': 'text/html',
      'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
    }
  })
  .then(response => response.text())
  .then(html => {
    document.body.insertAdjacentHTML('beforeend', html);
  });
}

function selectDriveFile(fileId, fileName) {
  fetch('/virus_total/download_from_drive', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
    },
    body: JSON.stringify({ file_id: fileId, file_name: fileName })
  })
  .then(response => response.json())
  .then(result => {
    // Handle scan result
    closeDriveModal();
    updateScanResults(result);
  });
}

function closeDriveModal() {
  document.getElementById('drive-modal').remove();
}

function updateScanResults(result) {
  // Update your UI with scan results
  // This should match your existing scan result display logic
}

// Add this JavaScript code to handle the form submission
document.addEventListener('DOMContentLoaded', function() {
  // Function to handle form submission
  function handleFormSubmit(formElement) {
    formElement.addEventListener('submit', function(e) {
      e.preventDefault();
      
      const formData = new FormData(formElement);
      
      fetch(formElement.action, {
        method: 'POST',
        body: formData,
        headers: {
          'Accept': 'application/json'
        }
      })
      .then(response => response.json())
      .then(data => {
        // Remove any existing error messages
        const existingErrors = formElement.querySelector('.error-messages');
        if (existingErrors) {
          existingErrors.remove();
        }
        
        if (data.success) {
          // Redirect on success
          window.location.href = data.redirect_to;
        } else {
          // Display errors
          const errorDiv = document.createElement('div');
          errorDiv.className = 'error-messages bg-red-50 border-l-4 border-red-500 text-red-700 p-4 mb-6 rounded';
          errorDiv.setAttribute('role', 'alert');
          
          data.errors.forEach(message => {
            const p = document.createElement('p');
            p.className = 'text-sm font-medium';
            p.textContent = message;
            errorDiv.appendChild(p);
          });
          
          formElement.insertBefore(errorDiv, formElement.firstChild);
        }
      })
      .catch(error => {
        console.error('Error:', error);
      });
    });
  }

  // Initialize form handlers
  const forms = ['registration_form', 'session_form'];
  forms.forEach(formId => {
    const form = document.getElementById(formId);
    if (form) {
      handleFormSubmit(form);
    }
  });
});