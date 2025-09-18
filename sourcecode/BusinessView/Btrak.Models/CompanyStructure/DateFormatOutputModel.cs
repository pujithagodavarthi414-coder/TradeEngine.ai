using System;
using System.Text;

namespace Btrak.Models.CompanyStructure
{
    public class DateFormatOutputModel
    {
        public Guid? DateFormatId { get; set; }
        public string DateFormatName { get; set; }
        public string DateFormatPattern { get; set; }
        public string TotalCount { get; set; }
        public bool IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", DateFormatId   = " + DateFormatId);
            stringBuilder.Append(", DisplayText  = " + DateFormatName);
            stringBuilder.Append(", DateFormatPattern  = " + DateFormatPattern);
            stringBuilder.Append(", TotalCount  = " + TotalCount);
            stringBuilder.Append(", IsArchived  = " + IsArchived);
            stringBuilder.Append(", TimeStamp  = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
