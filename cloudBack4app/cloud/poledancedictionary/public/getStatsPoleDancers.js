Parse.Cloud.job("getStatsPoleDancers", function (request, status) {
  

  // The query object
  var query = new Parse.Query(Profesores);
  query.equalTo("visible", true);
 

  query.find({
    success: function (results) {
      console.log("Successfully retrivied " + results.length + " Pole Dancers.");

      query.each(function (object, err) {
        var nombre = object.get("name");
        Parse.Cloud.run("numFigurasPoleDancer", {autor: nombre}).then(
	        function(numFiguras) {
		        object.set("figuras", numFiguras);
				object.save();
				console.log(result);
	        });
	        
   
        
        Parse.Cloud.run("numLikesPoleDancer", {autor: nombre}).then(
	        function(numLikes) {
		        object.set("likes", numLikes);
				object.save();
				console.log(result);
	        });
               
       
      })
    },
    error: function (error) {
      console.log("Error: " + error.code + " - " + error.message);
    }
  });
});
