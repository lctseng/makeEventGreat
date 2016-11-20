$(document).ready(function() {

    $('#submitBtn').click(function(e){
        console.log('clicked submit');
        e.preventDefault();

        var jsonData;

        var locationArray = [];

        if( $('#north').prop('checked') == true ){
            locationArray.push('北');
        }
        if( $('#medium').prop('checked') == true ){
            locationArray.push('中');
        }
        if( $('#south').prop('checked') == true ){
            locationArray.push('南');
        }
        if( $('#other').prop('checked') == true ){
            locationArray.push('其他');
        }

        var typeArray = [];

        if( $('#typeA').prop('checked') == true ){
            typeArray.push('前端');
        }
        if( $('#typeB').prop('checked') == true ){
            typeArray.push('後端');
        }
        if( $('#typeC').prop('checked') == true ){
            typeArray.push('研討會');
        }
        if( $('#typeD').prop('checked') == true ){
            typeArray.push('定期聚');
        }

        jsonData = {
            url: '/api/search',
            type: 'POST',
            dataType: 'json',
            data: {
                keyword: $('#eventKeyword').val(),
                host: $('#hostKeyword').val(),
                location: locationArray,
                type: typeArray,
                date: {
                    start: $('#minTime').val(),
                    end: $('#maxTime').val()
                },
                fee: {
                    lower: $('#minFee').val(),
                    upper: $('#maxFee').val()
                },
                number_of_people: {
                    lower: $('#minPeople').val(),
                    upper: $('#maxPeople').val()
                }
            }
        };

        $.ajax(jsonData)
        .done(function(data) {
            console.log( "success" );
            console.log(data);
            clean();
            for(var i=0; i<data.length; i++){
                showObject(data[i]);
            }
        })
        .fail(function(data) {
            console.log( "error" );
        })
        .always(function(data) {
            console.log( "always end." );
            console.log(jsonData);
        });
    });

});

function clean(){
    $('div.resultDiv').remove();
}

var resultBlock = '';

function showObject(inputData){
    console.log('show 1 time');

    var typeList = '';


    for(var i=0; i<inputData.type.length; i++){
        typeList = typeList + inputData.type[i]+' ';
    }

    resultBlock =
        '<div class="resultDiv">'+
            '<p class="title">活動標題：'+inputData.title+'</p>'+
            '<p class="location">活動地點：'+inputData.location+'</p>'+
            '<p class="date">活動日期：'+inputData.start_date+' ~ '+inputData.end_date+'</p>'+
            '<p class="type">活動類型：'+typeList+'</p>'+
            '<p class="description">活動介紹：'+inputData.description+'</p>'+
            '<p>活動報名網址：</p><a class="url" href="' + inputData.url + '">'+inputData.url+'</a>'+
            '<p class="host">活動主辦單位：'+inputData.host+'</p>'+
            '<p class="fee">活動費用：'+inputData.fee+'</p>'+
            '<p class="number_of_people">活動人數：'+inputData.number_of_people+'</p>'+
            '<p class="source">活動來源：'+inputData.source+'</p>'+
            '<img class="image_url" src="' + inputData.image_url + '">'+
        '</div>';

    $('form').after( resultBlock );
}
