using System;
using System.Text;

namespace Btrak.Models.BoardType
{
    public class BoardTypeUiApiReturnModel
    {
        public Guid? BoardTypeUiId { get; set; }
        public string BoardTypeUiName { get; set; }
        public string BoardTypeUiView { get; set; }
        public bool IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }
        public DateTimeOffset CreatedDateTime { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("BoardTypeUiId = " + BoardTypeUiId);
            stringBuilder.Append(", BoardTypeUiName = " + BoardTypeUiName);
            stringBuilder.Append(", BoardTypeUiView = " + BoardTypeUiView);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            return stringBuilder.ToString();
        }
    }
}
