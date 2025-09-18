using System;
using System.ComponentModel.DataAnnotations;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.TestRail
{
    public class TestCaseAutomationTypeInputModel : InputModelBase
    {
        public TestCaseAutomationTypeInputModel() : base(InputTypeGuidConstants.TestSuiteInputCommandTypeGuid)
        {
        }

        public Guid? TestCaseAutomationTypeId { get; set; }
        public string AutomationTypeName { get; set; }
        public bool IsArchived { get; set; }
        public bool IsDefault { get; set; }
        public string TimeZone { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" TestCaseAutomationTypeId = " + TestCaseAutomationTypeId);
            stringBuilder.Append(", AutomationTypeName = " + AutomationTypeName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", IsDefault =" + IsDefault);
            return stringBuilder.ToString();
        }
    }
}
