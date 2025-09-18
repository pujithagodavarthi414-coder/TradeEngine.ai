using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Recruitment
{
    public class InterviewRatingSearchInputModel : SearchCriteriaInputModelBase
    {
        public InterviewRatingSearchInputModel() : base(InputTypeGuidConstants.InterviewRatingSearchInputCommandTypeGuid)
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
            stringBuilder.Append(",IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }

    }
}
