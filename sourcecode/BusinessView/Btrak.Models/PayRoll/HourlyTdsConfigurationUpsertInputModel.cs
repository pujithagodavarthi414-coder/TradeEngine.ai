using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.PayRoll
{
    public class HourlyTdsConfigurationUpsertInputModel : InputModelBase
    {
        public HourlyTdsConfigurationUpsertInputModel() : base(InputTypeGuidConstants.HourlyTdsConfigurationUpsertInputCommandTypeGuid)
        {
        }

        public Guid? Id { get; set; }
        public Guid BranchId { get; set; }
        public decimal MaxLimit { get; set; }
        public decimal TaxPercentage { get; set; }
        public DateTime ActiveFrom { get; set; }
        public DateTime? ActiveTo { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("Id = " + Id);
            stringBuilder.Append(",BranchId = " + BranchId);
            stringBuilder.Append(",MaxLimit = " + MaxLimit);
            stringBuilder.Append(",TaxPercentage = " + TaxPercentage);
            stringBuilder.Append(",ActiveFrom = " + ActiveFrom);
            stringBuilder.Append(",ActiveTo = " + ActiveTo);
            stringBuilder.Append(",IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
