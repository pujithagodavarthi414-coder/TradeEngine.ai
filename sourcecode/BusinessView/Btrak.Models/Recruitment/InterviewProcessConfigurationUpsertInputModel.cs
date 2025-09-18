using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Recruitment
{
    public class InterviewProcessConfigurationUpsertInputModel : SearchCriteriaInputModelBase
    {
        public InterviewProcessConfigurationUpsertInputModel() : base(InputTypeGuidConstants.InterviewProcessConfigurationUpsertInputCommandTypeGuid)
        {
        }

        public Guid? InterviewProcessConfigurationId { get; set; }
        public Guid? InterviewTypeId { get; set; }
        public Guid? InterviewProcessId { get; set; }
        public Guid? JobOpeningId { get; set; }
        public Guid? CandidateId { get; set; }
        public Guid? StatusId { get; set; }
        public string StatusName { get; set; }
        public bool? IsPhoneCalling { get; set; }
        public bool? IsVideoCalling { get; set; }
        public bool? IsInitial { get; set; }
        public List<Guid?> interviewProcessConfigurationIds { get; set; }
        public string interviewProcessConfigurationIdsXml { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("InterviewProcessId = " + InterviewProcessConfigurationId);
            stringBuilder.Append(",InterviewTypeId = " + InterviewTypeId);
            stringBuilder.Append(",InterviewProcessId = " + InterviewProcessId);
            stringBuilder.Append(",JobOpeningId = " + JobOpeningId);
            stringBuilder.Append(",CandidateId = " + CandidateId);
            stringBuilder.Append(",IsPhoneCalling = " + IsPhoneCalling);
            stringBuilder.Append(",IsVideoCalling = " + IsVideoCalling);
            stringBuilder.Append(",interviewProcessConfigurationIds = " + interviewProcessConfigurationIds);
            stringBuilder.Append(",interviewProcessConfigurationIdsXml = " + interviewProcessConfigurationIdsXml);
            stringBuilder.Append(",IsInitial = " + IsInitial);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }

    }
}
