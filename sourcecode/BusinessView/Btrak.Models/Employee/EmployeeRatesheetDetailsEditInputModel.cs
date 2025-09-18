using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Employee
{
    public class EmployeeRatesheetDetailsEditInputModel : InputModelBase
    {
        public EmployeeRatesheetDetailsEditInputModel() : base(InputTypeGuidConstants.EmployeeRatesheetDetailsInputCommandTypeGuid)
        {
        }

        public Guid EmployeeRateSheetId { get; set; }
        public Guid? RateSheetId { get; set; }
        public string RateSheetName { get; set; }
        public Guid? RateSheetCurrencyId { get; set; }
        public Guid? RateSheetForId { get; set; }
        public string RateSheetForName { get; set; }
        public DateTime RateSheetStartDate { get; set; }
        public DateTime RateSheetEndDate { get; set; }
        public decimal? RatePerHour { get; set; }
        public decimal? RatePerHourMon { get; set; }
        public decimal? RatePerHourTue { get; set; }
        public decimal? RatePerHourWed { get; set; }
        public decimal? RatePerHourThu { get; set; }
        public decimal? RatePerHourFri { get; set; }
        public decimal? RatePerHourSat { get; set; }
        public decimal? RatePerHourSun { get; set; }
        public Guid? RateSheetEmployeeId { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" EmployeeRateSheetId = " + EmployeeRateSheetId);
            stringBuilder.Append(" RateSheetId = " + RateSheetId);
            stringBuilder.Append(", RateSheetName = " + RateSheetName);
            stringBuilder.Append(", RateSheetCurrencyId = " + RateSheetCurrencyId);
            stringBuilder.Append(", RateSheetForId = " + RateSheetForId);
            stringBuilder.Append(", RateSheetForName = " + RateSheetForName);
            stringBuilder.Append(", RateSheetStartDate = " + RateSheetStartDate);
            stringBuilder.Append(", RateSheetEndDate = " + RateSheetEndDate);
            stringBuilder.Append(", RatePerHour = " + RatePerHour);
            stringBuilder.Append(", RatePerHourMon = " + RatePerHourMon);
            stringBuilder.Append(", RatePerHourTue = " + RatePerHourTue);
            stringBuilder.Append(", RatePerHourWed = " + RatePerHourWed);
            stringBuilder.Append(", RatePerHourThu = " + RatePerHourThu);
            stringBuilder.Append(", RatePerHourFri = " + RatePerHourFri);
            stringBuilder.Append(", RatePerHourSat = " + RatePerHourSat);
            stringBuilder.Append(", RatePerHourSun = " + RatePerHourSun);
            stringBuilder.Append(", RateSheetEmployeeId = " + RateSheetEmployeeId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
