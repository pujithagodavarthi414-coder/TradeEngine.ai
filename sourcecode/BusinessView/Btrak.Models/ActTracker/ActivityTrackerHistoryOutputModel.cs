using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.ActTracker
{
    public class ActivityTrackerHistoryOutputModel 
    {
        public string OldValue { get; set; }
        public string NewValue { get; set; }
        public string Category { get; set; }
        public string FieldName { get; set; }
        public string ProfileImage { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public string Description { get; set; }
        public string UserName { get; set; }
        public int TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("OldValue = " + OldValue);
            stringBuilder.Append("NewValue = " + NewValue);
            stringBuilder.Append("Category = " + Category);
            stringBuilder.Append("FieldName = " + FieldName);
            stringBuilder.Append("ProfileImage = " + ProfileImage);
            stringBuilder.Append("CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append("CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append("Description = " + Description);
            stringBuilder.Append("UserName = " + UserName);
            stringBuilder.Append("TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
