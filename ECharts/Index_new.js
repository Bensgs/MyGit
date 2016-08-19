<script type="text/javascript">

var transAtOptions;
var transNumOptions;
var incomeOptions;

function load() {
	
	var imgList = $("img[name='imgSlide']");
	for (var i = 0; i < imgList.length; i++) {
		var img = imgList[i];
		var imgHeight = $(img).height();
		var id = $(img).attr("id");
		if (imgHeight > 280) {
			var label = $("#label" + id.substring(3));
			var n = imgHeight - 280;
			label.attr("style", "bottom:" + n);
		}
	}
	
}

$(function () {
	var allowVisitTransDataFlag = $.cookie("allowVisitTransData");
	
	//add by CJ
	if ('true' == allowVisitTransDataFlag) {
		$("#transDataDiv").attr("style", "display:block");
		menu_ul.getElementsByTagName("li")[5].style.display = "block";
	} else {
		$("#transDataDiv").attr("style", "display:none");
		menu_ul.getElementsByTagName("li")[5].style.display = "none";
	}
	//end add
	
	$("#searchLink").click(function() {
		var keyword = $("#searchTxt").val();
		if (keyword == '')
			return;
		var searchLink = $("#searchLink");
		searchLink.attr("target", "_blank");
		searchLink.attr("href", "f/search?q=" + keyword + "&t=article");
	});

    var nowDt = new Date();
    var nowYear = nowDt.getFullYear();
    var nowMonth = nowDt.getMonth();
    var queryYear;
    var queryMonth;
    var queryDay;
    var queryMonthStr;
    var queryDateStr;

    if(nowMonth == 0){
    	queryYear = nowYear - 1;
    	queryMonth = '12';
    }else if(nowMonth < 10){
    	queryYear = nowYear;
    	queryMonth = '0' + nowMonth.toString();		
    }else{
    	queryYear = nowYear;
    	queryMonth = nowMonth.toString();
    }    
    queryMonthStr = queryYear.toString() + queryMonth.toString();

    nowDt.setDate(1);
    nowDt.setMonth(nowDt.getMonth()+1);
    nowDt.setDate(nowDt.getDate()-1);

    queryYear = nowDt.getFullYear();
    queryMonth = nowDt.getMonth()+1;
    queryDay = nowDt.getDate();

    if(queryMonth < 10){
    	queryMonth = '0' + queryMonth.toString();		
    }
    if(queryDay < 10){
    	queryDay = '0' + queryDay.toString();		
    }
    queryDateStr = queryYear.toString() + queryMonth.toString() + queryDay.toString();

	var dailyTransDataUrl = '${fns:getTransDataUrl()}/trans/analysis!queryDay.action?insCd=${fns:getNmgInsIdCd()}&queryDate=' + queryDateStr + '&callback=?';
	var monthTransDataUrl = '${fns:getTransDataUrl()}/trans/analysis!queryMonth.action?insCd=${fns:getNmgInsIdCd()}&queryDate=' + queryMonthStr + '&callback=?';
	var incomeDataUrl = '${fns:getTransDataUrl()}/trans/analysis!queryClever.action?insCd=${fns:getNmgInsIdCd()}&callback=?';

	transAtOptions = {
            
        title: {
            text: '分公司日交易趋势',
			x:'center'
        },
        subtitle: {
            text: '交易金额'
        },
        xAxis: {
        	type: 'datetime',
            dateTimeLabelFormats: {
                day: '%m月%d日',
                week: '%m月%d日'
            },
            tickInterval: 5 * 24 * 3600 * 1000
        },
        yAxis: {
            title: {
                text: '金额 (亿元)'
            },
			type:'value'
        },
        // 数据提示框
        tooltip: {
			trigger:'axis',
        },
		toolbox: {
			feature: {
				saveAsImage: {}
			}
		}
        series: [
		{
            name: '上年度',
			type: 'line',
            data: []
        }, {
            name: '本年度',
			type: 'line',
            data: []
        }
		]
     };
    

	transNumOptions = {
                
        chart: {
        	renderTo: 'dailyTransNumContainer',
            type: 'line',
            width: 650,
            style : {
            	fontFamily:'Microsoft YaHei',
            },
            zoomType: 'x',
            events: {
                click: function (event) {
                	window.location.href='${ctx}/branchDailyTransChat';
                }
            }            
        },
        title: {
            text: '分公司日交易趋势'
        },
        subtitle: {
            text: '交易笔数'
        },
        colors: ['#5380CF', '#CF2715', '#5380CF', '#CF2715', '#5380CF', '#CF2715'],
        xAxis: {
        	type: 'datetime',
            dateTimeLabelFormats: {
                day: '%m月%d日',
                week: '%m月%d日'
            },
            tickInterval: 5 * 24 * 3600 * 1000
        },
        yAxis: {
            title: {
                text: '笔数 (万笔)'
            }     
        },
        // 数据提示框
        tooltip: {
            crosshairs: true,
            shared: true,
            valueDecimals: 2,
//            valuePrefix: '$',
            valueSuffix: ' 万笔',
            dateTimeLabelFormats: {
                day: '%m月%d日',
                week: '%m月%d日'
            },
            headerFormat: '<b>{point.x:%m月%e日}</b><br>',
            pointFormat: '<strong>{series.name}:</strong> {point.y} <br>'
        },	        
        credits:{
            enabled:false // 禁用版权信息
        },        
        plotOptions: {
            line: {
                dataLabels: {
                    enabled: false
                },
                enableMouseTracking: true
            }
        },
        series: [{
            name: '上年度',
            data: []
        }, {
            name: '本年度',
            data: []
        }]
    };


	incomeOptions = {
           
        chart: {
        	renderTo: 'dailyIncomeContainer',
            type: 'line',
            width: 650,
            style : {
            	fontFamily:'Microsoft YaHei',
            },
            zoomType: 'x',
            events: {
                click: function (event) {
                	window.location.href='${ctx}/branchDailyTransChat';
                }
            }            
        },
        title: {
            text: '分公司日收入趋势'
        },
        subtitle: {
            text: '收入金额'
        },
        colors: ['#5380CF', '#CF2715', '#5380CF', '#CF2715', '#5380CF', '#CF2715'],
        xAxis: {
        	type: 'datetime',
            dateTimeLabelFormats: {
                day: '%m月%d日',
                week: '%m月%d日'
            },
            tickInterval: 5 * 24 * 3600 * 1000
        },
        yAxis: {
            title: {
                text: '金额 (万元)'
            }     
        },
        // 数据提示框
        tooltip: {
            crosshairs: true,
            shared: true,
            valueDecimals: 2,
//            valuePrefix: '$',
            valueSuffix: ' 万元',
            dateTimeLabelFormats: {
                day: '%m月%d日',
                week: '%m月%d日'
            },
            headerFormat: '<b>{point.x:%m月%e日}</b><br>',
            pointFormat: '<strong>{series.name}:</strong> {point.y} <br>'
        },	        
        credits:{
            enabled:false // 禁用版权信息
        },        
        plotOptions: {
            line: {
                dataLabels: {
                    enabled: false
                },
                enableMouseTracking: true
            }
        },
        series: [{
            name: '上年度',
            data: []
        }, {
            name: '本年度',
            data: []
        }]
  	};     

	
	$.getJSON(dailyTransDataUrl, function (data) {

        var nowYear = data.nowYear + '年';
        var lastYear = data.lastYear + '年';

        transAtOptions.series[0].name = data.lastYear + '年';
        transAtOptions.series[0].data = data.lastYearData.dailyAtTrend;
        transAtOptions.series[1].name = data.nowYear + '年';
        transAtOptions.series[1].data = data.nowYearData.dailyAtTrend;
		
        transNumOptions.series[0].name = data.lastYear + '年';
        transNumOptions.series[0].data = data.lastYearData.dailyNumTrend;
        transNumOptions.series[1].name = data.nowYear + '年';
        transNumOptions.series[1].data = data.nowYearData.dailyNumTrend;

        incomeOptions.series[0].name = data.lastYear + '年';
        incomeOptions.series[0].data = data.lastYearData.incomeDaily;
        incomeOptions.series[1].name = data.nowYear + '年';
        incomeOptions.series[1].data = data.nowYearData.incomeDaily;

		var incomeChart = echarts.init(document.getElementById('dailyIncomeContainer'));
		var transAtChart = echarts.init(document.getElementById('dailyTransAtContainer'));
		var transNumChart = echarts.init(document.getElementById('dailyTransNumContainer'));

		incomeChart.setOption(incomeOptions);
		transAtChart.setOption(transAtOptions);
		transNumChart.setOption(transNumOptions);    	

    });

	$.getJSON(incomeDataUrl, function (data) {

        if(data.incomclever.date){
            var dateStr = data.incomclever.date.substr(4,2) + '月' + data.incomclever.date.substr(6,2) + '日';
        	$('#incomeDiv').html('<span class="line_detail_li">截止' + dateStr + '&nbsp;&nbsp;分公司当月完成收入&nbsp;<b>' + data.incomclever.riverAt.toFixed(2) + '</b>&nbsp;万元&nbsp;&nbsp;当年累计收入&nbsp;<b>' + data.incomclever.yearAt.toFixed(2) + '</b>&nbsp;万元&nbsp;&nbsp;已完成全年任务&nbsp;<b>' + data.incomclever.taskCompleteScale.toFixed(2) + '%</b>&nbsp;</span>');
        }else{
        	$('#incomeDiv').html('<span class="line_detail_li">分公司收入正在计算中</span>');
        }
       
    }); 
});
</script>
