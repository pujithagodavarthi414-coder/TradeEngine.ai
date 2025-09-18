using System;
using System.Text;

namespace Btrak.Models.Chat
{
    public class UpsertMessageOutputModel
    {
        public Guid? OriginalId { get; set; }
        public byte[] TimeStamp { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("OriginalId = " + OriginalId);
            stringBuilder.Append("TimeStamp = " + TimeStamp);
            return stringBuilder.ToString();
        }

    }
}
