using System;
using System.Collections.Generic;

namespace Btrak.Models.Widgets
{
    public class WidgetDynamicQueryModel
    {
        public string DynamicQuery { get; set; }

        public string FilterQuery { get; set; }

        public string ColumnFormatQuery { get; set; }
        public string ColumnAltName { get; set; }

        public string Name { get; set; }

        public string Description { get; set; }

        public Guid? SubmittedFormId { get; set; }

        public Guid? WorkspaceId { get; set; }

        public Guid? DashboardId { get; set; }

        public bool? IsSubQuery { get; set; }

        public DashboardFilterModel DashboardFilters { get; set; }

        public List<CustomAppChartModel> AllChartsDetails { get; set; }

        public bool? DoSubQueryExists { get; set; }

        public string SubQueryType { get; set; }

        public Guid? CustomWidgetId { get; set; }

      public string ClickedColumnData { get; set; }

      public string ClikedColumnDataXml { get; set; }

      public string ClickedColumn { get; set; }

        public bool IsReportingOnly { get; set; }

        public bool IsAll { get; set; }

        public bool IsMyself { get; set; }
        public bool? IsMongoQuery { get; set; }
        public string CollectionName { get; set; }
        public string ChartColorJson { get; set; }

    }
}
