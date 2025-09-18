using System;

namespace Btrak.Models.TradeManagement
{
    public class RFQReferenceOutputModel
    {
        public Guid? Id { get; set; }
        public Guid? ReferenceId { get; set; }
        public bool? IsBroker { get; set; }
        public int? RFQId { get; set; }
        public string RFQUniqueId { get; set; }
    }
}
