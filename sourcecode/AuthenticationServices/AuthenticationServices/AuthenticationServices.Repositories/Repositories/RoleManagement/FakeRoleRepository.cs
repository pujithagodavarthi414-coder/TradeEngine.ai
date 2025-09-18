using AuthenticationServices.Common;
using AuthenticationServices.Models;
using AuthenticationServices.Models.Role;
using System;
using System.Collections.Generic;
using System.Text;

namespace AuthenticationServices.Repositories.Repositories.RoleManagement
{
    public class FakeRoleRepository : IRoleRepository
    {
        public Guid? UpsertRole(RolesInputModel roleModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return new Guid("93A92096-ADEA-4443-B521-BE60ED12670D");
        }
        public Guid? DeleteRole(RolesInputModel roleModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return roleModel.RoleId;
        }
        public List<RolesOutputModel> GetAllRoles(RolesSearchCriteriaInputModel roleSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            var roleList = GetRolesList();

            if (roleSearchCriteriaInputModel.RoleId != null || !string.IsNullOrEmpty(roleSearchCriteriaInputModel.RoleName) || !string.IsNullOrEmpty(roleSearchCriteriaInputModel.SearchText) || roleSearchCriteriaInputModel.IsArchived != null)
            {
                var returnRoles = new List<RolesOutputModel>();
                foreach (var role in roleList)
                {
                    //if ((roleSearchCriteriaInputModel.RoleId == null || (roleSearchCriteriaInputModel.RoleId != null && roleSearchCriteriaInputModel.RoleId == role.RoleId)) &&
                    //    (string.IsNullOrEmpty(roleSearchCriteriaInputModel.RoleName) || (!string.IsNullOrEmpty(roleSearchCriteriaInputModel.RoleName) && role.RoleName.ToLower().Contains(roleSearchCriteriaInputModel.RoleName.ToLower())))
                    //    && (string.IsNullOrEmpty(roleSearchCriteriaInputModel.SearchText) || (!string.IsNullOrEmpty(roleSearchCriteriaInputModel.SearchText) && role.RoleName.ToLower().Contains(roleSearchCriteriaInputModel.SearchText.ToLower())))
                    //    && (roleSearchCriteriaInputModel.IsArchived == null || ((roleSearchCriteriaInputModel.IsArchived == null || roleSearchCriteriaInputModel.IsArchived == false) && (role.IsArchived == null || role.IsArchived == false)))
                    //    && (roleSearchCriteriaInputModel.IsArchived == null || (roleSearchCriteriaInputModel.IsArchived == true && role.IsArchived == true)))
                    //{
                    //    returnRoles.Add(role);
                    //}

                    if ((roleSearchCriteriaInputModel.RoleId != null && roleSearchCriteriaInputModel.RoleId == role.RoleId) ||
                        (!string.IsNullOrEmpty(roleSearchCriteriaInputModel.RoleName) && role.RoleName.ToLower().Contains(roleSearchCriteriaInputModel.RoleName.ToLower())) ||
                        (!string.IsNullOrEmpty(roleSearchCriteriaInputModel.SearchText) && role.RoleName.ToLower().Contains(roleSearchCriteriaInputModel.SearchText.ToLower()))
                        || ((roleSearchCriteriaInputModel.IsArchived == null || roleSearchCriteriaInputModel.IsArchived == false) && (role.IsArchived == null || role.IsArchived == false))
                        || (roleSearchCriteriaInputModel.IsArchived == true && role.IsArchived == true))
                    {
                        returnRoles.Add(role);
                    }
                }
                return returnRoles;
            }

            return roleList;
        }
        public List<RoleFeatureOutputModel> GetRolesByFeatureId(Guid? roleId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            List<RoleFeatureOutputModel> roleFeatureOutputs = new List<RoleFeatureOutputModel>();

            var role = new RoleFeatureOutputModel()
            {
                RoleId = new Guid("EA4F9C44-AEEA-47C9-9976-475CF4065738"),
                RoleName = "R1",
                FeatureName = "Add",
                FeatureId = new Guid("27CF289D-49E0-4C4F-9F77-F079570FDD3F")
            };
            roleFeatureOutputs.Add(role);

            role = new RoleFeatureOutputModel()
            {
                RoleId = new Guid("BD28040B-A463-42BC-8967-C3DB9E0DB6BD"),
                RoleName = "R2",
                FeatureName = "Update",
                FeatureId = new Guid("53C15DE3-D8E1-4D3F-BE50-2A069A849F84")
            };
            roleFeatureOutputs.Add(role);

            role = new RoleFeatureOutputModel()
            {
                RoleId = new Guid("6749F864-E274-40D4-B6C4-14FB7C94AC64"),
                RoleName = "R3",
                FeatureName = "Delete",
                FeatureId = new Guid("F7560B48-A220-400D-8149-42CEF300007A")
            };
            roleFeatureOutputs.Add(role);

            if (roleId != null)
            {
                List<RoleFeatureOutputModel> returnRoleList = new List<RoleFeatureOutputModel>();

                foreach (var r in roleFeatureOutputs)
                {
                    if (r.FeatureId.ToString().ToLower() == roleId.ToString().ToLower())
                    {
                        returnRoleList.Add(r);
                    }
                }

                return returnRoleList;
            }

            return roleFeatureOutputs;
        }
        public List<RoleDropDownOutputModel> GetAllRolesDropDown(string searchText, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            List<RoleDropDownOutputModel> roleDropDownOutputs = new List<RoleDropDownOutputModel>();

            var role = new RoleDropDownOutputModel()
            {
                RoleId = new Guid("EA4F9C44-AEEA-47C9-9976-475CF4065738"),
                RoleName = "R1"
            };
            roleDropDownOutputs.Add(role);

            role = new RoleDropDownOutputModel()
            {
                RoleId = new Guid("BD28040B-A463-42BC-8967-C3DB9E0DB6BD"),
                RoleName = "R2"
            };
            roleDropDownOutputs.Add(role);

            role = new RoleDropDownOutputModel()
            {
                RoleId = new Guid("6749F864-E274-40D4-B6C4-14FB7C94AC64"),
                RoleName = "R3"
            };
            roleDropDownOutputs.Add(role);

            if (!string.IsNullOrEmpty(searchText))
            {
                List<RoleDropDownOutputModel> returnRoleDropDownOutputs = new List<RoleDropDownOutputModel>();
                
                foreach (var r in roleDropDownOutputs)
                {
                    if (r.RoleName.Contains(searchText))
                    {
                        returnRoleDropDownOutputs.Add(r);
                    }
                }

                return returnRoleDropDownOutputs;
            }

            return roleDropDownOutputs;
        }
        public Guid? updateFeatureInputModel(UpdateFeatureInputModel updateFeatureInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return new Guid("EA4F9C44-AEEA-47C9-9976-475CF4065738");
        }

        private List<RolesOutputModel> GetRolesList()
        {
            List<RolesOutputModel> roleList = new List<RolesOutputModel>();
            var role = new RolesOutputModel()
            {
                RoleId = new Guid("EA4F9C44-AEEA-47C9-9976-475CF4065738"),
                RoleName = "R1",
                Features = "<Features />",
                IsArchived = null
            };
            roleList.Add(role);

            role = new RolesOutputModel()
            {
                RoleId = new Guid("30C0DC15-EC04-4C10-8F03-5F6EC46B5A82"),
                RoleName = "R2",
                Features = "<Features />",
                IsArchived = true
            };
            roleList.Add(role);

            role = new RolesOutputModel()
            {
                RoleId = new Guid("12A9B6EC-F1B6-4695-9FFF-4B55789DEDF6"),
                RoleName = "R3",
                Features = "<Features />",
                IsArchived = false
            };
            roleList.Add(role);

            return roleList;
        }
    }
}
