using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class UpsertDaysOfWeekConfigurationInputModel : InputModelBase
    {
        public UpsertDaysOfWeekConfigurationInputModel() : base(InputTypeGuidConstants.UpsertDaysOfWeekConfigurationInputCommandTypeGuid)
        {
        }
        public Guid? Id { get; set; }
        public Guid BranchId { get; set; }
        public Guid DayOfWeekId { get; set; }
        public Guid PartsOfDayId { get; set; }
        public bool IsWeekend { get; set; }
        public TimeSpan FromTime { get; set; }
        public TimeSpan ToTime { get; set; }
        public DateTime ActiveFrom { get; set; }
        public DateTime? ActiveTo { get; set; }
        public bool? IsArchived { get; set; }
        public bool? IsBankHoliday { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("Id = " + Id);
            stringBuilder.Append(",BranchId = " + BranchId);
            stringBuilder.Append(",DayOfWeekId = " + DayOfWeekId);
            stringBuilder.Append(",PartsOfDayId = " + PartsOfDayId);
            stringBuilder.Append(",IsWeekend = " + IsWeekend);
            stringBuilder.Append(",FromTime = " + FromTime);
            stringBuilder.Append(",ToTime = " + ToTime);
            stringBuilder.Append(",ActiveFrom = " + ActiveFrom);
            stringBuilder.Append(",ActiveTo = " + ActiveTo);
            stringBuilder.Append(",IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
