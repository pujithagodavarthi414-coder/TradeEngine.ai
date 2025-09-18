using System;
using System.Collections.Generic;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.TestRail
{
    public class TestRunInputModel : InputModelBase
    {
        public TestRunInputModel() : base(InputTypeGuidConstants.TestRunInputCommandTypeGuid)
        {
        }

        public Guid? TestRunId { get; set; }

        public Guid? ProjectId { get; set; }

        public Guid? TestSuiteId { get; set; }

        public string TestRunName { get; set; }

        public Guid? MilestoneId { get; set; }

        public Guid? AssignToId { get; set; }

        public string Description { get; set; }

        public bool? IsIncludeAllCases { get; set; }

        public List<SelectedTestCaseModel> SelectedCases { get; set; }

        public List<Guid?> SelectedSections { get; set; }

        public bool IsArchived { get; set; }

        public bool? IsCompleted { get; set; }

        public bool? IsFromUpload { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("TestRunId = " + TestRunId);
            stringBuilder.Append(", ProjectId = " + ProjectId);
            stringBuilder.Append(", TestSuiteId = " + TestSuiteId);
            stringBuilder.Append(", TestRunName = " + TestRunName);
            stringBuilder.Append(", MilestoneId = " + MilestoneId);
            stringBuilder.Append(", AssignToId = " + AssignToId);
            stringBuilder.Append(", Description = " + Description);
            stringBuilder.Append(", IsIncludeAllCases = " + IsIncludeAllCases);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", IsCompleted = " + IsCompleted);
            stringBuilder.Append(", SelectedSections = " + SelectedSections);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
