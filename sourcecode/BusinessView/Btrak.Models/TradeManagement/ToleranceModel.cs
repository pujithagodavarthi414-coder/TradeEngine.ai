using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.TradeManagement
{
    public class ToleranceModel
    {
        public Guid? ToleranceId { get; set; }
        public string ToleranceName { get; set; }
        public DateTime InActiveDateTime { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public Guid CreatedByUserId { get; set; }
        public bool IsArchived { get; set; }
        public int TotalCount { get; set; }
        public byte[] TimeStamp { get; set; }
    }
}
