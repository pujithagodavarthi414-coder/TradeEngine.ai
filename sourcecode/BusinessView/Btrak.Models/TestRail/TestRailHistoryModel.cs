using System;
using System.Text;

namespace Btrak.Models.TestRail
{
    public class TestRailHistoryModel
    {
        public Guid? Id { get; set; }
        public Guid? TestCaseId { get; set; }
        public Guid? StepId { get; set; }
        public Guid? TestRunId { get; set; }
        public Guid? ReportId { get; set; }
        public Guid? UserStoryId { get; set; }
        public Guid? ConfigurationId { get; set; }
        public string TestCaseTitle { get; set; }
        public string StepText { get; set; }
        public int StepOrder { get; set; }
        public string Step { get; set; }
        public string ExpectedResult { get; set; }
        public string NewValue { get; set; }
        public string OldValue { get; set; }
        public string FieldName { get; set; }
        public string TestRunName { get; set; }
        public string Description { get; set; }
        public string FilePath { get; set; }
        public DateTimeOffset? CreatedDateTime { get; set; }
        public bool? IsFromUpload { get; set; }
        public string CreatedByUser { get; set; }
        public string TestedByName { get; set; }
        public string TestedByProfileImage { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("HistoryId = " + Id);
            stringBuilder.Append(", TestCaseId = " + TestCaseId);
            stringBuilder.Append(", StepId = " + StepId);
            stringBuilder.Append(", TestRunId = " + TestRunId);
            stringBuilder.Append(", UserStoryId = " + UserStoryId);
            stringBuilder.Append(", NewValue = " + NewValue);
            stringBuilder.Append(", OldValue = " + OldValue);
            stringBuilder.Append(", FieldName = " + FieldName);
            stringBuilder.Append(", Description = " + Description);
            stringBuilder.Append(", FilePath = " + FilePath);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", IsFromUpload = " + IsFromUpload);
            stringBuilder.Append(", CreatedByUser = " + CreatedByUser);
            stringBuilder.Append(", TestedByName = " + TestedByName);
            stringBuilder.Append(", TestedByProfileImage = " + TestedByProfileImage);
            return stringBuilder.ToString();
        }

    }
} 