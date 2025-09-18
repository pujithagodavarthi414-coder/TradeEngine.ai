using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.Role
{
    public class RolesInputModel : InputModelBase
    {
        public RolesInputModel() : base(InputTypeGuidConstants.RolesInputCommandTypeGuid)
        {
        }

        public Guid? RoleId { get; set; }
        public string RoleName { get; set; }
        public string Data { get; set; }
        public List<Guid> FeatureIds { get; set; }
        public string FeatureIdXml { get; set; }
        public string Features { get; set; }
        public bool? IsArchived { get; set; }
        public bool? IsDeveloper { get; set; }
        public bool? IsNewRole { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", RoleId = " + RoleId);
            stringBuilder.Append(", RoleName = " + RoleName);
            stringBuilder.Append(", Data = " + Data);
            stringBuilder.Append(", FeatureIds = " + FeatureIds);
            stringBuilder.Append(", FeatureIdXml = " + FeatureIdXml);
            stringBuilder.Append(", Features = " + Features);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", IsDeveloper = " + IsDeveloper);
            return stringBuilder.ToString();
        }
    }
}
