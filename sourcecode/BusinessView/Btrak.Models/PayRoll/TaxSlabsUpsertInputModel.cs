using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class TaxSlabsUpsertInputModel : InputModelBase
    {

        public TaxSlabsUpsertInputModel() : base(InputTypeGuidConstants.TaxSlabsInputCommandTypeGuid)
        {
        }

        public Guid? TaxSlabId { get; set; }
        public string Name { get; set; }
        public decimal? FromRange { get; set; }
        public decimal? ToRange { get; set; }
        public decimal? TaxPercentage { get; set; }
        public DateTime? ActiveFrom { get; set; }
        public DateTime? ActiveTo { get; set; }
        public int? MinAge { get; set; }
        public int? MaxAge { get; set; }
        public bool? ForMale { get; set; }
        public bool? ForFemale { get; set; }
        public bool? Handicapped { get; set; }
        public int? Order { get; set; }
        public bool IsArchived { get; set; }
        public Guid? ParentId { get; set; }
        public List<Guid> PayRollTemplateIds { get; set; }
        public string PayRollTempalteXml { get; set; }
        public bool IsFlatRate { get; set; }
        public Guid? CountryId { get; set; }
        public Guid? BranchId { get; set; }
        public Guid? TaxCalculationTypeId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("TaxSlabId = " + TaxSlabId);
            stringBuilder.Append(",Name = " + Name);
            stringBuilder.Append(",FromRange = " + FromRange);
            stringBuilder.Append(",ToRange = " + ToRange);
            stringBuilder.Append(",TaxPercentage = " + TaxPercentage);
            stringBuilder.Append(",ActiveFrom = " + ActiveFrom);
            stringBuilder.Append(",ActiveTo = " + ActiveTo);
            stringBuilder.Append(",MinAge = " + MinAge);
            stringBuilder.Append(",MaxAge = " + MaxAge);
            stringBuilder.Append(",ForMale = " + ForMale);
            stringBuilder.Append(",ForFemale = " + ForFemale);
            stringBuilder.Append(",Handicapped = " + Handicapped);
            stringBuilder.Append(",Order = " + Order);
            stringBuilder.Append(",ParentId = " + ParentId);
            stringBuilder.Append(",PayRollTemplateIds = " + PayRollTemplateIds);
            stringBuilder.Append(",PayRollTempalteXml = " + PayRollTempalteXml);
            stringBuilder.Append(",IsFlatRate = " + IsFlatRate);
            stringBuilder.Append(",CountryId = " + CountryId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", BranchId = " + BranchId);
            stringBuilder.Append(", TaxCalculationTypeId = " + TaxCalculationTypeId);

            return stringBuilder.ToString();
        }
    }
}
