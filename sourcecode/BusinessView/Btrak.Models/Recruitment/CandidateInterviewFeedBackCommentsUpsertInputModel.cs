using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Recruitment
{
    public class CandidateInterviewFeedBackCommentsUpsertInputModel : SearchCriteriaInputModelBase
    {
        public CandidateInterviewFeedBackCommentsUpsertInputModel() : base(InputTypeGuidConstants.CandidateInterviewFeedBackCommentsUpsertInputCommandTypeGuid)
        {
        }
        
        public Guid? CandidateInterviewFeedBackCommentsId { get; set; }
        public Guid? CandidateInterviewScheduleId { get; set; }
        public string AssigneeComments { get; set; }
        public Guid? AssigneeId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CandidateInterviewFeedBackCommentsId = " + CandidateInterviewFeedBackCommentsId);
            stringBuilder.Append(",CandidateInterviewScheduleId = " + CandidateInterviewScheduleId);
            stringBuilder.Append(", AssigneeComments = " + AssigneeComments);
            stringBuilder.Append(", AssigneeId = " + AssigneeId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }

    }
}
