using System;
using System.Text;

namespace Btrak.Models.ConsiderHour
{
    public class ConsiderHourApiReturnModel
    {
        public Guid? ConsiderHourId { get; set; }
        public string ConsiderHourName { get; set; }
        public bool IsArchived { get; set; }
        public DateTimeOffset CreatedDateTime { get; set; }
        public string FullName { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }


        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ConsiderHourId = " + ConsiderHourId);
            stringBuilder.Append(", ConsiderHourName = " + ConsiderHourName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", FullName = " + FullName);
            return stringBuilder.ToString();
        }
    }
}
