// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

$('.dist-divider').click(function(){
  var url = '/distributions/random';
  $.ajax({
    type: "GET",
    url: url,
    dataType: "json",
    contentType: "text/html",
    data: { playtime_differential: $('#playtime-differential').html() },
    success: function(data){
      $('.dist-divider').html(data.distribution_html);
    },
    error: function(){
      console.log('error man');
    }
  });
});
$('.close').click(function(){ $(this).parent().remove() })
$('.gaben-trigger').hover(function(){ $('.gaben-target').addClass('gaben') }, function(){ $('.gaben-target').removeClass('gaben') })

function refresh_stats(){
  var url = '/fresh_stats';
  $.ajax({
    type: "GET",
    url: url,
    dataType: "json",
    contentType: "text/html",
    success: function(data){
      $('#biggest_playtime_differential_hours > span').html(data.biggest_playtime_differential.hours);
      $('#biggest_playtime_differential_words').html(data.biggest_playtime_differential.words);

      $('#average_playtime_differential_hours > span').html(data.average_playtime_differential.hours);
      $('#average_playtime_differential_words').html(data.average_playtime_differential.words);

      $('#total_playtime_differential_hours > span').html(data.total_playtime_differential.hours);
      $('#total_playtime_differential_words').html(data.total_playtime_differential.words);

      $('#total_steamids_checked > span').html(data.total_steamids_checked);
    },
    error: function(){
      console.log('error man');
    }
  });
}