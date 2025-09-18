using System;
using System.Text;

namespace Btrak.Models.CompanyStructure
{
    public class TimeFormatOutputModel
    {
        public Guid? TimeFormatId { get; set; }
        public string TimeFormatName { get; set; }
        public string TimeFormatPattern { get; set; }
        public string TotalCount { get; set; }
        public bool IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", TimeFormatId   = " + TimeFormatId);
            stringBuilder.Append(", TimeFormatName  = " + TimeFormatName);
            stringBuilder.Append(", TimeFormatPattern  = " + TimeFormatPattern);
            stringBuilder.Append(", TotalCount  = " + TotalCount);
            stringBuilder.Append(", IsArchived  = " + IsArchived);
            stringBuilder.Append(", TimeStamp  = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
