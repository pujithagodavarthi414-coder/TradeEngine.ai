using BTrak.Common;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class RateTagConfigurationAddInputModel : InputModelBase
    {
        public RateTagConfigurationAddInputModel() : base(InputTypeGuidConstants.RateTagConfigurationInputCommandTypeGuid)
        {
        }

        public DateTime RateTagStartDate { get; set; }
        public DateTime RateTagEndDate { get; set; }
        public Guid? RateTagRoleBranchConfigurationId { get; set; }
        public Guid? RateTagCurrencyId { get; set; }
        public bool? IsArchived { get; set; }
        public List<RateTagConfigurationEditInputModel> RateTagDetails { get; set; }
        public string RateTagConfigurationString { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", RateTagStartDate = " + RateTagStartDate);
            stringBuilder.Append(", RateTagEndDate = " + RateTagEndDate);
            stringBuilder.Append(", RateTagRoleBranchConfigurationId = " + RateTagRoleBranchConfigurationId);
            stringBuilder.Append(", RateTagCurrencyId = " + RateTagCurrencyId);
            stringBuilder.Append(", RateTagDetails = " + JsonConvert.SerializeObject(RateTagDetails));
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
