using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Performance
{
    public class PerformanceConfigurationOutputModel
    {
        public Guid? ConfigurationId { get; set; }
        public string ConfigurationName { get; set; }
        public string SelectedRoles { get; set; }
        public List<Guid> SelectedRoleIds { get; set; }
        public string RoleNames { get; set; }
        public string FormJson { get; set; }
        public byte[] TimeStamp { get; set; }
        public bool IsArchived { get; set; }
        public bool IsDraft { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public string CreatedBy { get; set; }
        public string CreatedByImage { get; set; }
        public DateTime CreatedDatetime { get; set; }
        public int TotalCount { get; set; }
    }
}
