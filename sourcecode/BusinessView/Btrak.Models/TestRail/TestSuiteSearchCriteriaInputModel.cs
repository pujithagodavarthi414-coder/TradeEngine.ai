using System;
using System.Collections.Generic;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.TestRail
{
    public class TestSuiteSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public TestSuiteSearchCriteriaInputModel() : base(InputTypeGuidConstants.TestSuiteSearchCriteriaInputCommandTypeGuid)
        {
        }
        
        public Guid? TestSuiteId { get; set; }

        public List<Guid> MultipleTestSuiteIds { get; set; }

        public string MultipleTestSuiteIdsXml { get; set; }

        public Guid? ProjectId { get; set; }

        public string TestSuiteName { get; set; }

        public string Description { get; set; }

        public DateTime? DateFrom { get; set; }

        public DateTime? DateTo { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("TestSuiteId = " + TestSuiteId);
            stringBuilder.Append("MultipleTestSuiteIds = " + MultipleTestSuiteIds);
            stringBuilder.Append("MultipleTestSuiteIdsXml = " + MultipleTestSuiteIdsXml);
            stringBuilder.Append(", ProjectId = " + ProjectId);
            stringBuilder.Append(", TestSuiteName = " + TestSuiteName);
            stringBuilder.Append(", Description = " + Description);
            stringBuilder.Append(", DateFrom = " + DateFrom);
            stringBuilder.Append(", DateTo = " + DateTo);
            return stringBuilder.ToString();
        }
    }
}
