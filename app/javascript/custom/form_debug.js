document.addEventListener('DOMContentLoaded', function() {
  const form = document.querySelector('.card-form');
  
  if (!form) {
    return;
  }

  form.addEventListener('submit', function(e) {
    console.log('Form submitted');
    
    // Log form data
    const formData = new FormData(form);
    for (let pair of formData.entries()) {
      console.log(pair[0] + ': ' + pair[1]);
    }
  });

  // Format price input
  const priceInput = form.querySelector('.price-input');
  if (priceInput) {
    priceInput.addEventListener('blur', function() {
      if (this.value) {
        this.value = parseFloat(this.value).toFixed(2);
      }
    });
  }
}); 