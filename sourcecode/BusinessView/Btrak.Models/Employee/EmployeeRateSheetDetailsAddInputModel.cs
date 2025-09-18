using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Text;
using Newtonsoft.Json;

namespace Btrak.Models.Employee
{
    public class EmployeeRateSheetDetailsAddInputModel: InputModelBase
    {
        public EmployeeRateSheetDetailsAddInputModel() : base(InputTypeGuidConstants.EmployeeRatesheetDetailsInputCommandTypeGuid)
        {
        }

        public DateTime RateSheetStartDate { get; set; }
        public DateTime RateSheetEndDate { get; set; }
        public Guid? RateSheetEmployeeId { get; set; }
        public Guid? RateSheetCurrencyId { get; set; }
        public bool? IsArchived { get; set; }
        public List<EmployeeRatesheetDetailsEditInputModel> RateSheetDetails { get; set; }
        public string EmployeeRatesheetDetailsString { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", RateSheetStartDate = " + RateSheetStartDate);
            stringBuilder.Append(", RateSheetEndDate = " + RateSheetEndDate);
            stringBuilder.Append(", RateSheetEmployeeId = " + RateSheetEmployeeId);
            stringBuilder.Append(", RateSheetCurrencyId = " + RateSheetCurrencyId);
            stringBuilder.Append(", RateSheetDetails = " + JsonConvert.SerializeObject(RateSheetDetails));
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
