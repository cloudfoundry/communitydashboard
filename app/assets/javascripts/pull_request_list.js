PullRequestList = {
  fetchList: function(){
    var opts = {
      lines: 13, // The number of lines to draw
      length: 10, // The length of each line
      width: 5, // The line thickness
      radius: 10, // The radius of the inner circle
      corners: 1, // Corner roundness (0..1)
      rotate: 0, // The rotation offset
      direction: 1, // 1: clockwise, -1: counterclockwise
      color: '#000', // #rgb or #rrggbb or array of colors
      speed: 1, // Rounds per second
      trail: 60, // Afterglow percentage
      shadow: false, // Whether to render a shadow
      hwaccel: false, // Whether to use hardware acceleration
      className: 'spinner', // The CSS class to assign to the spinner
      zIndex: 2e9, // The z-index (defaults to 2000000000)
      top: 'auto', // Top position relative to parent in px
      left: 'auto' // Left position relative to parent in px

    };

    var target = document.getElementById('spinnerContainer');
    var spinner = new Spinner(opts).spin(target);

    $.ajax({
      type:"GET",
      url: "pulls",
      contentType: 'application/json; charset=utf-8',
      dataType: 'json',
      success: function(response){
        $('#spinnerContainer .spinner').hide()
        PullRequestList.showInitialList(response);
      },
      failure: function(){
          console.log("Unable to fetch list of pull requests");
      }
    });
  },

  showInitialList: function(pr_data){
    var elements = ''
    var opts = {
        lines: 11, // The number of lines to draw
        length: 5, // The length of each line
        width: 3, // The line thickness
        radius: 4, // The radius of the inner circle
        corners: 1, // Corner roundness (0..1)
        rotate: 0, // The rotation offset
        direction: 1, // 1: clockwise, -1: counterclockwise
        color: '#000', // #rgb or #rrggbb or array of colors
        speed: 1, // Rounds per second
        trail: 60, // Afterglow percentage
        shadow: false, // Whether to render a shadow
        hwaccel: false, // Whether to use hardware acceleration
        className: 'spinner', // The CSS class to assign to the spinner
        zIndex: 2e9, // The z-index (defaults to 2000000000)
        top: 0, // Top position relative to parent in px
        left: -30 // Left position relative to parent in px
    };

    var index = 1
    _.each(pr_data, function(value, key){
       var el = '<li class="li-pull"><div class="li-spinner"><div>'+key+'</div></li>';
       elements += el;
       index += 1;
    });

    $('ul').html(elements)

    $('ul li').each(function(value, element){
        var target = element.getElementsByClassName('li-spinner')[0];
        var spinner = new Spinner(opts).spin(target);

        $.ajax({
          type:"GET",
          url: "pulls/"+pr_data[element.textContent].id,
          contentType: 'application/json; charset=utf-8',
          dataType: 'json',
          data: {org:'cloudfoundry', repo: pr_data[element.textContent].repo },
          success: function(response){
            $(element.getElementsByClassName('li-spinner')[0]).hide();
            var url = element.textContent;
            var repo = 'cloudfoundry/' + pr_data[element.textContent].repo;

            var html = '<a class="repolink" href=https://github.com/'+repo+'>'+repo+'</a> - ';
            html += '<a href='+url+'>'+response.title+'</a>';
            html += (response.body==null || response.body=='' ? '<div class="no-desc">No description available</div>' : '<div>'+response.body+'</div>');

            $(element).html(html);
          },
          failure: function(){
          }
        });
    });
  }
};
//
//$(document).ready(function(){
//    PullRequestList.fetchList();
//});

