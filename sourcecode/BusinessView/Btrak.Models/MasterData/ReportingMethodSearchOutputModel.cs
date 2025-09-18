using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.MasterData
{
    public class ReportingMethodSearchOutputModel
    {
        public Guid? ReportingMethodId { get; set; }
        public string ReportingMethodName { get; set; }
        public bool? IsArchived { get; set; }
        public int? TotalCount { get; set; }
        public byte[] TimeStamp { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" ReportingMethodId  = " + ReportingMethodId);
            stringBuilder.Append(", ReportingMethodName = " + ReportingMethodName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
