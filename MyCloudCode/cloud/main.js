
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:


Parse.Cloud.define("sendPushAlerts", function(request, response) { 

var urlTemplate = "http://menu.ha.ucla.edu/foodpro/default.asp?meal="; //append number to end
var meals = ["breakfast", "lunch", "dinner"];

for (i = 1; i <=3; i++) {

  Parse.Cloud.run('checkMeal', {"url":(urlTemplate+i), "meal":meals[i-1]}, {

    success: function(){
      response.success();
    },

    error: function() {
      response.error();
    }
  });

}

});

Parse.Cloud.define("checkMeal", function(request, response) {     

Parse.Cloud.httpRequest({
      //url: "http://menu.ha.ucla.edu/foodpro/default.asp?date=7%2F10%2F2014&meal=2&threshold=2",
      url: request.params.url,
      
      success: function(httpResponse) {
        var halls = ["Covel", "Hedrick", "B Plate", "Feast"];
        var text = httpResponse.text;
        text = text.replace(/&amp;/g, '&');

        var gridCellArray = new Array();
        var start = text.indexOf("<td class=\"menugridcell");

        while (start > 0) {

          text = text.substring(start);
          var end = text.indexOf("<\/td") + 4; // 4 is length
          gridCellArray.push(text.substring(0, end));

          text = text.substring(end);
          start  = text.indexOf("<td class=\"menugridcell");
        
        }

        var foodArray = new Array();
        var hallArray = new Array();
        var mealArray = new Array();

        var count = 0;
        console.log(gridCellArray.length);
        for (i = 0; i < gridCellArray.length; i++, count++) {
          
          var cellText = gridCellArray[i];
          var start = cellText.indexOf(";\">");

          while (start > 0) {

            var foodPlusExcess = cellText.substring(start+3);
            var end = foodPlusExcess.indexOf("<\/a>");
            food = foodPlusExcess.substring(0,end);
            cellText = foodPlusExcess.substring(end+4);
            start = cellText.indexOf(";\">");

            //if (i < 2) //for test
             //Parse.Cloud.run('push', {"food":food, "hall":halls[count%4], "meal":request.params.meal}, {});
             foodArray.push(food);
             hallArray.push(halls[count%4]);
          }
        }
        Parse.Cloud.run('push', {"foodList":foodArray, "hallList":hallArray, "meal":request.params.meal}, {});
        response.success();

     },
     error: function(httpResponse) {
        response.error('Request failed with response code ' + httpResponse.status);
      }


});

});


Parse.Cloud.define("pushFavorites", function(request, response) {   	

	Parse.Cloud.httpRequest({
  		url: "http://menu.ha.ucla.edu/foodpro/default.asp?date=7%2F10%2F2014&meal=2&threshold=2",
  		//url: "wwww.example.com",
  		success: function(httpResponse) {
   			// console.log(httpResponse.text);
   			var text = httpResponse.text;
   			
    		var start = text.indexOf("<td class=\"menugridcell\">");
    		text = text.substring(start);
    		var end = text.indexOf("<\/td");
    		text = text.substring(0,end+4);

    		var xpath = require("cloud/xpath.js"), dom = require("cloud/dom-parser.js").DOMParser;
    		var doc = new dom().parseFromString(text);
    		var cells = xpath.select("//ul", doc);
    		//response.success(text);
    		//var cells = xpath.select("//td[starts-with(@class, 'menugridcell')]", doc);
    		response.success("test " + cells.count);
    		//var cells = xpath.select("//head", doc);
 		 },
 		 error: function(httpResponse) {
  			console.error('Request failed with response code ' + httpResponse.status);
  		}
});

   	//var doc = httpGet("http://menu.ha.ucla.edu/foodpro/default.asp?date=7%2F10%2F2014&meal=2&threshold=2");
   	//add link and stuff

  
  /* 	var halls = ["Covel", "De Neve", "B Plate", "Feast"];
   	var count = 0;

   	for (i = 0; i < cells.length; i++) {

   		var listNode = xpath.select("//ul", cells[i])[0]; //idk if works
   		if (listNode) {
   			var listChildren = xpath.select("//li", listNode);
   			var stationName = listChildren[0];

   			for (j = 0; j < listChildren.length; j++) {

   				if (j!=0) {
   					var foodName = xpath.select("//a/text()", listChildren[j]).toString();
   					var currentHall  = halls[count%4];
   					response.success(foodName + " " + currentHall); 
   				}
   			}
   		}
   	}
*/
});


Parse.Cloud.define("push", function(request, response) {
  var foodList = request.params.foodList;
  var hallList = request.params.hallList;

  console.log("c " + foodList[0]);

for (i = 0; i < foodList.length; i++) {
var query = new Parse.Query(Parse.Installation);
	query.equalTo("favorites", foodList[i]);
 	var message = hallList[i]+ " is serving " + foodList[i] + " for " + request.params.meal;
  //console.log(message);
  Parse.Push.send({
    where: query, // Set our Installation query
        data: {
        alert: message
      }
      }, {
    success: function() {
        // Push was successful
    },
        error: function(error) {
        // Handle error
    }
      });  

}
});





