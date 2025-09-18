using System;
using System.Text;

namespace Btrak.Models.Features
{
    public class UserPermittedFeatureApiRetrnModel
    {
        public Guid? FeatureId { get; set; }
        public string FeatureName { get; set; }
        public Guid? ParentFeatureId { get; set; }
        public string ParentFeatureName { get; set; }
        public Guid? ProjectId { get; set; }
        public string ProjectName { get; set; }
        public Guid? RoleId { get; set; }
        public string RoleName { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("FeatureId = " + FeatureId);
            stringBuilder.Append(", FeatureName = " + FeatureName);
            stringBuilder.Append(", ParentFeatureId = " + ParentFeatureId);
            stringBuilder.Append(", ParentFeatureName = " + ParentFeatureName);
            stringBuilder.Append(", ProjectId = " + ProjectId);
            stringBuilder.Append(", ProjectName = " + ProjectName);
            stringBuilder.Append(", RoleId = " + RoleId);
            stringBuilder.Append(", RoleName = " + RoleName);
            return stringBuilder.ToString();
        }
    }
}
