using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Features
{
    public class FeatureInputModel : InputModelBase
    {
        public FeatureInputModel() : base(InputTypeGuidConstants.FeatureInputCommandTypeGuid)
        {
        }

        public Guid? FeatureId { get; set; }
        public string FeatureName { get; set; }
        public Guid? ParentFeatureId { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("FeatureId = " + FeatureId);
            stringBuilder.Append(", FeatureName = " + FeatureName);
            stringBuilder.Append(", ParentFeatureId = " + ParentFeatureId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
