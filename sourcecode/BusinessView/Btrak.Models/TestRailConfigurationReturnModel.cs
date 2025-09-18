using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.TestRail
{
    public class TestRailConfigurationReturnModel : InputModelBase
    {
        public TestRailConfigurationReturnModel() : base(InputTypeGuidConstants.TestCaseStatusSearchCommandTypeGuid)
        {
        }

        public Guid? TestRailConfigurationId { get; set; }

        public string ConfigurationName { get; set; }

        public string ConfigurationShortName { get; set; }

        public float? ConfigurationTime { get; set; }

        public bool IsArchived { get; set; }

        public Guid? CompanyId { get; set; }

        public DateTimeOffset CreatedDatetime { get; set; }

        public Guid? CreatedByUserId { get; set; }

        public int? TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("TestRailConfigurationId = " + TestRailConfigurationId);
            stringBuilder.Append(", ConfigurationName = " + ConfigurationName);
            stringBuilder.Append(", ConfigurationTime = " + ConfigurationTime);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", CompanyId = " + CompanyId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", CreatedDatetime = " + CreatedDatetime);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
