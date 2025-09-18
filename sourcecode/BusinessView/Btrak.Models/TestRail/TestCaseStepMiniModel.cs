using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.TestRail
{
    public class TestCaseStepMiniModel
    {
        public Guid? StepId { get; set; }

        public Guid? TestRunSelectedStepId { get; set; }

        public int? StepOrder { get; set; }
        public bool StepCreated { get; set; }

        public string StepText { get; set; }

        public string StepTextFilePath { get; set; }

        public string StepExpectedResultFilePath { get; set; }

        public string StepExpectedResult { get; set; }

        public string StepActualResult { get; set; }

        public string StepActualResultFilePath { get; set; }

        public Guid? StepStatusId { get; set; }

        public List<string> StepFilePaths { get; set; }

        public string StepStatusName { get; set; }

        public string StepStatusColor { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("StepId = " + StepId);
            stringBuilder.Append("StepOrder = " + StepOrder);
            stringBuilder.Append("StepCreated = " + StepCreated);
            stringBuilder.Append(", StepText = " + StepText);
            stringBuilder.Append(", StepExpectedResult = " + StepExpectedResult);
            stringBuilder.Append(", StepStatusId = " + StepStatusId);
            stringBuilder.Append(", StepFilePaths = " + StepFilePaths);
            stringBuilder.Append(", Status = " + StepStatusName);
            stringBuilder.Append(", StatusColor = " + StepStatusColor);
            stringBuilder.Append(", StepExpectedResult = " + StepExpectedResult);
            stringBuilder.Append(", StepActualResult = " + StepActualResult);
            stringBuilder.Append(", StepActualResultFilePath = " + StepActualResultFilePath);
            return stringBuilder.ToString();
        }
    }
}
