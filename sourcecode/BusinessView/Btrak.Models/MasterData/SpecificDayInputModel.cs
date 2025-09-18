using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.MasterData
{
    public class SpecificDayInputModel : InputModelBase
    {
        public SpecificDayInputModel() : base(InputTypeGuidConstants.SpecificDayInputCommandTypeGuid)
        {
        }

        public Guid? SpecificDayId { get; set; }
        public DateTime? Date { get; set; }
        public string Reason { get; set; }
        public Guid? CountryId { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("SpecificDayId = " + SpecificDayId);
            stringBuilder.Append(", Date = " + Date);
            stringBuilder.Append(", Reason = " + Reason);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
