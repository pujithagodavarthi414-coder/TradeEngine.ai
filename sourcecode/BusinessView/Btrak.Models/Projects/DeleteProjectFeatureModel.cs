using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Projects
{
    public class DeleteProjectFeatureModel : InputModelBase
    {
        public DeleteProjectFeatureModel() : base(InputTypeGuidConstants.DeleteProjectFeature)
        {
        }

        public Guid? ProjectFeatureId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" ProjectFeatureId = " + ProjectFeatureId);
            return stringBuilder.ToString();
        }
    }
}
