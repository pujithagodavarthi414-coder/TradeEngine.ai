using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.PayRoll
{
    public class TaxAllowanceUpsertInputModel : InputModelBase
    {
        public TaxAllowanceUpsertInputModel() : base(InputTypeGuidConstants.PayRollTemplateInputCommandTypeGuid)
        {
        }

        public Guid? TaxAllowanceId { get; set; }
        public string Name { get; set; }
        public Guid? TaxAllowanceTypeId { get; set; }
        public bool IsPercentage { get; set; }
        public decimal? MaxAmount { get; set; }
        public decimal? PercentageValue { get; set; }
        public Guid? ParentId { get; set; }
        public Guid? PayRollComponentId { get; set; }
        public Guid? ComponentId { get; set; }
        public Guid? DependentPayRollComponentId { get; set; }
        public DateTime? FromDate { get; set; }
        public DateTime? ToDate { get; set; }
        public decimal? OnlyEmployeeMaxAmount { get; set; }
        public decimal? MetroMaxPercentage { get; set; }
        public bool LowestAmountOfParentSet { get; set; }
        public bool? IsArchived { get; set; }
        public Guid? BranchId { get; set; }
        public Guid? CountryId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("TaxAllowanceId = " + TaxAllowanceId);
            stringBuilder.Append(",Name = " + Name);
            stringBuilder.Append(",TaxAllowanceTypeId = " + TaxAllowanceTypeId);
            stringBuilder.Append(",IsPercentage = " + IsPercentage);
            stringBuilder.Append(",MaxAmount = " + MaxAmount);
            stringBuilder.Append(", PercentageValue = " + PercentageValue);
            stringBuilder.Append(", ParentId = " + ParentId);
            stringBuilder.Append(", PayRollComponentId = " + PayRollComponentId);
            stringBuilder.Append(", ComponentId = " + ComponentId);
            stringBuilder.Append(", FromDate = " + FromDate);
            stringBuilder.Append(", ToDate = " + ToDate);
            stringBuilder.Append(", OnlyEmployeeMaxAmount = " + OnlyEmployeeMaxAmount);
            stringBuilder.Append(", MetroMaxPercentage = " + MetroMaxPercentage);
            stringBuilder.Append(", LowestAmountOfParentSet = " + LowestAmountOfParentSet);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", CountryId = " + CountryId);

            return stringBuilder.ToString();
        }
    }
}
