using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.TestRail
{
    public class TestCaseApiReturnModel
    {
        public Guid? TestCaseId { get; set; }

        public string TestCaseIdentity { get; set; }

        public Guid? TestSuiteId { get; set; }

        public string Title { get; set; }

        public Guid? SectionId { get; set; }

        public string SectionName { get; set; }

        public string TestCaseFilePath { get; set; }

        public string TestCaseMissionFilePath { get; set; }

        public string TestCaseGoalFilePath { get; set; }

        public string TestCaseStepDescriptionFilePath { get; set; }

        public Guid? TemplateId { get; set; }

        public string TemplateName { get; set; }

        public Guid? TypeId { get; set; }

        public string TypeName { get; set; }

        public Guid? PriorityId { get; set; }

        public string PreConditionFilePath { get; set; }

        public string ExpectedResultFilePath { get; set; }

        public string StepsFilePath { get; set; }

        public string PriorityType { get; set; }

        public int Estimate { get; set; }

        public string References { get; set; }

        public List<string> ReferencesList { get; set; }

        public Guid? AutomationTypeId { get; set; }

        public string AutomationType { get; set; }

        public string Precondition { get; set; }

        public string Steps { get; set; }

        public string TestCaseStepsXml { get; set; }

        public string TestCaseHistoryXml { get; set; }

        public List<TestCaseStepMiniModel> TestCaseSteps { get; set; }

        public List<TestCaseHistoryMiniModel> TestCaseHistory { get; set; }

        public string Mission { get; set; }

        public Guid? AssignToId { get; set; }

        public string AssignToComment { get; set; }

        public string StatusComment { get; set; }

        public Guid? StatusId { get; set; }

        public Guid? UserStoryId { get; set; }

        public string Status { get; set; }

        public string StatusName { get; set; }

        public string StatusColor { get; set; }

        public string AssignToName { get; set; }

        public string AssignToProfileImage { get; set; }

        public string Goals { get; set; }

        public string ExpectedResult { get; set; }

        public bool IsArchived { get; set; }

        public bool IsChecked { get; set; }

        public List<string> FilePaths { get; set; }

        public List<string> PreConditionFilePaths { get; set; }

        public byte[] TimeStamp { get; set; }

        public byte[] UserStoryScenarioTimeStamp { get; set; }

        public string Version { get; set; }

        public TimeSpan Elapsed { get; set; }

        public string TestSuiteName { get; set; }

        public int? TestCasesCount { get; set; }

        public int? BugsCount { get; set; }

        public int? TotalCount { get; set; }

        public DateTime CreatedDateTime { get; set; }

        public Guid? CreatedByUserId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("TestCaseId = " + TestCaseId);
            stringBuilder.Append(", TestCaseIdentity = " + TestCaseIdentity);
            stringBuilder.Append(", TestSuiteId = " + TestSuiteId);
            stringBuilder.Append(", Title = " + Title);
            stringBuilder.Append(", SectionId = " + SectionId);
            stringBuilder.Append(", SectionName = " + SectionName);
            stringBuilder.Append(", TemplateId = " + TemplateId);
            stringBuilder.Append(", TemplateName = " + TemplateName);
            stringBuilder.Append(", TypeId = " + TypeId);
            stringBuilder.Append(", TypeName = " + TypeName);
            stringBuilder.Append(", PriorityId = " + PriorityId);
            stringBuilder.Append(", UserStoryId = " + UserStoryId);
            stringBuilder.Append(", PriorityName = " + PriorityType);
            stringBuilder.Append(", Estimate = " + Estimate);
            stringBuilder.Append(", References = " + References);
            stringBuilder.Append(", AutomationTypeId = " + AutomationTypeId);
            stringBuilder.Append(", AutomationType = " + AutomationType);
            stringBuilder.Append(", Precondition = " + Precondition);
            stringBuilder.Append(", Steps = " + Steps);
            stringBuilder.Append(", TestCaseSteps = " + TestCaseSteps);
            stringBuilder.Append(", Mission = " + Mission);
            stringBuilder.Append(", Goals = " + Goals);
            stringBuilder.Append(", BugsCount = " + BugsCount);
            stringBuilder.Append(", TestCaseStepsXml = " + TestCaseStepsXml);
            stringBuilder.Append(", ExpectedResult = " + ExpectedResult);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", FilePaths = " + FilePaths);
            stringBuilder.Append(", PreConditionFilePaths = " + PreConditionFilePaths);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", UserStoryScenarioTimeStamp = " + UserStoryScenarioTimeStamp);
            stringBuilder.Append(", StatusId = " + StatusId);
            stringBuilder.Append(", StatusComment = " + StatusComment);
            stringBuilder.Append(", AssignToId = " + AssignToId);
            stringBuilder.Append(", Version = " + Version);
            stringBuilder.Append(", Elapsed = " + Elapsed);
            stringBuilder.Append(", TestSuiteName = " + TestSuiteName);
            stringBuilder.Append(", TestCasesCount = " + TestCasesCount);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", Status = " + Status);
            stringBuilder.Append(", AssignToName = " + AssignToName);
            stringBuilder.Append(", AssignToComment = " + AssignToComment);
            stringBuilder.Append(", StatusName = " + StatusName);
            stringBuilder.Append(", StatusColor = " + StatusColor);
            stringBuilder.Append(", AssignToProfileImage = " + AssignToProfileImage);
            stringBuilder.Append(", IsChecked = " + IsChecked);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
