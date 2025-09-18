using System;
using System.Text;

namespace Btrak.Models.BoardType
{
    public class BoardTypeApiApiReturnModel
    {
        public Guid? BoardTypeApiId { get; set; }
        public string ApiName { get; set; }
        public string ApiUrl { get; set; }
        public DateTimeOffset CreatedDateTime { get; set; }
        public bool IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("BoardTypeApiId = " + BoardTypeApiId);
            stringBuilder.Append(", ApiName = " + ApiName);
            stringBuilder.Append(", ApiUrl = " + ApiUrl);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
