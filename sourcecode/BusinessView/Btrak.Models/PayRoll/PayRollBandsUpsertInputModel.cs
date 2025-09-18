using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class PayRollBandsUpsertInputModel : InputModelBase
    {
        public PayRollBandsUpsertInputModel() : base(InputTypeGuidConstants.PayRollBandsInputCommandTypeGuid)
        {
        }

        public Guid? PayRollBandId { get; set; }
        public string Name { get; set; }
        public decimal? FromRange { get; set; }
        public decimal? ToRange { get; set; }
        public decimal? Percentage { get; set; }
        public DateTime? ActiveFrom { get; set; }
        public DateTime? ActiveTo { get; set; }
        public bool IsArchived { get; set; }
        public Guid? ParentId { get; set; }
        public Guid? CountryId { get; set; }
        public Guid? PayRollComponentId { get; set; }
        public int? MinAge { get; set; }
        public int? MaxAge { get; set; }
        public bool? ForMale { get; set; }
        public bool? ForFemale { get; set; }
        public bool? Handicapped { get; set; }
        public bool? IsMarried { get; set; }
        public int? Order { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("PayRollBandId = " + PayRollBandId);
            stringBuilder.Append(",Name = " + Name);
            stringBuilder.Append(",FromRange = " + FromRange);
            stringBuilder.Append(",ToRange = " + ToRange);
            stringBuilder.Append(",Percentage = " + Percentage);
            stringBuilder.Append(",ActiveFrom = " + ActiveFrom);
            stringBuilder.Append(",ActiveTo = " + ActiveTo);
            stringBuilder.Append(",ParentId = " + ParentId);
            stringBuilder.Append(",CountryId = " + CountryId);
            stringBuilder.Append(",PayRollComponentId = " + PayRollComponentId);
            stringBuilder.Append(",MinAge = " + MinAge);
            stringBuilder.Append(",MaxAge = " + MaxAge);
            stringBuilder.Append(",ForMale = " + ForMale);
            stringBuilder.Append(",ForFemale = " + ForFemale);
            stringBuilder.Append(",Handicapped = " + Handicapped);
            stringBuilder.Append(",IsMarried = " + IsMarried);
            stringBuilder.Append(",Order = " + Order);
            stringBuilder.Append(",IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
