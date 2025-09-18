using System;

namespace Btrak.Models.HrManagement
{
    public class ContractTypeSpReturnModel
    {
        public Guid? ContractTypeId { get; set; }
        public string ContractTypeName { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }
        public bool IsArchived { get; set; }
    }
}
