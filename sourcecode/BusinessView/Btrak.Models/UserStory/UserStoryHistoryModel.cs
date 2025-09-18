using System;
using System.Text;

namespace Btrak.Models.UserStory
{
    public class UserStoryHistoryModel
    {
        public Guid? UserStoryId { get; set; }

        public string OldValue { get;set; }
        public string NewValue { get; set; }
        public string FieldName { get; set; }
        public Guid? UserStoryHistoryId { get; set; }

        public string Description { get; set; }
        public string DescriptionSlug { get; set; }
        public string UserStoryName { get; set; }

        public Guid CreatedByUserId { get; set; }
        public DateTimeOffset CreatedDateTime { get; set; }
        public string FullName { get; set; }
        public string ProfileImage { get; set; }

        public Guid? OwnerUserId { get; set; }

        public int TotalCount { get; set; }
        public string TimeZoneName { get; set; }
        public string TimeZoneAbbreviation { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("UserStoryHistoryId = " + UserStoryHistoryId);
            stringBuilder.Append("OldValue = " + OldValue);
            stringBuilder.Append("NewValue = " + NewValue);
            stringBuilder.Append("UserStoryName = " + UserStoryName);
            stringBuilder.Append("Description = " + Description);
            stringBuilder.Append("FieldName = " + FieldName);
            stringBuilder.Append("CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append("CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append("FullName = " + FullName);
            stringBuilder.Append("ProfileImage = " + ProfileImage);
            stringBuilder.Append("TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}