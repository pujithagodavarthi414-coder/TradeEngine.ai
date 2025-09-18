using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Widgets
{
    public class DashboardSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public DashboardSearchCriteriaInputModel() : base(InputTypeGuidConstants.DashboardSearchCriteriaInputCommandTypeGuid)
        {
        }

        public Guid? DashboardId { get; set; }

        public Guid? WorkspaceId { get; set; }

        public Guid? CustomWidgetId { get; set; }

        public string AppName { get; set; }
        public string DashboardName { get; set; }
        public string IsCustomizedFor { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("DashboardId = " + DashboardId);
            stringBuilder.Append(", WorkspaceId = " + WorkspaceId);
            stringBuilder.Append(", CustomWidgetId = " + CustomWidgetId);
            stringBuilder.Append(", AppName = " + AppName);
            return stringBuilder.ToString();
        }
    }
}
