using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Recruitment
{
    public class InterviewTypesSearchInputModel : SearchCriteriaInputModelBase
    {
        public InterviewTypesSearchInputModel() : base(InputTypeGuidConstants.InterviewTypesSearchInputCommandTypeGuid)
        {
        }
      
        public Guid? InterviewTypeId { get; set; }
        public string InterviewTypeName { get; set; }
        public bool IsVideo { get; set; }
        public bool IsPhone { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("InterviewTypeId = " + InterviewTypeId);
            stringBuilder.Append(",InterviewTypeName = " + InterviewTypeName);
            stringBuilder.Append(",IsVideoCalling = " + IsVideo);
            stringBuilder.Append(",IsVideoCalling = " + IsPhone);
            stringBuilder.Append(",IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }

    }
}
