using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Text;
using Newtonsoft.Json;

namespace Btrak.Models.PayRoll
{
    public class EmployeeRateTagDetailsAddInputModel: InputModelBase
    {
        public EmployeeRateTagDetailsAddInputModel() : base(InputTypeGuidConstants.EmployeeRateTagDetailsInputCommandTypeGuid)
        {
        }

        public DateTime RateTagStartDate { get; set; }
        public DateTime RateTagEndDate { get; set; }
        public Guid? RateTagEmployeeId { get; set; }
        public Guid? RateTagCurrencyId { get; set; }
        public bool? IsArchived { get; set; }
        public List<EmployeeRateTagDetailsEditInputModel> RateTagDetails { get; set; }
        public string EmployeeRateTagDetailsString { get; set; }
        public bool? IsClearCustomize { get; set; }
        public int? GroupPriority { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", RateTagStartDate = " + RateTagStartDate);
            stringBuilder.Append(", RateTagEndDate = " + RateTagEndDate);
            stringBuilder.Append(", RateTagEmployeeId = " + RateTagEmployeeId);
            stringBuilder.Append(", RateTagCurrencyId = " + RateTagCurrencyId);
            stringBuilder.Append(", RateTagDetails = " + JsonConvert.SerializeObject(RateTagDetails));
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", IsClearCustomize = " + IsClearCustomize);
            return stringBuilder.ToString();
        }
    }
}
