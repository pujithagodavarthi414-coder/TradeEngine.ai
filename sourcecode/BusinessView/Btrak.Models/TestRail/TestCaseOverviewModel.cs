using System;
using System.Text;

namespace Btrak.Models.TestRail
{
    public class TestCaseOverviewModel
    {
        public Guid? TestCaseId { get; set; }

        public string Title { get; set; }

        public int TestCaseIdentity { get; set; }

        public Guid? AssignToId { get; set; }

        public string AssignToName { get; set; }

        public string AssignToProfileImage { get; set; }

        public Guid? StatusId { get; set; }

        public string Status { get; set; }

        public string TestSuiteName { get; set; }

        public int? TestCasesCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", TestCaseId = " + TestCaseId);
            stringBuilder.Append(", Title = " + Title);
            stringBuilder.Append(", TestCaseIdentity = " + TestCaseIdentity);
            stringBuilder.Append(", AssignToId = " + AssignToId);
            stringBuilder.Append(", AssignToName = " + AssignToName);
            stringBuilder.Append(", AssignToProfileImage = " + AssignToProfileImage);
            stringBuilder.Append(", StatusId = " + StatusId);
            stringBuilder.Append(", Status = " + Status);
            stringBuilder.Append(", TestSuiteName = " + TestSuiteName);
            stringBuilder.Append(", TestCasesCount = " + TestCasesCount);
            return stringBuilder.ToString();
        }
    }
}
