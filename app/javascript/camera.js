document.addEventListener('DOMContentLoaded', function() {
  const startButton = document.getElementById('start-camera');
  const takePhotoButton = document.getElementById('take-photo');
  const retakeButton = document.getElementById('retake-photo');
  const video = document.getElementById('camera-preview');
  const canvas = document.getElementById('camera-canvas');
  const previewContainer = document.getElementById('preview-container');
  const previewImage = document.getElementById('preview-image');
  const fileInput = document.querySelector('.hidden-file-input');
  
  let stream = null;

  startButton.addEventListener('click', async function() {
    try {
      stream = await navigator.mediaDevices.getUserMedia({ 
        video: { facingMode: 'environment' }, 
        audio: false 
      });
      video.srcObject = stream;
      video.style.display = 'block';
      startButton.style.display = 'none';
      takePhotoButton.style.display = 'inline-block';
      previewContainer.style.display = 'none';
    } catch (err) {
      console.error('Error accessing camera:', err);
      alert('Could not access camera. Please make sure you have granted camera permissions.');
    }
  });

  takePhotoButton.addEventListener('click', function() {
    canvas.width = video.videoWidth;
    canvas.height = video.videoHeight;
    canvas.getContext('2d').drawImage(video, 0, 0);
    
    // Convert canvas to blob
    canvas.toBlob(function(blob) {
      // Create a File object
      const file = new File([blob], "camera_photo.jpg", { type: "image/jpeg" });
      
      // Create a FileList-like object
      const dataTransfer = new DataTransfer();
      dataTransfer.items.add(file);
      fileInput.files = dataTransfer.files;
      
      // Show preview
      previewImage.src = URL.createObjectURL(blob);
      previewContainer.style.display = 'block';
    }, 'image/jpeg');

    // Clean up
    stream.getTracks().forEach(track => track.stop());
    video.style.display = 'none';
    takePhotoButton.style.display = 'none';
    retakeButton.style.display = 'inline-block';
  });

  retakeButton.addEventListener('click', function() {
    startButton.click();
    retakeButton.style.display = 'none';
  });
}); 