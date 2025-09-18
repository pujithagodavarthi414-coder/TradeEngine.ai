using BTrak.Common;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class RateTagRoleBranchConfigurationInputModel: InputModelBase
    {
        public RateTagRoleBranchConfigurationInputModel() : base(InputTypeGuidConstants.RateTagRoleBranchConfigurationsInputCommandTypeGuid)
        {
        }

        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
