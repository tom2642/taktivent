// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
// import "chartkick/chart.js"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

import "controllers"
import "bootstrap";
import Glide from '@glidejs/glide'
require('packs/raty') 

import { initUpdateNavbarOnScroll } from '../components/navbar';
import { initImagePreview } from '../components/image_preview';

document.addEventListener('turbolinks:load', () => {
  // Call your JS functions here
  initUpdateNavbarOnScroll();
  initImagePreview();
  var sliders = document.querySelectorAll('.glide');
  for (var i = 0; i < sliders.length; i++) {
    var glide = new Glide(sliders[i], {
      type: 'slider',
      gap: 30,
      perView: 3,
      peek: -window.innerWidth*0.55,
      startAt: 0,
      focusAt: 'center'
    });
    glide.mount()
  }
});
