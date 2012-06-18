/*****************************
  Author: Tony Liang
  Date: 06/17/2012
*****************************/

var markers = {};
var infoContent = {};
var infoWindow;

$(function(){

 $("#btnQuery").click(function(){
    //clearn up map first.
    clean_up_map();
    if($("#txtGeoLng").val().length==0 || $("#txtGeoLat").val().length==0){
        alert('Please input both lng and lat');
    }else{
        //chage map's center
        var Lat = parseFloat($("#txtGeoLat").val());
        var Lng = parseFloat($("#txtGeoLng").val());
        var myLatlng = new google.maps.LatLng(Lat,Lng);
        map.setCenter(myLatlng);
        //fetch new tweets
        var geo_coord = $("#txtGeoLat").val()+","+$("#txtGeoLng").val();
        $.get('query',{'geo':geo_coord},function(data){
             var txt = '';
             var tweets = data['result'];
             for(var i in tweets){
                /*var img = new google.maps.MarkerImage(tweets[i]['pic'],
                 new google.maps.Size(50,50),new google.maps.Point(0,0),
                 new google.maps.Point(18,42));*/
                 var marker = new RichMarker({
          			position: new google.maps.LatLng(tweets[i]['location'][0],tweets[i]['location'][1]),
          			map: map,
          			draggable: false,
                                anchor: RichMarkerPosition.TOP,
          			content: '<div class="mymarker"><img class="img" src="' + tweets[i]['pic'] +
            			'"/></div>'
          		});
                 /*
                 var marker = new google.maps.Marker({
                  position: new google.maps.LatLng(tweets[i]['location'][0],tweets[i]['location'][1]),map: map,icon: img});
                 */
                 markers[tweets[i]['id']]=marker;
                 infoContent[tweets[i]['id']]='<span class="name">'+tweets[i]['name']+'</span><br><span class="text">'+tweets[i]['text']+'</span>';
                 var tid = tweets[i]['id'];
                 google.maps.event.addListener(marker,'click',(function(marker,tid) {
                 return function() {
                   infoWindow.setContent(infoContent[tid]);
              
                   infoWindow.open(map, marker);
                    }
                 })(marker, tid));
             }
             
             $("#divResult").hide();
        },'json');
    }    
 });
initialize();
query_tweets();
});


var map;
 function initialize() {
        var myOptions = {
          center: new google.maps.LatLng(33.972652508736545, -118.25439167022705),
          zoom: 8,
          mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        map = new google.maps.Map(document.getElementById("map_canvas"),
            myOptions);
        google.maps.event.addListener(map, 'dragend', query_tweets);
        infoWindow = new google.maps.InfoWindow({
           content:''});
  }
function query_tweets(){

   var currentLatlng = map.getCenter();
   currentLatlng = currentLatlng+'';
   var curArray = currentLatlng.split(',');
   $("#txtGeoLat").val(curArray[0].substr(1,curArray[0].length));
   $("#txtGeoLng").val(curArray[1].substr(0,curArray[1].length-1));
   $("#btnQuery").trigger('click');
}

function clean_up_map(){
    //remove marker on map and from array
    //remove infoContent
    for(var key in markers){
         markers[key].setMap(null);
         delete markers[key];
    }
    for(var key in infoContent)
         delete infoContent[key];
    $("#divResult").show();
}

