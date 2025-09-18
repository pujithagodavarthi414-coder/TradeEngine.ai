using AuthenticationServices.Common;
using System;
using System.Collections.Generic;
using System.Text;

namespace AuthenticationServices.Models.Role
{
    public class RolesSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public RolesSearchCriteriaInputModel() : base(InputTypeGuidConstants.RoleSearchCriteriaInputCommandTypeGuid)
        {
        }

        public Guid? RoleId { get; set; }
        public string RoleName { get; set; }

        public Guid? CompanyId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", RoleId = " + RoleId);
            stringBuilder.Append(", RoleName = " + RoleName);
            return stringBuilder.ToString();
        }
    }
}
