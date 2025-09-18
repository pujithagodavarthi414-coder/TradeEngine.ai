using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.TestRail
{
    public class TestRailMasterDataModel : InputModelBase
    {
        public TestRailMasterDataModel() : base(InputTypeGuidConstants.TestRailMasterDataInputCommandTypeGuid)
        {
        }

        public Guid? Id { get; set; }

        public string Value { get; set; }

        public string TestCaseType { get; set; }

        public bool? IsArchived { get; set; }

        public string TimeZone { get; set; }

        public bool? IsDefault { get; set; }

        public Guid? CompanyId { get; set; }

        public DateTimeOffset CreatedDatetime { get; set; }

        public Guid? CreatedByUserId { get; set; }

        public int? TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("Id = " + Id);
            stringBuilder.Append(", Value = " + Value);
            stringBuilder.Append(", Testcasetype = " + TestCaseType);
            stringBuilder.Append(", IsDefault = " + IsDefault);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", CompanyId = " + CompanyId);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
