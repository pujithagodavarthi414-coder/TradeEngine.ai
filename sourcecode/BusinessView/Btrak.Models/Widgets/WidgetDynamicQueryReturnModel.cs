using System;
using System.Collections.Generic;

namespace Btrak.Models.Widgets
{
    public class WidgetDynamicQueryReturnModel
    {
        public List<CustomWidgetHeaderModel> Headers { get; set; }

        public string QueryData { get; set; }

        public string FilterQuery { get; set; }

        public string Name { get; set; }

        public string Description { get; set; }

        public List<CustomAppChartModel> AllChartsDetails { get; set; }

        public bool? DoSubQueryExists { get; set; }
        public string ChartColorJson { get; set; }
    }

    public class WidgetHeadersWithData
    {
        public string HeadersJson { get; set; }

        public string Query { get; set; }
    }

    public class CustomWidgetHeaderModel
    {
        public string Field { get; set; }
        public string ColumnAltName { get; set; }
        public string HeaderBackgroundColor { get; set; }
        public string HeaderFontColor { get; set; }
        public string ColumnBackgroundColor { get; set; }
        public string ColumnFontFamily { get; set; }
        public string ColumnFontColor { get; set; }
        public string RowBackgroundColor { get; set; }

        public string Width { get; set; }

        public string Title { get; set; }

        public string Filter { get; set; }

        public bool Hidden { get; set; }

        public int MaxLength { get; set; }

        public bool IsNullable { get; set; }

        public bool IncludeInFilters { get; set; }

        public string QueryVariable { get; set; }

        public string SubQuery { get; set; }

        public string SubQueryType { get; set; }

        public Guid? SubQueryTypeId { get; set; }

        public Guid? ColumnFormatTypeId { get; set; }
        public string ColumnFormatType { get; set; }

        public bool? IsAvailableForFiltering { get; set; }

        public string ColumnName { get; set; }

        public string ColumnType { get; set; }
    }

    public class QueryBuilder
    {
        public string Condition { get; set; }

        public List<QueryRule> Rules { get; set; }
    }

    public class QueryRule
    {
        public string Field { get; set; }

        public string Operator { get; set; }

        public string Value { get; set; }

        public string Condition { get; set; }

        public List<QueryRule> Rules { get; set; }
    }
}
