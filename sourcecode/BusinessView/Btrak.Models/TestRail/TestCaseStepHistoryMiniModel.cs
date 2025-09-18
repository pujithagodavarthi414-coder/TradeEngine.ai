using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.TestRail
{
    public class TestCaseStepHistoryMiniModel
    {
        public Guid? StepId { get; set; }

        public string StepText { get; set; }

        public string StepExpectedResult { get; set; }

        public string StepActualResult { get; set; }

        public Guid? StepStatusId { get; set; }

        public string StepStatusName { get; set; }

        public string StepStatusColor { get; set; }

        public DateTime? CreatedDateTime { get; set; }

        public string TestedBy { get; set; }

        public string TestedByProfileImage { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("StepId = " + StepId);
            stringBuilder.Append(", StepText = " + StepText);
            stringBuilder.Append(", StepExpectedResult = " + StepExpectedResult);
            stringBuilder.Append(", StepStatusId = " + StepStatusId);
            stringBuilder.Append(", Status = " + StepStatusName);
            stringBuilder.Append(", StatusColor = " + StepStatusColor);
            stringBuilder.Append(", StepExpectedResult = " + StepExpectedResult);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", TestedBy = " + TestedBy);
            stringBuilder.Append(", TestedByProfileImage = " + TestedByProfileImage);
            return stringBuilder.ToString();
        }
    }
}