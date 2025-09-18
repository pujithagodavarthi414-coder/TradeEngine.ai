using BTrak.Common;
using Btrak.Dapper.Dal.Models;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models.CompanyStructure;
using Btrak.Models;
using System.Data.SqlClient;
using Btrak.Models.SystemManagement;
using Btrak.Models.MasterData;

namespace Btrak.Dapper.Dal.Partial
{
    public class MailTemplateActivityRepository : BaseRepository
    {
        public UserDbEntity GetUserDetailsByNameAndCompanyId(string sqlConectionString ,string userName, Guid companyId, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenCamundaSqlConnection(sqlConectionString))
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@UserName", userName);
                    vParams.Add("@CompanyId", companyId);

                    return vConn.Query<UserDbEntity>(StoredProcedureConstants.SpetUserDetailsByNameAndCompanyId, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserDetailsByNameAndCompanyId", "MailTemplateActivityRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.SearchCompany);
                return null;
            }
        }

        public List<CompanyOutputModel> SearchCompanies(string sqlConectionString, CompanySearchCriteriaInputModel companySearchCriteriaInputModel, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenCamundaSqlConnection(sqlConectionString))
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
                    vParams.Add("@OperationsPerformedBy", null);
                    vParams.Add("@ForSuperUser", true);
                    return vConn.Query<CompanyOutputModel>(StoredProcedureConstants.SpGetCompanies, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchCompanies", "MailTemplateActivityRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.SearchCompany);
                return new List<CompanyOutputModel>();
            }
        }

        public virtual List<CompanyOutputModel> SearchCompanies(string sqlConectionString, CompanySearchCriteriaInputModel companySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenCamundaSqlConnection(sqlConectionString))
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
                    return vConn.Query<CompanyOutputModel>(StoredProcedureConstants.SpGetCompanies, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchCompanies", "MailTemplateActivityRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.SearchCompany);
                return new List<CompanyOutputModel>();
            }
        }

        public virtual SmtpDetailsModel SearchSmtpCredentials(string sqlConectionString, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, string SiteAddress)
        {
            try
            {
                using (var vConn = OpenCamundaSqlConnection(sqlConectionString))
                {

                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext?.LoggedInUserId == Guid.Empty ? null : loggedInContext?.LoggedInUserId);
                    vParams.Add("@CompanyId", loggedInContext?.CompanyGuid == Guid.Empty ? null : loggedInContext?.CompanyGuid);
                    vParams.Add("@SiteAddress", SiteAddress);
                    return vConn.Query<SmtpDetailsModel>(StoredProcedureConstants.SpGetSmtpCredentials, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchSmtpCredentials", "MailTemplateActivityRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchSystemCurrencies);
                return new SmtpDetailsModel();
            }
        }

        public virtual CompanyOutputModel GetCompanyDetails(string sqlConectionString, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenCamundaSqlConnection(sqlConectionString))
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<CompanyOutputModel>(StoredProcedureConstants.SpCompanyDetails, vParams, commandTimeout: 0, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCompanyDetails", "MailTemplateActivityRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertCompany);
                return null;
            }
        }

        public virtual List<CompanySettingsSearchOutputModel> GetCompanySettings(string sqlConectionString, CompanySettingsSearchInputModel companySettingsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenCamundaSqlConnection(sqlConectionString))
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
                    return vConn.Query<CompanySettingsSearchOutputModel>(StoredProcedureConstants.SpGetCompanySettings, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCompanySettings", "MailTemplateActivityRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCompanySettings);
                return new List<CompanySettingsSearchOutputModel>();
            }
        }

        public int GetMailsCount(string sqlConectionString, LoggedInContext loggedInContext)
        {
            try
            {
                using (IDbConnection vConn = OpenCamundaSqlConnection(sqlConectionString))
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<int>(StoredProcedureConstants.SpGetMailsCount, vParams, commandTimeout: 0, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetMailsCount", "MailTemplateActivityRepository ", sqlException.Message), sqlException);

                return 0;
            }
        }

        public void InsertSentMail(string sqlConectionString, EmailGenericModel emailGenericModel, LoggedInContext loggedInContext)
        {
            try
            {
                using (IDbConnection vConn = OpenCamundaSqlConnection(sqlConectionString))
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ToMail", emailGenericModel.ToAddresses != null ? string.Join(",", emailGenericModel.ToAddresses) : "");
                    vParams.Add("@CCMail", emailGenericModel.CCMails != null ? string.Join(",", emailGenericModel.CCMails) : "");
                    vParams.Add("@BCCMail", emailGenericModel.BCCMails != null ? string.Join(",", emailGenericModel.BCCMails) : "");
                    vParams.Add("@FromMail", emailGenericModel.SmtpMail);
                    vParams.Add("@Subject", emailGenericModel.Subject);
                    vParams.Add("@MailBody", emailGenericModel.HtmlContent);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vConn.Query<UpsertCompanyOutputModel>(StoredProcedureConstants.SpInsertMail, vParams, commandTimeout: 0, commandType: CommandType.StoredProcedure);
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertSentMail", "MailTemplateActivityRepository ", sqlException.Message), sqlException);

            }
        }

       


    }
}
