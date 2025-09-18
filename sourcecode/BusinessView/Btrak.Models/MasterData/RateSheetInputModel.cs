using BTrak.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.MasterData
{
    public class RateSheetInputModel : InputModelBase
    {

        public RateSheetInputModel() : base(InputTypeGuidConstants.GetRateSheet)
        {
        }

        public Guid? RateSheetId { get; set; }
        [StringLength(50)]
        public string RateSheetName { get; set; }
        public Guid RateSheetForId { get; set; }
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
        

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" RateSheetId = " + RateSheetId);
            stringBuilder.Append(", RateSheetName = " + RateSheetName);
            stringBuilder.Append(", RateSheetForId = " + RateSheetForId);
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
            return stringBuilder.ToString();
        }
    }
}
