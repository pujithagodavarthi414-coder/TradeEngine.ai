using System;
using System.Collections.Generic;
using System.Web.Script.Serialization;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models.Burndown;

namespace Btrak.Services.BurnDowns
{
    public class BurndownService : IBurndownService
    {
        private readonly GoalRepository _goalRepository = new GoalRepository();

        public string GetBurndownChartHtml(BurnDownChartModel burnDownChartModel)
        {
            var html = "<!DOCTYPE html>\r\n<meta charset=\"utf-8\">\r\n<body>\r\n  <div id=\"container\">\r\n  </div>\r\n</body>\r\n<script src=\"https://cdnjs.cloudflare.com/ajax/libs/d3/3.5.10/d3.min.js\"></script>\r\n<script src=\"https://cdn.rawgit.com/theodo/d3-burn-down-chart/master/dist/d3-bdc.js\"></script>\r\n<script>";

            html += "config = { \ncontainerId: '#container',\nwidth: " + burnDownChartModel.ConfigModel.Width
                    + ",\nheight: " + burnDownChartModel.ConfigModel.Height
                    + ",\nmargins: { \ntop: " + burnDownChartModel.ConfigModel.Margins.Top
                    + ",\nright: " + burnDownChartModel.ConfigModel.Margins.Right
                    + ",\nbottom: " + burnDownChartModel.ConfigModel.Margins.Bottom
                    + ",\nleft: " + burnDownChartModel.ConfigModel.Margins.Left + "},"
                    + "\ncolors: { \nstandard: '" + burnDownChartModel.ConfigModel.DisplayColors.Standard
                    + "',\ndone: '" + burnDownChartModel.ConfigModel.DisplayColors.Done
                    + "',\ngood: '" + burnDownChartModel.ConfigModel.DisplayColors.Good
                    + "',\nbad: '" + burnDownChartModel.ConfigModel.DisplayColors.Bad + "'\n},"
                    + "\nstartLabel: '" + burnDownChartModel.ConfigModel.StartLabel + "',\ndateFormat: '%A',"
                    + "\nxTitle: '" + burnDownChartModel.ConfigModel.XTitle + "',\ndotRadius: 4,\r\n  standardStrokeWidth: 2,\r\n  doneStrokeWidth: 2,\r\n  goodSuffix: \' :)\',\r\n  badSuffix: \' :(\'\r\n};"; 


            html += "data = [";

            foreach (var data in burnDownChartModel.BurnDownData)
            {
                html += "{" + "date : new Date(" + data.Date.Year + "," + data.Date.Month + "," + data.Date.Day +
                        "),\n standard:" + data.Standard + ",\n done:" + data.Done + ",},";
            }

            html += "\n];\r\nrenderBDC(data, config);\r\n</script>";

            return html;
        }

        public string GetD3BurndownChartHtml(List<BurndownModel> burndownModel, int yMax, Guid? companyId)
        {
            var burndownChartJson = new JavaScriptSerializer().Serialize(burndownModel);

            var html = _goalRepository.GetHtmlTemplateByName("BurndownTemplate", companyId).Replace("##burndownChartJson##", burndownChartJson).Replace("##yMax##", yMax.ToString());

            return html;
        }
    }
}