using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.Role
{
    public class EntityRoleFeatureOutputModel
    {
        public Guid? EntityRoleId { get; set; }
        public Guid? EntityFeatureId { get; set; }
        public string EntityRoleName { get; set; }
        public string EntityFeatureName { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", EntityRoleId = " + EntityRoleId);
            stringBuilder.Append(", EntityFeatureId = " + EntityFeatureId);
            stringBuilder.Append(", EntityRoleName = " + EntityRoleName);
            stringBuilder.Append(", EntityFeatureName = " + EntityFeatureName);
            return stringBuilder.ToString();
        }
    }
}
