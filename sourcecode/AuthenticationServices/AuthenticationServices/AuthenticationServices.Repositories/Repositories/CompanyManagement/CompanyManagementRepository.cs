using AuthenticationServices.Common;
using AuthenticationServices.Models;
using AuthenticationServices.Models.CompanyStructure;
using AuthenticationServices.Models.HrManagement;
using AuthenticationServices.Models.MasterData;
using AuthenticationServices.Models.Modules;
using AuthenticationServices.Repositories.Helpers;
using Dapper;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;


namespace AuthenticationServices.Repositories.Repositories.CompanyManagement
{
    public class CompanyManagementRepository : ICompanyManagementRepository
    {
        IConfiguration _iconfiguration;
        public CompanyManagementRepository(IConfiguration iconfiguration)
        {
            _iconfiguration = iconfiguration;
        }

        public List<CompanyOutputModel> SearchCompanies(CompanySearchCriteriaInputModel companySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnectionAuthentication())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CompanyId", companySearchCriteriaInputModel.CompanyId);
                    vParams.Add("@SearchText", companySearchCriteriaInputModel.SearchText);
                    vParams.Add("@IndustryId", companySearchCriteriaInputModel.IndustryId);
                    vParams.Add("@MainUseCaseId", companySearchCriteriaInputModel.MainUseCaseId);
                    vParams.Add("@TeamSize", companySearchCriteriaInputModel.TeamSize);
                    vParams.Add("@PhoneNumber", companySearchCriteriaInputModel.PhoneNumber);
                    vParams.Add("@CountryId", companySearchCriteriaInputModel.CountryId);
                    vParams.Add("@TimeZoneId", companySearchCriteriaInputModel.TimeZoneId);
                    vParams.Add("@CurrencyId", companySearchCriteriaInputModel.CurrencyId);
                    vParams.Add("@NumberFormatId", companySearchCriteriaInputModel.NumberFormatId);
                    vParams.Add("@DateFormatId", companySearchCriteriaInputModel.DateFormatId);
                    vParams.Add("@TimeFormatId", companySearchCriteriaInputModel.TimeFormatId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@PageNumber", companySearchCriteriaInputModel.PageNumber);
                    vParams.Add("@PageSize", companySearchCriteriaInputModel.PageSize);

                    return vConn.Query<CompanyOutputModel>(StoredProcedureConstants.SpGetCompanies, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchCompanies", "CompanyManagementRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.SearchCompany);
                return new List<CompanyOutputModel>();
            }
        }

