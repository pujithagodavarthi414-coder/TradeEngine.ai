using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Recruitment
{
    public class InterviewProcessSearchInputModel : SearchCriteriaInputModelBase
    {
        public InterviewProcessSearchInputModel() : base(InputTypeGuidConstants.InterviewProcessSearchInputCommandTypeGuid)
        {
        }


        public Guid? InterviewProcessId { get; set; }
        public string InterviewProcessName { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("InterviewProcessId = " + InterviewProcessId);
            stringBuilder.Append(",InterviewProcessName = " + InterviewProcessName);
            stringBuilder.Append(",IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }

    }
}
