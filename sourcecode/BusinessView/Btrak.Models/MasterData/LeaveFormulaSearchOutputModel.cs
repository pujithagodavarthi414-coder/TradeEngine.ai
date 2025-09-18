using System;

namespace Btrak.Models.MasterData
{
    public class LeaveFormulSearchOutputModel
    {
        public Guid? LeaveFormulaId { get; set; }
        public string Formula { get; set; }
        public Guid? CompanyId { get; set; }
        public decimal NoOfLeaves { get; set; }
        public decimal NoOfDays { get; set; }
        public bool? IsArchived { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? TotalCount { get; set; }
    }
}
