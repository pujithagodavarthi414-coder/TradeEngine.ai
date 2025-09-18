using System;
using System.Collections.Generic;
using System.Text;

namespace AuthenticationServices.Models.Role
{
    public class UpdateFeatureInputModel
    {
        public Guid? RoleId { get; set; }
        public Guid? FeatureId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", RoleId = " + RoleId);
            stringBuilder.Append(", FeatureId = " + FeatureId);
            return stringBuilder.ToString();
        }
    }
}
