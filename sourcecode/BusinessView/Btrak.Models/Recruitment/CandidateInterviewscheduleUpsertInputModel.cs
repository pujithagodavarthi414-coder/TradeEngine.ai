using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Recruitment
{
    public class CandidateInterviewScheduleUpsertInputModel : SearchCriteriaInputModelBase
    {
        public CandidateInterviewScheduleUpsertInputModel() : base(InputTypeGuidConstants.CandidateInterviewScheduleUpsertInputCommandTypeGuid)
        {
        }
        
        public Guid? CandidateInterviewScheduleId { get; set; }
        public Guid? InterviewTypeId { get; set; }
        public Guid? CandidateId { get; set; }
        public Guid? AssignToUserId { get; set; }
        public Guid Company { get; set; }
        public string StartTime { get; set; }
        public string EndTime { get; set; }
        public DateTimeOffset? StartDateTime { get; set; }
        public DateTimeOffset? EndDateTime { get; set; }
        public DateTime? InterviewDate { get; set; }
        public bool IsConfirmed { get; set; }
        public bool IsCancelled { get; set; }
        public bool IsRescheduled { get; set; }
        public string ScheduleComments { get; set; }
        public List<Guid?> Assignee { get; set; }
        public string AssigneeEmail { get; set; }
        public Guid? JobOpeningId { get; set; }
        public Guid StatusId { get; set; }
        public string CancelComment { get; set; }
        public string CandidateEmail { get; set; }
        public string AssigneeIds { get; set; }
        public string EmailAddress { get; set; }
        public string Name { get; set; }
        public string CandidateName { get; set; }
        public string InterviewTypeName { get; set; }
        public List<string> EmailsList { get; set; }
        //cron expression 
        public byte[] CronExpressionTimeStamp { get; set; }
        public string CronExpression { get; set; }
        public Guid? CronExpressionId { get; set; }
        public int JobId { get; set; }
        public DateTime? ScheduleEndDate { get; set; }
        public bool? IsPaused { get; set; }
        public bool? IsVideoCalling { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CandidateInterviewScheduleId = " + CandidateInterviewScheduleId);
            stringBuilder.Append(",InterviewTypeId = " + InterviewTypeId);
            stringBuilder.Append(",CandidateId = " + CandidateId);
            stringBuilder.Append(",StartTime = " + StartTime);
            stringBuilder.Append(",EndTime = " + EndTime);
            stringBuilder.Append(",InterviewDate = " + InterviewDate);
            stringBuilder.Append(",IsConfirmed = " + IsConfirmed);
            stringBuilder.Append(",IsCancelled = " + IsCancelled);
            stringBuilder.Append(",IsRescheduled = " + IsRescheduled);
            stringBuilder.Append(",ScheduleComments = " + ScheduleComments);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
