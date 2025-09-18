using System;
using System.Text;

namespace Btrak.Models.MasterData
{
    public class NationalityApiReturnModel
    {
        public Guid? NationalityId { get; set; }
        public string NationalityName { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public string CreatedOn { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public string InActiveOn { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("NationalityId = " + NationalityId);
            stringBuilder.Append(", NationalityName = " + NationalityName);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedOn = " + CreatedOn);
            stringBuilder.Append(", InActiveDateTime = " + InActiveDateTime);
            stringBuilder.Append(", InActiveOn = " + InActiveOn);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
