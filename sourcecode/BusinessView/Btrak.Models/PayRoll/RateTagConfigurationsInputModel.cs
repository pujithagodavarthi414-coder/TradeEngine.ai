using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class RateTagConfigurationsInputModel : InputModelBase
    {
        public RateTagConfigurationsInputModel() : base(InputTypeGuidConstants.RateTagConfigurationsInputCommandTypeGuid)
        {
        }

        public Guid? RateTagConfigurationId { get; set; }
        public string SearchText { get; set; }
        public Guid? BranchId { get; set; }
        public bool IsArchived { get; set; }
        public Guid? RateTagRoleBranchConfigurationId { get; set; }
        public Guid? RateTagRoleId { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("BranchId = " + BranchId);
            stringBuilder.Append(", SearchText = " + SearchText);
            stringBuilder.Append(", RateTagConfigurationId = " + RateTagConfigurationId);
            stringBuilder.Append(", RateTagRoleBranchConfigurationId = " + RateTagRoleBranchConfigurationId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
