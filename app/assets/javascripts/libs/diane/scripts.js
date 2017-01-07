
$(window).load(function(){
  fancy_scroller();
  leftnav_height();
});

$(window).resize(function() {
  if(this.resizeTO) clearTimeout(this.resizeTO);
  this.resizeTO = setTimeout(function() {
    $(this).trigger('resizeEnd');
  }, 500);
});

$(window).bind('resizeEnd', function() {
  fancy_scroller();
  for_mobile();
  leftnav_height();
});

$(document).ready(function(){

  for_mobile();

  $('.ttip').tooltip();

  if($(".tbl-sort").length>0){
    $(".tbl-sort").tablesorter();
  }

  $('a[href="#"]').click(function(e){
    e.preventDefault();
  });

  //Checkbox
  $("input.ird").change(function(){
    var group = ":checkbox[name='"+ $(this).attr("name") + "']";
    if($(this).is(':checked')){
      $(group).not($(this)).attr("checked",false);
    }
  });

  //Left Nav Height
  $('.gh-sn-box').css('min-height',$('.gh-row').height()+'px');

  //Slideout Nav
  $('#show-sn').on('click', function(){
    var t = $(this);
    var nw = $('#slideNav').width();
    if(t.hasClass('show-sn')){
      t.removeClass('show-sn');
      $('#slideNav').animate({
        left: "-="+nw+"px"
      });
      $('.gh-content-area, .navbar-fixed-top').animate({
        left: "0"
      });
    } else {
      t.addClass('show-sn');
      $('#slideNav').animate({
        left: "0"
      });
      $('.gh-content-area, .navbar-fixed-top').animate({
        left: "+="+nw+"px"
      });
    }
  });

  //Tabs
  /* Tab show no need for angularjs router
  $('#tab-list a').on('click', function () {
    $(this).tab('show');
  });
  */
  $('a[data-toggle="tab"]').on('shown.bs.tab', function () {
    leftnav_height();
  });
  //Accordion
  $('.jaccordion, .col-inline').on('shown.bs.collapse', function () {
    leftnav_height();
  });
  $('.jaccordion').on('hidden.bs.collapse', function () {
    leftnav_height();
  });
  $('.jaccordion').on('shown.bs.collapse', function () {
    $('.gh-col-ico').addClass('ci-show');
  });
  $('.jaccordion').on('hidden.bs.collapse', function () {
    $('.gh-col-ico').removeClass('ci-show');
  });

  //Inline Form
  $('.note-link').on('click', function(){
    var t = $(this)
    t.parent('.collapse-inline').hide();
  });
  $('.note-back').on('click',function(){
    var t = $(this)
    var tid = t.closest('.col-inline').attr('id');
    $('.note-link').each(function(){
      $('.note-link[data-target="#'+tid+'"]').parent('.collapse-inline').fadeIn();
    });
  });

  if($('.col-inline textarea').length>0){
    $('.col-inline textarea').autosize();
  }  

  //Collapse
  var active = true;
  $('.gh-col-ico').on('click', function () {
    var t = $(this);
    if (active) {
      active = false;
      $('.jaccordion .panel-collapse').collapse('show');
      $('.jaccordion .panel-title').attr('data-toggle', '');
      $('.jaccordion .panel-title a').removeClass('collapsed');
      t.addClass('gh-col-all');
    } else {
      active = true;
      $('.jaccordion .panel-collapse').collapse('hide');
      $('.jaccordion .panel-title').attr('data-toggle', 'collapse');
      $('.jaccordion .panel-title a').addClass('collapsed');
      t.removeClass('gh-col-all');
    }
  });

  //Range Slider
  if($( "#slider-range" ).length>0){
    var sr_val = $('.sr-lbl span').length;
    var width = $('.sr-lbl').width();
    var parentWidth = $('.sr-lbl').parent().width();
    var percent = (100*width/parentWidth)/(sr_val-1);
    $( "#slider-range" ).slider({
      range: "max",
      min: 1,
      max: sr_val,
      value: 1,
      slide:  function( event, ui ) {
        $('.ttip').tooltip('destroy');
        if(ui.value>1){
          $('.ttip').eq( ui.value-2).tooltip('show');
        }
      },
      create: function( event, ui ) {
        $('.sr-lbl span:last-child').addClass('last');

        $('.sr-lbl span').css('width',percent+'%');
      }
    });
  }

  //Assessment Value
  if($('#assess-val').val()==2){
    $("#assess-txt").removeClass('h-hide');
  }
  $('#assess-val').change(function(){
    var t = $(this).val();
    if(t==2){
      $("#assess-txt").removeClass('h-hide');
    } else {
      $("#assess-txt").addClass('h-hide');
    }
  });

});


function fancy_scroller(){
  if($('.gh-fscroller-light').length>0){
    $('.gh-fscroller-light').mCustomScrollbar("destroy");
  }
  if($('.gh-fscroller-dark').length>0){
    $('.gh-fscroller-dark').mCustomScrollbar("destroy");
  }
  if($(window).width()<768){
    //Fancy Scroller
    if($('.gh-fscroller-light').length>0){
      $(".gh-fscroller-light").mCustomScrollbar({
        autoHideScrollbar:true,
        theme:"light-thin"
      });
    }
    if($('.gh-fscroller-dark').length>0){
      $(".gh-fscroller-dark").mCustomScrollbar({
        autoHideScrollbar:true,
        theme:"dark-thick"
      });
    }
    $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
      if($('.gh-fscroller-light').length>0){
        $(".gh-fscroller-light").mCustomScrollbar("update");
      }
      if($('.gh-fscroller-dark').length>0){
        $(".gh-fscroller-dark").mCustomScrollbar("update");
      }
    });
  }
}

function for_mobile(){
  if($(window).width()<768){
    //Fixed Top Nav
    var dc = $(document);
    var hr = $('.gh-header .navbar-fixed-top');
    dc.scroll(function() {
      if (dc.scrollTop() >= 20) {
        hr.addClass('nav-shadow');
      } else {
        hr.removeClass('nav-shadow');
      }
    });

    $(document).on('click',function() {
      $('.gh-contents').removeClass('addOp');
      $('#show-sn').removeClass('show-sn');
      var nw = $('#slideNav').width();
      $('#slideNav').animate({
        left: "-"+nw+"px"
      });
      $('.gh-content-area, .navbar-fixed-top').animate({
        left: "0"
      });
    });
    $("#slideNav, #show-sn").on('click', function(e) {
      $('.gh-filter-top .dropdown').removeClass('open');
      $('.gh-contents').removeClass('addOp');
      e.stopPropagation();
      return false;
    });

    //Filter Nav
    $('.gh-filter-top .dropdown').on('click', function(){
      if(!$('.gh-filter-top .dropdown-menu').is(':visible')){
        $('.gh-contents').addClass('addOp');
      } else {
        $('.gh-contents').removeClass('addOp');
      }
    });
  }
}

function leftnav_height(){
  //Left Nav Height
  $('.sn-box').css('height',$('.ca-box').outerHeight()+'px');
}
