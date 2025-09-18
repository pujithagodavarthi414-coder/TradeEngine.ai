using System;
using System.Text;

namespace Btrak.Models.WorkFlow
{
    public class WorkFlowApiReturnModel
    {
        public Guid? WorkFlowId { get; set; }
        public string WorkFlowName { get; set; }
        public bool IsArchived { get; set; }

        public DateTimeOffset CreatedDatetime { get; set; }
        public string CreatedOn { get; set; }
        public int TotalCount { get; set; }
        public Guid? CompanyId { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public DateTimeOffset UpdatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }



        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("WorkFlowId = " + WorkFlowId);
            stringBuilder.Append(", WorkFlowName = " + WorkFlowName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", CreatedDatetime = " + CreatedDatetime);
            stringBuilder.Append(", CreatedOn = " + CreatedOn);
            stringBuilder.Append(", CompanyId = " + CompanyId);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", UpdatedByUserId = " + UpdatedByUserId);
            stringBuilder.Append(", UpdatedDateTime = " + UpdatedDateTime);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
