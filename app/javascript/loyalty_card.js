// Add punch animation
document.addEventListener('turbo:load', () => {
    const punchSquares = document.querySelectorAll('.punch-square');
    
    punchSquares.forEach(square => {
      square.addEventListener('click', function() {
        if (this.classList.contains('punched')) {
          this.style.animation = 'punchAnimation 0.5s ease-out';
          setTimeout(() => {
            this.style.animation = '';
          }, 500);
        }
      });
    });
    
    // Show celebration if card was just completed
    const statusElement = document.getElementById('cardStatus');
    if (statusElement && statusElement.classList.contains('status-completed')) {
      setTimeout(() => {
        alert('🎉 Congratulations! Your loyalty card is complete! You can now redeem your $8 reward!');
      }, 1000);
    }
  });