Parse.Cloud.job("pushTest", function(request, status) {
	
	var query = new Parse.Query(Parse.Installation);
	query.equalTo("favorites", "Fried Eggs");
	Parse.Push.send({
		where: query, // Set our Installation query
		    data: {
		    alert: "testing cloud code"
			}
	    }, {
		success: function() {
		    // Push was successful
		},
		    error: function(error) {
		    // Handle error
		}
	    });   

    });

Parse.Cloud.define("separateCells", function(request, response) {
  
  var start = request.params.text.indexOf("<td class=\"menugridcell");

        while (start > 0) {

          text = text.substring(start);
          var end = text.indexOf("<\/td") + 4; // 4 is length
          request.params.array.push(text.substring(0, end));

          text = text.substring(end);
          start  = text.indexOf("<td class=\"menugridcell");
        
        }
});



// getting all the food names

Parse.Cloud.define("checkForNewFoods", function(request, response) { 

for (i = 0; i < 1; i++) {
      var d = new Date();
      d.setDate(d.getDate()+i);
      var month = d.getMonth()+1; //months start at 0
      var date = d.getDate();
      var year = d.getFullYear();

      var urlTemplate= "http://menu.ha.ucla.edu/foodpro/default.asp?date=" + month + "%2F" + date + "%2F" + year +"&meal=" ; 
      for (j = 1; j <=3; j++) {

        Parse.Cloud.run('checkMeal2', {"url":(urlTemplate+j)}, {
          
          success: function(){
            //response.success();
          },

          error: function() {
           // response.error();
          }
        });

      }
}
});


Parse.Cloud.define("checkMeal2", function(request, response) {     

Parse.Cloud.httpRequest({
      //url: "http://menu.ha.ucla.edu/foodpro/default.asp?date=7%2F10%2F2014&meal=2&threshold=2",
      url: request.params.url,
      
      success: function(httpResponse) {
        var halls = ["Covel", "Hedrick", "B Plate", "Feast"];
        var text = httpResponse.text;
        text = text.replace(/&amp;/g, '&');

        var gridCellArray = new Array();
        var start = text.indexOf("<td class=\"menugridcell");

        while (start > 0) {

          text = text.substring(start);
          var end = text.indexOf("<\/td") + 4; // 4 is length
          gridCellArray.push(text.substring(0, end));

          text = text.substring(end);
          start  = text.indexOf("<td class=\"menugridcell");
        
        }


        var count = 0;
        //console.log(gridCellArray.length);
        var foodArray = new Array();
        for (i = 0; i < gridCellArray.length; i++, count++) {
          
          var cellText = gridCellArray[i];
          var start = cellText.indexOf(";\">");

          while (start > 0) {

            var foodPlusExcess = cellText.substring(start+3);
            var end = foodPlusExcess.indexOf("<\/a>");
            food = foodPlusExcess.substring(0,end);
            cellText = foodPlusExcess.substring(end+4);
            start = cellText.indexOf(";\">");
            //console.log(food);
            //Parse.Cloud.run('recordFavorite', {"food":food}, {});
            foodArray.push(food);
          }
        }
        Parse.Cloud.run('recordFavorite', {"foodList":foodArray}, {});
        response.success();

     },
     error: function(httpResponse) {
        response.error('Request failed with response code ' + httpResponse.status);
      }


});

});



Parse.Cloud.define("recordFavorite", function(request, response) {

  var foodList = request.params.foodList; //string array of food names
  var foodListCorrected = new Array();
  var Food = Parse.Object.extend("Food");

  // Wrap your logic in a function
  function process_food(i) {
      // Are we done?
      if (i == foodList.length) {
          //console.log("count is " + foodListCorrected.length);
          Parse.Object.saveAll(foodListCorrected, {
              success: function(foodListCorrected) {
                
              },
              error: function(foodListCorrected) {
           
              }
          });
          return;
      }

      var name = foodList[i];
      //console.log("before name is " + name);
      var query = new Parse.Query(Food);
      query.equalTo("name", name);

      query.count({
      success: function(number) {
        console.log(number);
        if(number==0){
          var food = new Food();
          food.set("name", name);
          foodListCorrected.push(food);
        //  console.log(foodListCorrected.length);
        } else {
          //don't create new food
        }
        process_food(i+1)

      },
      error: function(error) {
        console.log(error);
      }
    });

  }

  // Go! Call the function with the first food.
  process_food(0);
  

});





/*
Parse.Cloud.define("recordFavorite", function(request, response) {

  var foodList = request.params.foodList; //string array of food names
  var foodListCorrected = new Array();
  var Food = Parse.Object.extend("Food");

  var query = new Parse.Query(Food);
  query.find().then(function(foods) {
      for (i = 0; i < foodList.length; i++) {
            var j;
            for (j = 0; j < foods.length; j++){
                if (foodList[i] == foods[j])
                  break;
            }
            if (j==foods.length)
                foodListCorrected.push(foodList[i]);
      }
      console.log(foodListCorrected.length);
      return Parse.Object.saveAll(foodListCorrected);
  }).then(function() {
  // Everything is done!
     
  })
 
});

*/

