using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.EntityType
{
    public class EntityFeatureSearchInputModel : InputModelBase
    {
        public EntityFeatureSearchInputModel() : base(InputTypeGuidConstants.EntityFeatureSearchInputCommandTypeGuid)
        {
        }

        public Guid? EntityFeatureId { get; set; }

        public Guid? EntityTypeId { get; set; }

        public string EntityFeatureName { get; set; }
        public string SearchText { get; set; }
        public string IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EntityFeatureId = " + EntityFeatureId);
            stringBuilder.Append(", EntityTypeId = " + EntityTypeId);
            stringBuilder.Append(", EntityFeatureName = " + EntityFeatureName);
            stringBuilder.Append(", SearchText = " + SearchText);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}