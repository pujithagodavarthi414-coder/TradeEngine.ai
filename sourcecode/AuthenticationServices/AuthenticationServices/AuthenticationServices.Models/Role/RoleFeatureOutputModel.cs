using System;
using System.Text;

namespace AuthenticationServices.Models.Role
{
    public class RoleFeatureOutputModel
    {
        public Guid? RoleId { get; set; }
        public Guid? FeatureId { get; set; }
        public string RoleName { get; set; }
        public string FeatureName { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", RoleId = " + RoleId);
            stringBuilder.Append(", FeatureId = " + FeatureId);
            stringBuilder.Append(", FeatureName = " + FeatureName);
            stringBuilder.Append(", RoleName = " + RoleName);
            return stringBuilder.ToString();
        }
    }
}
