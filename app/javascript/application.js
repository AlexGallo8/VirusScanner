// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"


//= require rails-ujs
//= require turbolinks
//= require_tree .


console.log("Hello World from Webpacker")


const signUpButton = document.getElementById('signUp');
const signInButton = document.getElementById('signIn');
const container = document.getElementById('container');
  
signUpButton.addEventListener('click', () => {
    container.classList.add("right-panel-active");
});
  
signInButton.addEventListener('click', () => {
    container.classList.remove("right-panel-active");
});
  



// index.html.erb - container for the two boxes 
document.getElementById('box1').addEventListener('mouseover', function() {
    this.style.width = "100%";
    this.style.transform = "translateX(30%)";
    document.getElementById('box2').style.width = "0%";
    document.getElementById('box2').style.transform = "translateX(100%)";
});
  
document.getElementById('box1').addEventListener('mouseout', function() {
    this.style.width = "50%";
    this.style.transform = "translateX(0%)";
    document.getElementById('box2').style.width = "50%";
    document.getElementById('box2').style.transform = "translateX(0%)";
});
  
document.getElementById('box2').addEventListener('mouseover', function() {
    this.style.width = "100%";
    this.style.transform = "translateX(-30%)";
    document.getElementById('box1').style.width = "0%";
    document.getElementById('box1').style.transform = "translateX(-100%)";
});
  
document.getElementById('box2').addEventListener('mouseout', function() {
    this.style.width = "50%";
    this.style.transform = "translateX(0%)";
    document.getElementById('box1').style.width = "50%";
    document.getElementById('box1').style.transform = "translateX(0%)";
});


// new.html.erb - sign up and sign in buttons animation


