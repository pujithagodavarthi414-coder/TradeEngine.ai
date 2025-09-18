using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.MasterData.FeedbackTypeModel
{
    public class GetFeedbackTypeSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public GetFeedbackTypeSearchCriteriaInputModel() : base(InputTypeGuidConstants.GetFeedbackTypes)
        {
        }

        public Guid? FeedbackTypeId { get; set; }
        public string FeedbackTypeName { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" FeedbackTypeId= " + FeedbackTypeId);
            stringBuilder.Append(" FeedbackTypeName= " + FeedbackTypeName);
            return stringBuilder.ToString();
        }
    }
}