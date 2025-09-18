using System;

namespace Btrak.Models.MasterData
{
    public class EmployeeTimeSheetPunchCardUpsertInputModel
    {
        public Guid? TimeSheetPunchCardId { get; set; }
        public Guid? ApproverId { get; set; }
        public DateTime? Date { get; set; }
        public DateTime? StartTime { get; set; }
        public DateTime? EndTime { get; set; }
        public int? Breakmins { get; set; }
        public Guid? StatusId { get; set; }
        public byte[] TimeStamp { get; set; }
        public string Summary { get; set; }
        public Guid? UserId { get; set; }
        public Guid? TimeSheetSubmissionId { get; set; }
        public bool? IsOnLeave { get; set; }
    }
}
