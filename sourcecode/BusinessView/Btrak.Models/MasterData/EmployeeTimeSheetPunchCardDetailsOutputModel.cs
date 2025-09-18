using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.MasterData
{
    public class EmployeeTimeSheetPunchCardDetailsOutputModel
    {
        public Guid? TimeSheetPunchCardId { get; set; }
        public DateTime? Date { get; set; }
        public DateTime? StartTime { get; set; }
        public DateTime? EndTime { get; set; }
        public int? Breakmins { get; set; }
        public Guid? StatusId { get; set; }
        public string StatusName { get; set; }
        public Guid? ApproverId { get; set; }
        public string ApproverName { get; set; }
        public byte[] TimeStamp { get; set; }
        public Guid? UserId { get; set; }
        public string UserName { get; set; }
        public string Summary { get; set; }
        public bool? IsOnLeave { get; set; }
    }
}