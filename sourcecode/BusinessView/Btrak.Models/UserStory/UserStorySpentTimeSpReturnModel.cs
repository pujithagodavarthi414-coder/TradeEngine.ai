using System;

namespace Btrak.Models.UserStory
{
    public class UserStorySpentTimeSpReturnModel
    {
        public Guid? UserStorySpentTimeId { get; set; }
        public Guid? UserStoryId { get; set; }
        public decimal? SpentTimeInMin { get; set; }
        public string Comment { get; set; }
        public decimal? RemainingTimeInMin { get; set; }
        public DateTimeOffset? DateFrom { get; set; }
        public DateTimeOffset? DateTo { get; set; }
        public Guid? LogTimeOptionId { get; set; }
        public Guid? UserId { get; set; }
        public int? UserInput { get; set; }
        public string FullName { get; set; }
        public string ProfileImage { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTimeOffset CreatedDateTime { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public DateTimeOffset UpdatedDateTime { get; set; }
        public string RawSpentTime { get; set; }
        public string RawRemainingTimeSetOrReducedBy { get; set; }
        public decimal? SpentTime { get; set; }
        public decimal? EstimatedTime { get; set; }
        public decimal? TotalSpentTime { get; set; }
        public decimal? RemainingSpentTime { get; set; }
        public decimal? RemainingTimeSetOrReducedBy { get; set; }
        public string CreatedOn { get; set; }
        
    }
}
