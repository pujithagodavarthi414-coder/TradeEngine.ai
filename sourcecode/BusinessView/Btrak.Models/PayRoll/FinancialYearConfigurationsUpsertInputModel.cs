using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class FinancialYearConfigurationsUpsertInputModel : InputModelBase
    {
        public FinancialYearConfigurationsUpsertInputModel() : base(InputTypeGuidConstants.FinancialYearConfigurationsInputCommandTypeGuid)
        {
        }

        public Guid? FinancialYearConfigurationsId { get; set; }
        public int? FromMonth { get; set; }
        public int? ToMonth { get; set; }
        public bool? IsArchived { get; set; }
        public Guid? CountryId { get; set; }
        public Guid? FinancialYearTypeId { get; set; }
        public DateTime? ActiveFrom { get; set; }
        public DateTime? ActiveTo { get; set; }
        
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("FinancialYearConfigurationsId = " + FinancialYearConfigurationsId);
            stringBuilder.Append(",CountryId = " + CountryId);
            stringBuilder.Append(",FinancialYearTypeId = " + FinancialYearTypeId);
            stringBuilder.Append(",FromMonth = " + FromMonth);
            stringBuilder.Append(",ToMonth = " + ToMonth);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(",ActiveFrom = " + ActiveFrom);
            stringBuilder.Append(",ActiveTo = " + ActiveTo);
            return stringBuilder.ToString();
        }
    }
}
