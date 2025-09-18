using System;
using System.Text;

namespace Btrak.Models.BoardType
{
    public class BoardTypeApiReturnModel
    {
        public Guid? BoardTypeId { get; set; }
        public string BoardTypeName { get; set; }

        public Guid? BoardTypeUiId { get; set; }
        public string BoardTypeUiName { get; set; }

        public Guid? WorkFlowId { get; set; }
        public string WorkFlowName { get; set; }
        public bool? IsBugBoard { get; set; }
        public bool? IsSuperAgileBoard { get; set; }
        public bool? IsDefault { get; set; }
        public bool IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }
        public Guid? CompanyId { get; set; }

        public DateTimeOffset CreatedDateTime { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("BoardTypeId = " + BoardTypeId);
            stringBuilder.Append(", BoardTypeName = " + BoardTypeName);
            stringBuilder.Append(", BoardTypeUiId = " + BoardTypeUiId);
            stringBuilder.Append(", BoardTypeUiName = " + BoardTypeUiName);
            stringBuilder.Append(", WorkFlowId = " + WorkFlowId);
            stringBuilder.Append(", WorkFlowName = " + WorkFlowName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", IsBugBoard = " + IsBugBoard);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            return stringBuilder.ToString();
        }
    }
}
