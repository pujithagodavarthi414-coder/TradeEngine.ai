using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.Widgets
{
    public class DashboardApiReturnModel
    {
        public Guid DashboardId { get; set; }

        public Guid WorkspaceId { get; set; }

        public bool? IsArchived { get; set; }

        public int Cols { get; set; }

        public int Rows { get; set; }

        public int X { get; set; }

        public int Y { get; set; }

        public int MinItemCols { get; set; }

        public int MinItemRows { get; set; }

        public bool IsDraft { get; set; }

        public string Name { get; set; }

        public string DashboardName { get; set; }

        public string Component { get; set; }

        public Guid? CustomWidgetId { get; set; }

        public bool? IsCustomWidget { get; set; }

        public string GridData { get; set; }

        public List<CustomWidgetHeaderModel> GridColumns { get; set; }

        public string FilterQuery { get; set; }

        public string VisualizationType { get; set; }

        public string VisualizationName { get; set; }

        public string XCoOrdinate { get; set; }

        public string YCoOrdinate { get; set; }

        public string ModuleIds { get; set; }

        public string PersistanceJson { get; set; }

        public Guid? CustomAppVisualizationId { get; set; }

        public bool? IsProc { get; set; }

        public string ProcName { get; set; }

        public bool? IsProcess { get; set; }

        public bool? IsApi { get; set; }

        public bool? IsHtml { get; set; }

        public bool? IsEditable { get; set; }

        public string CustomWidgetOriginalName { get; set; }

        public string ExtraVariableJson { get; set; }
        public int Order { get; set; }
        public bool? IsMongoQuery { get; set; }
        public string CollectionName { get; set; }
       
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("DashboardId = " + DashboardId);
            stringBuilder.Append(", WorkspaceId = " + WorkspaceId);
            stringBuilder.Append(", Cols = " + Cols);
            stringBuilder.Append(", Rows = " + Rows);
            stringBuilder.Append(", X = " + X);
            stringBuilder.Append(", Y = " + Y);
            stringBuilder.Append(", MinItemCols = " + MinItemCols);
            stringBuilder.Append(", IsDraft = " + IsDraft);
            stringBuilder.Append(", MinItemRows = " + MinItemRows);
            stringBuilder.Append(", Name = " + Name);
            stringBuilder.Append(", Component = " + Component);
            stringBuilder.Append(", PersistanceJson = " + PersistanceJson);
            stringBuilder.Append(", CustomWidgetId = " + CustomWidgetId);
            stringBuilder.Append(", IsCustomWidget = " + IsCustomWidget);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", IsProc = " + IsProc);
            stringBuilder.Append(", ProcName = " + ProcName);
            stringBuilder.Append(", IsProcess = " + IsProcess);
            stringBuilder.Append(", IsHtml = " + IsHtml);
            stringBuilder.Append(", ExtraVariableJson = " + ExtraVariableJson);

            return stringBuilder.ToString();
        }
    }
}
