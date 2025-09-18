using System.Text;

namespace Btrak.Models.TestRail
{
    public class UploadTestRunsFromExcelModel
    {
        public string ID { get; set; }
        public string Title { get; set; }
        public string AssignedTo { get; set; }
        public string AutomationType { get; set; }
        public string CaseID { get; set; }
        public string Comment { get; set; }
        public string Defects { get; set; }
        public string Elapsed { get; set; }
        public string Estimate { get; set; }
        public string Expected { get; set; }
        public string Forecast { get; set; }
        public string Goals { get; set; }
        public string InProgress { get; set; }
        public string Mission { get; set; }
        public string Plan { get; set; }
        public string PlanID { get; set; }
        public string Preconditions { get; set; }
        public string Priority { get; set; }
        public string References { get; set; }
        public string Run { get; set; }
        public string RunConfigaration { get; set; }
        public string RunID { get; set; }
        public string Section { get; set; }
        public string SectionDepth { get; set; }
        public string SectionDescription { get; set; }
        public string SectionHierarchy { get; set; }
        public string Status { get; set; }
        public string Step { get; set; }
        public string Steps { get; set; }
        public string StepsInline { get; set; }
        public string ActualResult { get; set; }
        public string ExpectedResult { get; set; }
        public string ExpectedResultInline { get; set; }
        public string StepStatus { get; set; }
        public string StepsStep { get; set; }
        public string StepsStepInline { get; set; }
        public string Template { get; set; }
        public string TestedBy { get; set; }
        public string TestedOn { get; set; }
        public string Type { get; set; }
        public string Version { get; set; }
        public string TestSuiteName { get; set; } 
        public string TestCaseStepsXml { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ID = " + ID);
            stringBuilder.Append(", Title = " + Title);
            stringBuilder.Append(", AssignedTo = " + AssignedTo);
            stringBuilder.Append(", AutomationType = " + AutomationType);
            stringBuilder.Append(", CaseID = " + CaseID);
            stringBuilder.Append(", Comment = " + Comment);
            stringBuilder.Append(", Elapsed = " + Elapsed);
            stringBuilder.Append(", Estimate = " + Estimate);
            stringBuilder.Append(", Expected = " + Expected);
            stringBuilder.Append(", Forecast = " + Forecast);
            stringBuilder.Append(", Goals = " + Goals);
            stringBuilder.Append(", InProgress = " + InProgress);
            stringBuilder.Append(", Mission = " + Mission);
            stringBuilder.Append(", Plan = " + Plan);
            stringBuilder.Append(", PlanID = " + PlanID);
            stringBuilder.Append(", Preconditions = " + Preconditions);
            stringBuilder.Append(", Priority = " + Priority);
            stringBuilder.Append(", References = " + References);
            stringBuilder.Append(", Run = " + Run);
            stringBuilder.Append(", RunConfigaration = " + RunConfigaration);
            stringBuilder.Append(", RunID = " + RunID);
            stringBuilder.Append(", Section = " + Section);
            stringBuilder.Append(", SectionDepth = " + SectionDepth);
            stringBuilder.Append(", SectionDescription = " + SectionDescription);
            stringBuilder.Append(", SectionHierarchy = " + SectionHierarchy);
            stringBuilder.Append(", Status = " + Status);
            stringBuilder.Append(", Steps = " + Steps);
            stringBuilder.Append(", ActualResult = " + ActualResult);
            stringBuilder.Append(", ExpectedResult = " + ExpectedResult);
            stringBuilder.Append(", ExpectedResultInline = " + ExpectedResultInline);
            stringBuilder.Append(", StepStatus = " + StepStatus);
            stringBuilder.Append(", StepsStep = " + StepsStep);
            stringBuilder.Append(", StepsStepInline = " + StepsStepInline);
            stringBuilder.Append(", Template = " + Template);
            stringBuilder.Append(", TestedBy = " + TestedBy);
            stringBuilder.Append(", TestedOn = " + TestedOn);
            stringBuilder.Append(", Type = " + Type);
            stringBuilder.Append(", Version = " + Version);
            stringBuilder.Append(", TestSuiteName = " + TestSuiteName);
            return stringBuilder.ToString();
        }
    }
}
