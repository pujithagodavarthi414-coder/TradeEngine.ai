using System;

namespace Btrak.Models.PayRoll
{
    public class BankModel
    {
        public Guid? BankId { get; set; }
        public string BankName { get; set; }
        public Guid? CountryId { get; set; }
        public string CountryName { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? TotalCount { get; set; }
    }
}
