using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class RateTagRoleBranchConfigurationUpsertInputModel : InputModelBase
    {
        public RateTagRoleBranchConfigurationUpsertInputModel() : base(InputTypeGuidConstants.RateTagRoleBranchConfigurationInputCommandTypeGuid)
        {
        }

        public Guid? RateTagRoleBranchConfigurationId { get; set; }
        public Guid? RoleId { get; set; }
        public Guid? BranchId { get; set; }
        public bool? IsArchived { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public int? Priority { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("RateTagRoleBranchConfigurationId = " + RateTagRoleBranchConfigurationId);
            stringBuilder.Append(",RoleId = " + RoleId);
            stringBuilder.Append(",BranchId = " + BranchId);
            stringBuilder.Append(",Priority = " + Priority);
            stringBuilder.Append(",IsArchived = " + IsArchived);
            stringBuilder.Append(",StartDate = " + StartDate);
            stringBuilder.Append(",EndDate = " + EndDate);
            return stringBuilder.ToString();
        }
    }
}
