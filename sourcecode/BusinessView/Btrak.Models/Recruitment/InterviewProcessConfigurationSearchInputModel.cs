using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Recruitment
{
    public class InterviewProcessConfigurationSearchInputModel : SearchCriteriaInputModelBase
    {
        public InterviewProcessConfigurationSearchInputModel() : base(InputTypeGuidConstants.InterviewProcessConfigurationSearchInputCommandTypeGuid)
        {
        }


        public Guid? InterviewProcessConfigurationId { get; set; }
        public Guid? InterviewTypeId { get; set; }
        public Guid? InterviewProcessId { get; set; }
        public Guid? JobOpeningId { get; set; }
        public Guid? CandidateId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("InterviewProcessConfigurationId = " + InterviewProcessConfigurationId);
            stringBuilder.Append(",InterviewTypeId = " + InterviewTypeId);
            stringBuilder.Append(",InterviewProcessTypeId = " + InterviewProcessId);
            stringBuilder.Append(",JobOpeningId = " + JobOpeningId);
            stringBuilder.Append(",CandidateId = " + CandidateId);
            stringBuilder.Append(",IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }

    }
}
