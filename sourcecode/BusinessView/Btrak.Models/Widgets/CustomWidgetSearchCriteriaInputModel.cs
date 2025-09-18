using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Widgets
{
    public class CustomWidgetSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {

        public CustomWidgetSearchCriteriaInputModel() : base(InputTypeGuidConstants.CustomWidgetSearchCriteriaInputCommandTypeGuid)
        {
        }

        public Guid? CustomWidgetId { get; set; }

        public Guid? DashboardId { get; set; }

        public Guid? WorkspaceId { get; set; }

        public Guid? SubmittedFormId { get; set; }

        public string CustomWidgetName { get; set; }

        public DashboardFilterModel DashboardFilters { get; set; }

        public string SubQueryType { get; set; }

        public string SubQuery { get; set; }

        public bool? GetSubQuery { get; set; }

        public bool? IsExport { get; set; }

        public bool IsReportingOnly { get; set; }

        public bool IsAll { get; set; }

        public bool IsMyself { get; set; }

        public bool IsFormTags { get; set; }

        public bool? IsQuery { get; set; }
        public bool? IsMongoQuery { get; set; }
        public string CollectionName { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("WidgetId = " + CustomWidgetId);
            stringBuilder.Append("CustomWidgetName = " + CustomWidgetName);
            stringBuilder.Append("SubQueryType = " + SubQueryType);
            stringBuilder.Append("SubQuery = " + SubQuery);
            stringBuilder.Append("IsFormTags = " + IsFormTags);
            return stringBuilder.ToString();
        }
    }
}
