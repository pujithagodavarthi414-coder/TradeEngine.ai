using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.Role
{
    public class UpdateEntityFeature
    {
        public Guid? EntityRoleId { get; set; }
        public Guid? EntityFeatureId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", EntityRoleId = " + EntityRoleId);
            stringBuilder.Append(", EntityFeatureId = " + EntityFeatureId);
            return stringBuilder.ToString();
        }
    }
}