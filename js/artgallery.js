var page=1;
var maxart = parseInt($("#number").text());
var maxpages = Math.ceil(maxart/4);
console.log(maxpages);

$(document).ready(function() {
  
  // add a new event handler
  $(".art").on("mouseover", ".arts", function(){
  	$(this).parent().find(".art-title").animate({height: "toggle"},500,function(){
  		$(this).toggleClass("no");});
  });
  $(".art").on("mouseout", ".arts", function(){
  	$(this).parent().find(".art-title").animate({height: "toggle"},500,function(){
  		$(this).toggleClass("no");});
  });
  $("#left").on("click", function(){
  	if(page>1){		
  		// for (var i = 1; i <= 4; i++) {
  		// 	$("#"+(4*page-i)).animate({marginLeft: 50*4+"%"}, 50, function(){ $(this).toggleClass("no"); });
  		// };
  		for (var i = (page)*4; i >= (page)*4-7; i--) {
  			$("#"+i).toggleClass("no");
  		};
  		page--;
  	}
  });
  $("#right").on("click", function(){
  	if(page<maxpages){
  		// for (var i = 1; i <= 4; i++) {
  		// 	$("#"+(4*(page-1)+i)).animate({marginRight: 50*(4-i)+"%"}, 50, function(){ $(this).toggleClass("no");	});
  		// }	
  		for (var i = 1+(page-1)*4; i <= 8+(page-1)*4; i++) {
  			$("#"+i).toggleClass("no");
  		}
  			page++;	
  	}
  });
             
});
