using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.TestRail
{
    public class TestCaseAutomationTypeSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public TestCaseAutomationTypeSearchCriteriaInputModel() : base(InputTypeGuidConstants.TestCaseAutomationTypeSearchCriteriaInputCommandTypeGuid)
        {
        }
        
        public Guid? TestCaseAutomationTypeId { get; set; }
        public string AutomationTypeName { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("TestCaseAutomationTypeId = " + TestCaseAutomationTypeId);
            stringBuilder.Append(", AutomationTypeName = " + AutomationTypeName);
            return stringBuilder.ToString();
        }
    }
}
