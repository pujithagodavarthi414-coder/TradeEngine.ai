using BTrak.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class RateTagInputModel : InputModelBase
    {

        public RateTagInputModel() : base(InputTypeGuidConstants.GetRateTag)
        {
        }

        public Guid? RateTagId { get; set; }
        [StringLength(50)]
        public string RateTagName { get; set; }
        public Guid RateTagForId { get; set; }
        public decimal? RatePerHour { get; set; }
        public decimal? RatePerHourMon { get; set; }
        public decimal? RatePerHourTue { get; set; }
        public decimal? RatePerHourWed { get; set; }
        public decimal? RatePerHourThu { get; set; }
        public decimal? RatePerHourFri { get; set; }
        public decimal? RatePerHourSat { get; set; }
        public decimal? RatePerHourSun { get; set; }
        public int? Priority { get; set; }
        public bool? IsArchived { get; set; }
        public List<RateTagForTypeModel> RateTagForIds { get; set; }
        public string RateTagForIdsXml { get; set; }
        public int? MinTime { get; set; }
        public int? MaxTime { get; set; }
        public Guid? EmployeeId { get; set; }
        public Guid? RoleId { get; set; }
        public Guid? BranchId { get; set; }
        


        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" RateTagId = " + RateTagId);
            stringBuilder.Append(", RateTagName = " + RateTagName);
            stringBuilder.Append(", RateTagForId = " + RateTagForId);
            stringBuilder.Append(", RatePerHour = " + RatePerHour);
            stringBuilder.Append(", RatePerHourMon = " + RatePerHourMon);
            stringBuilder.Append(", RatePerHourTue = " + RatePerHourTue);
            stringBuilder.Append(", RatePerHourWed = " + RatePerHourWed);
            stringBuilder.Append(", RatePerHourThu = " + RatePerHourThu);
            stringBuilder.Append(", RatePerHourFri = " + RatePerHourFri);
            stringBuilder.Append(", RatePerHourSat = " + RatePerHourSat);
            stringBuilder.Append(", RatePerHourSun = " + RatePerHourSun);
            stringBuilder.Append(", Priority = " + Priority);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", MinTime = " + MinTime);
            stringBuilder.Append(", MaxTime = " + MaxTime);
            stringBuilder.Append(" EmployeeId = " + EmployeeId);
            stringBuilder.Append(" RoleId = " + RoleId);
            stringBuilder.Append(" BranchId = " + BranchId);
            return stringBuilder.ToString();
        }
    }
}
