using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.TestRail
{
    public class TestRailFileModel
    {
        public Guid? TestRailId { get; set; }

        public bool? IsTestCasePreCondition { get; set; }

        public bool? IsTestCaseStatus { get; set; }

        public bool? IsTestCaseStep { get; set; }

        public bool? IsTestRun { get; set; }

        public bool? IsTestPlan { get; set; }

        public bool? IsExpectedResult { get; set; }

        public Guid? TestRunId { get; set; }

        public bool? IsMilestone { get; set; }

        public bool? IsTestCase { get; set; }

        public string FilePath { get; set; }

        public List<string> FilePathList { get; set; }

        public string FilePathXml { get; set; }

        public Guid? FileId { get; set; }

        public string FileName { get; set; }

        public Guid? CreatedByUserId { get; set; }

        public DateTime? CreatedDateTime { get; set; }

        public Guid? UpdatedByUserId { get; set; }

        public DateTime? UpdatedDateTime { get; set; }

        public byte[] TimeStamp { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("TestRailId = " + TestRailId);
            stringBuilder.Append(", IsTestCasePreCondition = " + IsTestCasePreCondition);
            stringBuilder.Append(", IsTestCaseStatus = " + IsTestCaseStatus);
            stringBuilder.Append(", IsTestCaseStep = " + IsTestCaseStep);
            stringBuilder.Append(", IsTestRun = " + IsTestRun);
            stringBuilder.Append(", IsTestPlan = " + IsTestPlan);
            stringBuilder.Append(", IsMilestone = " + IsMilestone);
            stringBuilder.Append(", IsTestCase = " + IsTestCase);
            stringBuilder.Append(", FilePath = " + FilePath);
            stringBuilder.Append(", FileId = " + FileId);
            stringBuilder.Append(", FileName = " + FileName);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", UpdatedByUserId = " + UpdatedByUserId);
            stringBuilder.Append(", UpdatedDateTime = " + UpdatedDateTime);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
