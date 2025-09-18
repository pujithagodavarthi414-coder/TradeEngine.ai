using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.MasterData
{
    public class NumberFormatInputModel : InputModelBase
    {
        public NumberFormatInputModel() : base(InputTypeGuidConstants.NumberFormatInputCommandTypeGuid)
        {
        }
        
        public Guid? NumberFormatId { get; set; }
        public string NumberFormat { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("NumberFormatId = " + NumberFormatId);
            stringBuilder.Append(", NumberFormat = " + NumberFormat);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}