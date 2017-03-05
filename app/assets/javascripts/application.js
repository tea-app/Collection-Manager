// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

jQuery( function($) {


  $("#menu-icon").click(function(){

    if ($(this).hasClass('open')) {
      $(".header-toggleMenu").find(".item-search").hide();
      $(".header-toggleMenu").find(".item-mypage").hide();
      $(".header-toggleMenu").find(".item-logout").hide();
      $(this).removeClass('open');
    } else {
      $(".header-toggleMenu").find(".item-search").show();
      $(".header-toggleMenu").find(".item-mypage").show();
      $(".header-toggleMenu").find(".item-logout").show();
      $(this).addClass('open');

    }

  });
});
  /*    if ($(this).hasClass('open')) {
  $(".item-search").hide();
  $(".item-mypage").hide();
  $(".item-logout").hide();
  $(this).removeClass('open');
} else {
$(".item-search").css("display", "block");
$(".item-mypage").css("display", "block");
$(".item-logout").css("display", "block");
$(this).addClass('open');
}
*/
