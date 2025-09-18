using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class RateTagConfigurationEditInputModel : InputModelBase
    {
        public RateTagConfigurationEditInputModel() : base(InputTypeGuidConstants.RateTagConfigurationInputCommandTypeGuid)
        {
        }

        public Guid? RateTagConfigurationId { get; set; }
        public Guid? RateTagRoleBranchConfigurationId { get; set; }
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
        public Guid? RateTagBranchId { get; set; }
        public Guid? RateTagRoleId { get; set; }
        public bool? IsArchived { get; set; }
        public int? Priority { get; set; }
        
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" RateTagConfigurationId = " + RateTagConfigurationId);
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
            stringBuilder.Append(", RateTagRoleId = " + RateTagRoleId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", Priority = " + Priority);
            return stringBuilder.ToString();
        }
    }
}
