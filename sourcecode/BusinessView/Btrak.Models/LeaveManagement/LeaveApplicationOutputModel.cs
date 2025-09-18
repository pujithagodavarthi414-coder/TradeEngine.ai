using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.LeaveManagement
{
    public class LeaveApplicationOutputModel
    {
        public string AppliedUsername { get; set; }
        public Guid? AppliedUserId { get; set; }
        public DateTime? LeaveDateFrom { get; set; }
        public DateTime? LeaveDateTo { get; set; }
        public float? NumberOfDays { get; set; }
        public Guid? ReportToUserId { get; set; }
        public string ReportToUserMail { get; set; }
        public string ReportToUserName { get; set; }
        public Guid? LeaveApplicationId { get; set; }
        public bool? IsToSendmail { get; set; }
    }
}
