using System;
using System.Collections.Generic;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.TestRail
{
    public class TestTeamStatusReportingRetunrModel : InputModelBase
    {
        public TestTeamStatusReportingRetunrModel() : base(InputTypeGuidConstants.TestTeamStatusReportingInputCommandTypeGuid)
        {
        }
        public Guid? UserId { get; set; }
        public string UserName { get; set; }
        public float OriginalSpentTime { get; set; }
        public string DateName { get; set; }
        public string BugsCountText { get; set; }
        public string ConfigurationName { get; set; }
        public string ConfigurationTime { get; set; }
        public float ActualSpentTime { get; set; }
        public float? BugsCount { get; set; }
        public float? P0BugsCount { get; set; }
        public float? P1BugsCount { get; set; }
        public float? P2BugsCount { get; set; }
        public float? P3BugsCount { get; set; }
        public string CreatedOn { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public string DateString { get; set; }
        public Guid? ProjectId { get; set; }
        public string ProjectName { get; set; }
        public string TestCaseCreated { get; set; }
        public string TestCasesCount { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("UserId = " + UserId);
            stringBuilder.Append(", CreatedOn = " + CreatedOn);
            stringBuilder.Append(", DateFrom = " + DateFrom);
            stringBuilder.Append(", DateTo = " + DateTo);
            stringBuilder.Append(", DateName = " + DateName);
            stringBuilder.Append(", ConfigurationName = " + ConfigurationName);
            stringBuilder.Append(", ConfigurationTime = " + ConfigurationTime);
            stringBuilder.Append(", BugsCount = " + BugsCount);
            stringBuilder.Append(", OriginalSpentTime = " + OriginalSpentTime);
            stringBuilder.Append(", BugsCountText = " + BugsCountText);
            stringBuilder.Append(", P1BugsCount = " + P1BugsCount);
            stringBuilder.Append(", P2BugsCount = " + P2BugsCount);
            stringBuilder.Append(", P3BugsCount = " + P3BugsCount);
            stringBuilder.Append(", BugsCount = " + BugsCount);
            stringBuilder.Append(", ProjectId = " + ProjectId);
            stringBuilder.Append(", ProjectName = " + ProjectName);
            return stringBuilder.ToString();
        }
    }
}