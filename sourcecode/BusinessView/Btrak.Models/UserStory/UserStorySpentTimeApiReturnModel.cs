using System;

namespace Btrak.Models.UserStory
{
    public class UserStorySpentTimeApiReturnModel
    {
        public Guid? UserStorySpentTimeId { get; set; }
        public Guid? UserStoryId { get; set; }
        public DateTimeOffset? DateFrom { get; set; }
        public DateTimeOffset? DateTo { get; set; }
        public Guid? LogTimeOptionId { get; set; }
        public string Comment { get; set; }

        public string RawSpentTime { get; set; }
        public string RawRemainingTimeSetOrReducedBy { get; set; }

        public decimal? SpentTime { get; set; }
        public decimal? RemainingTimeSetOrReducedBy { get; set; }
        public decimal? EstimatedTime { get; set; }
        public decimal? TotalSpentTime { get; set; }
        public decimal? RemainingSpentTime { get; set; }

        public decimal? RemainingTimeInMin { get; set; }
        public decimal? SpentTimeInMin { get; set; }
        public Guid? UserId { get; set; }
        public int? UserInput { get; set; }

        public DateTimeOffset CreatedDateTime { get; set; }
        public string CreatedOn { get; set; }
        public string FullName { get; set; }
        public string ProfileImage { get; set; }
    }
}
