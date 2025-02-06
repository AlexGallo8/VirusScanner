document.addEventListener('DOMContentLoaded', function() {
  const handleConfirm = function(element) {
    if (!confirm('Sei sicuro di voler eliminare questo commento?')) {
      event.preventDefault();
    }
  };

  document.querySelectorAll('[data-custom-confirm]').forEach(element => {
    element.addEventListener('click', function(event) {
      event.preventDefault();
      handleConfirm(this);
      if (!event.defaultPrevented) {
        this.closest('form').submit();
      }
    });
  });
});
