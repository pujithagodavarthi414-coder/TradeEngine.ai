using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.TestRail
{
    public class TestCasesForExport
    {

        public string TestCaseIdentity { get; set; }

        public string Title { get; set; }

        public string TemplateName { get; set; }

        public string TypeName { get; set; }

        public string PriorityType { get; set; }

        public int? Estimate { get; set; }

        public string References { get; set; }

        public string AutomationType { get; set; }

        public string Precondition { get; set; }

        public string Steps { get; set; }

        public string Mission { get; set; }

        public string AssignToName { get; set; }

        public string AssignToProfileImage { get; set; }

        public string Goals { get; set; }

        public string ExpectedResult { get; set; }

        public string Version { get; set; }

        public TimeSpan? Elapsed { get; set; }

        public DateTime? CreatedDateTime { get; set; }

        public List<TestCaseStepsForExport> TestCaseSteps { get; set; }

    }
}