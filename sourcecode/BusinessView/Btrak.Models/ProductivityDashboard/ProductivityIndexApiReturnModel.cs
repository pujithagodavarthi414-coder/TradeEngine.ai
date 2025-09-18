using System;
using System.Text;

namespace Btrak.Models.ProductivityDashboard
{
    public class ProductivityIndexApiReturnModel
    {
        public Guid? UserId { get; set; }
        public string UserName { get; set; }
        public string UserProfileImage { get; set; }
        public decimal ProductivityIndex { get; set; }
        public decimal GRPIndex { get; set; }
        public int ReopenCount { get; set; }
        public TimeSpan AvgInTime { get; set; }
        public int AvgLunchBreakInMin { get; set; }
        public TimeSpan AvgOutTime { get; set; }
        public int AvgBreakInMin { get; set; }
        public int CompletedUserStoriesCount { get; set; }
        public int ReopenedUserStoriesCount { get; set; }
        public float PercentageOfBouncedUserStories { get; set; }
        public int UserStoriesBouncedBackOnceCount { get; set; }
        public int UserStoriesBouncedBackMoreThanOnceCount { get; set; }
        public int DaysLate { get; set; }
        public int PermittedDays { get; set; }
        public float AvgSpentTime { get; set; }
        public float AvgReplan { get; set; }
        public float PercentageOfQAApprovedUserStories { get; set; }
        public int DaysLateWithOutPermission { get; set; }
        public int TotalCount { get; set; }
        public float AvgActivityTrackerProductivity { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("UserId = " + UserId);
            stringBuilder.Append(", UserName = " + UserName);
            stringBuilder.Append(", UserProfileImage = " + UserProfileImage);
            stringBuilder.Append(", ProductivityIndex = " + ProductivityIndex);
            stringBuilder.Append(", GRPIndex = " + GRPIndex);
            stringBuilder.Append(", ReopenCount = " + ReopenCount);
            stringBuilder.Append(", AvgInTime = " + AvgInTime);
            stringBuilder.Append(", AvgLunchBreakInMin = " + AvgLunchBreakInMin);
            stringBuilder.Append(", AvgOutTime = " + AvgOutTime);
            stringBuilder.Append(", AvgBreakInMin = " + AvgBreakInMin);
            stringBuilder.Append(", CompletedUserStoriesCount = " + CompletedUserStoriesCount);
            stringBuilder.Append(", ReopenedUserStoriesCount = " + ReopenedUserStoriesCount);
            stringBuilder.Append(", PercentageOfBouncedUserStories = " + PercentageOfBouncedUserStories);
            stringBuilder.Append(", UserStoriesBouncedBackOnceCount = " + UserStoriesBouncedBackOnceCount);
            stringBuilder.Append(", UserStoriesBouncedBackMoreThanOnceCount = " + UserStoriesBouncedBackMoreThanOnceCount);
            stringBuilder.Append(", DaysLate = " + DaysLate);
            stringBuilder.Append(", PermittedDays = " + PermittedDays);
            stringBuilder.Append(", AvgSpentTime = " + AvgSpentTime);
            stringBuilder.Append(", AvgReplan = " + AvgReplan);
            stringBuilder.Append(", PercentageOfQAApprovedUserStories = " + PercentageOfQAApprovedUserStories);
            stringBuilder.Append(", DaysLateWithOutPermission = " + DaysLateWithOutPermission);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", AvgActivityTrackerProductivity = " + AvgActivityTrackerProductivity);
            return stringBuilder.ToString();
        }
    }
}
