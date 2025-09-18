using System;
using System.Text;

namespace Btrak.Models.MasterData
{
    public class ReportingMethodsOutputModel
    {
        public Guid? ReportingMethodId { get; set; }
        public string ReportingMethodName { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" ReportingMethodId = " + ReportingMethodId);
            stringBuilder.Append(", ReportingMethodName = " + ReportingMethodName);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
