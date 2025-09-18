using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Recruitment
{
    public class JobTypesSearchInputModel : SearchCriteriaInputModelBase
    {
        public JobTypesSearchInputModel() : base(InputTypeGuidConstants.JobTypeSearchInputCommandTypeGuid)
        {
        }

        public Guid? JobTypeId { get; set; }
        public string JobTypeName { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("JobTypeId = " + JobTypeId);
            stringBuilder.Append(",JobTypeName = " + JobTypeName);
            stringBuilder.Append(",SearchText = " + SearchText);
            return stringBuilder.ToString();
        }

    }
}
