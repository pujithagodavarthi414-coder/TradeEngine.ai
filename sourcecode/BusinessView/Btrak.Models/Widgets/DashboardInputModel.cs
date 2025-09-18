using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.Widgets
{
    public class DashboardInputModel : InputModelBase
    {
        public DashboardInputModel() : base(InputTypeGuidConstants.WidgetUpsertInputCommandTypeGuid)
        {
        }
        public Guid? Id { get; set; }
        public string WorkspaceName { get; set; }
        public Guid? CustomAppId { get; set; }
        public Guid? WorkspaceId { get; set; }
        public bool? IsArchived { get; set; }
        public string FilterQuery { get; set; }
        public Guid? CustomAppVisualizationId { get; set; }
        public List<DashboardModel> Dashboard { get; set; }
        public bool? IsFromImport { get; set; }
        public bool? IsDefaultforAll { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("DashboardId = " + Id);
            stringBuilder.Append(", WorkspaceName = " + WorkspaceName);
            stringBuilder.Append(", FilterQuery = " + FilterQuery);
            return stringBuilder.ToString();
        }
    }
}
