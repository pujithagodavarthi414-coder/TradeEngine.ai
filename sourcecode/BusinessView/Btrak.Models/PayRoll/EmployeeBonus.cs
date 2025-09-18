using System;
using System.Collections.Generic;

namespace Btrak.Models.PayRoll
{
   public class EmployeeBonus 
    {
        public EmployeeBonus()
        {
            EmployeeIds = new List<Guid>();
        }
        public Guid? Id { get; set; }
        public List<Guid> EmployeeIds { get; set; }
        public Guid EmployeeId { get; set; }
        public decimal? Bonus { get; set; }
        public DateTime? GeneratedDate { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid CreatedByUserId { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public Guid UpdatedByUserId { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public DateTime? TimeStamp { get; set; }
        public bool IsArchived { get; set; }
        public bool IsApproved { get; set; }
        public string EmployeeName { get; set; }
        public string EmployeeNumber { get; set; }
        public Guid? PayRollComponentId { get; set; }
        public bool? IsCtcType { get; set; }
        public decimal? Percentage { get; set; }
        public string PayRollComponentName { get; set; }
        public int? Type { get; set; }
        public int? AmountType { get; set; }
        public decimal? Value { get; set; }
        public string ModifiedBonus { get; set; }
        public string ProfileImage { get; set; }
        public Guid? UserId { get; set; }
        public bool? IsPaid { get; set; }
    }
}
