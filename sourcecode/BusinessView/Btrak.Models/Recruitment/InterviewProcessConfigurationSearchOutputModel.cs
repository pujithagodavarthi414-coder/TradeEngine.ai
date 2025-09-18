using System;

namespace Btrak.Models.Recruitment
{
    public class InterviewProcessConfigurationSearchOutputModel
    {
        public Guid? InterviewProcessConfigurationId { get; set; }
        public Guid? InterviewTypeId { get; set; }
        public string InterviewTypeName { get; set; }
        public Guid? JobOpeningId { get; set; }
        public Guid? InterviewProcessId { get; set; }
        public string InterviewProcessName { get; set; }
        public bool IsPhoneCalling { get; set; }
        public bool IsVideoCalling { get; set; }
        public int Order { get; set; }
        public string Color { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
        public bool? IsActiveSchedule { get; set; }
        public bool? IsNew { get; set; }
        public string StatusColor { get; set; }
        public string StatusName { get; set; }
        public Guid StatusId { get; set; }
        public string RoleId { get; set; }
        public Guid ScheduleId { get; set; }
        public byte[] ScheduleTimeStamp { get; set; }

    }
}
