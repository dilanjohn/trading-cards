document.addEventListener('DOMContentLoaded', function() {
  const startButton = document.getElementById('start-camera');
  if (!startButton) return;

  const takePhotoButton = document.getElementById('take-photo');
  const retakeButton = document.getElementById('retake-photo');
  const retakeFinalButton = document.getElementById('retake-final');
  const cropButton = document.getElementById('crop-button');
  const video = document.getElementById('camera-preview');
  const cropperContainer = document.getElementById('cropper-container');
  const cropperImage = document.getElementById('cropper-image');
  const previewContainer = document.getElementById('preview-container');
  const previewImage = document.getElementById('preview-image');
  const fileInput = document.querySelector('.hidden-file-input');
  
  let stream = null;
  let cropper = null;

  // Start camera function
  startButton.addEventListener('click', async function() {
    console.log('Starting camera...');
    try {
      if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
        throw new Error('Camera API not supported in this browser');
      }

      stream = await navigator.mediaDevices.getUserMedia({
        video: {
          facingMode: 'environment',
          width: { ideal: 1280 },
          height: { ideal: 720 }
        },
        audio: false
      });

      console.log('Camera access granted, setting up video stream...');
      
      video.srcObject = stream;
      video.style.display = 'block';
      
      await new Promise((resolve) => {
        video.onloadedmetadata = () => {
          console.log('Video metadata loaded');
          resolve();
        };
      });

      await video.play();
      console.log('Video playing');
      
      startButton.style.display = 'none';
      takePhotoButton.style.display = 'inline-block';
      cropperContainer.style.display = 'none';
      previewContainer.style.display = 'none';
      
    } catch (err) {
      console.error('Detailed camera error:', err);
      let errorMessage = 'Could not access camera. ';
      
      if (err.name === 'NotAllowedError') {
        errorMessage += 'Please grant camera permissions in your browser settings.';
      } else if (err.name === 'NotFoundError') {
        errorMessage += 'No camera device found.';
      } else if (err.name === 'NotReadableError') {
        errorMessage += 'Camera is already in use by another application.';
      } else {
        errorMessage += err.message || 'Unknown error occurred.';
      }
      
      alert(errorMessage);
      
      video.style.display = 'none';
      startButton.style.display = 'inline-block';
      takePhotoButton.style.display = 'none';
    }
  });

  // Take photo function
  takePhotoButton.addEventListener('click', function() {
    try {
      console.log('Taking photo...');
      const canvas = document.createElement('canvas');
      canvas.width = video.videoWidth;
      canvas.height = video.videoHeight;
      
      const context = canvas.getContext('2d');
      context.drawImage(video, 0, 0);
      
      if (stream) {
        stream.getTracks().forEach(track => track.stop());
      }

      cropperImage.src = canvas.toDataURL('image/jpeg');
      video.style.display = 'none';
      takePhotoButton.style.display = 'none';
      cropperContainer.style.display = 'block';

      if (cropper) {
        cropper.destroy();
      }
      
      console.log('Initializing cropper...');
      cropper = new Cropper(cropperImage, {
        aspectRatio: 1,
        viewMode: 1,
        autoCropArea: 1,
        background: false,
        ready: function() {
          console.log('Cropper initialized');
        }
      });
    } catch (err) {
      console.error('Error taking photo:', err);
      alert('Error taking photo: ' + err.message);
    }
  });

  // Crop image function
  cropButton.addEventListener('click', function() {
    try {
      console.log('Cropping image...');
      const croppedCanvas = cropper.getCroppedCanvas();
      
      croppedCanvas.toBlob(function(blob) {
        const file = new File([blob], "camera_photo.jpg", { type: "image/jpeg" });
        
        const dataTransfer = new DataTransfer();
        dataTransfer.items.add(file);
        fileInput.files = dataTransfer.files;
        
        previewImage.src = croppedCanvas.toDataURL('image/jpeg');
        cropperContainer.style.display = 'none';
        previewContainer.style.display = 'block';
      }, 'image/jpeg', 0.9);
    } catch (err) {
      console.error('Error cropping image:', err);
      alert('Error cropping image: ' + err.message);
    }
  });

  // Retake photo functions
  retakeButton.addEventListener('click', function() {
    if (cropper) {
      cropper.destroy();
    }
    startButton.click();
  });

  retakeFinalButton.addEventListener('click', function() {
    startButton.click();
  });
}); 