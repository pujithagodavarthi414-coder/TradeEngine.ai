using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Recruitment
{
    public class CandidateInterviewScheduleSearchInputModel : SearchCriteriaInputModelBase
    {
        public CandidateInterviewScheduleSearchInputModel() : base(InputTypeGuidConstants.CandidateInterviewScheduleSearchInputCommandTypeGuid)
        {
        }

        public Guid? CandidateInterviewScheduleId { get; set; }
        public Guid? InterviewTypeId { get; set; }
        public Guid? CandidateId { get; set; }
        public Guid? AssigneId { get; set; }
        public DateTime? StartTime { get; set; }
        public DateTime? EndTime { get; set; }
        public DateTime? InterviewDate { get; set; }
        public bool IsConfirmed { get; set; }
        public bool IsCancelled { get; set; }
        public bool IsRescheduled { get; set; }
        public bool IsInterviewer { get; set; }
        public string ScheduleComments { get; set; }

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
            stringBuilder.Append(",IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }

    }
}
