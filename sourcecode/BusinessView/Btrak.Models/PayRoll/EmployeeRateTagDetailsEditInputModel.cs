using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class EmployeeRateTagDetailsEditInputModel : InputModelBase
    {
        public EmployeeRateTagDetailsEditInputModel() : base(InputTypeGuidConstants.EmployeeRateTagDetailsInputCommandTypeGuid)
        {
        }

        public Guid? EmployeeRateTagId { get; set; }
        public Guid? RateTagId { get; set; }
        public string RateTagName { get; set; }
        public Guid? RateTagCurrencyId { get; set; }
        public Guid? RateTagForId { get; set; }
        public string RateTagForName { get; set; }
        public DateTime? RateTagStartDate { get; set; }
        public DateTime? RateTagEndDate { get; set; }
        public decimal? RatePerHour { get; set; }
        public decimal? RatePerHourMon { get; set; }
        public decimal? RatePerHourTue { get; set; }
        public decimal? RatePerHourWed { get; set; }
        public decimal? RatePerHourThu { get; set; }
        public decimal? RatePerHourFri { get; set; }
        public decimal? RatePerHourSat { get; set; }
        public decimal? RatePerHourSun { get; set; }
        public Guid? RateTagEmployeeId { get; set; }
        public bool? IsArchived { get; set; }
        public bool? IsOverRided { get; set; }
        public int? Priority { get; set; }
        public int? GroupPriority { get; set; }
        public Guid? RoleId { get; set; }
        public Guid? BranchId { get; set; }


        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" EmployeeRateTagId = " + EmployeeRateTagId);
            stringBuilder.Append(" RateTagId = " + RateTagId);
            stringBuilder.Append(", RateTagName = " + RateTagName);
            stringBuilder.Append(", RateTagCurrencyId = " + RateTagCurrencyId);
            stringBuilder.Append(", RateTagForId = " + RateTagForId);
            stringBuilder.Append(", RateTagForName = " + RateTagForName);
            stringBuilder.Append(", RateTagStartDate = " + RateTagStartDate);
            stringBuilder.Append(", RateTagEndDate = " + RateTagEndDate);
            stringBuilder.Append(", RatePerHour = " + RatePerHour);
            stringBuilder.Append(", RatePerHourMon = " + RatePerHourMon);
            stringBuilder.Append(", RatePerHourTue = " + RatePerHourTue);
            stringBuilder.Append(", RatePerHourWed = " + RatePerHourWed);
            stringBuilder.Append(", RatePerHourThu = " + RatePerHourThu);
            stringBuilder.Append(", RatePerHourFri = " + RatePerHourFri);
            stringBuilder.Append(", RatePerHourSat = " + RatePerHourSat);
            stringBuilder.Append(", RatePerHourSun = " + RatePerHourSun);
            stringBuilder.Append(", RateTagEmployeeId = " + RateTagEmployeeId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", IsOverRided = " + IsOverRided);
            stringBuilder.Append(", Priority = " + Priority);
            stringBuilder.Append(", GroupPriority = " + GroupPriority);
            stringBuilder.Append(", RoleId = " + RoleId);
            stringBuilder.Append(", RoleId = " + BranchId);
            return stringBuilder.ToString();
        }
    }
}
