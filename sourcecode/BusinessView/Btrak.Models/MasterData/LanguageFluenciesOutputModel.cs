using System;
using System.Text;

namespace Btrak.Models.MasterData
{
    public class LanguageFluenciesOutputModel
    {
        public Guid? LanguageFluencyId { get; set; }
        public string LanguageFluencyName { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" LanguageFluencyId = " + LanguageFluencyId);
            stringBuilder.Append(", LanguageFluencyName = " + LanguageFluencyName);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
