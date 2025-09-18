using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.MasterData
{
    public class ApproverTimeSheetSubmissionsGetOutputModel
    {
        public DateTime? Date { get; set; }
        public DateTime? StartTime { get; set; }
        public DateTime? EndTime { get; set; }
        public int? Breakmins { get; set; }
        public int? SpentTime { get; set; }
        public Guid? UserId { get; set; }
        public string UserName { get; set; }
        public Guid? TimeSheetSubmissionId { get; set; }
        public string Name { get; set; }
        public string Summary { get; set; }
        public bool? IsOnLeave { get; set; }
        public string ProfileImage { get; set; }
    }
}
