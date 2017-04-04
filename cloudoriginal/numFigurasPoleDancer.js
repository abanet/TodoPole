Parse.Cloud.define("numFigurasPoleDancer", function(request, response) {
	var query = new Parse.Query("Figura")
	query.equalTo("autor", request.params.autor)
	
	query.find({
		success: function(results){
			var sum = 0;
			for(var i = 0; i < results.length; ++i){
				sum += 1;
			}
			response.success(sum);
		},
		
		error: function(){
			response.error("Autor no encontrado")
		}
	});
	
});