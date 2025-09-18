using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.MasterData
{
    public class LeaveFrequencyUpsertInputModel : InputModelBase
    {
        public LeaveFrequencyUpsertInputModel() : base(InputTypeGuidConstants.LeaveFrequencyUpsertInputModel)
        {
        }
        public Guid? LeaveFrequencyId { get; set; }
        public float? NoOfLeaves { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public bool? IsArchived { get; set; }
        public Guid? LeaveTypeId { get; set; }
        public Guid? EncashmentTypeId { get; set; }
        public Guid? LeaveFormulaId { get; set; }
        public float NoOfDaysToBeIntimated { get; set; }
        public bool? IsToCarryForward { get; set; }
        public Guid? RestrictionTypeId { get; set; }
        public float? CarryForwardLeavesCount { get; set; }
        public float? PayableLeavesCount { get; set; }
        public bool? IsToIncludeHolidays { get; set; }
        public bool? IsToRepeatInterval { get; set; }
        public Guid? PaymentTypeId { get; set; }
        public Guid? EmploymentStatusId { get; set; }
        public bool? IsAutoApproval { get; set; }
        public bool? IsEncashable { get; set; }
        public bool? IsPaid { get; set; }
        public byte[] LeaveFrequencyTimeStamp { get; set; }
        public float? EncashedLeavesCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" LeaveFrequencyId" + LeaveFrequencyId);
            stringBuilder.Append(", DateFrom" + DateFrom);
            stringBuilder.Append(", DateTo" + DateTo);
            stringBuilder.Append(", NoOfLeaves" + NoOfLeaves);
            stringBuilder.Append(", IsArchived" + IsArchived);
            stringBuilder.Append(", LeaveTypeId" + LeaveTypeId);
            stringBuilder.Append(", EncashMentTypeId" + EncashmentTypeId);
            stringBuilder.Append(", LeaveFormulaId" + LeaveFormulaId);
            stringBuilder.Append(", NoOfDaysToBeIntimated" + NoOfDaysToBeIntimated);
            stringBuilder.Append(", IsToCarryForward" + IsToCarryForward);
            stringBuilder.Append(", RestrictionTypeId" + RestrictionTypeId);
            stringBuilder.Append(", CarryForwardLeavesCount" + CarryForwardLeavesCount);
            stringBuilder.Append(", PayableLeavesCount" + PayableLeavesCount);
            stringBuilder.Append(", IsToIncludeHolidays" + IsToIncludeHolidays);
            stringBuilder.Append(", IsToRepeatTheInterval" + IsToRepeatInterval);
            stringBuilder.Append(", PaymentTypeId" + PaymentTypeId);
            stringBuilder.Append(", IsPaid" + IsPaid);
            stringBuilder.Append(", IsAutoApproval" + IsAutoApproval);
            stringBuilder.Append(", IsEncashable" + IsEncashable);
            stringBuilder.Append(", EncashedLeavesCount" + EncashedLeavesCount);
            return stringBuilder.ToString();
        }
    }
}
