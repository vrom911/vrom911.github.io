//$("#overlaylogo").height($(window.height()));
$(window).on("load", function() {
   // PAGE IS FULLY LOADED
   // FADE OUT YOUR OVERLAYING DIV
   $('.overlaylogo').fadeOut();
});
$(document).ready(function(){
  var h = $("#link").width();
  $(".nav-parent").height(Math.floor(h/4));
  $("#coming-canvas").height($("#coming-canvas").width()/2);
  $(".icons").height($(".icon").width());
});

function resizeAll(){
  var h = $("#link").width();
  $(".nav-parent").height(Math.floor(h/4));
  Processing.getInstanceById('logo-can').resizeLogo();
  Processing.getInstanceById('coming-canvas').resizeComing();
  Processing.getInstanceById('coming-canvas').draw();
  Processing.getInstanceById('uz').resizeUzor();
  Processing.getInstanceById('uz').draw();
  Processing.getInstanceById('subuz').resizeUzor();
  Processing.getInstanceById('subuz').draw();
  Processing.getInstanceById('nav1').resizeNav();
  Processing.getInstanceById('nav2').resizeNav();
  Processing.getInstanceById('nav3').resizeNav();
  Processing.getInstanceById('nav4').resizeNav();
}
$(window).resize(function() {
  resizeAll();
});
