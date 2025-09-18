CREATE PROCEDURE [dbo].[Marker76]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 


       MERGE INTO [dbo].[HtmlTemplates] AS Target 
        USING ( VALUES 
                 ('BurndownTemplate',
                  '<!DOCTYPE html>
        <head>
          <meta charset="utf-8">
          <script src="https://d3js.org/d3.v4.min.js"></script>
          <style>
            body { margin:0;position:fixed;top:0;right:0;bottom:0;left:0; }
            
            .line {
              fill: none;
              stroke: steelblue;
              stroke-width: 1.5px;
        }
        .h1 {
          font: 200 1.2em "Segoe UI Light", "DejaVu Sans", "Trebuchet MS", Verdana, sans-serif;
          font-weight: bold;
          padding: 20px;
          margin: 0;
          border-bottom: 10px solid #ccc;
          strong {
            font-family: "Segoe UI Black";
            font-weight: bold;
          }
        }
          </style>
        </head>
        
        <body>
          <script>
            
            var svg = d3.select("body").append("svg")
              .attr("width", 850)
              .attr("height", 400)
        
            var margin = {left:50, right:30, top: 60, bottom: 60}
            var width = svg.attr("width") - margin.left - margin.right;
            var height = svg.attr("height") - margin.bottom - margin.top;
            
               var data = ##burndownChartJson## 
            var x = d3.scaleTime()
            	.rangeRound([0, width]);
            var x_axis = d3.axisBottom(x);
            
            var y = d3.scaleLinear()
            	.rangeRound([height, 0]);
            var y_axis = d3.axisBottom(y);
            var xFormat = "%d-%b-%Y";;
            var parseTime = d3.timeParse("%d/%m/%Y");
            
            x.domain(d3.extent(data, function(d) { return parseTime(d.date); }));
          	y.domain([0, ##yMax##]);
        
            var a = function(d) {return d.expected};
            
            var multiline = function(category) {
              var line = d3.line()
                          .x(function(d) { return x(parseTime(d.date)); })
                          .y(function(d) { return y(d[category]); });
              return line;
            }
            
           
        
            var categories = [''expected'', ''actual'', ''c'', ''d''];
            //var color = d3.scale.category10();  // escala com 10 cores (category10)
            var color = d3.scaleOrdinal(d3.schemeCategory10);
            
            var g = svg.append("g")
                .attr("transform",
                  "translate(" + margin.left + "," + margin.top + ")");
            
            for (i in categories) {
              var lineFunction = multiline(categories[i]);
              g.append("path")
                .datum(data) 
                .attr("class", "line")
                .style("stroke", color(i))
                .attr("d", lineFunction);
            }
            
              // Add the X Axis
          		g.append("g")
              .attr("transform", "translate(0," + height + ")")
              .call(d3.axisBottom(x).ticks(d3.timeDay.every(1)).tickFormat(d3.timeFormat(xFormat)))
            .selectAll("text")
            .attr("transform", "translate(-20,10)rotate(-45)");
            
        	
              // Add the Y Axis
          		g.append("g")
              .call(d3.axisLeft(y));
        	  
        	  svg.append("text")
        		.attr("class", "h1")
        		.attr("text-anchor", "end")
        		.attr("y", 25)
        		.attr("x", 500)
        		.attr("dy", "0.75em")
        		.text("Work burn down");
        
          </script>
        </body>',@CompanyId)
        ,('AssetsTemplate',
        '<!DOCTYPE html>
        <html>
        <head>
        <link href="https://fonts.googleapis.com/css?family=Roboto&display=swap" rel="stylesheet">
        <style>
        #para{font-family: "Roboto", sans-serif;font-weight:bold;font-size:15px;padding-left:0px}
        #para1{float: right;margin-top:80px;margin-right:80px;font-size: 14px;font-family: "Roboto", sans-serif;}
        .a{border: 1px solid #dddddd;text-align: left;padding: 6px ;width:80%;font-family:"Roboto", sans-serif;border-collapse: collapse}
        .b{border: 1px solid #dddddd;text-align: left;padding: 6px ;width:8%;font-family:"Roboto", sans-serif;border-collapse: collapse;font-size:15px;font-weight: 400;word-break:break-word}
        img{position:absolute;left:80px;top:50px;height:50px;width:200px}
        table { page-break-inside:auto }
        tr    { page-break-inside:avoid; page-break-after:auto }
        thead { display:table-header-group }
        tfoot { display:table-footer-group }
        @page :left {margin-top: 1cm;}
        </style>
        </head>
        <body>
        ##assetsListJson##
        <p id="para1">Signature</p>
        </body></html>',@CompanyId)
        ,('SplitBarChartTemplate',
        '<!DOCTYPE html>
        <meta charset="utf-8"> 
        <head>
        
        </head>
        
        <script src="https://d3js.org/d3.v4.js"></script>
        
        
        <div id="chart"></div>
        
        <div id="tooltip"></div>
        
        <script src="https://d3js.org/d3-scale-chromatic.v1.min.js"></script>
        
        
        <script>
        var maxProd = 1;
        
        var myData = [];
        var dataFromDB = ##splitBarChartJson##;
        var subGroups = [];
        
        convertDataToD3Format(dataFromDB);
        createChart(dataFromDB);
        
        function convertDataToD3Format(data) {
                var dataSet = data;
        		var maxProdValue = [];
                if (dataSet && dataSet.length > 0) {
                    dataSet.forEach(x => {
                        var obj = {};
                        var names = x.ConfigurationName.split(",");
                        var values = x.ConfigurationTime.split(",");
                        obj["dateName"] = x.DateName;
                        obj["originalSpentTime"] = x.OriginalSpentTime;
        				obj["bugsCountText"] = x.BugsCountText;
                        names.forEach((y, i) => {
                            obj[y] = values[i];
        					maxProdValue.push(parseFloat(values[i]));
                        });
        				maxProdValue.push(x.OriginalSpentTime);
                        myData.push(obj);
                    });
        			subGroups = dataSet[0].ConfigurationName.split(",");
                    maxProd = Math.max(...maxProdValue);
        			if (maxProd == 0)
        				maxProd = 1;
                }
        		else
        			maxProd = 1;
            }
        
        function createChart(data) {
        		var color = d3.scaleOrdinal()
        						.domain(subGroups)
        						.range(["blue","#d2691e","orange","#6554c0","red","#ff5630","#00b8d9","#04fe02","#757575"]);
        	
        		var stackedData = d3.stack()
        							.keys(subGroups)	
        							(myData)						
                d3.select("#chart").select("svg").remove();
                var margin = { top: 30, right: 30, bottom: 70, left: 60 },
                    width = 360 - margin.left - margin.right,
                    height = 300 - margin.top - margin.bottom;
        
                var tooltip = d3.select("#toolTip").attr("class", "toolTip");
        
                var svg = d3.select("#chart")
                    .classed("svg-container", true)
                    .append("svg")
                    .attr("preserveAspectRatio", "xMinYMin meet")
                    .attr("viewBox", "0 0 900 400")
                    .classed("svg-content-responsive", true)
                    .append("g")
                    .attr("transform",
                        "translate(280,30)");
        
                var x = d3.scaleBand()
                    .range([0, width])
                    .domain(myData.map(function (d) { return d.dateName; }))
                    .padding(0.4);
        
                svg.append("g")
                    .attr("transform", "translate(0,200)")
                    .call(d3.axisBottom(x))
                    .selectAll("text")
                    .attr("transform", "translate(-10,0)rotate(-45)")
                    .style("text-anchor", "end");
        
                svg.append("text")
                    .attr("x", 135)
                    .attr("y", 270)
                    .style("text-anchor", "middle")
                    .text("Time period");
        		
        		// Right side text
        		svg.append("text")
                    .attr("x", 365)
                    .attr("y", 20)
                    .style("text-anchor", "middle")
        			.style("font-size","8")
                    .text("Original spent time")
        			.attr("fill","green");
        		// Right side text
        		svg.append("text")
                    .attr("x", 362)
                    .attr("y", 35)
                    .style("text-anchor", "middle")
        			.style("font-size","8")
                    .text("Test case created/updated")
        			.attr("fill","blue");
        		// Right side text
        		svg.append("text")
                    .attr("x", 362)
                    .attr("y", 50)
                    .style("text-anchor", "middle")
        			.style("font-size","8")
                    .text("Scenario created/updated")
        			.attr("fill","#d2691e");
        		// Right side text
        		svg.append("text")
                    .attr("x", 362)
                    .attr("y", 65)
                    .style("text-anchor", "middle")
        			.style("font-size","8")
                    .text("Run created/updated")
        			.attr("fill","orange");
        		// Right side text
        		svg.append("text")
                    .attr("x", 362)
                    .attr("y", 80)
                    .style("text-anchor", "middle")
        			.style("font-size","8")
                    .text("Test case status updated")
        			.attr("fill","#6554c0");
        		// Right side text
        		svg.append("text")
                    .attr("x", 362)
                    .attr("y", 95)
                    .style("text-anchor", "middle")
        			.style("font-size","8")
                    .text("Bugs created/updated")
        			.attr("fill","red");
        		// Right side text
        		svg.append("text")
                    .attr("x", 362)
                    .attr("y", 110)
                    .style("text-anchor", "middle")
        			.style("font-size","8")
                    .text("Version created/updated")
        			.attr("fill","#ff5630");
        		// Right side text
        		svg.append("text")
                    .attr("x", 362)
                    .attr("y", 125)
                    .style("text-anchor", "middle")
        			.style("font-size","8")
                    .text("Test report created/updated")
        			.attr("fill","#00b8d9");
        		// Right side text
        		svg.append("text")
                    .attr("x", 362)
                    .attr("y", 140)
                    .style("text-anchor", "middle")
        			.style("font-size","8")
                    .text("Test case viewed")
        			.attr("fill","#04fe02");
        		// Right side text
        		svg.append("text")
                    .attr("x", 362)
                    .attr("y", 155)
                    .style("text-anchor", "middle")
        			.style("font-size","8")
                    .text("Scenario section created/updated")
        			.attr("fill","#757575");
        		// Right side text
        		svg.append("text")
                    .attr("x", 362)
                    .attr("y", 170)
                    .style("text-anchor", "middle")
        			.style("font-size","8")
                    .text("Bugs created today")
        			.attr("fill","red");
        		// Right side text
        		svg.append("text")
                    .attr("x", 362)
                    .attr("y", 185)
                    .style("text-anchor", "middle")
        			.style("font-size","8")
                    .text(data[0].BugsCountText)
        			.attr("fill","red");
        
                var y = d3.scaleLinear()
                    .domain([0, maxProd])
                    .range([height, 0]);
        
                svg.append("g")
                    .call(d3.axisLeft(y));
        
                svg.append("text")
                    .attr("transform", "rotate(-90)")
                    .attr("y", -50)
                    .attr("x", -105)
                    .attr("dy", "1em")
                    .style("text-anchor", "middle")
                    .text("Effective spent time (hr)");
        		
        		svg.selectAll("mybar1")
                    .data(myData)
                    .enter()
                    .append("rect")
                    .attr("x", function (d) { 
        				return x(d["dateName"]); 
        				})
                    .attr("y", function (d) { 
        				return y(0); 
        				})
                    .attr("width", 10)
                    .attr("height", function (d) { 
        				return height - y(0); 
        				})
                    .attr("fill", "green")
        
        		// Tooltip
                svg.selectAll("rect")
                    .data(myData)
                    .on("mousemove", function (d) {
                        tooltip
                            .style("left", d3.event.pageX - 50 + "px")
                            .style("top", d3.event.pageY - 70 + "px")
                            .style("display", "inline-block")
                            .html(("Day: " + d["dateName"]) + "<br>" + "Effective spent time: " + (d["originalSpentTime"]));
                    })
                    .on("mouseout", function (d) { tooltip.style("display", "none"); });
        
                svg.selectAll("rect")
                    .attr("y", function (d) { return y(d["originalSpentTime"]); })
                    .attr("height", function (d) { return height - y(d["originalSpentTime"]); })
        			
        
        		// Show the bars			
        			svg.append("g")
        				.selectAll("g")
        				.data(stackedData)
        				.enter().append("g")
        				.attr("fill", function(d) { 
        					return color(d.key); 
        				})
        				.selectAll("rect")
        				.data(function(d) { 
        					return d; 
        				})
        				.enter().append("rect")
        				.attr("x", function(d) { 
        					return x(d.data.dateName); 
        				})
        				.attr("y", function(d) { 
        					return y(d[1]); 
        				})
        				.attr("height", function(d) { 
        					return y(d[0]) - y(d[1]); 
        				})
        				.attr("width",10)
        				.attr("transform",
                        "translate(11,0)")
            }
        </script>',@CompanyId),
        ('ResetPasswordTemplate',
        '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
        <html xmlns="http://www.w3.org/1999/xhtml">
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
            <!--[if !mso]><!-->
            <meta http-equiv="X-UA-Compatible" content="IE=edge" />
            <!--<![endif]-->
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title></title>
            <style type="text/css">
                * {
                    -webkit-font-smoothing: antialiased;
                }
        
                body {
                    Margin: 0;
                    padding: 0;
                    min-width: 100%;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                    mso-line-height-rule: exactly;
                }
        
                table {
                    border-spacing: 0;
                    color: #333333;
                    font-family: Arial, sans-serif;
                }
        
                img {
                    border: 0;
                }
        
                .wrapper {
                    width: 100%;
                    table-layout: fixed;
                    -webkit-text-size-adjust: 100%;
                    -ms-text-size-adjust: 100%;
                }
        
                .webkit {
                    max-width: 600px;
                }
        
                .outer {
                    Margin: 0 auto;
                    width: 100%;
                    max-width: 600px;
                }
        
                .full-width-image img {
                    width: 100%;
                    max-width: 600px;
                    height: auto;
                }
        
                .inner {
                    padding: 10px;
                }
        
                p {
                    Margin: 0;
                    padding-bottom: 10px;
                }
        
                .h1 {
                    font-size: 21px;
                    font-weight: bold;
                    Margin-top: 15px;
                    Margin-bottom: 5px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .h2 {
                    font-size: 18px;
                    font-weight: bold;
                    Margin-top: 10px;
                    Margin-bottom: 5px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .one-column .contents {
                    text-align: left;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .one-column p {
                    font-size: 14px;
                    Margin-bottom: 10px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .two-column {
                    text-align: center;
                    font-size: 0;
                }
        
                    .two-column .column {
                        width: 100%;
                        max-width: 300px;
                        display: inline-block;
                        vertical-align: top;
                    }
        
                .contents {
                    width: 100%;
                }
        
                .two-column .contents {
                    font-size: 14px;
                    text-align: left;
                }
        
                .two-column img {
                    width: 100%;
                    max-width: 280px;
                    height: auto;
                }
        
                .two-column .text {
                    padding-top: 10px;
                }
        
                .three-column {
                    text-align: center;
                    font-size: 0;
                    padding-top: 10px;
                    padding-bottom: 10px;
                }
        
                    .three-column .column {
                        width: 100%;
                        max-width: 200px;
                        display: inline-block;
                        vertical-align: top;
                    }
        
                    .three-column .contents {
                        font-size: 14px;
                        text-align: center;
                    }
        
                    .three-column img {
                        width: 100%;
                        max-width: 180px;
                        height: auto;
                    }
        
                    .three-column .text {
                        padding-top: 10px;
                    }
        
                .img-align-vertical img {
                    display: inline-block;
                    vertical-align: middle;
                }
        
                @@media only screen and (max-device-width: 480px) {
                    table[class=hide], img[class=hide], td[class=hide] {
                        display: none !important;
                    }
        
                    .contents1 {
                        width: 100%;
                    }
        
                    .contents1 {
                        width: 100%;
                    }
                }
            </style>
        </head>
        <body style="Margin:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;min-width:100%;background-color:#f3f2f0;">
            <center class="wrapper" style="width:100%;table-layout:fixed;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#f3f2f0;">
                <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#f3f2f0;" bgcolor="#f3f2f0;">
                    <tr>
                        <td width="100%">
                            <div class="webkit" style="max-width:600px;Margin:0 auto;">
                                <table class="outer" align="center" cellpadding="0" cellspacing="0" border="0" style="border-spacing:0;Margin:0 auto;width:100%;max-width:600px;">
                                    <tr>
                                        <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;">
                                            <table border="0" width="100%" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td>
                                                        <table style="width:100%;" cellpadding="0" cellspacing="0" border="0">
                                                            <tbody>
                                                                <tr>
                                                                    <td align="center">
                                                                        <center>
                                                                            <table border="0" align="center" width="100%" cellpadding="0" cellspacing="0" style="Margin: 0 auto;">
                                                                                <tbody>
                                                                                    <tr>
                                                                                        <td class="one-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;" bgcolor="#FFFFFF">
                                                                                            <table cellpadding="0" cellspacing="0" border="0" width="100%" bgcolor="#f3f2f0">
                                                                                                <tr>
                                                                                                    <td class="two-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;text-align:left;font-size:0;">
                                                                                                        <div class="column" style="max-width:150px;height:11px;display:inline-block;vertical-align:top;">
                                                                                                            <table class="contents" style="border-spacing:0; width:100%">
                                                                                                                <tr>
                                                                                                                    <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:5px;" align="left"><a href="#" target="_blank"><img src="https://bviewstorage.blob.core.windows.net/5cfabe47-dd1d-454b-8a71-72580aa92ad4/localsiteuploads/54910103-9ebe-4020-a347-4be1cbfc36be/snovasys-5ac4c12f-20b1-425f-b550-076cf851f59e.png" alt="" width="60" height="60" style="border-width:0; height:auto; display:block" align="left" /></a></td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </div>
                                                                                                        <div class="column" style="width:100%;max-width:518px;display:inline-block;vertical-align:top;">
                                                                                                            <table width="100" style="border-spacing:0" cellpadding="0" cellspacing="0" border="0">
                                                                                                                <tr>
                                                                                                                    <td class="inner" style="padding-top:0px;padding-bottom:10px; padding-right:10px;padding-left:10px;">
                                                                                                                        <table class="contents" style="border-spacing:0; width:100%" cellpadding="0" cellspacing="0" border="0">
                                                                                                                            <tr>
                                                                                                                                <td align="left" valign="top">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr></tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </div>
                                                                                                    </td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td>&nbsp;</td>
                                                                                                </tr>
                                                                                            </table>
                                                                                        </td>
                                                                                    </tr>
                                                                                </tbody>
                                                                            </table>
                                                                        </center>
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                            <table class="one-column" border="0" cellpadding="0" cellspacing="0" width="100%" style="border-spacing:0; border-left:1px solid #e8e7e5; border-right:1px solid #e8e7e5; border-bottom:1px solid #e8e7e5; border-top:1px solid #e8e7e5" bgcolor="#FFFFFF">
                                                <tr>
                                                    <td align="left" style="padding:50px 50px 50px 50px">
                                                        <p style="color:#262626; font-size:24px; text-align:left; font-family: Verdana, Geneva, sans-serif"><h2>Dear ##userName##,</h2></p>
                                                        <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                            Please reset your password by clicking on the below button.<br />
                                                            <br />
                                                            <br />
                                                        </p>
                                                        <table border="0" align="left" cellpadding="0" cellspacing="0" style="Margin:0 auto;">
                                                            <tbody>
                                                                <tr>
                                                                    <td align="center">
                                                                        <table border="0" cellpadding="0" cellspacing="0" style="Margin:0 auto;">
                                                                            <tr>
                                                                                <td width="250" height="60" align="center" bgcolor="#009999" style="-moz-border-radius: 30px; -webkit-border-radius: 30px; border-radius: 30px;"><a href= "##resetPasswordLink##" style="width:250px; display:block; text-decoration:none; border:0; text-align:center; font-weight:bold;font-size:18px; font-family: Arial, sans-serif; color: #ffffff">Reset Password</a></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                        <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                            <br />
                                                            <br />
                                                            <br />
                                                            <br />
                                                            <br />
                                                            Best Regards, <br />
                                                            ##footerName##
                                                        </p>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                </table>
            </center>
        </body>
        </html>',@CompanyId),
        ('CompanyRegistrationTemplate'
        ,'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
        <html xmlns="http://www.w3.org/1999/xhtml">
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
            <!--[if !mso]><!-->
            <meta http-equiv="X-UA-Compatible" content="IE=edge" />
            <!--<![endif]-->
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title></title>
            <style type="text/css">
                * {
                    -webkit-font-smoothing: antialiased;
                }
        
                body {
                    Margin: 0;
                    padding: 0;
                    min-width: 100%;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                    mso-line-height-rule: exactly;
                }
        
                table {
                    border-spacing: 0;
                    color: #333333;
                    font-family: Arial, sans-serif;
                }
        
                img {
                    border: 0;
                }
        
                .wrapper {
                    width: 100%;
                    table-layout: fixed;
                    -webkit-text-size-adjust: 100%;
                    -ms-text-size-adjust: 100%;
                }
        
                .webkit {
                    max-width: 600px;
                }
        
                .outer {
                    Margin: 0 auto;
                    width: 100%;
                    max-width: 600px;
                }
        
                .full-width-image img {
                    width: 100%;
                    max-width: 600px;
                    height: auto;
                }
        
                .inner {
                    padding: 10px;
                }
        
                p {
                    Margin: 0;
                    padding-bottom: 10px;
                }
        
                .h1 {
                    font-size: 21px;
                    font-weight: bold;
                    Margin-top: 15px;
                    Margin-bottom: 5px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .h2 {
                    font-size: 18px;
                    font-weight: bold;
                    Margin-top: 10px;
                    Margin-bottom: 5px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .one-column .contents {
                    text-align: left;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .one-column p {
                    font-size: 14px;
                    Margin-bottom: 10px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .two-column {
                    text-align: center;
                    font-size: 0;
                }
        
                    .two-column .column {
                        width: 100%;
                        max-width: 300px;
                        display: inline-block;
                        vertical-align: top;
                    }
        
                .contents {
                    width: 100%;
                }
        
                .two-column .contents {
                    font-size: 14px;
                    text-align: left;
                }
        
                .two-column img {
                    width: 100%;
                    max-width: 280px;
                    height: auto;
                }
        
                .two-column .text {
                    padding-top: 10px;
                }
        
                .three-column {
                    text-align: center;
                    font-size: 0;
                    padding-top: 10px;
                    padding-bottom: 10px;
                }
        
                    .three-column .column {
                        width: 100%;
                        max-width: 200px;
                        display: inline-block;
                        vertical-align: top;
                    }
        
                    .three-column .contents {
                        font-size: 14px;
                        text-align: center;
                    }
        
                    .three-column img {
                        width: 100%;
                        max-width: 180px;
                        height: auto;
                    }
        
                    .three-column .text {
                        padding-top: 10px;
                    }
        
                .img-align-vertical img {
                    display: inline-block;
                    vertical-align: middle;
                }
        
                @@media only screen and (max-device-width: 480px) {
                    table[class=hide], img[class=hide], td[class=hide] {
                        display: none !important;
                    }
        
                    .contents1 {
                        width: 100%;
                    }
        
                    .contents1 {
                        width: 100%;
                    }
                }
            </style>
        </head>
        <body style="Margin:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;min-width:100%;background-color:#f3f2f0;">
            <center class="wrapper" style="width:100%;table-layout:fixed;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#f3f2f0;">
                <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#f3f2f0;" bgcolor="#f3f2f0;">
                    <tr>
                        <td width="100%">
                            <div class="webkit" style="max-width:600px;Margin:0 auto;">
                                <table class="outer" align="center" cellpadding="0" cellspacing="0" border="0" style="border-spacing:0;Margin:0 auto;width:100%;max-width:600px;">
                                    <tr>
                                        <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;">
                                            <table border="0" width="100%" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td>
                                                        <table style="width:100%;" cellpadding="0" cellspacing="0" border="0">
                                                            <tbody>
                                                                <tr>
                                                                    <td align="center">
                                                                        <center>
                                                                            <table border="0" align="center" width="100%" cellpadding="0" cellspacing="0" style="Margin: 0 auto;">
                                                                                <tbody>
                                                                                    <tr>
                                                                                        <td class="one-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;" bgcolor="#FFFFFF">
                                                                                            <table cellpadding="0" cellspacing="0" border="0" width="100%" bgcolor="#f3f2f0">
                                                                                                <tr>
                                                                                                    <td class="two-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;text-align:left;font-size:0;">
                                                                                                        <div class="column" style="max-width:150px;height:11px;display:inline-block;vertical-align:top;">
                                                                                                            <table class="contents" style="border-spacing:0; width:100%">
                                                                                                                <tr>
                                                                                                                    <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:5px;" align="left">
                                                                                                                        @*<a href="#" target="_blank"><img src="https://bviewstorage.blob.core.windows.net/5cfabe47-dd1d-454b-8a71-72580aa92ad4/localsiteuploads/54910103-9ebe-4020-a347-4be1cbfc36be/snovasys-5ac4c12f-20b1-425f-b550-076cf851f59e.png" alt="" width="60" height="60" style="border-width:0; height:auto; display:block" align="left" /></a>*@
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </div>
                                                                                                        <div class="column" style="width:100%;max-width:518px;display:inline-block;vertical-align:top;">
                                                                                                            <table width="100" style="border-spacing:0" cellpadding="0" cellspacing="0" border="0">
                                                                                                                <tr>
                                                                                                                    <td class="inner" style="padding-top:0px;padding-bottom:10px; padding-right:10px;padding-left:10px;">
                                                                                                                        <table class="contents" style="border-spacing:0; width:100%" cellpadding="0" cellspacing="0" border="0">
                                                                                                                            <tr>
                                                                                                                                <td align="left" valign="top">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr></tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </div>
                                                                                                    </td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td>&nbsp;</td>
                                                                                                </tr>
                                                                                            </table>
                                                                                        </td>
                                                                                    </tr>
                                                                                </tbody>
                                                                            </table>
                                                                        </center>
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                            <table class="one-column" border="0" cellpadding="0" cellspacing="0" width="100%" style="border-spacing:0; border-left:1px solid #e8e7e5; border-right:1px solid #e8e7e5; border-bottom:1px solid #e8e7e5; border-top:1px solid #e8e7e5" bgcolor="#FFFFFF">
                                                <tr>
                                                    <td align="left" style="padding:50px 50px 50px 50px">
                                                        <p style="color:#262626; font-size:24px; text-align:left; font-family: Verdana, Geneva, sans-serif"><h2>Dear ##ToName##,</h2></p>
                                                        <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                            Thank you for choosing Snovasys Business Suite to grow your business.Hope you have a great success in the coming future.<a target="_blank" href="##siteAddress##" style="color: #099">Click here</a> to go to your site.<br />
                                                            <br />
                                                        </p>
                                                        <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                            Best Regards, <br />
                                                            ##footerName##
                                                        </p>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                </table>
            </center>
        </body>
        </html>',@CompanyId),
        ('CompanyRegistrationDemoDataTemplate'
        ,'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
        <html xmlns="http://www.w3.org/1999/xhtml">
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
            <!--[if !mso]><!-->
            <meta http-equiv="X-UA-Compatible" content="IE=edge" />
            <!--<![endif]-->
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title></title>
            <style type="text/css">
                * {
                    -webkit-font-smoothing: antialiased;
                }
        
                body {
                    Margin: 0;
                    padding: 0;
                    min-width: 100%;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                    mso-line-height-rule: exactly;
                }
        
                table {
                    border-spacing: 0;
                    color: #333333;
                    font-family: Arial, sans-serif;
                }
        
                img {
                    border: 0;
                }
        
                .wrapper {
                    width: 100%;
                    table-layout: fixed;
                    -webkit-text-size-adjust: 100%;
                    -ms-text-size-adjust: 100%;
                }
        
                .webkit {
                    max-width: 600px;
                }
        
                .outer {
                    Margin: 0 auto;
                    width: 100%;
                    max-width: 600px;
                }
        
                .full-width-image img {
                    width: 100%;
                    max-width: 600px;
                    height: auto;
                }
        
                .inner {
                    padding: 10px;
                }
        
                p {
                    Margin: 0;
                    padding-bottom: 10px;
                }
        
                .h1 {
                    font-size: 21px;
                    font-weight: bold;
                    Margin-top: 15px;
                    Margin-bottom: 5px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .h2 {
                    font-size: 18px;
                    font-weight: bold;
                    Margin-top: 10px;
                    Margin-bottom: 5px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .one-column .contents {
                    text-align: left;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .one-column p {
                    font-size: 14px;
                    Margin-bottom: 10px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .two-column {
                    text-align: center;
                    font-size: 0;
                }
        
                    .two-column .column {
                        width: 100%;
                        max-width: 300px;
                        display: inline-block;
                        vertical-align: top;
                    }
        
                .contents {
                    width: 100%;
                }
        
                .two-column .contents {
                    font-size: 14px;
                    text-align: left;
                }
        
                .two-column img {
                    width: 100%;
                    max-width: 280px;
                    height: auto;
                }
        
                .two-column .text {
                    padding-top: 10px;
                }
        
                .three-column {
                    text-align: center;
                    font-size: 0;
                    padding-top: 10px;
                    padding-bottom: 10px;
                }
        
                    .three-column .column {
                        width: 100%;
                        max-width: 200px;
                        display: inline-block;
                        vertical-align: top;
                    }
        
                    .three-column .contents {
                        font-size: 14px;
                        text-align: center;
                    }
        
                    .three-column img {
                        width: 100%;
                        max-width: 180px;
                        height: auto;
                    }
        
                    .three-column .text {
                        padding-top: 10px;
                    }
        
                .img-align-vertical img {
                    display: inline-block;
                    vertical-align: middle;
                }
        
                @@media only screen and (max-device-width: 480px) {
                    table[class=hide], img[class=hide], td[class=hide] {
                        display: none !important;
                    }
        
                    .contents1 {
                        width: 100%;
                    }
        
                    .contents1 {
                        width: 100%;
                    }
                }
            </style>
        </head>
        <body style="Margin:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;min-width:100%;background-color:#f3f2f0;">
            <center class="wrapper" style="width:100%;table-layout:fixed;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#f3f2f0;">
                <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#f3f2f0;" bgcolor="#f3f2f0;">
                    <tr>
                        <td width="100%">
                            <div class="webkit" style="max-width:600px;Margin:0 auto;">
                                <table class="outer" align="center" cellpadding="0" cellspacing="0" border="0" style="border-spacing:0;Margin:0 auto;width:100%;max-width:600px;">
                                    <tr>
                                        <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;">
                                            <table border="0" width="100%" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td>
                                                        <table style="width:100%;" cellpadding="0" cellspacing="0" border="0">
                                                            <tbody>
                                                                <tr>
                                                                    <td align="center">
                                                                        <center>
                                                                            <table border="0" align="center" width="100%" cellpadding="0" cellspacing="0" style="Margin: 0 auto;">
                                                                                <tbody>
                                                                                    <tr>
                                                                                        <td class="one-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;" bgcolor="#FFFFFF">
                                                                                            <table cellpadding="0" cellspacing="0" border="0" width="100%" bgcolor="#f3f2f0">
                                                                                                <tr>
                                                                                                    <td class="two-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;text-align:left;font-size:0;">
                                                                                                        <div class="column" style="max-width:150px;height:11px;display:inline-block;vertical-align:top;">
                                                                                                            <table class="contents" style="border-spacing:0; width:100%">
                                                                                                                <tr>
                                                                                                                    <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:5px;" align="left">
                                                                                                                    @*<a href="#" target="_blank"><img src="https://bviewstorage.blob.core.windows.net/5cfabe47-dd1d-454b-8a71-72580aa92ad4/localsiteuploads/54910103-9ebe-4020-a347-4be1cbfc36be/snovasys-5ac4c12f-20b1-425f-b550-076cf851f59e.png" alt="" width="60" height="60" style="border-width:0; height:auto; display:block" align="left" /></a>*@
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </div>
                                                                                                        <div class="column" style="width:100%;max-width:518px;display:inline-block;vertical-align:top;">
                                                                                                            <table width="100" style="border-spacing:0" cellpadding="0" cellspacing="0" border="0">
                                                                                                                <tr>
                                                                                                                    <td class="inner" style="padding-top:0px;padding-bottom:10px; padding-right:10px;padding-left:10px;">
                                                                                                                        <table class="contents" style="border-spacing:0; width:100%" cellpadding="0" cellspacing="0" border="0">
                                                                                                                            <tr>
                                                                                                                                <td align="left" valign="top">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr></tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </div>
                                                                                                    </td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td>&nbsp;</td>
                                                                                                </tr>
                                                                                            </table>
                                                                                        </td>
                                                                                    </tr>
                                                                                </tbody>
                                                                            </table>
                                                                        </center>
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                            <table class="one-column" border="0" cellpadding="0" cellspacing="0" width="100%" style="border-spacing:0; border-left:1px solid #e8e7e5; border-right:1px solid #e8e7e5; border-bottom:1px solid #e8e7e5; border-top:1px solid #e8e7e5" bgcolor="#FFFFFF">
                                                <tr>
                                                    <td align="left" style="padding:50px 50px 50px 50px">
                                                        <p style="color:#262626; font-size:24px; text-align:left; font-family: Verdana, Geneva, sans-serif"><h2>Dear ##ToName##,</h2></p>
                                                        <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                            Thank you for choosing Snovasys Business Suite to grow your business.Hope you have a great success in the coming future.We are creating your site, once it is finished, we will let you know.Please go through the below link and find the terms and conditions of Snovasys Business Suite<br />
                                                            <br />
                                                            <br />
                                                        </p>
                                                        <table border="0" align="left" cellpadding="0" cellspacing="0" style="Margin:0 auto;">
                                                            <tbody>
                                                                <tr>
                                                                    <td align="center">
                                                                        <table border="0" cellpadding="0" cellspacing="0" style="Margin:0 auto;">
                                                                            <tr>
                                                                                <td width="250" height="60" align="center" bgcolor="#009999" style="-moz-border-radius: 30px; -webkit-border-radius: 30px; border-radius: 30px;"><a href="https://snovasys.com/Documents/SnovasysTerms.pdf" style="width:250px; display:block; text-decoration:none; border:0; text-align:center; font-weight:bold;font-size:18px; font-family: Arial, sans-serif; color: #ffffff">Terms and Conditions</a></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                        <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                            <br />
                                                            <br />
                                                            <br />
                                                            <br />
                                                            <br />
                                                            Best Regards, <br />
                                                            ##footerName##
                                                        </p>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                </table>
            </center>
        </body>
        </html>',@CompanyId),
        ('TestRailReportTemplate'
        ,'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
        <html xmlns="http://www.w3.org/1999/xhtml">
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
            <!--[if !mso]><!-->
            <meta http-equiv="X-UA-Compatible" content="IE=edge" />
            <!--<![endif]-->
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title></title>
            <style type="text/css">
                * {
                    -webkit-font-smoothing: antialiased;
                }
        
                body {
                    Margin: 0;
                    padding: 0;
                    min-width: 100%;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                    mso-line-height-rule: exactly;
                }
        
                table {
                    border-spacing: 0;
                    color: #333333;
                    font-family: Arial, sans-serif;
                }
        
                img {
                    border: 0;
                }
        
                .wrapper {
                    width: 100%;
                    table-layout: fixed;
                    -webkit-text-size-adjust: 100%;
                    -ms-text-size-adjust: 100%;
                }
        
                .webkit {
                    max-width: 600px;
                }
        
                .outer {
                    Margin: 0 auto;
                    width: 100%;
                    max-width: 600px;
                }
        
                .full-width-image img {
                    width: 100%;
                    max-width: 600px;
                    height: auto;
                }
        
                .inner {
                    padding: 10px;
                }
        
                p {
                    Margin: 0;
                    padding-bottom: 10px;
                }
        
                .h1 {
                    font-size: 21px;
                    font-weight: bold;
                    Margin-top: 15px;
                    Margin-bottom: 5px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .h2 {
                    font-size: 18px;
                    font-weight: bold;
                    Margin-top: 10px;
                    Margin-bottom: 5px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .one-column .contents {
                    text-align: left;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .one-column p {
                    font-size: 14px;
                    Margin-bottom: 10px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .two-column {
                    text-align: center;
                    font-size: 0;
                }
        
                    .two-column .column {
                        width: 100%;
                        max-width: 300px;
                        display: inline-block;
                        vertical-align: top;
                    }
        
                .contents {
                    width: 100%;
                }
        
                .two-column .contents {
                    font-size: 14px;
                    text-align: left;
                }
        
                .two-column img {
                    width: 100%;
                    max-width: 280px;
                    height: auto;
                }
        
                .two-column .text {
                    padding-top: 10px;
                }
        
                .three-column {
                    text-align: center;
                    font-size: 0;
                    padding-top: 10px;
                    padding-bottom: 10px;
                }
        
                    .three-column .column {
                        width: 100%;
                        max-width: 200px;
                        display: inline-block;
                        vertical-align: top;
                    }
        
                    .three-column .contents {
                        font-size: 14px;
                        text-align: center;
                    }
        
                    .three-column img {
                        width: 100%;
                        max-width: 180px;
                        height: auto;
                    }
        
                    .three-column .text {
                        padding-top: 10px;
                    }
        
                .img-align-vertical img {
                    display: inline-block;
                    vertical-align: middle;
                }
        
                .download-button {
                    background-color: #4CAF50;
                    border: none;
                    color: white;
                    padding: 15px 32px;
                    text-align: center;
                    text-decoration: none;
                    display: inline-block;
                    font-size: 16px;
                    margin: 4px 2px;
                    cursor: pointer;
                }
        
                @@media only screen and (max-device-width: 480px) {
                    table[class=hide], img[class=hide], td[class=hide] {
                        display: none !important;
                    }
        
                    .contents1 {
                        width: 100%;
                    }
        
                    .contents1 {
                        width: 100%;
                    }
                }
            </style>
        </head>
        <body style="Margin:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;min-width:100%;background-color:#f3f2f0;">
            <center class="wrapper" style="width:100%;table-layout:fixed;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#f3f2f0;">
                <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#f3f2f0;" bgcolor="#f3f2f0;">
                    <tr>
                        <td width="100%">
                            <div class="webkit" style="max-width:600px;Margin:0 auto;">
                                <table class="outer" align="center" cellpadding="0" cellspacing="0" border="0" style="border-spacing:0;Margin:0 auto;width:100%;max-width:600px;">
                                    <tr>
                                        <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;">
                                            <table border="0" width="100%" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td>
                                                        <table style="width:100%;" cellpadding="0" cellspacing="0" border="0">
                                                            <tbody>
                                                                <tr>
                                                                    <td align="center">
                                                                        <center>
                                                                            <table border="0" align="center" width="100%" cellpadding="0" cellspacing="0" style="Margin: 0 auto;">
                                                                                <tbody>
                                                                                    <tr>
                                                                                        <td class="one-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;" bgcolor="#FFFFFF">
                                                                                            <table cellpadding="0" cellspacing="0" border="0" width="100%" bgcolor="#f3f2f0">
                                                                                                <tr>
                                                                                                    <td class="two-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;text-align:left;font-size:0;">
                                                                                                        <div class="column" style="max-width:150px;height:11px;display:inline-block;vertical-align:top;">
                                                                                                            <table class="contents" style="border-spacing:0; width:100%">
                                                                                                                <tr>
                                                                                                                    <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:5px;" align="left"><a href="#" target="_blank"><img src="https://bviewstorage.blob.core.windows.net/5cfabe47-dd1d-454b-8a71-72580aa92ad4/localsiteuploads/54910103-9ebe-4020-a347-4be1cbfc36be/snovasys-5ac4c12f-20b1-425f-b550-076cf851f59e.png" alt="" width="60" height="60" style="border-width:0; height:auto; display:block" align="left" /></a></td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </div>
                                                                                                        <div class="column" style="width:100%;max-width:518px;display:inline-block;vertical-align:top;">
                                                                                                            <table width="100" style="border-spacing:0" cellpadding="0" cellspacing="0" border="0">
                                                                                                                <tr>
                                                                                                                    <td class="inner" style="padding-top:0px;padding-bottom:10px; padding-right:10px;padding-left:10px;">
                                                                                                                        <table class="contents" style="border-spacing:0; width:100%" cellpadding="0" cellspacing="0" border="0">
                                                                                                                            <tr>
                                                                                                                                <td align="left" valign="top">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr></tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </div>
                                                                                                    </td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td>&nbsp;</td>
                                                                                                </tr>
                                                                                            </table>
                                                                                        </td>
                                                                                    </tr>
                                                                                </tbody>
                                                                            </table>
                                                                        </center>
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                            <table class="one-column" border="0" cellpadding="0" cellspacing="0" width="100%" style="border-spacing:0; border-left:1px solid #e8e7e5; border-right:1px solid #e8e7e5; border-bottom:1px solid #e8e7e5; border-top:1px solid #e8e7e5" bgcolor="#FFFFFF">
                                                <tr>
                                                    <td align="left" style="padding:50px 50px 50px 50px">
                                                        <p style="color:#262626; font-size:24px; text-align:left; font-family: Verdana, Geneva, sans-serif"><h2>Dear User ,</h2></p>
                                                        <p style="color:#000000; font-size:14px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                            The following Testrepo report was sent to you:<br /><br />
                                                            <b>##ReportName##</b><br /><br />
                                                            If the email contains a PDF, after downloading it you can open it in your preferred PDF viewer.<br />
                                                        </p>
                                                        <a class="download-button" href="##PdfUrl##" target="_blank">Click here to download report</a>
                                                        <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                            <br />
                                                            Best Regards, <br />
                                                            ##footerName##
                                                        </p>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                </table>
            </center>
        </body>
        </html>',@CompanyId),
        ('LeaveApplicationTemplate'
        ,'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
        <html xmlns="http://www.w3.org/1999/xhtml">
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
            <!--[if !mso]><!-->
            <meta http-equiv="X-UA-Compatible" content="IE=edge" />
            <!--<![endif]-->
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title></title>
            <style type="text/css">
                * {
                    -webkit-font-smoothing: antialiased;
                }
        
                body {
                    Margin: 0;
                    padding: 0;
                    min-width: 100%;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                    mso-line-height-rule: exactly;
                }
        
                table {
                    border-spacing: 0;
                    color: #333333;
                    font-family: Arial, sans-serif;
                }
        
                img {
                    border: 0;
                }
        
                .wrapper {
                    width: 100%;
                    table-layout: fixed;
                    -webkit-text-size-adjust: 100%;
                    -ms-text-size-adjust: 100%;
                }
        
                .webkit {
                    max-width: 600px;
                }
        
                .outer {
                    Margin: 0 auto;
                    width: 100%;
                    max-width: 600px;
                }
        
                .full-width-image img {
                    width: 100%;
                    max-width: 600px;
                    height: auto;
                }
        
                .inner {
                    padding: 10px;
                }
        
                p {
                    Margin: 0;
                    padding-bottom: 10px;
                }
        
                .h1 {
                    font-size: 21px;
                    font-weight: bold;
                    Margin-top: 15px;
                    Margin-bottom: 5px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .h2 {
                    font-size: 18px;
                    font-weight: bold;
                    Margin-top: 10px;
                    Margin-bottom: 5px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .one-column .contents {
                    text-align: left;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .one-column p {
                    font-size: 14px;
                    Margin-bottom: 10px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .two-column {
                    text-align: center;
                    font-size: 0;
                }
        
                    .two-column .column {
                        width: 100%;
                        max-width: 300px;
                        display: inline-block;
                        vertical-align: top;
                    }
        
                .contents {
                    width: 100%;
                }
        
                .two-column .contents {
                    font-size: 14px;
                    text-align: left;
                }
        
                .two-column img {
                    width: 100%;
                    max-width: 280px;
                    height: auto;
                }
        
                .two-column .text {
                    padding-top: 10px;
                }
        
                .three-column {
                    text-align: center;
                    font-size: 0;
                    padding-top: 10px;
                    padding-bottom: 10px;
                }
        
                    .three-column .column {
                        width: 100%;
                        max-width: 200px;
                        display: inline-block;
                        vertical-align: top;
                    }
        
                    .three-column .contents {
                        font-size: 14px;
                        text-align: center;
                    }
        
                    .three-column img {
                        width: 100%;
                        max-width: 180px;
                        height: auto;
                    }
        
                    .three-column .text {
                        padding-top: 10px;
                    }
        
                .img-align-vertical img {
                    display: inline-block;
                    vertical-align: middle;
                }
        
                .download-button {
                    background-color: #009999;
                    border: none;
                    color: white;
                    padding: 15px 32px;
                    text-align: center;
                    text-decoration: none;
                    display: inline-block;
                    font-size: 16px;
                    margin: 4px 2px;
                    cursor: pointer;
                }
        
                @@media only screen and (max-device-width: 480px) {
                    table[class=hide], img[class=hide], td[class=hide] {
                        display: none !important;
                    }
        
                    .contents1 {
                        width: 100%;
                    }
        
                    .contents1 {
                        width: 100%;
                    }
                }
            </style>
        </head>
        <body style="Margin:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;min-width:100%;background-color:#f3f2f0;">
            <center class="wrapper" style="width:100%;table-layout:fixed;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#f3f2f0;">
                <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#f3f2f0;" bgcolor="#f3f2f0;">
                    <tr>
                        <td width="100%">
                            <div class="webkit" style="max-width:600px;Margin:0 auto;">
                                <table class="outer" align="center" cellpadding="0" cellspacing="0" border="0" style="border-spacing:0;Margin:0 auto;width:100%;max-width:600px;">
                                    <tr>
                                        <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;">
                                            <table border="0" width="100%" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td>
                                                        <table style="width:100%;" cellpadding="0" cellspacing="0" border="0">
                                                            <tbody>
                                                                <tr>
                                                                    <td align="center">
                                                                        <center>
                                                                            <table border="0" align="center" width="100%" cellpadding="0" cellspacing="0" style="Margin: 0 auto;">
                                                                                <tbody>
                                                                                    <tr>
                                                                                        <td class="one-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;" bgcolor="#FFFFFF">
                                                                                            <table cellpadding="0" cellspacing="0" border="0" width="100%" bgcolor="#f3f2f0">
                                                                                                <tr>
                                                                                                    <td class="two-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;text-align:left;font-size:0;">
                                                                                                        <div class="column" style="max-width:150px;height:11px;display:inline-block;vertical-align:top;">
                                                                                                            <table class="contents" style="border-spacing:0; width:100%">
                                                                                                                <tr>
                                                                                                                    <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:5px;" align="left"><a href="#" target="_blank"><img src="https://bviewstorage.blob.core.windows.net/5cfabe47-dd1d-454b-8a71-72580aa92ad4/localsiteuploads/54910103-9ebe-4020-a347-4be1cbfc36be/snovasys-5ac4c12f-20b1-425f-b550-076cf851f59e.png" alt="" width="60" height="60" style="border-width:0; height:auto; display:block" align="left" /></a></td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </div>
                                                                                                        <div class="column" style="width:100%;max-width:518px;display:inline-block;vertical-align:top;">
                                                                                                            <table width="100" style="border-spacing:0" cellpadding="0" cellspacing="0" border="0">
                                                                                                                <tr>
                                                                                                                    <td class="inner" style="padding-top:0px;padding-bottom:10px; padding-right:10px;padding-left:10px;">
                                                                                                                        <table class="contents" style="border-spacing:0; width:100%" cellpadding="0" cellspacing="0" border="0">
                                                                                                                            <tr>
                                                                                                                                <td align="left" valign="top">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr></tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </div>
                                                                                                    </td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td>&nbsp;</td>
                                                                                                </tr>
                                                                                            </table>
                                                                                        </td>
                                                                                    </tr>
                                                                                </tbody>
                                                                            </table>
                                                                        </center>
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                            <table class="one-column" border="0" cellpadding="0" cellspacing="0" width="100%" style="border-spacing:0; border-left:1px solid #e8e7e5; border-right:1px solid #e8e7e5; border-bottom:1px solid #e8e7e5; border-top:1px solid #e8e7e5" bgcolor="#FFFFFF">
                                                <tr>
                                                    <td align="left" style="padding:50px 50px 50px 50px">
                                                        <p style="color:#262626; font-size:24px; text-align:left; font-family: Verdana, Geneva, sans-serif"><h2>Dear sir/madam ,</h2></p>
                                                        <p style="color:#000000; font-size:14px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                            <br />##ToName## has applied leave from ##leaveFromDate## to ##leaveDateTo## for ##NoofDays## day(s)
                                                        </p>
                                                       <div style="width: 100%;text-align: center;">
        													<button class="download-button" target="_blank" style="-moz-border-radius: 30px; -webkit-border-radius: 30px; border-radius: 30px;            background-color: #009999;border: none;color: white;padding: 15px 32px;text-align: center;text-decoration: none;display: inline-block;font-size: 16px;margin: 4px 2px;cursor: pointer; ">
        														<a style="text-decoration:none;text-align:center; font-weight:bold;font-size:18px; font-family: Arial, sans-serif; color: #ffffff"" href="##siteAddress##">Click here to Accept/Decline</a> 
        													</button>      
        												</div>   
                                                        <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                            <br />
                                                            Best Regards, <br />
                                                            BTrak Team
                                                        </p>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                </table>
            </center>
			</body>
        </html>',@CompanyId),
		('AssetNotificationTemplate'
        ,'<!DOCTYPE html
  PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <!--[if !mso]><!-->
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <!--<![endif]-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title></title>
    <style type="text/css">
        * {
            -webkit-font-smoothing: antialiased;
        }
        
        body {
            Margin: 0;
            padding: 0;
            min-width: 100%;
            font-family: Arial, sans-serif;
            -webkit-font-smoothing: antialiased;
            mso-line-height-rule: exactly;
        }
        
        table {
            border-spacing: 0;
            color: #333333;
            font-family: Arial, sans-serif;
        }
        
        img {
            border: 0;
        }
        
        .wrapper {
            width: 100%;
            table-layout: fixed;
            -webkit-text-size-adjust: 100%;
            -ms-text-size-adjust: 100%;
        }
        
        .webkit {
            max-width: 600px;
        }
        
        .outer {
            Margin: 0 auto;
            width: 100%;
            max-width: 600px;
        }
        
        .full-width-image img {
            width: 100%;
            max-width: 600px;
            height: auto;
        }
        
        .inner {
            padding: 10px;
        }
        
        p {
            Margin: 0;
            padding-bottom: 10px;
        }
        
        .h1 {
            font-size: 21px;
            font-weight: bold;
            Margin-top: 15px;
            Margin-bottom: 5px;
            font-family: Arial, sans-serif;
            -webkit-font-smoothing: antialiased;
        }
        
        .h2 {
            font-size: 18px;
            font-weight: bold;
            Margin-top: 10px;
            Margin-bottom: 5px;
            font-family: Arial, sans-serif;
            -webkit-font-smoothing: antialiased;
        }
        
        .one-column .contents {
            text-align: left;
            font-family: Arial, sans-serif;
            -webkit-font-smoothing: antialiased;
        }
        
        .one-column p {
            font-size: 14px;
            Margin-bottom: 10px;
            font-family: Arial, sans-serif;
            -webkit-font-smoothing: antialiased;
        }
        
        .two-column {
            text-align: center;
            font-size: 0;
        }
        
        .two-column .column {
            width: 100%;
            max-width: 300px;
            display: inline-block;
            vertical-align: top;
        }
        
        .contents {
            width: 100%;
        }
        
        .two-column .contents {
            font-size: 14px;
            text-align: left;
        }
        
        .two-column img {
            width: 100%;
            max-width: 280px;
            height: auto;
        }
        
        .two-column .text {
            padding-top: 10px;
        }
        
        .three-column {
            text-align: center;
            font-size: 0;
            padding-top: 10px;
            padding-bottom: 10px;
        }
        
        .three-column .column {
            width: 100%;
            max-width: 200px;
            display: inline-block;
            vertical-align: top;
        }
        
        .three-column .contents {
            font-size: 14px;
            text-align: center;
        }
        
        .three-column img {
            width: 100%;
            max-width: 180px;
            height: auto;
        }
        
        .three-column .text {
            padding-top: 10px;
        }
        
        .img-align-vertical img {
            display: inline-block;
            vertical-align: middle;
        }
        
        .download-button {
            background-color: #009999;
            border: none;
            color: white;
            padding: 15px 32px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 16px;
            margin: 4px 2px;
            cursor: pointer;
        }
        
        @@media only screen and (max-device-width: 480px) {
            table[class=hide], img[class=hide], td[class=hide] {
                display: none !important;
            }
            .contents1 {
                width: 100%;
            }
            .contents1 {
                width: 100%;
            }
        }
    </style>
</head>

<body style="Margin:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;min-width:100%;background-color:#f3f2f0;">
    <center class="wrapper" style="width:100%;table-layout:fixed;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#f3f2f0;">
        <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#f3f2f0;" bgcolor="#f3f2f0;">
            <tr>
                <td width="100%">
                    <div class="webkit" style="max-width:600px;Margin:0 auto;">
                        <table class="outer" align="center" cellpadding="0" cellspacing="0" border="0" style="border-spacing:0;Margin:0 auto;width:100%;max-width:600px;">
                            <tr>
                                <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;">
                                    <table border="0" width="100%" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td>
                                                <table style="width:100%;" cellpadding="0" cellspacing="0" border="0">
                                                    <tbody>
                                                        <tr>
                                                            <td align="center">
                                                                <center>
                                                                    <table border="0" align="center" width="100%" cellpadding="0" cellspacing="0" style="Margin: 0 auto;">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td class="one-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;" bgcolor="#FFFFFF">
                                                                                    <table cellpadding="0" cellspacing="0" border="0" width="100%" bgcolor="#f3f2f0">
                                                                                        <tr>
                                                                                            <td class="two-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;text-align:left;font-size:0;">
                                                                                                <div class="column" style="max-width:150px;height:11px;display:inline-block;vertical-align:top;">
                                                                                                    <table class="contents" style="border-spacing:0; width:100%">
                                                                                                        <tr>
                                                                                                            <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:5px;" align="left">
                                                                                                                <a href="#" target="_blank">
                                                                                                                    <img src="https://bviewstorage.blob.core.windows.net/5cfabe47-dd1d-454b-8a71-72580aa92ad4/localsiteuploads/54910103-9ebe-4020-a347-4be1cbfc36be/snovasys-5ac4c12f-20b1-425f-b550-076cf851f59e.png" alt="" width="60" height="60" style="border-width:0; height:auto; display:block" align="left" />
                                                                                                                </a>
                                                                                                            </td>
                                                                                                        </tr>
                                                                                                    </table>
                                                                                                </div>
                                                                                                <div class="column" style="width:100%;max-width:518px;display:inline-block;vertical-align:top;">
                                                                                                    <table width="100" style="border-spacing:0" cellpadding="0" cellspacing="0" border="0">
                                                                                                        <tr>
                                                                                                            <td class="inner" style="padding-top:0px;padding-bottom:10px; padding-right:10px;padding-left:10px;">
                                                                                                                <table class="contents" style="border-spacing:0; width:100%" cellpadding="0" cellspacing="0" border="0">
                                                                                                                    <tr>
                                                                                                                        <td align="left" valign="top">&nbsp;</td>
                                                                                                                    </tr>
                                                                                                                    <tr></tr>
                                                                                                                </table>
                                                                                                            </td>
                                                                                                        </tr>
                                                                                                    </table>
                                                                                                </div>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>&nbsp;</td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                </center>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                    <table class="one-column" border="0" cellpadding="0" cellspacing="0" width="100%" style="border-spacing:0; border-left:1px solid #e8e7e5; border-right:1px solid #e8e7e5; border-bottom:1px solid #e8e7e5; border-top:1px solid #e8e7e5" bgcolor="#FFFFFF">
                                        <tr>
                                            <td align="left" style="padding:50px 50px 50px 50px">
                                                <p style="color:#262626; font-size:24px; text-align:left; font-family: Verdana, Geneva, sans-serif">
                                                    <h2>Dear ##userName## ,</h2>
                                                </p>
                                                <p style="color:#000000; font-size:14px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                    <br />The following asset(s) ##assets## with codes ##assetNumbers## has been assigned to you.</p>
                                                <div style="width: 100%;text-align: center;">
                                                    <button class="download-button" target="_blank" style="-moz-border-radius: 30px; -webkit-border-radius: 30px; border-radius: 30px;            background-color: #009999;border: none;color: white;padding: 15px 32px;text-align: center;text-decoration: none;display: inline-block;font-size: 16px;margin: 4px 2px;cursor: pointer; ">
                                                        <a style="text-decoration:none;text-align:center; font-weight:bold;font-size:18px; font-family: Arial, sans-serif; color: #ffffff" " href="##siteAddress##">Click here to take action</a>                        </button>                            </div>                                                             <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">                                                       
<br/>                                                           
Best Regards, <br/>                                             
BTrak Team                                  
</p>                                
</td>                               
</tr>                          
</table>                        
</td>                     
</tr>                    
</table>                
</div>             
</td>             
</tr>              
</table>          
</center>  
</body>
</html>',@CompanyId)
		,('EmployeeRosterTemplate'
,'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head> <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/> <meta http-equiv="X-UA-Compatible" content="IE=edge"/> <meta name="viewport" content="width=device-width, initial-scale=1.0"/> <title></title> <style type="text/css"> *{-webkit-font-smoothing: antialiased;}body{Margin: 0; padding: 0; min-width: 100%; font-family: Arial, sans-serif; -webkit-font-smoothing: antialiased; mso-line-height-rule: exactly;}table{border-spacing: 0; color: #333333; font-family: Arial, sans-serif;}img{border: 0;}.wrapper{width: 100%; table-layout: fixed; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%;}.webkit{max-width: 600px;}.outer{Margin: 0 auto; width: 100%; max-width: 600px;}.full-width-image img{width: 100%; max-width: 600px; height: auto;}.inner{padding: 10px;}p{Margin: 0; padding-bottom: 10px;}.h1{font-size: 21px; font-weight: bold; Margin-top: 15px; Margin-bottom: 5px; font-family: Arial, sans-serif; -webkit-font-smoothing: antialiased;}.h2{font-size: 18px; font-weight: bold; Margin-top: 10px; Margin-bottom: 5px; font-family: Arial, sans-serif; -webkit-font-smoothing: antialiased;}.one-column .contents{text-align: left; font-family: Arial, sans-serif; -webkit-font-smoothing: antialiased;}.one-column p{font-size: 14px; Margin-bottom: 10px; font-family: Arial, sans-serif; -webkit-font-smoothing: antialiased;}.two-column{text-align: center; font-size: 0;}.two-column .column{width: 100%; max-width: 300px; display: inline-block; vertical-align: top;}.contents{width: 100%;}.two-column .contents{font-size: 14px; text-align: left;}.two-column img{width: 100%; max-width: 280px; height: auto;}.two-column .text{padding-top: 10px;}.three-column{text-align: center; font-size: 0; padding-top: 10px; padding-bottom: 10px;}.three-column .column{width: 100%; max-width: 200px; display: inline-block; vertical-align: top;}.three-column .contents{font-size: 14px; text-align: center;}.three-column img{width: 100%; max-width: 180px; height: auto;}.three-column .text{padding-top: 10px;}.img-align-vertical img{display: inline-block; vertical-align: middle;}.download-button{background-color: #4CAF50; border: none; color: white; padding: 15px 32px; text-align: center; text-decoration: none; display: inline-block; font-size: 16px; margin: 4px 2px; cursor: pointer;}@@media only screen and (max-device-width: 480px){table[class=hide], img[class=hide], td[class=hide]{display: none !important;}.contents1{width: 100%;}.contents1{width: 100%;}}.tabletd{width: 25%; vertical-align: top; padding: 2px 5px 2px 5px;}.tabletd p{margin: 5px 0}</style></head><body style="Margin:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;min-width:100%;background-color:#f3f2f0;"> <center class="wrapper" style="width:100%;table-layout:fixed;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#f3f2f0;"> <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#f3f2f0;" bgcolor="#f3f2f0;"> <tr> <td width="100%"> <div class="webkit" style="max-width:600px;Margin:0 auto;"> <table class="outer" align="center" cellpadding="0" cellspacing="0" border="0" style="border-spacing:0;Margin:0 auto;width:100%;max-width:600px;"> <tr> <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;"> <table class="one-column" border="0" cellpadding="0" cellspacing="0" width="100%" style="border-spacing:0; border-left:1px solid #e8e7e5; border-right:1px solid #e8e7e5; border-bottom:1px solid #e8e7e5; border-top:1px solid #e8e7e5" bgcolor="#FFFFFF"> <tr> <td align="left" style="padding:50px 50px 50px 50px"> <p style="color:#262626; font-size:24px; text-align:left; font-family: Verdana, Geneva, sans-serif"> <h2>Dear User ,</h2> </p><p style="color:#000000; font-size:14px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px "> Please check the below roster created by <b>##EmployeeName##</b> and have to follow the same please let us know in person, if you have any changes or queries<br/><br/> <table border="1" cellspacing="0" cellpadding="0" style="border-collapse:separate"> <tr> <th>Employee Name</th> <th>Scheduled Day</th> <th>Scheduled Time</th> <th>Department</th> </tr>##EmployeeRoster## </table> <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px "> <br/> Best Regards, <br/> ##footerName## </p></td></tr></table> </td></tr></table> </div></td></tr></table> </center></body></html>'
,@CompanyId),
		(N'InvoicePDFTemplate',
		'<!DOCTYPE html>
<html>

<style>
    .div {
        box-sizing: border-box;
    }

    .p-1 {
        padding: 1rem !important;
    }

    h6 {
        font-size: 1rem;
        margin-bottom: .5rem;
        font-weight: 400;
        line-height: 1.1;
        color: inherit;
        margin-top: 0;
    }

    .fxLayout-row {
        flex-flow: row wrap;
        box-sizing: border-box;
        display: flex;
    }

    .fxFlex48 {
        flex: 1 1 100%;
        box-sizing: border-box;
        max-width: 48%;
    }

    .fxFlex {
        flex: 1 1 0%;
        box-sizing: border-box;
    }

    .fxFlex49-column {
        flex: 1 1 100%;
        box-sizing: border-box;
        flex-direction: column;
        display: flex;
        max-width: 49%;
    }

    .fxFlex50-row-start {
        flex: 1 1 50%;
        box-sizing: border-box;
        place-content: center flex-start;
        align-items: center;
        flex-direction: row;
        display: flex;
        max-width: 50%;
    }

    .fxFlex50-column-start {
        flex: 1 1 50%;
        box-sizing: border-box;
        place-content: center flex-start;
        align-items: center;
        flex-direction: column;
        display: block;
        max-width: 50%;
    }

    .fxFlex50-column-end {
        flex: 1 1 50%;
        box-sizing: border-box;
        place-content: flex-start flex-end;
        align-items: center;
        flex-direction: column;
        display: block;
        max-width: 50%;
    }

    .fxFlex100 {
        flex: 1 1 100%;
        box-sizing: border-box;
        max-width: 100%;
    }

    .fxFlex100-end {
        flex: 1 1 100%;
        box-sizing: border-box;
        place-content: flex-start flex-end;
        align-items: flex-start;
        flex-direction: row;
        display: flex;
        max-width: 100%;
    }

    .fxLayout-end {
        place-content: center flex-end;
        align-items: center;
        flex-direction: row;
        box-sizing: border-box;
        display: flex;
    }

    .word-break {
        word-break: break-word !important;
    }

    .d-block {
        display: bloack !important;
    }

    .mb-1 {
        margin-bottom: 1rem !important;
    }

    .mt-02 {
        margin-top: .3rem !important;
    }

    .mt-1 {
        margin-top: 1rem !important;
    }

    .mt-1-05 {
        margin-top: 1.5rem;
    }

    .ml-1 {
        margin-left: 1rem !important;
    }

    .mt-05 {
        margin-top: .5rem !important;
    }
    
    .mr-05 {
        margin-right: .5rem !important;
    }

    .invoice-amount-price {
        font-size: 23px;
        font-weight: 700;
        position: relative;
        top: 1px;
    }

    .overflow-visible {
        overflow: visible;
    }

    .table-responsive {
        display: block;
        width: 100%;
        overflow-x: auto;
        -webkit-overflow-scrolling: touch;
    }

    .mb-0 {
        margin-bottom: 0 !important;
    }

    .table {
        width: 100%;
        margin-bottom: 1rem;
        color: #212529;
    }

    table {
        border-collapse: collapse;
    }

    .invoice-container td:first-child,
    .invoice-container th:first-child {
        text-align: inherit;
        padding-left: 0;
        width: 40%;
    }

    .table thead th {
        vertical-align: bottom;
        border-bottom: 2px solid #dee2e6;
    }

    .invoice-container td,
    .invoice-container th {
        padding-right: 0;
        text-align: right;
        width: 13%;
    }

    .table td,
    .table th {
        padding: .75rem;
        vertical-align: top;
        border-top: 1px solid #dee2e6;
    }

	td    { page-break-before: always; }
	th    { page-break-before: always; }

	@page {
		margin-top: 10px;
		margin-bottom: 10px
	}
</style>

<body>
    <div class="p-1 invoice-preview-height">
		##invoicePDFJson##
	</div>
</body>

</html>
		',@CompanyId),
		(N'InvoiceMailTemplate',
		'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
        <html xmlns="http://www.w3.org/1999/xhtml">
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
            <!--[if !mso]><!-->
            <meta http-equiv="X-UA-Compatible" content="IE=edge" />
            <!--<![endif]-->
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title></title>
            <style type="text/css">
                * {
                    -webkit-font-smoothing: antialiased;
                }
        
                body {
                    Margin: 0;
                    padding: 0;
                    min-width: 100%;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                    mso-line-height-rule: exactly;
                }
        
                table {
                    border-spacing: 0;
                    color: #333333;
                    font-family: Arial, sans-serif;
                }
        
                img {
                    border: 0;
                }
        
                .wrapper {
                    width: 100%;
                    table-layout: fixed;
                    -webkit-text-size-adjust: 100%;
                    -ms-text-size-adjust: 100%;
                }
        
                .webkit {
                    max-width: 600px;
                }
        
                .outer {
                    Margin: 0 auto;
                    width: 100%;
                    max-width: 600px;
                }
        
                .full-width-image img {
                    width: 100%;
                    max-width: 600px;
                    height: auto;
                }
        
                .inner {
                    padding: 10px;
                }
        
                p {
                    Margin: 0;
                    padding-bottom: 10px;
                }
        
                .h1 {
                    font-size: 21px;
                    font-weight: bold;
                    Margin-top: 15px;
                    Margin-bottom: 5px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .h2 {
                    font-size: 18px;
                    font-weight: bold;
                    Margin-top: 10px;
                    Margin-bottom: 5px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .one-column .contents {
                    text-align: left;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .one-column p {
                    font-size: 14px;
                    Margin-bottom: 10px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .two-column {
                    text-align: center;
                    font-size: 0;
                }
        
                    .two-column .column {
                        width: 100%;
                        max-width: 300px;
                        display: inline-block;
                        vertical-align: top;
                    }
        
                .contents {
                    width: 100%;
                }
        
                .two-column .contents {
                    font-size: 14px;
                    text-align: left;
                }
        
                .two-column img {
                    width: 100%;
                    max-width: 280px;
                    height: auto;
                }
        
                .two-column .text {
                    padding-top: 10px;
                }
        
                .three-column {
                    text-align: center;
                    font-size: 0;
                    padding-top: 10px;
                    padding-bottom: 10px;
                }
        
                    .three-column .column {
                        width: 100%;
                        max-width: 200px;
                        display: inline-block;
                        vertical-align: top;
                    }
        
                    .three-column .contents {
                        font-size: 14px;
                        text-align: center;
                    }
        
                    .three-column img {
                        width: 100%;
                        max-width: 180px;
                        height: auto;
                    }
        
                    .three-column .text {
                        padding-top: 10px;
                    }
        
                .img-align-vertical img {
                    display: inline-block;
                    vertical-align: middle;
                }
        
                @@media only screen and (max-device-width: 480px) {
                    table[class=hide], img[class=hide], td[class=hide] {
                        display: none !important;
                    }
        
                    .contents1 {
                        width: 100%;
                    }
        
                    .contents1 {
                        width: 100%;
                    }
                }
            </style>
        </head>
        <body
    style="Margin:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;min-width:100%;background-color:#f3f2f0;">
    <center class="wrapper"
        style="width:100%;table-layout:fixed;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#f3f2f0;">
        <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#f3f2f0;"
            bgcolor="#f3f2f0;">
            <tr>
                <td width="100%">
                    <div class="webkit" style="max-width:600px;Margin:0 auto;">
                        <table class="outer" align="center" cellpadding="0" cellspacing="0" border="0"
                            style="border-spacing:0;Margin:0 auto;width:100%;max-width:600px;">
                            <tr>
                                <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;">
                                    <table class="one-column" border="0" cellpadding="0" cellspacing="0" width="100%"
                                        style="border-spacing:0; border-left:1px solid #e8e7e5; border-right:1px solid #e8e7e5; border-bottom:1px solid #e8e7e5; border-top:1px solid #e8e7e5"
                                        bgcolor="#FFFFFF">
                                        <tr>
                                            <td align="left" style="padding:50px 50px 50px 50px">
                                                <p
                                                    style="color:#262626; font-size:24px; text-align:left; font-family: Verdana, Geneva, sans-serif">
                                                    <h2>Dear ##ToName##,</h2>
                                                </p>
                                                <p
                                                    style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                    Thank you for choosing Snovasys Business Suite to grow your
                                                    business.Hope you have a great success in the coming future.<a
                                                        target="_blank" href="##PdfUrl##" style="color: #099">Click
                                                        here</a> to download the invoice.<br />
                                                    <br />
                                                </p>
                                                <p
                                                    style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                    Best Regards, <br />
                                                    ##footerName##
                                                </p>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>
        </table>
    </center>
</body>
</html>',@CompanyId),
        (N'ScenarioExportMailTemplate',
        '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
        <html xmlns="http://www.w3.org/1999/xhtml">
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
            <!--[if !mso]><!-->
            <meta http-equiv="X-UA-Compatible" content="IE=edge" />
            <!--<![endif]-->
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title></title>
            <style type="text/css">
                * {
                    -webkit-font-smoothing: antialiased;
                }
        
                body {
                    Margin: 0;
                    padding: 0;
                    min-width: 100%;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                    mso-line-height-rule: exactly;
                }
        
                table {
                    border-spacing: 0;
                    color: #333333;
                    font-family: Arial, sans-serif;
                }
        
                img {
                    border: 0;
                }
        
                .wrapper {
                    width: 100%;
                    table-layout: fixed;
                    -webkit-text-size-adjust: 100%;
                    -ms-text-size-adjust: 100%;
                }
        
                .webkit {
                    max-width: 600px;
                }
        
                .outer {
                    Margin: 0 auto;
                    width: 100%;
                    max-width: 600px;
                }
        
                .full-width-image img {
                    width: 100%;
                    max-width: 600px;
                    height: auto;
                }
        
                .inner {
                    padding: 10px;
                }
        
                p {
                    Margin: 0;
                    padding-bottom: 10px;
                }
        
                .h1 {
                    font-size: 21px;
                    font-weight: bold;
                    Margin-top: 15px;
                    Margin-bottom: 5px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .h2 {
                    font-size: 18px;
                    font-weight: bold;
                    Margin-top: 10px;
                    Margin-bottom: 5px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .one-column .contents {
                    text-align: left;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .one-column p {
                    font-size: 14px;
                    Margin-bottom: 10px;
                    font-family: Arial, sans-serif;
                    -webkit-font-smoothing: antialiased;
                }
        
                .two-column {
                    text-align: center;
                    font-size: 0;
                }
        
                    .two-column .column {
                        width: 100%;
                        max-width: 300px;
                        display: inline-block;
                        vertical-align: top;
                    }
        
                .contents {
                    width: 100%;
                }
        
                .two-column .contents {
                    font-size: 14px;
                    text-align: left;
                }
        
                .two-column img {
                    width: 100%;
                    max-width: 280px;
                    height: auto;
                }
        
                .two-column .text {
                    padding-top: 10px;
                }
        
                .three-column {
                    text-align: center;
                    font-size: 0;
                    padding-top: 10px;
                    padding-bottom: 10px;
                }
        
                    .three-column .column {
                        width: 100%;
                        max-width: 200px;
                        display: inline-block;
                        vertical-align: top;
                    }
        
                    .three-column .contents {
                        font-size: 14px;
                        text-align: center;
                    }
        
                    .three-column img {
                        width: 100%;
                        max-width: 180px;
                        height: auto;
                    }
        
                    .three-column .text {
                        padding-top: 10px;
                    }
        
                .img-align-vertical img {
                    display: inline-block;
                    vertical-align: middle;
                }
        
                @@media only screen and (max-device-width: 480px) {
                    table[class=hide], img[class=hide], td[class=hide] {
                        display: none !important;
                    }
        
                    .contents1 {
                        width: 100%;
                    }
        
                    .contents1 {
                        width: 100%;
                    }
                }
            </style>
        </head>
        <body
    style="Margin:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;min-width:100%;background-color:#f3f2f0;">
    <center class="wrapper"
        style="width:100%;table-layout:fixed;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#f3f2f0;">
        <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#f3f2f0;"
            bgcolor="#f3f2f0;">
            <tr>
                <td width="100%">
                    <div class="webkit" style="max-width:600px;Margin:0 auto;">
                        <table class="outer" align="center" cellpadding="0" cellspacing="0" border="0"
                            style="border-spacing:0;Margin:0 auto;width:100%;max-width:600px;">
                            <tr>
                                <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;">
                                    <table class="one-column" border="0" cellpadding="0" cellspacing="0" width="100%"
                                        style="border-spacing:0; border-left:1px solid #e8e7e5; border-right:1px solid #e8e7e5; border-bottom:1px solid #e8e7e5; border-top:1px solid #e8e7e5"
                                        bgcolor="#FFFFFF">
                                        <tr>
                                            <td align="left" style="padding:50px 50px 50px 50px">
                                                <p
                                                    style="color:#262626; font-size:24px; text-align:left; font-family: Verdana, Geneva, sans-serif">
                                                    <h2>Dear ##ToName##,</h2>
                                                </p>
                                                <p
                                                    style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                    Thank you for choosing Snovasys Business Suite to grow your
                                                    business.Hope you have a great success in the coming future. <a
                                                        target="_blank" href="##PdfUrl##" style="color: #099">Click
                                                        here</a> to download the exported file.<br />
                                                    <br />
                                                </p>
                                                <p
                                                    style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                    Best Regards, <br />
                                                    ##footerName##
                                                </p>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>
        </table>
    </center>
</body>
</html>',@CompanyId),
(N'RemoteSiteCompanyRegistrationTemplate',
		'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">  
<html xmlns="http://www.w3.org/1999/xhtml">
   <head>
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
      <!--[if !mso]><!-->      
      <meta http-equiv="X-UA-Compatible" content="IE=edge" />
      <!--<![endif]-->      
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title></title>
      <style type="text/css">          * {              -webkit-font-smoothing: antialiased;          }            body {              Margin: 0;              padding: 0;              min-width: 100%;              font-family: Arial, sans-serif;              -webkit-font-smoothing: antialiased;              mso-line-height-rule: exactly;          }            table {              border-spacing: 0;              color: #333333;              font-family: Arial, sans-serif;          }            img {              border: 0;          }            .wrapper {              width: 100%;              table-layout: fixed;              -webkit-text-size-adjust: 100%;              -ms-text-size-adjust: 100%;          }            .webkit {              max-width: 600px;          }            .outer {              Margin: 0 auto;              width: 100%;              max-width: 600px;          }            .full-width-image img {              width: 100%;              max-width: 600px;              height: auto;          }            .inner {              padding: 10px;          }            p {              Margin: 0;              padding-bottom: 10px;          }            .h1 {              font-size: 21px;              font-weight: bold;              Margin-top: 15px;              Margin-bottom: 5px;              font-family: Arial, sans-serif;              -webkit-font-smoothing: antialiased;          }            .h2 {              font-size: 18px;              font-weight: bold;              Margin-top: 10px;              Margin-bottom: 5px;              font-family: Arial, sans-serif;              -webkit-font-smoothing: antialiased;          }            .one-column .contents {              text-align: left;              font-family: Arial, sans-serif;              -webkit-font-smoothing: antialiased;          }            .one-column p {              font-size: 14px;              Margin-bottom: 10px;              font-family: Arial, sans-serif;              -webkit-font-smoothing: antialiased;          }            .two-column {              text-align: center;              font-size: 0;          }                .two-column .column {                  width: 100%;                  max-width: 300px;                  display: inline-block;                  vertical-align: top;              }            .contents {              width: 100%;          }            .two-column .contents {              font-size: 14px;              text-align: left;          }            .two-column img {              width: 100%;              max-width: 280px;              height: auto;          }            .two-column .text {              padding-top: 10px;          }            .three-column {              text-align: center;              font-size: 0;              padding-top: 10px;              padding-bottom: 10px;          }                .three-column .column {                  width: 100%;                  max-width: 200px;                  display: inline-block;                  vertical-align: top;              }                .three-column .contents {                  font-size: 14px;                  text-align: center;              }                .three-column img {                  width: 100%;                  max-width: 180px;                  height: auto;              }                .three-column .text {                  padding-top: 10px;              }            .img-align-vertical img {              display: inline-block;              vertical-align: middle;          }            @@media only screen and (max-device-width: 480px) {              table[class=hide], img[class=hide], td[class=hide] {                  display: none !important;              }                .contents1 {                  width: 100%;              }                .contents1 {                  width: 100%;              }          }      </style>
   </head>
   <body style="Margin:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;min-width:100%;background-color:#f3f2f0;">
      <center class="wrapper" style="width:100%;table-layout:fixed;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#f3f2f0;">
         <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#f3f2f0;" bgcolor="#f3f2f0;">
            <tr>
               <td width="100%">
                  <div class="webkit" style="max-width:750px;Margin:0 auto;">
                     <table class="outer" align="center" cellpadding="0" cellspacing="0" border="0" style="border-spacing:0;Margin:0 auto;width:100%;max-width:750px;">
                        <tr>
                           <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;">
                              <table border="0" width="100%" cellpadding="0" cellspacing="0">
                                 <tr>
                                    <td>
                                       <table style="width:100%;" cellpadding="0" cellspacing="0" border="0">
                                          <tbody>
                                             <tr>
                                                <td align="center">
                                                   <center>
                                                      <table border="0" align="center" width="100%" cellpadding="0" cellspacing="0" style="Margin: 0 auto;">
                                                         <tbody>
                                                            <tr>
                                                               <td class="one-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;" bgcolor="#FFFFFF">
                                                                  <table cellpadding="0" cellspacing="0" border="0" width="100%" bgcolor="#f3f2f0">
                                                                     <tr>
                                                                        <td class="two-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;text-align:left;font-size:0;">
                                                                           <div class="column" style="max-width:150px;height:11px;display:inline-block;vertical-align:top;">
                                                                              <table class="contents" style="border-spacing:0; width:100%">
                                                                                 <tr>
                                                                                    <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0px;" align="left"> 
                                                                                       <a href="#" target="_blank"><img src="https://bviewstorage.blob.core.windows.net/5cfabe47-dd1d-454b-8a71-72580aa92ad4/localsiteuploads/54910103-9ebe-4020-a347-4be1cbfc36be/snovasys-5ac4c12f-20b1-425f-b550-076cf851f59e.png" alt="" width="120" height="120" style="border-width:0; height:auto; display:block" align="left" /></a>
                                                                                    </td>
                                                                                 </tr>
                                                                              </table>
                                                                           </div>
                                                                           <div class="column" style="width:100%;max-width:518px;display:inline-block;vertical-align:top;">
                                                                              <table width="100" style="border-spacing:0" cellpadding="0" cellspacing="0" border="0">
                                                                                 <tr>
                                                                                    <td class="inner" style="padding-top:0px;padding-bottom:0px; padding-right:10px;padding-left:10px;">
                                                                                       <table class="contents" style="border-spacing:0; width:100%" cellpadding="0" cellspacing="0" border="0">
                                                                                          <tr>
                                                                                             <td align="left" valign="top">&nbsp;</td>
                                                                                          </tr>
                                                                                          <tr></tr>
                                                                                       </table>
                                                                                    </td>
                                                                                 </tr>
                                                                              </table>
                                                                           </div>
                                                                        </td>
                                                                     </tr>
                                                                     <tr>
                                                                        <td>&nbsp;</td>
                                                                     </tr>
                                                                  </table>
                                                               </td>
                                                            </tr>
                                                         </tbody>
                                                      </table>
                                                   </center>
                                                </td>
                                             </tr>
                                          </tbody>
                                       </table>
                                    </td>
                                 </tr>
                              </table>
                              <table class="one-column" border="0" cellpadding="0" cellspacing="0" width="100%" style="border-spacing:0; border-left:1px solid #e8e7e5; border-right:1px solid #e8e7e5; border-bottom:1px solid #e8e7e5; border-top:1px solid #e8e7e5" bgcolor="#FFFFFF">
                                 <tr>
                                    <td align="left" style="padding:5px 50px 50px 50px">
                                       <p style="color:#262626; font-size:24px; text-align:left; font-family: Verdana, Geneva, sans-serif">
                                       <h2>Dear ##ToName##,</h2>
                                       </p>                                                  
                                       <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px">Thank you and congratulations for choosing Snovasys Remote Working Software. Please find the details below.</p>
                                       <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px"> 
                                          Please click the following link on your browser to access the application.
                                       </p>
                                       <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px "><a target="_blank" href="##siteAddress##" style="color: #099">Snovasys Remote Working Software Link</a></p>
                                       <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px "> Please use the following login credentials.</p>
                                       <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ;margin-bottom: 0px !important;">User Name - ##userName##</p>
                                       <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">Password - ##password##</p>
                                       <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">As needed, you could install a light weight tool on your computer to help tracking, messaging purposes. Please click here or paste the following link in your browser.</p>
                                       <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px "><a target="_blank" href="##chatApllication##" style="color: #099">Snovasys Remote Working Desktop Tool</a></p>
                                       <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">Thank you again for your registration and all the very best. For further queries, please reach out to your dedicated account manager and our Whatsapp number (0044-7944144944).</p>
                                       <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">You could also access our user guide by clicking on the following link.</p>
                                       <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px "><a target="_blank" href="##guidelink##" style="color: #099">Snovasys Remote Working User Guide</a></p>
                                       <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px;margin-bottom:0px !important">
									   <b>Best Regards,</b> <br /> 
                                       ##footerName##
									   </p>
									   <a href="#" target="_blank"><img src="https://bviewstorage.blob.core.windows.net/5cfabe47-dd1d-454b-8a71-72580aa92ad4/localsiteuploads/54910103-9ebe-4020-a347-4be1cbfc36be/snovasys-5ac4c12f-20b1-425f-b550-076cf851f59e.png" alt="" width="120" height="120" style="border-width:0; height:auto; display:block" align="left" /></a>
									   <br/>
									   
                                    </td>
                                 </tr>
                              </table>
                           </td>
                        </tr>
                     </table>
                  </div>
               </td>
            </tr>
         </table>
      </center>
   </body>
</html>',@CompanyId),

--contact templates
(N'RemoteContactMailTemplate',
	'	<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <!--[if !mso]><!-->
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <!--<![endif]-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title></title>
    <style type="text/css">
        * {
            -webkit-font-smoothing: antialiased;
        }

        body {
            Margin: 0;
            padding: 0;
            min-width: 100%;
            font-family: Arial, sans-serif;
            -webkit-font-smoothing: antialiased;
            mso-line-height-rule: exactly;
        }

        table {
            border-spacing: 0;
            color: #333333;
            font-family: Arial, sans-serif;
        }

        img {
            border: 0;
        }

        .wrapper {
            width: 100%;
            table-layout: fixed;
            -webkit-text-size-adjust: 100%;
            -ms-text-size-adjust: 100%;
        }

        .webkit {
            max-width: 600px;
        }

        .outer {
            Margin: 0 auto;
            width: 100%;
            max-width: 600px;
        }

        .full-width-image img {
            width: 100%;
            max-width: 600px;
            height: auto;
        }

        .inner {
            padding: 10px;
        }

        p {
            Margin: 0;
            padding-bottom: 10px;
        }

        .h1 {
            font-size: 21px;
            font-weight: bold;
            Margin-top: 15px;
            Margin-bottom: 5px;
            font-family: Arial, sans-serif;
            -webkit-font-smoothing: antialiased;
        }

        .h2 {
            font-size: 18px;
            font-weight: bold;
            Margin-top: 10px;
            Margin-bottom: 5px;
            font-family: Arial, sans-serif;
            -webkit-font-smoothing: antialiased;
        }

        .one-column .contents {
            text-align: left;
            font-family: Arial, sans-serif;
            -webkit-font-smoothing: antialiased;
        }

        .one-column p {
            font-size: 14px;
            Margin-bottom: 10px;
            font-family: Arial, sans-serif;
            -webkit-font-smoothing: antialiased;
        }

        .two-column {
            text-align: center;
            font-size: 0;
        }

            .two-column .column {
                width: 100%;
                max-width: 300px;
                display: inline-block;
                vertical-align: top;
            }

        .contents {
            width: 100%;
        }

        .two-column .contents {
            font-size: 14px;
            text-align: left;
        }

        .two-column img {
            width: 100%;
            max-width: 280px;
            height: auto;
        }

        .two-column .text {
            padding-top: 10px;
        }

        .three-column {
            text-align: center;
            font-size: 0;
            padding-top: 10px;
            padding-bottom: 10px;
        }

            .three-column .column {
                width: 100%;
                max-width: 200px;
                display: inline-block;
                vertical-align: top;
            }

            .three-column .contents {
                font-size: 14px;
                text-align: center;
            }

            .three-column img {
                width: 100%;
                max-width: 180px;
                height: auto;
            }

            .three-column .text {
                padding-top: 10px;
            }

        .img-align-vertical img {
            display: inline-block;
            vertical-align: middle;
        }

        @@media only screen and (max-device-width: 480px) {
            table[class=hide], img[class=hide], td[class=hide] {
                display: none !important;
            }

            .contents1 {
                width: 100%;
            }

            .contents1 {
                width: 100%;
            }
        }
    </style>
</head>
<body style="Margin:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;min-width:100%;background-color:#f3f2f0;">
    <center class="wrapper" style="width:100%;table-layout:fixed;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#f3f2f0;">
        <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#f3f2f0;" bgcolor="#f3f2f0;">
            <tr>
                <td width="100%">
                    <div class="webkit" style="max-width:600px;Margin:0 auto;">
                        <table class="outer" align="center" cellpadding="0" cellspacing="0" border="0" style="border-spacing:0;Margin:0 auto;width:100%;max-width:600px;">
                            <tr>
                                <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;">
                                    <table border="0" width="100%" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td>
                                                <table style="width:100%;" cellpadding="0" cellspacing="0" border="0">
                                                    <tbody>
                                                        <tr>
                                                            <td align="center">
                                                                <center>
                                                                    <table border="0" align="center" width="100%" cellpadding="0" cellspacing="0" style="Margin: 0 auto;">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td class="one-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;" bgcolor="#FFFFFF">
                                                                                    <table cellpadding="0" cellspacing="0" border="0" width="100%" bgcolor="#f3f2f0">
                                                                                        <tr>
                                                                                            <td class="two-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;text-align:left;font-size:0;">
                                                                                                <div class="column" style="max-width:150px;height:11px;display:inline-block;vertical-align:top;">
                                                                                                    <table class="contents" style="border-spacing:0; width:100%">
                                                                                                        <tr>
                                                                                                            <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:5px;" align="left">
                                                                                                                @*<a href="#" target="_blank"><img src="https://bviewstorage.blob.core.windows.net/5cfabe47-dd1d-454b-8a71-72580aa92ad4/localsiteuploads/54910103-9ebe-4020-a347-4be1cbfc36be/snovasys-5ac4c12f-20b1-425f-b550-076cf851f59e.png" alt="" width="60" height="60" style="border-width:0; height:auto; display:block" align="left" /></a>*@
                                                                                                            </td>
                                                                                                        </tr>
                                                                                                    </table>
                                                                                                </div>
                                                                                                <div class="column" style="width:100%;max-width:518px;display:inline-block;vertical-align:top;">
                                                                                                    <table width="100" style="border-spacing:0" cellpadding="0" cellspacing="0" border="0">
                                                                                                        <tr>
                                                                                                            <td class="inner" style="padding-top:0px;padding-bottom:10px; padding-right:10px;padding-left:10px;">
                                                                                                                <table class="contents" style="border-spacing:0; width:100%" cellpadding="0" cellspacing="0" border="0">
                                                                                                                    <tr>
                                                                                                                        <td align="left" valign="top">&nbsp;</td>
                                                                                                                    </tr>
                                                                                                                    <tr></tr>
                                                                                                                </table>
                                                                                                            </td>
                                                                                                        </tr>
                                                                                                    </table>
                                                                                                </div>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>&nbsp;</td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                </center>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                    <table class="one-column" border="0" cellpadding="0" cellspacing="0" width="100%" style="border-spacing:0; border-left:1px solid #e8e7e5; border-right:1px solid #e8e7e5; border-bottom:1px solid #e8e7e5; border-top:1px solid #e8e7e5" bgcolor="#FFFFFF">
                                        <tr>
                                            <td align="left" style="padding:50px 50px 50px 50px">
                                                <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                    Hi there, I’m really excited to get started with your product. I just have a few questions before I get started.
                                                </p>
												<p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                   ##description##
                                                </p>
											<p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                    User Name - ##userName##
                                                </p>
													<p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                    Phone Number - ##phone##
                                                </p>
                                                <p style="color:#262626; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                   Thanks!
												   
                                                 </p>
												<p style="color:#262626; font-size:24px; text-align:left; font-family: Verdana, Geneva, sans-serif"><h3>Customer Details:</h3></p>
												 <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                    Name - ##userName##
                                                </p>
												<p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                    Email - ##email##
                                                </p>
												<p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                    Phone number - ##phone##
                                                </p>
												<p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                    Company Name - ##company##
                                                </p>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>
        </table>
    </center>
</body>
</html>',@CompanyId)

        )
        AS Source ([TemplateName], [HtmlTemplate],CompanyId) 
        ON Target.[TemplateName] = Source.[TemplateName]  
        AND Target.CompanyId = Source.CompanyId  
        WHEN MATCHED THEN 
        UPDATE SET [HtmlTemplate] = Source.[HtmlTemplate];

MERGE INTO [dbo].[HtmlTemplates] AS Target 
USING ( VALUES 

('SprintApprovedEmailTemplate',
'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
   <head>
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
      <!--[if !mso]><!-->
      <meta http-equiv="X-UA-Compatible" content="IE=edge" />
      <!--<![endif]-->
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title></title>
      <style type="text/css">
         * {
         -webkit-font-smoothing: antialiased;
         }
         body {
         Margin: 0;
         padding: 0;
         min-width: 100%;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         mso-line-height-rule: exactly;
         }
         table {
         border-spacing: 0;
         color: #333333;
         font-family: Arial, sans-serif;
         }
         img {
         border: 0;
         }
         .wrapper {
         width: 100%;
         table-layout: fixed;
         -webkit-text-size-adjust: 100%;
         -ms-text-size-adjust: 100%;
         }
         .webkit {
         max-width: 600px;
         }
         .outer {
         Margin: 0 auto;
         width: 100%;
         max-width: 600px;
         }
         .full-width-image img {
         width: 100%;
         max-width: 600px;
         height: auto;
         }
         .inner {
         padding: 10px;
         }
         p {
         Margin: 0;
         padding-bottom: 10px;
         }
         .h1 {
         font-size: 21px;
         font-weight: bold;
         Margin-top: 15px;
         Margin-bottom: 5px;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         }
         .h2 {
         font-size: 18px;
         font-weight: bold;
         Margin-top: 10px;
         Margin-bottom: 5px;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         }
         .one-column .contents {
         text-align: left;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         }
         .one-column p {
         font-size: 14px;
         Margin-bottom: 10px;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         }
         .two-column {
         text-align: center;
         font-size: 0;
         }
         .two-column .column {
         width: 100%;
         max-width: 300px;
         display: inline-block;
         vertical-align: top;
         }
         .contents {
         width: 100%;
         }
         .two-column .contents {
         font-size: 14px;
         text-align: left;
         }
         .two-column img {
         width: 100%;
         max-width: 280px;
         height: auto;
         }
         .two-column .text {
         padding-top: 10px;
         }
         .three-column {
         text-align: center;
         font-size: 0;
         padding-top: 10px;
         padding-bottom: 10px;
         }
         .three-column .column {
         width: 100%;
         max-width: 200px;
         display: inline-block;
         vertical-align: top;
         }
         .three-column .contents {
         font-size: 14px;
         text-align: center;
         }
         .three-column img {
         width: 100%;
         max-width: 180px;
         height: auto;
         }
         .three-column .text {
         padding-top: 10px;
         }
         .img-align-vertical img {
         display: inline-block;
         vertical-align: middle;
         }
         .download-button {
         background-color: #009999;
         border: none;
         color: white;
         padding: 15px 32px;
         text-align: center;
         text-decoration: none;
         display: inline-block;
         font-size: 16px;
         margin: 4px 2px;
         cursor: pointer;
         }
         @@media only screen and (max-device-width: 480px) {
         table[class=hide], img[class=hide], td[class=hide] {
         display: none !important;
         }
         .contents1 {
         width: 100%;
         }
         .contents1 {
         width: 100%;
         }
         }
      </style>
   </head>
   <body style="Margin:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;min-width:100%;background-color:#f3f2f0;">
      <center class="wrapper" style="width:100%;table-layout:fixed;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#f3f2f0;">
         <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#f3f2f0;" bgcolor="#f3f2f0;">
            <tr>
               <td width="100%">
                  <div class="webkit" style="max-width:600px;Margin:0 auto;">
                     <table class="outer" align="center" cellpadding="0" cellspacing="0" border="0" style="border-spacing:0;Margin:0 auto;width:100%;max-width:600px;">
                        <tr>
                           <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;">
                              <table border="0" width="100%" cellpadding="0" cellspacing="0">
                                 <tr>
                                    <td>
                                       <table style="width:100%;" cellpadding="0" cellspacing="0" border="0">
                                          <tbody>
                                             <tr>
                                                <td align="center">
                                                   <center>
                                                      <table border="0" align="center" width="100%" cellpadding="0" cellspacing="0" style="Margin: 0 auto;">
                                                         <tbody>
                                                            <tr>
                                                               <td class="one-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;" bgcolor="#FFFFFF">
                                                                  <table cellpadding="0" cellspacing="0" border="0" width="100%" bgcolor="#f3f2f0">
                                                                     <tr>
                                                                        <td class="two-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;text-align:left;font-size:0;">
                                                                           <div class="column" style="max-width:150px;height:11px;display:inline-block;vertical-align:top;">
                                                                              <table class="contents" style="border-spacing:0; width:100%">
                                                                                 <tr>
                                                                                    <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:5px;" align="left">
                                                                                       <a href="#" target="_blank"><img src="" alt="" width="60" height="60" style="border-width:0; max-width:60px;height:auto; display:block" align="left" /></a>
                                                                                    </td>
                                                                                 </tr>
                                                                              </table>
                                                                           </div>
                                                                           <div class="column" style="width:100%;max-width:518px;display:inline-block;vertical-align:top;">
                                                                              <table width="100" style="border-spacing:0" cellpadding="0" cellspacing="0" border="0">
                                                                                 <tr>
                                                                                    <td class="inner" style="padding-top:0px;padding-bottom:10px; padding-right:10px;padding-left:10px;">
                                                                                       <table class="contents" style="border-spacing:0; width:100%" cellpadding="0" cellspacing="0" border="0">
                                                                                          <tr>
                                                                                             <td align="left" valign="top">&nbsp;</td>
                                                                                          </tr>
                                                                                          <tr></tr>
                                                                                       </table>
                                                                                    </td>
                                                                                 </tr>
                                                                              </table>
                                                                           </div>
                                                                        </td>
                                                                     </tr>
                                                                     <tr>
                                                                        <td>&nbsp;</td>
                                                                     </tr>
                                                                  </table>
                                                               </td>
                                                            </tr>
                                                         </tbody>
                                                      </table>
                                                   </center>
                                                </td>
                                             </tr>
                                          </tbody>
                                       </table>
                                    </td>
                                 </tr>
                              </table>
                              <table class="one-column" border="0" cellpadding="0" cellspacing="0" width="100%" style="border-spacing:0; border-left:1px solid #e8e7e5; border-right:1px solid #e8e7e5; border-bottom:1px solid #e8e7e5; border-top:1px solid #e8e7e5" bgcolor="#FFFFFF">
                                 <tr>
                                    <td align="left" style="padding:50px 50px 50px 50px">
                                       <p style="color:#262626; font-size:24px; text-align:left; font-family: Verdana, Geneva, sans-serif">
                                       <h2>##OperationPerformedUser## started the sprint - ##SprintName##(##SprintUniqueName##) from ##SprintStatus##</h2>
                                       </p>
									   <div style="width: 100%;">
									   <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                    Project name - ##ProjectName##
                                                </p>
													<p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                    Sprint start date - ##SprintStartDate##
                                                </p>
                                                <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">
                                                    Sprint end date - ##SprintEndDate##
                                                </p>
									   </div>

                                       <div style="width: 100%;text-align: center;">
                                          <a style="text-decoration:none;text-align:center; font-weight:bold;font-size:18px; font-family: Arial, sans-serif; color: #ffffff" " href="##siteAddress##">                                                    
                                           <button class="download-button" target="_blank" style="-moz-border-radius: 30px; -webkit-border-radius: 30px; border-radius: 30px;            background-color: #009999;border: none;color: white;padding: 15px 32px;text-align: center;text-decoration: none;display: inline-block;font-size: 16px;margin: 4px 2px;cursor: pointer; ">
										   Go to ##SprintUniqueName##
										   </button>
										   </a>
									   </div>
                                       <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">                                                              <br />                                                              Best Regards, <br />                                                              ##footerName##                                                          </p>
                                    </td>
                                 </tr>
                              </table>
                           </td>
                        </tr>
                     </table>
                  </div>
               </td>
            </tr>
         </table>
      </center>
   </body>
</html>',@CompanyId),
('GoalRequestedForReplanEmailTemplate',
'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
   <head>
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
      <!--[if !mso]><!-->
      <meta http-equiv="X-UA-Compatible" content="IE=edge" />
      <!--<![endif]-->
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title></title>
      <style type="text/css">
         * {
         -webkit-font-smoothing: antialiased;
         }
         body {
         Margin: 0;
         padding: 0;
         min-width: 100%;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         mso-line-height-rule: exactly;
         }
         table {
         border-spacing: 0;
         color: #333333;
         font-family: Arial, sans-serif;
         }
         img {
         border: 0;
         }
         .wrapper {
         width: 100%;
         table-layout: fixed;
         -webkit-text-size-adjust: 100%;
         -ms-text-size-adjust: 100%;
         }
         .webkit {
         max-width: 600px;
         }
         .outer {
         Margin: 0 auto;
         width: 100%;
         max-width: 600px;
         }
         .full-width-image img {
         width: 100%;
         max-width: 600px;
         height: auto;
         }
         .inner {
         padding: 10px;
         }
         p {
         Margin: 0;
         padding-bottom: 10px;
         }
         .h1 {
         font-size: 21px;
         font-weight: bold;
         Margin-top: 15px;
         Margin-bottom: 5px;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         }
         .h2 {
         font-size: 18px;
         font-weight: bold;
         Margin-top: 10px;
         Margin-bottom: 5px;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         }
         .one-column .contents {
         text-align: left;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         }
         .one-column p {
         font-size: 14px;
         Margin-bottom: 10px;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         }
         .two-column {
         text-align: center;
         font-size: 0;
         }
         .two-column .column {
         width: 100%;
         max-width: 300px;
         display: inline-block;
         vertical-align: top;
         }
         .contents {
         width: 100%;
         }
         .two-column .contents {
         font-size: 14px;
         text-align: left;
         }
         .two-column img {
         width: 100%;
         max-width: 280px;
         height: auto;
         }
         .two-column .text {
         padding-top: 10px;
         }
         .three-column {
         text-align: center;
         font-size: 0;
         padding-top: 10px;
         padding-bottom: 10px;
         }
         .three-column .column {
         width: 100%;
         max-width: 200px;
         display: inline-block;
         vertical-align: top;
         }
         .three-column .contents {
         font-size: 14px;
         text-align: center;
         }
         .three-column img {
         width: 100%;
         max-width: 180px;
         height: auto;
         }
         .three-column .text {
         padding-top: 10px;
         }
         .img-align-vertical img {
         display: inline-block;
         vertical-align: middle;
         }
         .download-button {
         background-color: #009999;
         border: none;
         color: white;
         padding: 15px 32px;
         text-align: center;
         text-decoration: none;
         display: inline-block;
         font-size: 16px;
         margin: 4px 2px;
         cursor: pointer;
         }
         @@media only screen and (max-device-width: 480px) {
         table[class=hide], img[class=hide], td[class=hide] {
         display: none !important;
         }
         .contents1 {
         width: 100%;
         }
         .contents1 {
         width: 100%;
         }
         }
      </style>
   </head>
   <body style="Margin:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;min-width:100%;background-color:#f3f2f0;">
      <center class="wrapper" style="width:100%;table-layout:fixed;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#f3f2f0;">
         <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#f3f2f0;" bgcolor="#f3f2f0;">
            <tr>
               <td width="100%">
                  <div class="webkit" style="max-width:600px;Margin:0 auto;">
                     <table class="outer" align="center" cellpadding="0" cellspacing="0" border="0" style="border-spacing:0;Margin:0 auto;width:100%;max-width:600px;">
                        <tr>
                           <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;">
                              <table border="0" width="100%" cellpadding="0" cellspacing="0">
                                 <tr>
                                    <td>
                                       <table style="width:100%;" cellpadding="0" cellspacing="0" border="0">
                                          <tbody>
                                             <tr>
                                                <td align="center">
                                                   <center>
                                                      <table border="0" align="center" width="100%" cellpadding="0" cellspacing="0" style="Margin: 0 auto;">
                                                         <tbody>
                                                            <tr>
                                                               <td class="one-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;" bgcolor="#FFFFFF">
                                                                  <table cellpadding="0" cellspacing="0" border="0" width="100%" bgcolor="#f3f2f0">
                                                                     <tr>
                                                                        <td class="two-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;text-align:left;font-size:0;">
                                                                           <div class="column" style="max-width:150px;height:11px;display:inline-block;vertical-align:top;">
                                                                              <table class="contents" style="border-spacing:0; width:100%">
                                                                                 <tr>
                                                                                    <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:5px;" align="left">
                                                                                       <a href="#" target="_blank"><img src="https://bviewstorage.blob.core.windows.net/5cfabe47-dd1d-454b-8a71-72580aa92ad4/localsiteuploads/54910103-9ebe-4020-a347-4be1cbfc36be/snovasys-5ac4c12f-20b1-425f-b550-076cf851f59e.png" alt="" width="60" height="60" style="border-width:0; height:auto; display:block" align="left" /></a>
                                                                                    </td>
                                                                                 </tr>
                                                                              </table>
                                                                           </div>
                                                                           <div class="column" style="width:100%;max-width:518px;display:inline-block;vertical-align:top;">
                                                                              <table width="100" style="border-spacing:0" cellpadding="0" cellspacing="0" border="0">
                                                                                 <tr>
                                                                                    <td class="inner" style="padding-top:0px;padding-bottom:10px; padding-right:10px;padding-left:10px;">
                                                                                       <table class="contents" style="border-spacing:0; width:100%" cellpadding="0" cellspacing="0" border="0">
                                                                                          <tr>
                                                                                             <td align="left" valign="top">&nbsp;</td>
                                                                                          </tr>
                                                                                          <tr></tr>
                                                                                       </table>
                                                                                    </td>
                                                                                 </tr>
                                                                              </table>
                                                                           </div>
                                                                        </td>
                                                                     </tr>
                                                                     <tr>
                                                                        <td>&nbsp;</td>
                                                                     </tr>
                                                                  </table>
                                                               </td>
                                                            </tr>
                                                         </tbody>
                                                      </table>
                                                   </center>
                                                </td>
                                             </tr>
                                          </tbody>
                                       </table>
                                    </td>
                                 </tr>
                              </table>
                              <table class="one-column" border="0" cellpadding="0" cellspacing="0" width="100%" style="border-spacing:0; border-left:1px solid #e8e7e5; border-right:1px solid #e8e7e5; border-bottom:1px solid #e8e7e5; border-top:1px solid #e8e7e5" bgcolor="#FFFFFF">
                                 <tr>
                                    <td align="left" style="padding:50px 50px 50px 50px">
                                       <p style="color:#262626; font-size:24px; text-align:left; font-family: Verdana, Geneva, sans-serif">
                                       <h2>##OperationPerformedUser## Requested to replan the ##GoalLabel## - ##GoalName##(##GoalUniqueName##) from ##GoalStatus##</h2>
                                       </p>
                                       <div style="width: 100%;text-align: center;">
                                          <a style="text-decoration:none;text-align:center; font-weight:bold;font-size:18px; font-family: Arial, sans-serif; color: #ffffff" " href="##siteAddress##">                      
										  <button class="download-button" target="_blank" style="-moz-border-radius: 30px; -webkit-border-radius: 30px; border-radius: 30px;            background-color: #009999;border: none;color: white;padding: 15px 32px;text-align: center;text-decoration: none;display: inline-block;font-size: 16px;margin: 4px 2px;cursor: pointer; ">
										     Go to ##GoalUniqueName##
										  </button>   
										  </a>
                                       </div>
                                       <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">                                                              <br />                                                              Best Regards, <br />                                                              ##footerName##                                                          </p>
                                    </td>
                                 </tr>
                              </table>
                           </td>
                        </tr>
                     </table>
                  </div>
               </td>
            </tr>
         </table>
      </center>
   </body>
</html>',@CompanyId),
('SprintRequestedForReplanEmailTemplate',
'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
   <head>
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
      <!--[if !mso]><!-->
      <meta http-equiv="X-UA-Compatible" content="IE=edge" />
      <!--<![endif]-->
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title></title>
      <style type="text/css">
         * {
         -webkit-font-smoothing: antialiased;
         }
         body {
         Margin: 0;
         padding: 0;
         min-width: 100%;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         mso-line-height-rule: exactly;
         }
         table {
         border-spacing: 0;
         color: #333333;
         font-family: Arial, sans-serif;
         }
         img {
         border: 0;
         }
         .wrapper {
         width: 100%;
         table-layout: fixed;
         -webkit-text-size-adjust: 100%;
         -ms-text-size-adjust: 100%;
         }
         .webkit {
         max-width: 600px;
         }
         .outer {
         Margin: 0 auto;
         width: 100%;
         max-width: 600px;
         }
         .full-width-image img {
         width: 100%;
         max-width: 600px;
         height: auto;
         }
         .inner {
         padding: 10px;
         }
         p {
         Margin: 0;
         padding-bottom: 10px;
         }
         .h1 {
         font-size: 21px;
         font-weight: bold;
         Margin-top: 15px;
         Margin-bottom: 5px;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         }
         .h2 {
         font-size: 18px;
         font-weight: bold;
         Margin-top: 10px;
         Margin-bottom: 5px;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         }
         .one-column .contents {
         text-align: left;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         }
         .one-column p {
         font-size: 14px;
         Margin-bottom: 10px;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         }
         .two-column {
         text-align: center;
         font-size: 0;
         }
         .two-column .column {
         width: 100%;
         max-width: 300px;
         display: inline-block;
         vertical-align: top;
         }
         .contents {
         width: 100%;
         }
         .two-column .contents {
         font-size: 14px;
         text-align: left;
         }
         .two-column img {
         width: 100%;
         max-width: 280px;
         height: auto;
         }
         .two-column .text {
         padding-top: 10px;
         }
         .three-column {
         text-align: center;
         font-size: 0;
         padding-top: 10px;
         padding-bottom: 10px;
         }
         .three-column .column {
         width: 100%;
         max-width: 200px;
         display: inline-block;
         vertical-align: top;
         }
         .three-column .contents {
         font-size: 14px;
         text-align: center;
         }
         .three-column img {
         width: 100%;
         max-width: 180px;
         height: auto;
         }
         .three-column .text {
         padding-top: 10px;
         }
         .img-align-vertical img {
         display: inline-block;
         vertical-align: middle;
         }
         .download-button {
         background-color: #009999;
         border: none;
         color: white;
         padding: 15px 32px;
         text-align: center;
         text-decoration: none;
         display: inline-block;
         font-size: 16px;
         margin: 4px 2px;
         cursor: pointer;
         }
         @@media only screen and (max-device-width: 480px) {
         table[class=hide], img[class=hide], td[class=hide] {
         display: none !important;
         }
         .contents1 {
         width: 100%;
         }
         .contents1 {
         width: 100%;
         }
         }
      </style>
   </head>
   <body style="Margin:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;min-width:100%;background-color:#f3f2f0;">
      <center class="wrapper" style="width:100%;table-layout:fixed;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#f3f2f0;">
         <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#f3f2f0;" bgcolor="#f3f2f0;">
            <tr>
               <td width="100%">
                  <div class="webkit" style="max-width:600px;Margin:0 auto;">
                     <table class="outer" align="center" cellpadding="0" cellspacing="0" border="0" style="border-spacing:0;Margin:0 auto;width:100%;max-width:600px;">
                        <tr>
                           <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;">
                              <table border="0" width="100%" cellpadding="0" cellspacing="0">
                                 <tr>
                                    <td>
                                       <table style="width:100%;" cellpadding="0" cellspacing="0" border="0">
                                          <tbody>
                                             <tr>
                                                <td align="center">
                                                   <center>
                                                      <table border="0" align="center" width="100%" cellpadding="0" cellspacing="0" style="Margin: 0 auto;">
                                                         <tbody>
                                                            <tr>
                                                               <td class="one-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;" bgcolor="#FFFFFF">
                                                                  <table cellpadding="0" cellspacing="0" border="0" width="100%" bgcolor="#f3f2f0">
                                                                     <tr>
                                                                        <td class="two-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;text-align:left;font-size:0;">
                                                                           <div class="column" style="max-width:150px;height:11px;display:inline-block;vertical-align:top;">
                                                                              <table class="contents" style="border-spacing:0; width:100%">
                                                                                 <tr>
                                                                                    <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:5px;" align="left">
                                                                                       <a href="#" target="_blank"><img src="https://bviewstorage.blob.core.windows.net/5cfabe47-dd1d-454b-8a71-72580aa92ad4/localsiteuploads/54910103-9ebe-4020-a347-4be1cbfc36be/snovasys-5ac4c12f-20b1-425f-b550-076cf851f59e.png" alt="" width="60" height="60" style="border-width:0; height:auto; display:block" align="left" /></a>
                                                                                    </td>
                                                                                 </tr>
                                                                              </table>
                                                                           </div>
                                                                           <div class="column" style="width:100%;max-width:518px;display:inline-block;vertical-align:top;">
                                                                              <table width="100" style="border-spacing:0" cellpadding="0" cellspacing="0" border="0">
                                                                                 <tr>
                                                                                    <td class="inner" style="padding-top:0px;padding-bottom:10px; padding-right:10px;padding-left:10px;">
                                                                                       <table class="contents" style="border-spacing:0; width:100%" cellpadding="0" cellspacing="0" border="0">
                                                                                          <tr>
                                                                                             <td align="left" valign="top">&nbsp;</td>
                                                                                          </tr>
                                                                                          <tr></tr>
                                                                                       </table>
                                                                                    </td>
                                                                                 </tr>
                                                                              </table>
                                                                           </div>
                                                                        </td>
                                                                     </tr>
                                                                     <tr>
                                                                        <td>&nbsp;</td>
                                                                     </tr>
                                                                  </table>
                                                               </td>
                                                            </tr>
                                                         </tbody>
                                                      </table>
                                                   </center>
                                                </td>
                                             </tr>
                                          </tbody>
                                       </table>
                                    </td>
                                 </tr>
                              </table>
                              <table class="one-column" border="0" cellpadding="0" cellspacing="0" width="100%" style="border-spacing:0; border-left:1px solid #e8e7e5; border-right:1px solid #e8e7e5; border-bottom:1px solid #e8e7e5; border-top:1px solid #e8e7e5" bgcolor="#FFFFFF">
                                 <tr>
                                    <td align="left" style="padding:50px 50px 50px 50px">
                                       <p style="color:#262626; font-size:24px; text-align:left; font-family: Verdana, Geneva, sans-serif">
                                       <h2>##OperationPerformedUser## Requested to replan the sprint - ##SprintName##(##SprintUniqueName##) from ##SprintStatus##</h2>
                                       </p>
                                       <div style="width: 100%;text-align: center;">
                                          <a style="text-decoration:none;text-align:center; font-weight:bold;font-size:18px; font-family: Arial, sans-serif; color: #ffffff" " href="##siteAddress##">
										   <button class="download-button" target="_blank" style="-moz-border-radius: 30px; -webkit-border-radius: 30px; border-radius: 30px;            background-color: #009999;border: none;color: white;padding: 15px 32px;text-align: center;text-decoration: none;display: inline-block;font-size: 16px;margin: 4px 2px;cursor: pointer; ">
                                              Go to ##SprintUniqueName##
										  </button>
										  </a>                       
										                             
                                       </div>
                                       <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">                                                              <br />                                                              Best Regards, <br />                                                              ##footerName##                                                          </p>
                                    </td>
                                 </tr>
                              </table>
                           </td>
                        </tr>
                     </table>
                  </div>
               </td>
            </tr>
         </table>
      </center>
   </body>
</html>',@CompanyId),
( N'GoalReplanChangesTemplate',
		'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
   <head>
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
      <!--[if !mso]><!-->
      <meta http-equiv="X-UA-Compatible" content="IE=edge" />
      <!--<![endif]-->
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title></title>
      <style type="text/css">
         * {
         -webkit-font-smoothing: antialiased;
         }
         body {
         Margin: 0;
         padding: 0;
         min-width: 100%;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         mso-line-height-rule: exactly;
         }
		 .replanhistorytable {
		    border-collapse: collapse;
		 }
		  .replanhistorytable td,.replanhistorytable th {
		    border: 1px solid #000000;
		  }
         table {
         border-spacing: 0;
         color: #333333;
         font-family: Arial, sans-serif;
         }
         img {
         border: 0;
         }
         .wrapper {
         width: 100%;
         table-layout: fixed;
         -webkit-text-size-adjust: 100%;
         -ms-text-size-adjust: 100%;
         }
         .webkit {
         max-width: 600px;
         }
         .outer {
         Margin: 0 auto;
         width: 100%;
         max-width: 600px;
         }
         .full-width-image img {
         width: 100%;
         max-width: 600px;
         height: auto;
         }
         .inner {
         padding: 10px;
         }
         p {
         Margin: 0;
         padding-bottom: 10px;
         }
         .h1 {
         font-size: 21px;
         font-weight: bold;
         Margin-top: 15px;
         Margin-bottom: 5px;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         }
         .h2 {
         font-size: 18px;
         font-weight: bold;
         Margin-top: 10px;
         Margin-bottom: 5px;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         }
         .one-column .contents {
         text-align: left;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         }
         .one-column p {
         font-size: 14px;
         Margin-bottom: 10px;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         }
         .two-column {
         text-align: center;
         font-size: 0;
         }
         .two-column .column {
         width: 100%;
         max-width: 300px;
         display: inline-block;
         vertical-align: top;
         }
         .contents {
         width: 100%;
         }
         .two-column .contents {
         font-size: 14px;
         text-align: left;
         }
         .two-column img {
         width: 100%;
         max-width: 280px;
         height: auto;
         }
         .two-column .text {
         padding-top: 10px;
         }
         .three-column {
         text-align: center;
         font-size: 0;
         padding-top: 10px;
         padding-bottom: 10px;
         }
         .three-column .column {
         width: 100%;
         max-width: 200px;
         display: inline-block;
         vertical-align: top;
         }
         .three-column .contents {
         font-size: 14px;
         text-align: center;
         }
         .three-column img {
         width: 100%;
         max-width: 180px;
         height: auto;
         }
         .three-column .text {
         padding-top: 10px;
         }
         .img-align-vertical img {
         display: inline-block;
         vertical-align: middle;
         }
         .download-button {
         background-color: #009999;
         border: none;
         color: white;
         padding: 15px 32px;
         text-align: center;
         text-decoration: none;
         display: inline-block;
         font-size: 16px;
         margin: 4px 2px;
         cursor: pointer;
         }
         @@media only screen and (max-device-width: 480px) {
         table[class=hide], img[class=hide], td[class=hide] {
         display: none !important;
         }
         .contents1 {
         width: 100%;
         }
         .contents1 {
         width: 100%;
         }
         }
      </style>
   </head>
   <body style="Margin:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;min-width:100%;background-color:#f3f2f0;">
      <center class="wrapper" style="width:100%;table-layout:fixed;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#f3f2f0;">
         <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#f3f2f0;" bgcolor="#f3f2f0;">
            <tr>
               <td width="100%">
                  <div class="webkit" style="max-width:600px;Margin:0 auto;">
                     <table class="outer" align="center" cellpadding="0" cellspacing="0" border="0" style="border-spacing:0;Margin:0 auto;width:100%;max-width:600px;">
                        <tr>
                           <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;">
                              <table border="0" width="100%" cellpadding="0" cellspacing="0">
                                 <tr>
                                    <td>
                                       <table style="width:100%;" cellpadding="0" cellspacing="0" border="0">
                                          <tbody>
                                             <tr>
                                                <td align="center">
                                                   <center>
                                                      <table border="0" align="center" width="100%" cellpadding="0" cellspacing="0" style="Margin: 0 auto;">
                                                         <tbody>
                                                            <tr>
                                                               <td class="one-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;" bgcolor="#FFFFFF">
                                                                  <table cellpadding="0" cellspacing="0" border="0" width="100%" bgcolor="#f3f2f0">
                                                                     <tr>
                                                                        <td class="two-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;text-align:left;font-size:0;">
                                                                           <div class="column" style="max-width:150px;height:11px;display:inline-block;vertical-align:top;">
                                                                              <table class="contents" style="border-spacing:0; width:100%">
                                                                                 <tr>
                                                                                    <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:5px;" align="left">
                                                                                       <a href="#" target="_blank"><img src="https://bviewstorage.blob.core.windows.net/5cfabe47-dd1d-454b-8a71-72580aa92ad4/localsiteuploads/54910103-9ebe-4020-a347-4be1cbfc36be/snovasys-5ac4c12f-20b1-425f-b550-076cf851f59e.png" alt="" width="60" height="60" style="border-width:0; height:auto; display:block" align="left" /></a>
                                                                                    </td>
                                                                                 </tr>
                                                                              </table>
                                                                           </div>
                                                                           <div class="column" style="width:100%;max-width:518px;display:inline-block;vertical-align:top;">
                                                                              <table width="100" style="border-spacing:0" cellpadding="0" cellspacing="0" border="0">
                                                                                 <tr>
                                                                                    <td class="inner" style="padding-top:0px;padding-bottom:10px; padding-right:10px;padding-left:10px;">
                                                                                       <table class="contents" style="border-spacing:0; width:100%" cellpadding="0" cellspacing="0" border="0">
                                                                                          <tr>
                                                                                             <td align="left" valign="top">&nbsp;</td>
                                                                                          </tr>
                                                                                          <tr></tr>
                                                                                       </table>
                                                                                    </td>
                                                                                 </tr>
                                                                              </table>
                                                                           </div>
                                                                        </td>
                                                                     </tr>
                                                                     <tr>
                                                                        <td>&nbsp;</td>
                                                                     </tr>
                                                                  </table>
                                                               </td>
                                                            </tr>
                                                         </tbody>
                                                      </table>
                                                   </center>
                                                </td>
                                             </tr>
                                          </tbody>
                                       </table>
                                    </td>
                                 </tr>
                              </table>
                              <table class="one-column" border="0" cellpadding="0" cellspacing="0" width="100%" style="border-spacing:0; border-left:1px solid #e8e7e5; border-right:1px solid #e8e7e5; border-bottom:1px solid #e8e7e5; border-top:1px solid #e8e7e5" bgcolor="#FFFFFF">
                                 <tr>
                                    <td align="left" style="padding:50px 50px 50px 50px">
                                       <p style="color:#262626; font-size:24px; text-align:left; font-family: Verdana, Geneva, sans-serif">
                                       <h2>##OperationPerformedUser## replanned the ##Goal## of - ##GoalName##(<a  href="##siteAddress##" target="_blank">##GoalUniqueName##</a>) with the below changes </h2>
                                       </p>
									   <p>##ReplanJson##</p>
                                       
                                       <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">                                                              <br />                                                              Best Regards, <br />                                                              ##footerName##                                                          </p>
                                    </td>
                                 </tr>
                              </table>
                           </td>
                        </tr>
                     </table>
                  </div>
               </td>
            </tr>
         </table>
      </center>
   </body>
</html>',@CompanyId),
		(N'SprintReplanChangesTemplate',
		'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
   <head>
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
      <!--[if !mso]><!-->
      <meta http-equiv="X-UA-Compatible" content="IE=edge" />
      <!--<![endif]-->
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title></title>
      <style type="text/css">
         * {
         -webkit-font-smoothing: antialiased;
         }
         body {
         Margin: 0;
         padding: 0;
         min-width: 100%;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         mso-line-height-rule: exactly;
         }
		 .replanhistorytable {
		    border-collapse: collapse;
		 }
		  .replanhistorytable td,.replanhistorytable th {
		    border: 1px solid #000000;
		  }
         table {
         border-spacing: 0;
         color: #333333;
         font-family: Arial, sans-serif;
         }
         img {
         border: 0;
         }
         .wrapper {
         width: 100%;
         table-layout: fixed;
         -webkit-text-size-adjust: 100%;
         -ms-text-size-adjust: 100%;
         }
         .webkit {
         max-width: 600px;
         }
         .outer {
         Margin: 0 auto;
         width: 100%;
         max-width: 600px;
         }
         .full-width-image img {
         width: 100%;
         max-width: 600px;
         height: auto;
         }
         .inner {
         padding: 10px;
         }
         p {
         Margin: 0;
         padding-bottom: 10px;
         }
         .h1 {
         font-size: 21px;
         font-weight: bold;
         Margin-top: 15px;
         Margin-bottom: 5px;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         }
         .h2 {
         font-size: 18px;
         font-weight: bold;
         Margin-top: 10px;
         Margin-bottom: 5px;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         }
         .one-column .contents {
         text-align: left;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         }
         .one-column p {
         font-size: 14px;
         Margin-bottom: 10px;
         font-family: Arial, sans-serif;
         -webkit-font-smoothing: antialiased;
         }
         .two-column {
         text-align: center;
         font-size: 0;
         }
         .two-column .column {
         width: 100%;
         max-width: 300px;
         display: inline-block;
         vertical-align: top;
         }
         .contents {
         width: 100%;
         }
         .two-column .contents {
         font-size: 14px;
         text-align: left;
         }
         .two-column img {
         width: 100%;
         max-width: 280px;
         height: auto;
         }
         .two-column .text {
         padding-top: 10px;
         }
         .three-column {
         text-align: center;
         font-size: 0;
         padding-top: 10px;
         padding-bottom: 10px;
         }
         .three-column .column {
         width: 100%;
         max-width: 200px;
         display: inline-block;
         vertical-align: top;
         }
         .three-column .contents {
         font-size: 14px;
         text-align: center;
         }
         .three-column img {
         width: 100%;
         max-width: 180px;
         height: auto;
         }
         .three-column .text {
         padding-top: 10px;
         }
         .img-align-vertical img {
         display: inline-block;
         vertical-align: middle;
         }
         .download-button {
         background-color: #009999;
         border: none;
         color: white;
         padding: 15px 32px;
         text-align: center;
         text-decoration: none;
         display: inline-block;
         font-size: 16px;
         margin: 4px 2px;
         cursor: pointer;
         }
         @@media only screen and (max-device-width: 480px) {
         table[class=hide], img[class=hide], td[class=hide] {
         display: none !important;
         }
         .contents1 {
         width: 100%;
         }
         .contents1 {
         width: 100%;
         }
         }
      </style>
   </head>
   <body style="Margin:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;min-width:100%;background-color:#f3f2f0;">
      <center class="wrapper" style="width:100%;table-layout:fixed;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#f3f2f0;">
         <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#f3f2f0;" bgcolor="#f3f2f0;">
            <tr>
               <td width="100%">
                  <div class="webkit" style="max-width:600px;Margin:0 auto;">
                     <table class="outer" align="center" cellpadding="0" cellspacing="0" border="0" style="border-spacing:0;Margin:0 auto;width:100%;max-width:600px;">
                        <tr>
                           <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;">
                              <table border="0" width="100%" cellpadding="0" cellspacing="0">
                                 <tr>
                                    <td>
                                       <table style="width:100%;" cellpadding="0" cellspacing="0" border="0">
                                          <tbody>
                                             <tr>
                                                <td align="center">
                                                   <center>
                                                      <table border="0" align="center" width="100%" cellpadding="0" cellspacing="0" style="Margin: 0 auto;">
                                                         <tbody>
                                                            <tr>
                                                               <td class="one-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;" bgcolor="#FFFFFF">
                                                                  <table cellpadding="0" cellspacing="0" border="0" width="100%" bgcolor="#f3f2f0">
                                                                     <tr>
                                                                        <td class="two-column" style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;text-align:left;font-size:0;">
                                                                           <div class="column" style="max-width:150px;height:11px;display:inline-block;vertical-align:top;">
                                                                              <table class="contents" style="border-spacing:0; width:100%">
                                                                                 <tr>
                                                                                    <td style="padding-top:0;padding-bottom:0;padding-right:0;padding-left:5px;" align="left">
                                                                                       <a href="#" target="_blank"><img src="https://bviewstorage.blob.core.windows.net/5cfabe47-dd1d-454b-8a71-72580aa92ad4/localsiteuploads/54910103-9ebe-4020-a347-4be1cbfc36be/snovasys-5ac4c12f-20b1-425f-b550-076cf851f59e.png" alt="" width="60" height="60" style="border-width:0; height:auto; display:block" align="left" /></a>
                                                                                    </td>
                                                                                 </tr>
                                                                              </table>
                                                                           </div>
                                                                           <div class="column" style="width:100%;max-width:518px;display:inline-block;vertical-align:top;">
                                                                              <table width="100" style="border-spacing:0" cellpadding="0" cellspacing="0" border="0">
                                                                                 <tr>
                                                                                    <td class="inner" style="padding-top:0px;padding-bottom:10px; padding-right:10px;padding-left:10px;">
                                                                                       <table class="contents" style="border-spacing:0; width:100%" cellpadding="0" cellspacing="0" border="0">
                                                                                          <tr>
                                                                                             <td align="left" valign="top">&nbsp;</td>
                                                                                          </tr>
                                                                                          <tr></tr>
                                                                                       </table>
                                                                                    </td>
                                                                                 </tr>
                                                                              </table>
                                                                           </div>
                                                                        </td>
                                                                     </tr>
                                                                     <tr>
                                                                        <td>&nbsp;</td>
                                                                     </tr>
                                                                  </table>
                                                               </td>
                                                            </tr>
                                                         </tbody>
                                                      </table>
                                                   </center>
                                                </td>
                                             </tr>
                                          </tbody>
                                       </table>
                                    </td>
                                 </tr>
                              </table>
                              <table class="one-column" border="0" cellpadding="0" cellspacing="0" width="100%" style="border-spacing:0; border-left:1px solid #e8e7e5; border-right:1px solid #e8e7e5; border-bottom:1px solid #e8e7e5; border-top:1px solid #e8e7e5" bgcolor="#FFFFFF">
                                 <tr>
                                    <td align="left" style="padding:50px 50px 50px 50px">
                                       <p style="color:#262626; font-size:24px; text-align:left; font-family: Verdana, Geneva, sans-serif">
                                       <h2>##OperationPerformedUser## replanned the sprint of - ##SprintName##(<a  href="##siteAddress##" target="_blank">##SprintUniqueName##</a>) with the below changes </h2>
                                       </p>
									   <p>##ReplanJson##</p>
                                       
                                       <p style="color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px ">                                                              <br />                                                              Best Regards, <br />                                                              ##footerName##                                                          </p>
                                    </td>
                                 </tr>
                              </table>
                           </td>
                        </tr>
                     </table>
                  </div>
               </td>
            </tr>
         </table>
      </center>
   </body>
</html>',@CompanyId)
)
AS Source ([TemplateName], [HtmlTemplate],CompanyId) 
ON Target.[TemplateName] = Source.[TemplateName]  
AND Target.CompanyId = Source.CompanyId  
WHEN MATCHED THEN 
UPDATE SET [HtmlTemplate] = Source.[HtmlTemplate];

END
GO