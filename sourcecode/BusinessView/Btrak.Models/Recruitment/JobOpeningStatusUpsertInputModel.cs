using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Recruitment
{
    public class JobOpeningStatusUpsertInputModel : InputModelBase
    {
        public JobOpeningStatusUpsertInputModel() : base(InputTypeGuidConstants.CompanySettingsInputCommandTypeGuid)
        {
        }

        public Guid? JobOpeningStatusId { get; set; }
        public string Status { get; set; }
        public int Order { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CompanySettingsId = " + JobOpeningStatusId);
            stringBuilder.Append(",Status = " + Status);
            stringBuilder.Append(",Order = " + Order);
            return stringBuilder.ToString();
        }
    }
}
