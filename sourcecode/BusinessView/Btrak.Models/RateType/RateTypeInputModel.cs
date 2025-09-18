using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.RateType
{
    public class RateTypeInputModel : InputModelBase
    {
        public RateTypeInputModel() : base(InputTypeGuidConstants.RateTypeInputCommandTypeGuid)
        {
        }
        public Guid? RateTypeId { get; set; }
        public string TypeName { get; set; }
        public decimal Rate { get; set; }
        public bool? IsArchive { get; set; }
        
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" RateTypeId = " + RateTypeId);
            stringBuilder.Append(", TypeName = " + TypeName);
            stringBuilder.Append(", Rate = " + Rate);
            stringBuilder.Append(", IsArchive = " + IsArchive);
            return stringBuilder.ToString();
        }
    }
}
