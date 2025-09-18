using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.Widgets
{
    public class CustomWidgetsApiReturnModel
    {
        public Guid? CustomWidgetId { get; set; }

        public string RoleIds { get; set; }

        public string Description { get; set; }

        public string RoleNames { get; set; }

        public string CustomWidgetName { get; set; }

        public string WidgetQuery { get; set; }

        public string VisualizationType { get; set; }

        public string VisualizationName { get; set; }

        public string XAxisColumnName { get; set; }

        public string YAxisDetails { get; set; }

        public string DefaultColumns { get; set; }
        public string ColumnAltName { get; set; }

        public bool IsArchived { get; set; }

        public bool IsEditable { get; set; }

        public string CustomWidgetsMultipleChartsXML { get; set; }

        public string CronExpressionName { get; set; }

        public string SelectedCharts { get; set; }

        public string CronExpression { get; set; }

        public string ModuleIds { get; set; }
        public string ModuleNames { get; set; }

        public string TemplateType { get; set; }
        
        public List<CustomAppChartModel> AllChartsDetails { get; set; }

        public Guid? CronExpressionId { get; set; }

        public string Tags { get; set; }

        public string TemplateUrl { get; set; }

        public Byte[] TimeStamp { get; set; }

        public int? JobId { get; set; }

        public bool? IsHtml { get; set; }

        public string FileUrls { get; set; }

        public bool? IsProc { get; set; }

        public bool? IsApi { get; set; }

        public string ProcName { get; set; }

        public Guid? CustomStoredProcId { get; set; }

        public Byte[] CustomProcWidgetTimeStamp { get; set; }

        public string SubQueryType { get; set; }

        public string SubQuery { get; set; }

        public string CustomAppColumns { get; set; }

        public string PersistanceJson { get; set; }

        public bool? IsFavouriteWidget { get; set; }

        public bool? IsQuery { get; set; }
        public bool? IsMongoQuery { get; set; }
        public string HeaderBackgroundColor { get; set; }
        public string HeaderFontColor { get; set; }
        public string ColumnBackgroundColor { get; set; }
        public string ColumnFontFamily { get; set; }
        public string ColumnFontColor { get; set; }
        public string RowBackgroundColor { get; set; }
        public string CollectionName { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CustomWidgetId = " + CustomWidgetId);
            stringBuilder.Append(", CustomWidgetName = " + CustomWidgetName);
            stringBuilder.Append(", Description = " + Description);
            stringBuilder.Append(", WidgetQuery = " + WidgetQuery);
            stringBuilder.Append(", RoleIds = " + RoleIds);
            stringBuilder.Append(", RoleNames = " + RoleNames);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", CronExpressionName = " + CronExpressionName);
            stringBuilder.Append(", SelectedCharts = " + SelectedCharts);
            stringBuilder.Append(", CronExpression = " + CronExpression);
            stringBuilder.Append(", TemplateType = " + TemplateType);
            stringBuilder.Append(", CronExpressionId = " + CronExpressionId);
            stringBuilder.Append(", TemplateUrl = " + TemplateUrl);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", Tags = " + Tags);
            stringBuilder.Append(", JobId = " + JobId);
            stringBuilder.Append(", FileUrls = " + FileUrls);
            stringBuilder.Append(", FileUrls = " + IsProc);
            stringBuilder.Append(", FileUrls = " + ProcName);
            stringBuilder.Append(", CustomStoredProcId = " + CustomStoredProcId);
            stringBuilder.Append(", CustomProcWidgetTimeStamp = " + CustomProcWidgetTimeStamp);
            stringBuilder.Append(", HeaderBackgroundColor = " + HeaderBackgroundColor);
            stringBuilder.Append(", HeaderFontColor = " + HeaderFontColor);
            stringBuilder.Append(", ColumnBackgroundColor = " + ColumnBackgroundColor);
            stringBuilder.Append(", ColumnFontFamily = " + ColumnFontFamily);
            stringBuilder.Append(", ColumnFontColor = " + ColumnFontColor);
            stringBuilder.Append(", RowBackgroundColor = " + RowBackgroundColor);
            return stringBuilder.ToString();
        }
    }
}
