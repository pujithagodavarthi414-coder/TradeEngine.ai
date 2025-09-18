using System;

namespace Btrak.Models.MasterData
{
    public class LeaveFrequencySearchOutputModel
    {
        public Guid? LeaveFrequencyId { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public Guid? CompanyId { get; set; }
        public Guid? LeaveTypeId { get; set; }
        public string LeaveTypeShortName { get; set; }
        public string LeaveTypeName { get; set; }
        public string MasterLeaveTypeName { get; set; }
        public Guid? MasterLeaveTypeId { get; set; }
        public decimal NoOfLeaves { get; set; }
        public decimal LeaveFrequencyCount { get; set; }
        public bool? IsArchived { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? OriginalCreatedByUserId { get; set; }
        public DateTime? OriginalCreatedDateTime { get; set; }
        public byte[] LeaveFrequencyTimeStamp { get; set; }
        public byte[] LeaveTypeTimeStamp { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? TotalCount { get; set; }
        public string Formula { get; set; }
        public Guid? EncashmentTypeId{ get; set; }
        public string Encashmenttype{ get; set; }
        public Guid? RestrictionTypeId{ get; set; }
        public string Restriction{ get; set; }
        public bool? IsPaid{ get; set; }
        public bool? IsEncashable{ get; set; }
        public bool? IsToCarryForward{ get; set; }
        public bool? IsToIncludeHolidays { get; set; }
        public bool? IsToRepeatInterval{ get; set; }
        public float? NoOfDaysToBeIntimated { get; set; }
        public float? CarryForwardLeavesCount { get; set; }
        public float? PayableLeavesCount { get; set; }
        public Guid? LeaveFormulaId { get; set; }
        public string EmploymentStatusName { get; set; }
        public Guid? EmploymentStatusId { get; set; }
        public string LeaveTypeColor { get; set; }
        public float? EncashedLeavesCount { get; set; }
    }
}
