using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Widgets
{
    public class WorkspaceDashboardFilterInputModel
    {
        public Guid? WorkspaceDashboardFilterId { get; set; }
        public Guid? WorkspaceDashboardId { get; set; }
        public string FilterJson { get; set; }
        public bool IsCalenderView { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("WorkspaceDashboardFilterId = " + WorkspaceDashboardFilterId);
            stringBuilder.Append("WorkspaceDashboardId = " + WorkspaceDashboardId);
            stringBuilder.Append("FilterJson = " + FilterJson);
            stringBuilder.Append("IsCalenderView = " + IsCalenderView);
            return stringBuilder.ToString();
        }
    }
}