        public CompanyOutputModel GetCompanyDetails(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnectionAuthentication())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@CompanyId", loggedInContext.CompanyGuid);
                    return vConn.Query<CompanyOutputModel>(StoredProcedureConstants.SpCompanyDetails, vParams, commandTimeout: 0, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCompanyDetails", "CompanyManagementRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertCompany);
                return null;
            }
        }

        public void InsertSentMail(EmailGenericModel emailGenericModel, LoggedInContext loggedInContext)
        {
            try
            {
                using (IDbConnection vConn = OpenConnectionAuthentication())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ToMail", emailGenericModel.ToAddresses != null ? string.Join(",", emailGenericModel.ToAddresses) : "");
                    vParams.Add("@CCMail", emailGenericModel.CCMails != null ? string.Join(",", emailGenericModel.CCMails) : "");
                    vParams.Add("@BCCMail", emailGenericModel.BCCMails != null ? string.Join(",", emailGenericModel.BCCMails) : "");
                    vParams.Add("@FromMail", emailGenericModel.SmtpMail);
                    vParams.Add("@Subject", emailGenericModel.Subject);
                    vParams.Add("@MailBody", emailGenericModel.HtmlContent);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@CompanyId", loggedInContext.CompanyGuid);
                    vConn.Query<UpsertCompanyOutputModel>(StoredProcedureConstants.SpInsertMail, vParams, commandTimeout: 0, commandType: CommandType.StoredProcedure);
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertSentMail", "CompanyManagementRepository ", sqlException.Message), sqlException);

            }
        }

        public int GetMailsCount(LoggedInContext loggedInContext)
        {
            try
            {
                using (IDbConnection vConn = OpenConnectionAuthentication())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@CompanyId", loggedInContext.CompanyGuid);
                    return vConn.Query<int>(StoredProcedureConstants.SpGetMailsCount, vParams, commandTimeout: 0, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetMailsCount", "CompanyManagementRepository ", sqlException.Message), sqlException);

                return 0;
            }
        }

        public List<CompanySettingsSearchOutputModel> GetCompanySettings(CompanySettingsSearchInputModel companySettingsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnectionAuthentication())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CompanySettingsId", companySettingsSearchInputModel.CompanySettingsId);
                    vParams.Add("@Key", companySettingsSearchInputModel.Key);
                    vParams.Add("@Description", companySettingsSearchInputModel.Description);
                    vParams.Add("@Value", companySettingsSearchInputModel.Value);
                    vParams.Add("@SearchText", companySettingsSearchInputModel.SearchText);
                    vParams.Add("@IsArchived", companySettingsSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext?.LoggedInUserId);
                    vParams.Add("@IsSystemApp", companySettingsSearchInputModel.IsSystemApp);
                    vParams.Add("@IsFromExport", companySettingsSearchInputModel.IsFromExport);
                    vParams.Add("@CompanyId", loggedInContext.CompanyGuid);
                    return vConn.Query<CompanySettingsSearchOutputModel>(StoredProcedureConstants.SpGetCompanySettings, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCompanySettings", "CompanyManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCompanySettings);
                return new List<CompanySettingsSearchOutputModel>();
            }
        }

        public string GetHtmlTemplateByName(string templateName, Guid? companyId)
        {
            using (IDbConnection vConn = OpenConnectionAuthentication())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@TemplateName", templateName);
                vParams.Add("@CompanyId", companyId);
                return vConn.Query<string>(StoredProcedureConstants.SpGetTemplate, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }

        public List<HtmlTemplateApiReturnModel> GetHtmlTemplates(HtmlTemplateSearchInputModel htmlTemplateSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnectionAuthentication())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@HtmlTemplateId", htmlTemplateSearchInputModel.HtmlTemplateId);
                    vParams.Add("@SearchText", htmlTemplateSearchInputModel.SearchText);
                    vParams.Add("@IsArchived", htmlTemplateSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@CompanyId", loggedInContext.CompanyGuid);
                    return vConn.Query<HtmlTemplateApiReturnModel>(StoredProcedureConstants.SpGetAllHtmlTemplate, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetHtmlTemplates", "CompanyManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetHtmlTemplate);
                return new List<HtmlTemplateApiReturnModel>();
            }
        }

        public void CheckUpsertCompanyValidations(CompanyInputModel companyInputModel, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnectionAuthentication())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@CompanyName", companyInputModel.CompanyName);
                    vParams.Add("@SiteAddress", companyInputModel.SiteAddress);
                    vParams.Add("@WorkEmail", companyInputModel.WorkEmail);
                    vParams.Add("@Password", companyInputModel.Password);
                    vParams.Add("@IndustryId", companyInputModel.IndustryId);
                    vParams.Add("@MainUseCaseId", companyInputModel.MainUseCaseId);
                    vParams.Add("@TeamSize", companyInputModel.TeamSize);
                    vParams.Add("@MobileNumber", companyInputModel.MobileNumber);
                    vParams.Add("@CountryId", companyInputModel.CountryId);
                    vParams.Add("@TimeZoneId", companyInputModel.TimeZoneId);
                    vParams.Add("@CurrencyId", companyInputModel.CurrencyId);
                    vParams.Add("@NumberFormatId", companyInputModel.NumberFormatId);
                    vParams.Add("@DateFormatId", companyInputModel.DateFormatId);
                    vParams.Add("@TimeFormatId", companyInputModel.TimeFormatId);
                    vParams.Add("@FirstName", companyInputModel.FirstName);
                    vParams.Add("@LastName", companyInputModel.LastName);
                    vConn.Query<HtmlTemplateApiReturnModel>(StoredProcedureConstants.SpCheckValidationsUpsertCompany_New, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CheckUpsertCompanyValidations", "CompanyManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetHtmlTemplate);
            }
        }

        public UpsertCompanyOutputModel UpsertCompany(CompanyInputModel companyInputModel, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnectionAuthentication())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CompanyName", companyInputModel.CompanyName);
                    vParams.Add("@SiteAddress", companyInputModel.SiteAddress);
                    vParams.Add("@WorkEmail", companyInputModel.WorkEmail);
                    vParams.Add("@Password", companyInputModel.Password);
                    vParams.Add("@IndustryId", companyInputModel.IndustryId);
                    vParams.Add("@MainUseCaseId", companyInputModel.MainUseCaseId);
                    vParams.Add("@TeamSize", companyInputModel.TeamSize);
                    vParams.Add("@MobileNumber", companyInputModel.MobileNumber);
                    vParams.Add("@CountryId", companyInputModel.CountryId);
                    vParams.Add("@TimeZoneId", companyInputModel.TimeZoneId);
                    vParams.Add("@CurrencyId", companyInputModel.CurrencyId);
                    vParams.Add("@NumberFormatId", companyInputModel.NumberFormatId);
                    vParams.Add("@IsRemoteAccess", companyInputModel.IsRemoteAccess);
                    vParams.Add("@DateFormatId", companyInputModel.DateFormatId);
                    vParams.Add("@TimeFormatId", companyInputModel.TimeFormatId);
                    vParams.Add("@FirstName", companyInputModel.FirstName);
                    vParams.Add("@LastName", companyInputModel.LastName);
                    vParams.Add("@IsDemoData", companyInputModel.IsDemoData);
                    vParams.Add("@IsSoftWare", companyInputModel.IsSoftWare);
                    vParams.Add("@Language", companyInputModel.LangCode);
                    vParams.Add("@TrailPeriod", companyInputModel.TrailPeriod);
                    vParams.Add("@ReDirectionUrl", companyInputModel.ReDirectionUrl);
                    vParams.Add("@ConfigurationUrl", companyInputModel.ConfigurationUrl);
                    vParams.Add("@ApiUrl", companyInputModel.ApiUrl);
                    vParams.Add("@SiteDomain", companyInputModel.SiteDomain);
                    vParams.Add("@RegisterSiteAddress", companyInputModel.RegistrerSiteAddress);
                    vParams.Add("@IdentityServerCallback", companyInputModel.IdentityServerCallback);
                    return vConn.Query<UpsertCompanyOutputModel>(StoredProcedureConstants.SpUpsertCompany_New, vParams, commandTimeout: 0, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCompany", "CompanyManagementRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertCompany);
                return null;
            }
        }

        public bool UpdateCompanySettings(CompanyInputModel companyInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnectionAuthentication())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@CompanyId", loggedInContext.CompanyGuid);
                    vParams.Add("@Email", companyInputModel.WorkEmail);
                    vParams.Add("@SiteAddress", companyInputModel.SiteAddress);
                    vParams.Add("@SiteDomain", companyInputModel.SiteDomain);
                    vParams.Add("@CompanyLogo", companyInputModel.CompanyLogo);
                    vParams.Add("@CompanyMiniLogo", companyInputModel.CompanyMiniLogo);
                    vParams.Add("@CompanyRegisatrationLogo", companyInputModel.CompanyRegistrationLogo);
                    vParams.Add("@CompanySigninLogo", companyInputModel.CompanySigninLogo);
                    vParams.Add("@MailFooterAddress", companyInputModel.MailFooterAddress);
                    return vConn.Query<bool>(StoredProcedureConstants.SpUpdateCompanySettings, vParams, commandType: CommandType.StoredProcedure).First();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateCompanySettings", "CompanyManagementRepository", sqlException.Message), sqlException);
                return false;
            }
        }

        public Guid? UpsertCompanyDetails(CompanyInputModel companyInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnectionAuthentication())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CompanyName", companyInputModel.CompanyName);
                    vParams.Add("@SiteAddress", companyInputModel.SiteAddress);
                    vParams.Add("@SiteDomain", companyInputModel.SiteDomain);
                    vParams.Add("@WorkEmail", companyInputModel.WorkEmail);
                    vParams.Add("@IndustryId", companyInputModel.IndustryId);
                    vParams.Add("@FirstName", companyInputModel.FirstName);
                    vParams.Add("@LastName", companyInputModel.LastName);
                    vParams.Add("@MainUseCaseId", companyInputModel.MainUseCaseId);
                    vParams.Add("@TeamSize", companyInputModel.TeamSize);
                    vParams.Add("@CountryId", companyInputModel.CountryId);
                    vParams.Add("@TimeZoneId", companyInputModel.TimeZoneId);
                    vParams.Add("@CurrencyId", companyInputModel.CurrencyId);
                    vParams.Add("@NumberFormatId", companyInputModel.NumberFormatId);
                    vParams.Add("@DateFormatId", companyInputModel.DateFormatId);
                    vParams.Add("@TimeFormatId", companyInputModel.TimeFormatId);
                    vParams.Add("@PhoneNumber", companyInputModel.MobileNumber);
                    vParams.Add("@CompanyLogo", companyInputModel.CompanyLogo);
                    vParams.Add("@TrialDays", companyInputModel.TrailPeriod);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@CompanyId", companyInputModel.CompanyId);
                    vParams.Add("@TimeStamp", companyInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@ApiUrl", companyInputModel.ApiUrl);
                    return vConn.Query<Guid>(StoredProcedureConstants.SpUpsertCompany, vParams, commandTimeout: 0, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCompanyDetails", "CompanyManagementRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertCompany);
                return null;
            }
        }

        public string UpdateCompanyDetails(CompanyInputModel companyInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnectionAuthentication())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CompanyName", companyInputModel.CompanyName);
                    vParams.Add("@CompanyId", companyInputModel.CompanyId);
                    vParams.Add("@PrimayrAddress", companyInputModel.PrimaryAddress);
                    vParams.Add("@CompanyLogo", companyInputModel.CompanyLogo);
                    vParams.Add("@VAT", companyInputModel.VAT);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<string>(StoredProcedureConstants.SpUpdateCompany, vParams, commandTimeout: 0, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateCompanyDetails", "CompanyManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertCompany);
                return sqlException.Message.ToString();
            }
        }

        public Guid? DeleteCompanyTestData(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnectionAuthentication())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CompanyId", loggedInContext.CompanyGuid);
                    vParams.Add("@UserId", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpCompanyTestDataDelete, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateCompanyDetails", "CompanyManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertCompany);
                return null;
            }
        }

        public Guid? DeleteCompanyModule(DeleteCompanyModuleModel deleteCompanyModuleModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnectionAuthentication())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CompanyModuleId", deleteCompanyModuleModel.CompanyModuleId);
                    vParams.Add("@TimeStamp", deleteCompanyModuleModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@CompanyId", loggedInContext.CompanyGuid);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpDeleteCompanyModule, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteCompanyModule", "CompanyStructureRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionDeleteCompanyModule);
                return null;
            }
        }

        public Guid? ArchiveCompany(ArchiveCompanyInputModel archiveCompanyInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnectionAuthentication())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CompanyId", archiveCompanyInputModel.CompanyId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@TimeStamp", archiveCompanyInputModel.TimeStamp, DbType.Binary);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpArchiveCompany, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ArchiveCompany", "CompanyStructureRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionDeleteCompanyModule);
                return null;
            }
        }

        public List<CompanyStructureOutputModel> SearchCompanyStructure(CompanyStructureSearchCriteriaInputModel companyStructureSearchCriteriaInputModel, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@IndustryId", companyStructureSearchCriteriaInputModel.IndustryId);
                    vParams.Add("@SearchText", companyStructureSearchCriteriaInputModel.SearchText);
                    vParams.Add("@IsArchived", companyStructureSearchCriteriaInputModel.IsArchived);
                    return vConn.Query<CompanyStructureOutputModel>(StoredProcedureConstants.SpGetIndustries, vParams,
                        commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchCompanyStructure", "CompanyStructureRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.SearchCompanyStructure);
                return new List<CompanyStructureOutputModel>();
            }
        }

        public List<CompanyModuleOutputModel> GetCompanyModules(CompanyModuleSearchInputModel companySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnectionAuthentication())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CompanyId", companySearchCriteriaInputModel.CompanyId);
                    vParams.Add("@SearchText", companySearchCriteriaInputModel.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@PageNumber", companySearchCriteriaInputModel.PageNumber);
                    vParams.Add("@PageSize", companySearchCriteriaInputModel.PageSize);
                    return vConn.Query<CompanyModuleOutputModel>(StoredProcedureConstants.SpGetCompanyModules, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCompanyModules", "CompanyManagementRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchCompanyModules);
                return new List<CompanyModuleOutputModel>();
            }
        }

        public Guid? UpsertModule(ModuleUpsertInputModel moduleInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnectionAuthentication())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CompanyId", moduleInputModel.CompanyId);
                    vParams.Add("@ModuleId", moduleInputModel.ModuleId);
                    vParams.Add("@ModuleDescription", moduleInputModel.ModuleDescription);
                    vParams.Add("@ModuleLogo", moduleInputModel.ModuleLogo);
                    vParams.Add("@ModuleName", moduleInputModel.ModuleName);
                    vParams.Add("@IsArchived", moduleInputModel.IsArchived);
                    vParams.Add("@Tags", moduleInputModel.Tags);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@TimeStamp", moduleInputModel.TimeStamp, DbType.Binary);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertModule, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertModule", "CompanyStructureRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionForUpsertModule);
                return null;
            }
        }

        public Guid? UpsertModulePage(ModulePageUpsertInputModel moduleUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnectionAuthentication())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ModuleId", moduleUpsertInputModel.ModuleId);
                    vParams.Add("@ModulePageId", moduleUpsertInputModel.ModulePageId);
                    vParams.Add("@PageName", moduleUpsertInputModel.PageName);
                    vParams.Add("@IsDefault", moduleUpsertInputModel.IsDefault);
                    vParams.Add("@CompanyId", moduleUpsertInputModel.CompanyId);
                    vParams.Add("@IsArchived", moduleUpsertInputModel.IsArchived);
                    vParams.Add("@IsNameEdit", moduleUpsertInputModel.IsNameEdit);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@TimeStamp", moduleUpsertInputModel.TimeStamp, DbType.Binary);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertModulePages, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertModulePage", "CompanyStructureRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionForUpsertModulePages);
                return null;
            }
        }

        public List<ModulePageOutputReturnModel> GetModulePages(ModulePageSearchInputModel modulePageSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnectionAuthentication())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SearchText", modulePageSearchInputModel.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@ModuleId", modulePageSearchInputModel.ModuleId);
                    vParams.Add("@ModulePageId", modulePageSearchInputModel.ModulePageId);
                    return vConn.Query<ModulePageOutputReturnModel>(StoredProcedureConstants.SpGetModulePages, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetModulePages", "CompanyManagementRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionForSearchModulePages);
                return new List<ModulePageOutputReturnModel>();
            }
        }

        public Guid? UpsertModuleLayout(ModuleLayoutUpsertInputModel moduleUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnectionAuthentication())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ModulePageId", moduleUpsertInputModel.ModulePageId);
                    vParams.Add("@ModuleLayoutId", moduleUpsertInputModel.ModuleLayoutId);
                    vParams.Add("@LayoutName", moduleUpsertInputModel.LayoutName);
                    vParams.Add("@IsNameEdit", moduleUpsertInputModel.IsNameEdit);
                    vParams.Add("@CompanyId", moduleUpsertInputModel.CompanyId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@TimeStamp", moduleUpsertInputModel.TimeStamp, DbType.Binary);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertModuleLayout, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertModuleLayout", "CompanyStructureRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionForUpsertModulePages);
                return null;
            }
        }

        public List<ModuleLayoutOutputReturnModel> GetModuleLayouts(ModulePageSearchInputModel modulePageSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnectionAuthentication())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SearchText", modulePageSearchInputModel.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@ModuleLayoutId", modulePageSearchInputModel.ModuleLayoutId);
                    vParams.Add("@ModulePageId", modulePageSearchInputModel.ModulePageId);
                    vParams.Add("@PageNumber", modulePageSearchInputModel.PageNumber);
                    vParams.Add("@PageSize", modulePageSearchInputModel.PageSize);
                    return vConn.Query<ModuleLayoutOutputReturnModel>(StoredProcedureConstants.SpGetModuleLayout, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetModuleLayouts", "CompanyManagementRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionForSearchModulePages);
                return new List<ModuleLayoutOutputReturnModel>();
            }
        }

        public List<ModuleOutputModel> GetModules(ModuleSearchInputModel moduleSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnectionAuthentication())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SearchText", moduleSearchInputModel.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@ModuleId", moduleSearchInputModel.ModuleId);
                    return vConn.Query<ModuleOutputModel>(StoredProcedureConstants.SpGetModules, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetModules", "CompanyManagementRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionForSearchModules);
                return new List<ModuleOutputModel>();
            }
        }

        public Guid? UpsertCompanyModules(CompanyModuleUpsertModel companyModuleUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnectionAuthentication())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CompanyId", companyModuleUpsertModel.CompanyId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@ModuleIds", companyModuleUpsertModel.ModuleIdsList);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertCompanyModule, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCompanyModules", "CompanyManagementRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionForUpsertCompanyModule);
                return null;
            }
        }
        protected IDbConnection OpenConnection()
        {
            IDbConnection connection = new SqlConnection(_iconfiguration.GetConnectionString("BTrakConnectionString"));
            connection.Open();
            return connection;
        }

        protected IDbConnection OpenConnectionAuthentication()
        {
            IDbConnection connection = new SqlConnection(_iconfiguration.GetConnectionString("AuthConnectionString"));
            connection.Open();
            return connection;
        }

        
    }
}
