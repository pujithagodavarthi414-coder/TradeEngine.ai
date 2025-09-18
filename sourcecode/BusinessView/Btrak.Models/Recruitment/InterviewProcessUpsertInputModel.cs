using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Recruitment
{
    public class InterviewProcessUpsertInputModel : SearchCriteriaInputModelBase
    {
        public InterviewProcessUpsertInputModel() : base(InputTypeGuidConstants.InterviewProcessUpsertInputCommandTypeGuid)
        {
        }

        public Guid? InterviewProcessId { get; set; }
        public string InterviewProcessName { get; set; }
        public List<Guid?> InterviewTypeId { get; set; }
        public string InterviewTypeIds { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("InterviewProcessId = " + InterviewProcessId);
            stringBuilder.Append(",InterviewProcessName = " + InterviewProcessName);
            stringBuilder.Append(",InterviewTypeIds = " + InterviewTypeId);
            stringBuilder.Append(",InterviewTypes = " + InterviewTypeIds);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }

    }
}
