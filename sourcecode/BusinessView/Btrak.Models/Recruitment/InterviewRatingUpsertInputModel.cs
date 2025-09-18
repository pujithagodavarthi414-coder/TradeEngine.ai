using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Recruitment
{
    public class InterviewRatingUpsertInputModel : SearchCriteriaInputModelBase
    {
        public InterviewRatingUpsertInputModel() : base(InputTypeGuidConstants.InterviewRatingUpsertInputCommandTypeGuid)
        {
        }

        public Guid? InterviewRatingId { get; set; }
        public string InterviewRatingName { get; set; }
        public string Value { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("InterviewRatingId = " + InterviewRatingId);
            stringBuilder.Append(",InterviewRatingName = " + InterviewRatingName);
            stringBuilder.Append(",Value = " + Value);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }

    }
}
