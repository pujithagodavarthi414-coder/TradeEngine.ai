using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.MasterData
{
    public class TimeSheetSubmissionSearchOutputModel
    {
        public Guid? TimeSheetSubmissionId { get; set; }
        public Guid? TimeSheetIntervalId { get; set; }
        public Guid? TimeSheetFrequencyId { get; set; }
        public DateTime? ActiveFrom { get; set; }
        public DateTime? ActiveTo { get; set; }
        public byte[] TimeStamp { get; set; }
        public string Name { get; set; }
        public string Status { get; set; }
    }


    public class TimeSheetSubmissionModel
    {
        public string TimeSheetTitle { get; set; }
        public List<DateTimeValues> Date { get; set; }
        public bool IsHeaderVisible { get; set; }
        public string Status { get; set; }
        public string StatusColour { get; set; }
        public string RejectedReason { get; set; }
        public bool IsEnableBuuton { get; set; }
        public string UserName { get; set; }
        public bool? IsRejected { get; set; }
        public Guid? UserId { get; set; }
        public string ProfileImage { get; set; }

    }
    public class DateTimeValues
    {
        public DateTime? Date { get; set; } 
        public int? SpentTime { get; set; }
        public DateTime? InTime { get; set; }
        public DateTime? OutTime { get; set; }
        public Guid? UserId { get; set; }
        public string UserName { get; set; }
        public Guid? TimeSheetSubmissionId { get; set; }
        public string Summary { get; set; }
        public int? Breakmins { get; set; }
        public bool? IsOnLeave { get; set; }
        public string AdditionInformation { get; set; }
        public string LeaveReason { get; set; }
        public string HolidayReason { get; set; }
        public DateTime? AdditionalIntTime { get; set; }
        public DateTime? AdditionalOuttTime { get; set; }
        public string Status { get; set; }
    }
}
