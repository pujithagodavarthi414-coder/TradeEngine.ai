using System;
using System.Collections.Generic;
using System.Text;

namespace AuthenticationServices.Common
{
    public class RouteConstants
    {
        public const string UpsertUser = "UserManagement/UserManagementApi/UpsertUser";
        public const string GetAllUsers = "UserManagement/UserManagementApi/GetAllUsers";
        public const string GetUserById = "UserManagement/UserManagementApi/GetUserById";
        public const string UpsertUserProfileDetails = "UserManagement/UserManagementApi/UpsertUserProfileDetails";
        public const string ChangePassword = "UserManagement/UserManagementApi/ChangePassword";
        public const string UploadProfileImage = "UserManagement/UserManagementApi/UploadProfileImage";

        public const string Authorize = "api/LoginApi/Authorise";
        public const string AuthorizeNewUser = "api/LoginApi/AuthorizeNewUser";
        public const string CompanyLogin = "api/LoginApi/CompanyLogin";
        public const string ForgotPassword = "api/LoginApi/ForgotPassword";
        public const string ResetPassword = "api/LoginApi/ResetPassword";
        public const string UpdatePassword = "api/LoginApi/UpdatePassword";
        public const string GetLoggedInUser = "api/LoginApi/GetLoggedInUser";
        public const string RefreshAccessToken = "api/LoginApi/RefreshAccessToken";
        public const string GetRootPathAccess = "api/LoginApi/GetRootPathAccess";
        public const string GetUserAuthToken = "api/LoginApi/GetUserAuthToken";
        
        public const string UpsertRole = "Roles/RolesApi/UpsertRole";
        public const string DeleteRole = "Roles/RolesApi/DeleteRole";
        public const string UpdateRoleFeature = "Roles/RolesApi/UpdateRoleFeature";
        public const string GetAllRoles = "Roles/RolesApi/GetAllRoles";
        public const string GetRoleById = "Roles/RolesApi/GetRoleById";
        public const string GetRolesByFeatureId = "Roles/RolesApi/GetRolesByFeatureId";
        public const string GetAllRolesDropDown = "Roles/RolesApi/GetAllRolesDropDown";

        public const string UpsertCompany = "CompanyManagement/CompanyManagementApi/UpsertCompany";
        public const string CompanyDetails = "CompanyManagement/CompanyManagementApi/CompanyDetails";
        public const string GetCompanyById = "CompanyManagement/CompanyManagementApi/GetCompanyById";
        public const string SearchCompanies = "CompanyManagement/CompanyManagementApi/SearchCompanies";
        public const string UpsertCompanyDetails = "CompanyManagement/CompanyManagementApi/UpsertCompanyDetails";
        public const string DeleteCompanyModule = "CompanyManagement/CompanyManagementApi/DeleteCompanyModule";
        public const string ArchiveCompany = "CompanyManagement/CompanyManagementApi/ArchiveCompany";
        public const string SearchIndustries = "CompanyManagement/CompanyManagementApi/SearchIndustries";
        public const string GetCompanyModules = "CompanyManagement/CompanyManagementApi/GetCompanyModules";
        public const string UpsertModule = "CompanyManagement/CompanyManagementApi/UpsertModule";
        public const string UpsertModulePage = "CompanyManagement/CompanyManagementApi/UpsertModulePage";
        public const string GetModulePage = "CompanyManagement/CompanyManagementApi/GetModulePage";
        public const string UpsertModuleLayout = "CompanyManagement/CompanyManagementApi/UpsertModuleLayout";
        public const string GetModuleLayout = "CompanyManagement/CompanyManagementApi/GetModuleLayout";
        public const string GetModules = "CompanyManagement/CompanyManagementApi/GetModules";
        public const string UpsertCompanyModule = "CompanyManagement/CompanyManagementApi/UpsertCompanyModule";

        public const string GetAllTimeZones = "TimeZone/TimeZoneApi/GetAllTimeZones";

        public const string GetCompanySettingsDetails = "MasterData/MasterDataManagementApi/GetCompanySettingsDetails";
        public const string UpsertCompanysettings = "MasterData/MasterDataManagementApi/UpsertCompanysettings";
        public const string UpsertCompanyLogo = "MasterData/MasterDataManagementApi/UpsertCompanyLogo";
    }
}
