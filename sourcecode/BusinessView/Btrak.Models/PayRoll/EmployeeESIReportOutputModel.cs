using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.PayRoll
{
    public class EmployeeESIReportOutputModel
    {
        public string IPNumber { get; set; }
        public string IPName { get; set; }
        public string ProfileImage { get; set; }
        public Guid UserId { get; set; }
        public bool IsArchived { get; set; }
        public int EffectiveDays { get; set; }
        public string TotalWages { get; set; }
        public int ReasonCode { get; set; }
        public string LastWorkingDay { get; set; }
        public int TotalRecordsCount { get; set; }
    }
}
