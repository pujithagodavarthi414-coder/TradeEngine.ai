using System;
using System.Collections.Generic;

namespace Btrak.Models.Widgets
{
    public class DashboardOrderSearchCriteriaInputModel
    {
        public Guid? WorkspaceId { get; set; }
        public List<Guid> DashboardIds { get; set; }
    }
}
