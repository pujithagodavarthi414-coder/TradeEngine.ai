using System;
using System.Collections.Generic;

namespace Btrak.Models
{
    public class OrgChartModel
    {
        public Guid UserId { get; set; }
        public string UserName { get; set; }
        public string Image { get; set; }
        public string Designation { get; set; }
        public List<OrgChartModel> childOrgChart { get; set; }
    }
}
