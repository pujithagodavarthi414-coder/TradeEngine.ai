using System;
using System.Text;

namespace Btrak.Models.CompanyStructure
{
    public class NumberFormatOutputModel
    {
        public Guid? NumberFormatId { get; set; }
        public string NumberFormat { get; set; }
        public string TotalCount { get; set; }
        public bool IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", NumberFormatId   = " + NumberFormatId);
            stringBuilder.Append(", NumberFormat  = " + NumberFormat);
            stringBuilder.Append(", TotalCount  = " + TotalCount);
            stringBuilder.Append(", IsArchived  = " + IsArchived);
            stringBuilder.Append(", TimeStamp  = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
