using BTrak.Common;
using System;

namespace Btrak.Models.UserStory
{
    public class UserStorySpentTimeSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public UserStorySpentTimeSearchCriteriaInputModel() : base(InputTypeGuidConstants.UserStorySpentTimeReportCommandTypeGuid)
        {
        }

        public Guid? UserStorySpentTimeId { get; set; }
        public Guid? UserStoryId { get; set; }
        public decimal? SpentTime { get; set; }
        public DateTimeOffset? DateFrom { get; set; }
        public DateTimeOffset? DateTo { get; set; }
        public Guid? RemainingEstimateTypeId { get; set; }
        public string RemainingTimeSetOrReducedBy { get; set; }
        public string Comment { get; set; }
        public Guid? UserId { get; set; }
        public bool? IsFromAudits { get; set; }
    }
}
