using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using BTrak.Common;

namespace Btrak.Models.TestRail
{
    public class TestCaseStatusMasterDataInputModel : InputModelBase
    {
        public TestCaseStatusMasterDataInputModel() : base(InputTypeGuidConstants.TestCaseStatusMasterDataInputCommandTypeGuid)
        {
        }

        public Guid? StatusId { get; set; }

        public string Status { get; set; }

        public string StatusHexValue { get; set; }

        public bool IsArchived { get; set; }

        public string TimeZone { get; set; }

        public bool? IsDefault { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("StatusId = " + StatusId);
            stringBuilder.Append(", Status = " + Status);
            stringBuilder.Append(", StatusHexValue = " + StatusHexValue);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", IsDefault = " + IsDefault);
            return stringBuilder.ToString();
        }
    }
}
