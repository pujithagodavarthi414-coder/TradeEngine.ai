using System;
using System.Collections.Generic;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.TestRail
{
    public class TestCaseInputModel : InputModelBase
    {
        public TestCaseInputModel() : base(InputTypeGuidConstants.TestCaseInputCommandTypeGuid)
        {
        }

        public Guid? TestCaseId { get; set; }

        public int TestCaseIntId { get; set; }

        public Guid? TestSuiteId { get; set; }

        public List<Guid?> MultipleTestCasesIds { get; set; }

        public string[] MultipleTestCasesTitles { get; set; }

        public string Title { get; set; }
        public string MultipleTestCaseIds { get; set; }

        public Guid? SectionId { get; set; }

        public Guid? TemplateId { get; set; }

        public Guid? TypeId { get; set; }

        public Guid? PriorityId { get; set; }

        public int Estimate { get; set; }

        public string References { get; set; }

        public Guid? AutomationTypeId { get; set; }

        public string Precondition { get; set; }

        public string Steps { get; set; }

        public List<TestCaseStepMiniModel> TestCaseSteps { get; set; }

        public string Mission { get; set; }

        public string Goals { get; set; }

        public string ExpectedResult { get; set; }

        public bool IsArchived { get; set; }

        public Guid? StatusId { get; set; }

        public string StatusComment { get; set; }

        public Guid? AssignToId { get; set; }

        public string AssignToComment { get; set; }

        public List<Guid?> TestCaseIds { get; set; }

        public List<string> FilePaths { get; set; }

        public List<string> PreConditionFilePaths { get; set; }

        public string Version { get; set; }

        public TimeSpan Elapsed { get; set; }

        public Guid? FeatureId { get; set; }

        public Guid? UserStoryId { get; set; }

        public bool? IsSection { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("TestCaseId = " + TestCaseId);
            stringBuilder.Append("MultipleTestCaseIds = " + MultipleTestCaseIds);
            stringBuilder.Append(", Title = " + Title);
            stringBuilder.Append(", TestCaseIntId = " + TestCaseIntId);
            stringBuilder.Append(", SectionId = " + SectionId);
            stringBuilder.Append(", TestSuiteId = " + TestSuiteId);
            stringBuilder.Append(", TemplateId = " + TemplateId);
            stringBuilder.Append(", TypeId = " + TypeId);
            stringBuilder.Append(", PriorityId = " + PriorityId);
            stringBuilder.Append(", Estimate = " + Estimate);
            stringBuilder.Append(", References = " + References);
            stringBuilder.Append(", AutomationTypeId = " + AutomationTypeId);
            stringBuilder.Append(", Steps = " + Steps);
            stringBuilder.Append(", TestCaseSteps = " + TestCaseSteps);
            stringBuilder.Append(", Mission = " + Mission);
            stringBuilder.Append(", Goals = " + Goals);
            stringBuilder.Append(", ExpectedResult = " + ExpectedResult);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", StatusId = " + StatusId);
            stringBuilder.Append(", StatusComment = " + StatusComment);
            stringBuilder.Append(", AssignToId = " + AssignToId);
            stringBuilder.Append(", UserStoryId = " + UserStoryId);
            stringBuilder.Append(", AssignToComment = " + AssignToComment);
            stringBuilder.Append(", TestCaseIds = " + TestCaseIds);
            stringBuilder.Append(", FilePaths = " + FilePaths);
            stringBuilder.Append(",AssignToId = " + AssignToId);
            stringBuilder.Append(", StatusComment =" + StatusComment);
            stringBuilder.Append(", PreConditionFilePaths = " + PreConditionFilePaths);
            stringBuilder.Append(", Version = " + Version);
            stringBuilder.Append(", Elapsed = " + Elapsed);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
	