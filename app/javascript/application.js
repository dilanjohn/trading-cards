// Configure your importmap in config/importmap.rb with pin "@hotwired/turbo-rails", to: "turbo.min.js"

import "@hotwired/turbo-rails"
import "controllers"
import "custom/camera"
import "custom/form_debug"

// Add this to verify the file is loading
console.log('Application.js loaded');
