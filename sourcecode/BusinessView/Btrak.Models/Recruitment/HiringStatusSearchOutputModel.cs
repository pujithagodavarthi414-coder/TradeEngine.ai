using System;

namespace Btrak.Models.Recruitment
{
    public class HiringStatusSearchOutputModel
    {
       
        public Guid? HiringStatusId { get; set; }
        public int Order { get; set; }
        public string Status { get; set; }
        public string Color { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }

    }
}
