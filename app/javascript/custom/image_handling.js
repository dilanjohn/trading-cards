document.addEventListener('DOMContentLoaded', function() {
  const changeImageBtn = document.getElementById('change-image');
  const currentImageContainer = document.getElementById('current-image-container');
  const cameraSection = document.getElementById('camera-section');

  if (changeImageBtn) {
    changeImageBtn.addEventListener('click', function() {
      currentImageContainer.style.display = 'none';
      cameraSection.style.display = 'block';
    });
  }
}); 