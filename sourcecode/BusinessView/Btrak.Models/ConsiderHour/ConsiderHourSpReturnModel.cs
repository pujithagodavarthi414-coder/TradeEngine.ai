using System;

namespace Btrak.Models.ConsiderHour
{
    public class ConsiderHourSpReturnModel
    {
        public Guid? ConsiderHourId { get; set; }
        public string ConsiderHourName { get; set; }
        public bool IsArchived { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public string FullName { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }
    }
}
