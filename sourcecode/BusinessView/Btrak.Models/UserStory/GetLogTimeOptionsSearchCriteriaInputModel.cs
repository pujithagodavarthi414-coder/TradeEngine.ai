using BTrak.Common;
using System;

namespace Btrak.Models.UserStory
{
    public class GetLogTimeOptionsSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public GetLogTimeOptionsSearchCriteriaInputModel() : base(InputTypeGuidConstants.UserStorySpentTimeReportCommandTypeGuid)
        {
        }

        public Guid? LogTimeOptionId { get; set; }
        public string LogTimeOption { get; set; }
    }
}
