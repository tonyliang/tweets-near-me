$(function(){

 $("#btnQuery").click(function(){
    if($("#txtGeoLng").val().length==0 || $("#txtGeoLat").val().length==0){
        alert('Please input both lng and lat');
    }else{
 
        var geo_coord = $("#txtGeoLng").val()+","+$("#txtGeoLat").val();
        $.get('query',{'geo':geo_coord},function(data){
             if(data=="OKAY")
               alert('Done');
        },'text');
    }    
 });

});
