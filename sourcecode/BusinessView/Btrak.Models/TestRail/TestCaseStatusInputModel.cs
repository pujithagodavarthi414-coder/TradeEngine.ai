using System;
using System.Collections.Generic;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.TestRail
{
    public class TestCaseStatusInputModel : InputModelBase
    {
        public TestCaseStatusInputModel() : base(InputTypeGuidConstants.TestCaseStatusInputCommandTypeGuid)
        {
        }

        public Guid? TestCaseId { get; set; }

        public Guid? TestRunId { get; set; }

        public bool IsArchived { get; set; }

        public string TimeZone { get; set; }

        public Guid? UserStoryId { get; set; }

        public Guid? StatusId { get; set; }

        public string Comment { get; set; }

        public string StatusComment { get; set; }

        public string Status { get; set; }

        public string StatusName { get; set; }

        public List<TestCaseStepMiniModel> StepStatus { get; set; }

        public Guid? AssignToId { get; set; }

        public string AssignToComment { get; set; }

        public string Version { get; set; }

        public TimeSpan Elapsed { get; set; }

        public List<string> FilePath { get; set; }

        public byte[] UserStoryScenarioTimeStamp { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("TestCaseId = " + TestCaseId);
            stringBuilder.Append("UserStory = " + UserStoryId);
            stringBuilder.Append(", StatusId = " + StatusId);
            stringBuilder.Append(", Status = " + Status);
            stringBuilder.Append(", Comment = " + Comment);
            stringBuilder.Append(", AssignToId = " + AssignToId);
            stringBuilder.Append(", Version = " + Version);
            stringBuilder.Append(", Elapsed = " + Elapsed);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", FilePath = " + FilePath);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", UserStoryScenarioTimeStamp = " + UserStoryScenarioTimeStamp);
            stringBuilder.Append(", StatusComment = " + StatusComment);
            stringBuilder.Append(", StatusName = " + StatusName);
            stringBuilder.Append(", AssignToComment = " + AssignToComment);
            return stringBuilder.ToString();
        }
    }
}
