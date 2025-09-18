using System.Text;

namespace Btrak.Models.TestRail
{
    public class UploadTestCasesFromExcelModel
    {
        public string ID { get; set; }
        public string Title { get; set; }
        public string AutomationType { get; set; }
        public string CreatedBy { get; set; }
        public string CreatedOn { get; set; }
        public string Estimate { get; set; }
        public string ExpectedResult { get; set; }
        public string Forecast { get; set; }
        public string Goals { get; set; }
        public string Mission { get; set; }
        public string Preconditions { get; set; }
        public string Priority { get; set; }
        public string References { get; set; }
        public string Section { get; set; }
        public string SectionDepth { get; set; }
        public string SectionDescription { get; set; }
        public string SectionHierarchy { get; set; }
        public string Steps { get; set; }
        public string InlineSteps { get; set; }
        public string StepsExpectedResult { get; set; }
        public string StepText { get; set; }
        public string Suite { get; set; }
        public string SuiteID { get; set; }
        public string Template { get; set; }
        public string Type { get; set; }
        public string UpdatedBy { get; set; }
        public string UpdatedOn { get; set; }
        public string TestCaseStepsXml { get; set; }
        public TestCaseStepMiniModel TestCaseSteps { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ID = " + ID);
            stringBuilder.Append(", Title = " + Title);
            stringBuilder.Append(", AutomationType = " + AutomationType);
            stringBuilder.Append(", CreatedBy = " + CreatedBy);
            stringBuilder.Append(", CreatedOn = " + CreatedOn);
            stringBuilder.Append(", Estimate = " + Estimate);
            stringBuilder.Append(", ExpectedResult = " + ExpectedResult);
            stringBuilder.Append(", Forecast = " + Forecast);
            stringBuilder.Append(", Goals = " + Goals);
            stringBuilder.Append(", Mission = " + Mission);
            stringBuilder.Append(", Preconditions = " + Preconditions);
            stringBuilder.Append(", Priority = " + Priority);
            stringBuilder.Append(", References = " + References);
            stringBuilder.Append(", Section = " + Section);
            stringBuilder.Append(", SectionDepth = " + SectionDepth);
            stringBuilder.Append(", SectionDescription = " + SectionDescription);
            stringBuilder.Append(", SectionHierarchy = " + SectionHierarchy);
            stringBuilder.Append(", Steps = " + Steps);
            stringBuilder.Append(", InlineSteps = " + InlineSteps);
            stringBuilder.Append(", StepsExpectedResult = " + StepsExpectedResult);
            stringBuilder.Append(", StepText = " + StepText);
            stringBuilder.Append(", Suite = " + Suite);
            stringBuilder.Append(", Template = " + Template);
            stringBuilder.Append(", Type = " + Type);
            stringBuilder.Append(", UpdatedBy = " + UpdatedBy);
            stringBuilder.Append(", UpdatedOn = " + UpdatedOn);
            //stringBuilder.Append(", TestCaseSteps = " + TestCaseSteps);
            stringBuilder.Append(", TestCaseStepsXml = " + TestCaseStepsXml);
            return stringBuilder.ToString();
        }
    }

    public class Error
    {
        public int ErrorLine { get; set; }
        public string ErrorMessage { get; set; }
    }
}
