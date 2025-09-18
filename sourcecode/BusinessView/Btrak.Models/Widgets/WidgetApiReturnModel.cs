using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.Widgets
{
    public class WidgetApiReturnModel
    {
        public Guid? WidgetId { get; set; }

        public string RoleIds { get; set; }

        public string RoleNames { get; set; }

        public string WidgetName { get; set; }

        public bool IsCustomWidget { get; set; }

        public bool IsArchived { get; set; }

        public byte[] TimeStamp { get; set; }

        public string Description { get; set; }

        public string Tags { get; set; }

        public string WidgetQuery { get; set; }

        public Guid? CustomAppVisualizationId { get; set; }

        public List<CustomAppChartModel> AllChartsDetails { get; set; }

        public bool? IsHtml { get; set; }

        public bool? IsProc { get; set; }

        public bool? IsApi { get; set; }
        public bool? IsMongoQuery { get; set; }

        public string ProcName { get; set; }

        public string WorkSpaceNames { get; set; }
        
        public bool? IsProcess { get; set; }

        public bool? IsEntryApp { get; set; }

        public bool? IsPublished { get; set; }

        public int? Id { get; set; }

        public bool? isEditable { get; set; }

        public string Filters { get; set; }

        public string TotalCount { get; set; }

        public bool? IsFavouriteWidget { get; set; }

        public string VisualizationType { get; set; }
        public string CollectionName { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("WidgetId = " + WidgetId);
            stringBuilder.Append(", WidgetName = " + WidgetName);
            stringBuilder.Append(", RoleIds = " + RoleIds);
            stringBuilder.Append(", RoleNames = " + RoleNames);
            stringBuilder.Append(", Tags = " + Tags);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", IsHtml = " + IsHtml);
            stringBuilder.Append(", IsApi = " + IsProc);
            stringBuilder.Append(", IsProcess = " + IsProcess);
            stringBuilder.Append(", IsPublished = " + IsPublished);
            return stringBuilder.ToString();
        }
    }
}
