using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Widgets
{
    public class WorkspaceDashboardFilterOutputModel
    {
        public Guid? WorkspaceDashboardFilterId { get; set; }
        public Guid? WorkspaceDashboardId { get; set; }
        public string FilterJson { get; set; }
        public bool IsCalenderView { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("WorkspaceDashboardFilterId = " + WorkspaceDashboardFilterId);
            stringBuilder.Append("WorkspaceDashboardId = " + WorkspaceDashboardId);
            stringBuilder.Append("FilterJson = " + FilterJson);
            stringBuilder.Append("IsCalenderView = " + IsCalenderView);
            stringBuilder.Append("CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append("CreatedDateTime = " + CreatedDateTime);
            return stringBuilder.ToString();
        }
    }
}
