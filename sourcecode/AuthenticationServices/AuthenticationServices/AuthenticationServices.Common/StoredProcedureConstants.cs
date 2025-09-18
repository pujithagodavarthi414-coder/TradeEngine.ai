namespace AuthenticationServices.Common
{
    public class StoredProcedureConstants
    {
        // User Management
        public const string SpGetUserDetails = "USP_GetUserDetails";
        public const string SpUpsertUser = "USP_UpsertUser";
        public const string SpGetUsers = "USP_GetUsers";
        public const string SpUpdateUserProfileDetails = "USP_UpdateUserProfileDetails";

        public const string SpGetResetPasswordDetails = "USP_GetResetPasswordDetails";

        // Company Management
        public const string SpGetCompanies = "USP_GetCompanies";
        public const string SpCompanyDetails = "USP_GetCompanyDetails";
        public const string SpInsertMail = "USP_InsertMail";
        public const string SpGetMailsCount = "USP_GetMailsCount";

        public const string SpGetCompanySettings = "USP_GetCompanySettings";
        public const string SpCheckValidationsUpsertCompany_New = "USP_CheckValidationsForCompanyRegistration";

        public const string SpGetAllHtmlTemplate = "USP_GetHtmlTemplate";
        public const string SpGetTemplate = "USP_GetTemplate";
        public const string SpGetSmtpCredentials = "USP_SearchSmtpCredentials";

        public const string SpValidateApiKey = "USP_ValidateApiKey";
        public const string SpValidateAuthTokenAndActionPath = "USP_ValidateAuthTokenAndActionPath";
        public const string SpUserAuthTokensReadItem = "USP_UserAuthTokens_ReadItem";


        public const string SpGetUserDetailsByName = "USP_GetUserDetailsByName";
        public const string SpGetUserDetailsByNameAndSiteAddress = "USP_GetUserDetailsByNameAndSiteAddress";
        public const string SpGetUserDetailsByUserIdAndCompanyId = "USP_GetUserDetailsByUserIdAndCompanyId";

        public const string SpUserAuthTokenInsert = "USP_UserAuthTokenInsert";
        public const string SpUserAuthTokenUpdate = "USP_UserAuthTokenUpdate";

        public const string SpUserDetails = "USP_UserDetails";
        public const string SpUserCompaniesList = "USP_UserCompaniesList";
        public const string SpUpsertCompany_New = "USP_NewCompanyRegistration";
        public const string SpUpdateCompanySettings = "USP_UpdateCompanySettings";
        public const string SpUpsertCompany = "USP_UpsertCompany";
        public const string SpUpdateCompany = "USP_UpdateCompanyVatDetails";
        public const string SpCompanyTestDataDelete = "USP_CompanyTestDataDelete";
        public const string SpDeleteCompanyModule = "USP_DeleteCompanyModule";
        public const string SpArchiveCompany = "USP_ArchiveCompany";
        public const string SpGetIndustries = "USP_GetIndustries";

        public const string SpUpdateResetPassword = "USP_UpdateResetPassword";
        public const string SpUpdatePassword = "USP_UpdatePassword";
        public const string SpUpdateUserForgottenPassword = "USP_UpdateUserForgottenPassword";

        public const string SpUpsertRoleFeature = "USP_UpsertRoleFeature";
        public const string SpUpdateRoleFeature = "USP_UpdateRoleFeature";
        public const string SpDeleteRole = "USP_DeleteRole";
        public const string SpGetRoles = "USP_GetRoles";
        public const string SpGetRoleByFeatureId = "USP_GetRoleByFeatureId";
        public const string SpGetRolesDropDown = "USP_GetRolesDropDown";
        public const string SpGetCompanyModules = "USP_GetCompanyModules";
        public const string SpUpsertModule = "USP_UpsertModule";
        public const string SpUpsertModulePages = "USP_UpsertModulePages";
        public const string SpGetModulePages = "USP_GetModulePages";
        public const string SpUpsertModuleLayout = "USP_UpsertModuleLayout";
        public const string SpGetModuleLayout = "USP_GetModuleLayouts";
        public const string SpGetModules = "USP_GetModules";
        public const string SpUpsertCompanyModule = "USP_UpsertCompanyModule";
        public const string SpUpsertCompanySettings = "USP_UpsertCompanySettings";
        public const string SpUpsertCompanyLogo = "USP_UpsertCompanyLogo";

        public const string SpGetTimeZones = "USP_GetTimeZones";
    }
}
