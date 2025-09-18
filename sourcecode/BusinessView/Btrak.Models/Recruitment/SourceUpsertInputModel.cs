using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Recruitment
{
    public class SourceUpsertInputModel : InputModelBase
    {
        public SourceUpsertInputModel() : base(InputTypeGuidConstants.CompanySettingsInputCommandTypeGuid)
        {
        }

        public Guid? SourceId { get; set; }
        public string Name { get; set; }
        public bool IsReferenceNumberNeeded { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CompanySettingsId = " + SourceId);
            stringBuilder.Append(",Status = " + Name);
            stringBuilder.Append(",Order = " + IsReferenceNumberNeeded);
            stringBuilder.Append(",IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
