using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.Widgets
{
    public class DashboardModel
    {
        public Guid? DashboardId { get; set; }
        public string DashboardName { get; set; }
        public int Cols { get; set; }
        public int Rows { get; set; }
        public int X { get; set; }
        public int Y { get; set; }
        public int MinItemCols { get; set; }
        public bool IsDraft { get; set; }
        public int MinItemRows { get; set; }
        public string Name { get; set; }
        public string Component { get; set; }
        public Guid? CustomWidgetId { get; set; }
        public bool? IsCustomWidget { get; set; }
        public string GridData { get; set; }
        public List<CustomWidgetHeaderModel> GridColumns { get; set; }
        public string FilterQuery { get; set; }
        public bool IsArchived { get; set; }
        public Guid? CustomAppVisualizationId { get; set; }
        public bool? IsProceess { get; set; }
        public string ExtraVariableJson { get; set; }
        public int? Order { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("DashboardId = " + DashboardId);
            stringBuilder.Append(", DashboardName = " + DashboardName);
            stringBuilder.Append(", Columns = " + Cols);
            stringBuilder.Append(", Rows = " + Rows);
            stringBuilder.Append(", X = " + X);
            stringBuilder.Append(", Y = " + Y);
            stringBuilder.Append(", MinItemCols = " + MinItemCols);
            stringBuilder.Append(", MinItemRows = " + MinItemRows);
            stringBuilder.Append(", IsDraft = " + IsDraft);
            stringBuilder.Append(", CustomWidgetId = " + CustomWidgetId);
            stringBuilder.Append(", IsCustomWidget = " + IsCustomWidget);
            stringBuilder.Append(", Name = " + Name);
            stringBuilder.Append(", Component = " + Component);
            stringBuilder.Append(", FilterQuery = " + FilterQuery);
            return stringBuilder.ToString();
        }
    }
}
