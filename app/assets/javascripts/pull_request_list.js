PullRequestList = {
    initialize: function(){
        console.log("Starting up")
    },

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
                console.log(response);
                $('.pr-list-spinner').hide()
                PullRequestList.showInitialList(response);
            },
            failure: function(){
                console.log("Unable to fetch list of pull requests");
            }
        });
    },

    showInitialList: function(pr_data){
        elements = '<tr><th></th><th></th><th>Pull Requests for CloudFoundry</th></tr>'
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
            top: 'auto', // Top position relative to parent in px
            left: 'auto' // Left position relative to parent in px
        };

        _.each(pr_data, function(value, key){
           var el = '<tr class="pull"><td>1</td><td><div class="td-spinner"></div></td><td>'+key+'</td></tr>';
           elements += el
        });

        $('table').html(elements)

        $('table tr').each(function(value, element){
          if( element.children[0].textContent != "" ){
            var target = element.children[1];
            var spinner = new Spinner(opts).spin(target);

            $.ajax({
                type:"GET",
                url: "pulls/"+pr_data[element.children[2].textContent].id,
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                data: {org:'cloudfoundry', repo: pr_data[element.children[2].textContent].repo },
                success: function(response){
                    $(element.children[1]).hide();
                },
                failure: function(){
                }
            });
          }
        });
    }

};

$(document).ready(function(){
    PullRequestList.initialize();
    PullRequestList.fetchList();
});

