using System;

namespace Btrak.Models.PayRoll
{
    public class PayRollRunEmployeeComponentYTDModel
    {
        public Guid? PayRollRunEmployeeComponentId { get; set; }
        public Guid? PayRollRunId { get; set; }
        public Guid? EmployeeId { get; set; }
        public Guid? ComponentId { get; set; }
        public decimal ActualComponentAmount { get; set; }
        public string Comments { get; set; }
        public byte[] TimeStamp { get; set; }
    }
}
