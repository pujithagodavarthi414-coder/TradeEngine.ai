using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.TestRail
{
    public class TestRunSelectedCasesApiReturnModel
    {
        public Guid? TestRunSelectedCaseId { get; set; }

        public Guid? TestCaseId { get; set; }

        public Guid? TestRunId { get; set; }

        public string Title { get; set; }

        public string TestCaseFilePath { get; set; }

        public string TestCaseMissionFilePath { get; set; }

        public string TestCaseStepDescriptionFilePath { get; set; }

        public string TestCaseGoalFilePath { get; set; }

        public Guid? SectionId { get; set; }

        public string SectionName { get; set; }

        public Guid? TemplateId { get; set; }

        public string TemplateName { get; set; }

        public string TestCaseIdentity { get; set; }

        public Guid? TestSuiteId { get; set; }

        public Guid? TypeId { get; set; }

        public string TypeName { get; set; }

        public int Estimate { get; set; }

        public int BugsCount { get; set; }

        public string References { get; set; }

        public string Steps { get; set; }

        public string ExpectedResult { get; set; }

        public string PreConditionFilePath { get; set; }

        public string ExpectedResultFilePath { get; set; }

        public string StatusCommentFilePath { get; set; }

        public string AssigneeCommentFilePath { get; set; }

        public string StepsFilePath { get; set; }

        public string Mission { get; set; }

        public string Goals { get; set; }

        public Guid? PriorityId { get; set; }

        public string PriorityType { get; set; }

        public Guid? AutomationTypeId { get; set; }

        public string AutomationType { get; set; }

        public string Precondition { get; set; }
               
        public Guid? AssignToId { get; set; }

        public string AssignToComment { get; set; }

        public List<string> ReferencesList { get; set; }

        public string Version { get; set; }

        public DateTime? Elapsed { get; set; }

        public Guid? StatusId { get; set; }

        public string StatusName { get; set; }

        public string StatusColor { get; set; }

        public string StatusComment { get; set; }

        public string AssignToName { get; set; }

        public string AssignToProfileImage { get; set; }

        public Guid? CreatedByUserId { get; set; }

        public DateTime? CreatedDateTime { get; set; }

        public string TestCaseStepsXml { get; set; }

        public string TestCaseHistoryXml { get; set; }

        public List<TestCaseStepMiniModel> TestCaseSteps { get; set; }

        public List<TestCaseHistoryMiniModel> TestCaseHistory { get; set; }

        public string TestedBy { get; set; }

        public int? TotalCount { get; set; }

        public byte[] TimeStamp { get; set; }

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
            stringBuilder.Append(", PriorityName = " + PriorityType);
            stringBuilder.Append(", Estimate = " + Estimate);
            stringBuilder.Append(", References = " + References);
            stringBuilder.Append(", AutomationTypeId = " + AutomationTypeId);
            stringBuilder.Append(", AutomationType = " + AutomationType);
            stringBuilder.Append(", Precondition = " + Precondition);
            stringBuilder.Append(", PreConditionFilePath = " + PreConditionFilePath);
            stringBuilder.Append(", TestCaseSteps = " + TestCaseSteps);
            stringBuilder.Append(", Mission = " + Mission);
            stringBuilder.Append(", Goals = " + Goals);
            stringBuilder.Append(", TestCaseStepsXml = " + TestCaseStepsXml);
            stringBuilder.Append(", TestCaseHistoryXml = " + TestCaseHistoryXml);
            stringBuilder.Append(", Steps = " + Steps);
            stringBuilder.Append(", StepsFilePath = " + StepsFilePath);
            stringBuilder.Append(", ExpectedResult = " + ExpectedResult);
            stringBuilder.Append(", ExpectedResultFilePath = " + ExpectedResultFilePath);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", AssignToId = " + AssignToId);
            stringBuilder.Append(", StatusComment = " + StatusComment);
            stringBuilder.Append(", StatusId = " + StatusId);
            stringBuilder.Append(", StatusName = " + StatusName);
            stringBuilder.Append(", AssignToName = " + AssignToName);
            stringBuilder.Append(", AssignToComment = " + AssignToComment);
            stringBuilder.Append(", StatusColor = " + StatusColor);
            stringBuilder.Append(", AssignToProfileImage = " + AssignToProfileImage);
            stringBuilder.Append(", TestedBy = " + TestedBy);
            return stringBuilder.ToString();
        }
    }
}
