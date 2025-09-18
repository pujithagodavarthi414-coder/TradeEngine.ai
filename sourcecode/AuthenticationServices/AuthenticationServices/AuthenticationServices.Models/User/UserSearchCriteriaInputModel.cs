using AuthenticationServices.Common;
using System;
using System.Collections.Generic;
using System.Text;

namespace AuthenticationServices.Models.User
{
    public class UserSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public UserSearchCriteriaInputModel() : base(InputTypeGuidConstants.UserSearchCriteriaInputCommandTypeGuid)
        {
        }
        public Guid? UserId { get; set; }
        public string UserName { get; set; }
        public Guid? RoleId { get; set; }
        public string RoleIds { get; set; }
        public bool? IsUsersPage { get; set; }
        public Guid? EntityId { get; set; }
        public Guid? BranchId { get; set; }
        public bool? IsActive { get; set; }
        public bool? IsExternal { get; set; }
        public string EmployeeNameText { get; set; }
        public bool? IsEmployeeOverviewDetails { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", UserId = " + UserId);
            stringBuilder.Append(", UserName = " + UserName);
            stringBuilder.Append(", RoleId = " + RoleId);
            stringBuilder.Append(", BranchId = " + BranchId);
            stringBuilder.Append(", EmployeeNameText = " + EmployeeNameText);
            stringBuilder.Append(", IsEmployeeOverviewDetails = " + IsEmployeeOverviewDetails);
            return stringBuilder.ToString();
        }
    }
}
