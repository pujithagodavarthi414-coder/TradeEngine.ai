using System;
using System.Text;

namespace Btrak.Models.TestRail
{
    public class TestCaseHistoryMiniModel
    {
        public Guid? Id { get; set; }

        public Guid? ConfigurationId { get; set; }

        public Guid? TestCaseId { get; set; }
        public Guid? TestRunId { get; set; }

        public string FieldName { get; set; }

        public string OldValue { get; set; }

        public string NewValue { get; set; }

        public string Step { get; set; }

        public string ExpectedResult { get; set; }

        public string TestedByName { get; set; }

        public string TestedByProfileImage { get; set; }

        public DateTime? CreatedDateTime { get; set; }

        public Guid? CreatedByUserId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("HistoryId = " + Id);
            stringBuilder.Append("TestCaseId = " + TestCaseId);
            stringBuilder.Append("FieldName = " + FieldName);
            stringBuilder.Append("OldValue = " + OldValue);
            stringBuilder.Append("NewValue = " + NewValue);
            stringBuilder.Append("Step = " + Step);
            stringBuilder.Append("ExpectedResult = " + ExpectedResult);
            stringBuilder.Append("TestedByName = " + TestedByName);
            stringBuilder.Append("TestedByProfileImage = " + TestedByProfileImage);
            stringBuilder.Append("CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append("CreatedByUserId = " + CreatedByUserId);
            return stringBuilder.ToString();
        }
    }
}
