describe("PullRequestList", function(){
  it(".fetchList", function(){

//    debugger
//    console.log($('*'));



    spyOn($, 'ajax').andCallFake(function (req) {
      var d = $.Deferred();
      d.resolve({});
      return d.promise();
    });

    PullRequestList.fetchList();

     expect($('.pr-list-spinner').is(':visible')).toBe(false);
  });
});
