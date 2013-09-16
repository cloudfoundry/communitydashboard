describe("PullRequestList", function(){
  describe(".fetchList", function(){
      describe("on success", function(){
         it("hides the spinner", function(){
              spyOn($, 'ajax').andCallFake(function (req) {
                  var d = $.Deferred();
                  d.resolve({});
                  return d.promise();
              });

              PullRequestList.fetchList();

              debugger;

              expect($('.pr-list-spinner').length).not.toEqual(0);
              expect($('.pr-list-spinner').is(':visible')).toBe(false);
         });
      });
  });
});
