using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ActivityTracker
{
    public class TeamActivityInputModel
    {
        public List<Guid> UserId { get; set; }
        public DateTime? OnDate { get; set; }
        public List<Guid> RoleId { get; set; }
        public string RoleIdXml { get; set; }
        public List<Guid> BranchId { get; set; }
        public string BranchIdXml { get; set; }
        public string UserIdXml { get; set; }
        public string DateFrom { get; set; }
        public string DateTo { get; set; }
        public bool IsForSummary { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", UserId" + UserId);
            stringBuilder.Append(", OnDate" + OnDate);
            return stringBuilder.ToString();
        }
    }
}
