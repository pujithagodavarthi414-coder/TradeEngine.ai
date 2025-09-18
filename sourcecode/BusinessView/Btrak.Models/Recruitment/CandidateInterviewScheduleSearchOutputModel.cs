using System;

namespace Btrak.Models.Recruitment
{
    public class CandidateInterviewScheduleSearchOutputModel
    {
        
        public Guid? CandidateInterviewScheduleId { get; set; }
        public Guid? InterviewTypeId { get; set; }
        public string InterviewTypeName { get; set; }
        public Guid? CandidateId { get; set; }
        public string CandidateName { get; set; }
        public string StartTime { get; set; }
        public string EndTime { get; set; }
        public DateTime? InterviewDate { get; set; }
        public bool IsConfirmed { get; set; }
        public bool IsCancelled { get; set; }
        public bool IsRescheduled { get; set; }
        public string ScheduleComments { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
        public Guid? Assignee { get; set; }
        public Guid CompanyId { get; set; }
        public Guid? AssignToUserId { get; set; }
        public string AssigneeEmail { get; set; }
        public string AssigneeIds { get; set; }
        public string AssigneeNames { get; set; }
        public string UserName { get; set; }
        public string AssignToUserName { get; set; }
        //cron expression 
        public byte[] CronExpressionTimeStamp { get; set; }
        public string CronExpression { get; set; }
        public Guid? CronExpressionId { get; set; }
        public int JobId { get; set; }
        public DateTime? ScheduleEndDate { get; set; }
        public bool? IsPaused { get; set; }
        public bool? IsApproved { get; set; }
        public string CandidateEmail { get; set; }
        public bool? IsPhoneCalling { get; set; }
        public bool? IsVideoCalling { get; set; }
        public int TotalCount { get; set; }
        public int PageSize { get; set; }
        public int PageNumber { get; set; }
    }
}
