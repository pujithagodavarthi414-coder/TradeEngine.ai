using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.EntityType
{
    public class EntityRoleFeatureSearchInputModel : InputModelBase
    {
        public EntityRoleFeatureSearchInputModel() : base(InputTypeGuidConstants.EntityRoleFeatureSearchInputCommandTypeGuid)
        {
        }

        public Guid? EntityRoleFeatureId { get; set; }

        public Guid? EntityFeatureId { get; set; }
        public string EntityFeatureName { get; set; }

        public Guid? EntityRoleId { get; set; }
        public string EntityRoleName { get; set; }
        public string SearchText { get; set; }

        public Guid? ProjectId { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EntityRoleFeatureId = " + EntityRoleFeatureId);
            stringBuilder.Append(", EntityFeatureId = " + EntityFeatureId);
            stringBuilder.Append(", EntityFeatureName = " + EntityFeatureName);
            stringBuilder.Append(", EntityRoleId = " + EntityRoleId);
            stringBuilder.Append(", EntityRoleName = " + EntityRoleName);
            stringBuilder.Append(", SearchText = " + SearchText);
            stringBuilder.Append(", ProjectId = " + ProjectId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
