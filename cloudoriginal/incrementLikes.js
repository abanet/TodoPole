Parse.Cloud.define("incrementViewCount", function(request, response) {   
	Parse.Cloud.useMasterKey();   
	var Item = Parse.Object.extend("Item");   
	var item = new Item();   
	var item.id = request.params.itemId;   
	var increment = request.params.increment;   
	item.increment("viewCount", increment);   
	item.save(null, {       
		success: function(item) {         
			response.success(true);       
			},       
			error: function(item, error) {         
				response.error("Could not increment view count.");       
				}   
				}); 
});