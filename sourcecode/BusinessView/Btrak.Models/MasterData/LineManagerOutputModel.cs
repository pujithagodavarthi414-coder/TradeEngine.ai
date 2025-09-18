using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.MasterData
{
    public class LineManagerOutputModel
    {
        public string UserName { get; set; }
        public string ProfileImage { get; set; }
        public string TimeZoneName { get; set; }
        public Guid? UserId { get; set; }
        public Guid? EmployeeId { get; set; }
        public Guid? TimeZoneId { get; set; }
        public string ReportingMembers { get; set; }
    }
}
