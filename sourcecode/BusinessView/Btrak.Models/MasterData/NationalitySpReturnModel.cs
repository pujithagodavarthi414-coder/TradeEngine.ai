using System;

namespace Btrak.Models.MasterData
{
    public class NationalitySpReturnModel
    {
        public Guid? NationalityId { get; set; }
        public string NationalityName { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }
    }
}
