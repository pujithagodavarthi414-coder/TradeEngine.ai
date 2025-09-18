using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.TestRail
{
    public class TestCaseStatusMasterDataModel : InputModelBase
    {
        public TestCaseStatusMasterDataModel() : base(InputTypeGuidConstants.TestCaseStatusSearchCommandTypeGuid)
        {
        }

        public Guid? StatusId { get; set; }

        public string Status { get; set; }

        public string StatusHexValue { get; set; }

        public bool IsArchived { get; set; }

        public Guid? CompanyId { get; set; }

        public DateTimeOffset CreatedDatetime { get; set; }

        public Guid? CreatedByUserId { get; set; }

        public int? TotalCount { get; set; }

        public string TestCaseStatus { get; set; }

        public string StatusShortName { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("StatusId = " + StatusId);
            stringBuilder.Append(", Status = " + Status);
            stringBuilder.Append(", StatusHexValue = " + StatusHexValue);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", CompanyId = " + CompanyId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", CreatedDatetime = " + CreatedDatetime);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(",TestCaseStatus =" + TestCaseStatus);
            return stringBuilder.ToString();
        }
    }
}
