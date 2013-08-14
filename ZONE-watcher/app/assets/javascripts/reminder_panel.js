//When the document is ready, prepare and initiate different function to the object of the modal
$(document).ready(function() {
    //Reminder box in the item page
    $("#reminder").hover(function() {
    }, function() {
        $("#openReminder").fadeIn();
        $("#reminder").css("left", "-37%");
    });

    $("#openReminder").hover(function(){
    	$('#openReminder').popover('hide');
        $("#openReminder").fadeOut();
        $("#reminder").css("transition", "all 0.5s ease-in");
        $("#reminder").css("left", "-1%");
    },function(){});
});

function showUpdate(){
	var timer = setInterval(function(){
		if($(".updater").css("opacity")==1)
			$(".updater").css("opacity","0.5");
		else
			$(".updater").css("opacity","1");
	},300);
	setTimeout(function(){
		clearInterval(timer);
		$(".updater").css("opacity","1");
	},2000);
}