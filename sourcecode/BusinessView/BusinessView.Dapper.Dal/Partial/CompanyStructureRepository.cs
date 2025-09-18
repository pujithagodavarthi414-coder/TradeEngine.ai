using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.CompanyStructure;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace Btrak.Dapper.Dal.Repositories
{
    public class CompanyStructureRepository : BaseRepository
    {
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

        public List<MainUseCaseOutputModel> SearchMainUseCases(MainUseCaseSearchCriteriaInputModel mainUseCaseSearchCriteriaInputModel, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@MainUseCaseId", mainUseCaseSearchCriteriaInputModel.MainUseCaseId);
                    vParams.Add("@SearchText", mainUseCaseSearchCriteriaInputModel.SearchText);
                    vParams.Add("@IsArchived", mainUseCaseSearchCriteriaInputModel.IsArchived);
                    return vConn.Query<MainUseCaseOutputModel>(StoredProcedureConstants.SpGetMainUseCases, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchMainUseCases", "CompanyStructureRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.SearchMainUseCases);
                return new List<MainUseCaseOutputModel>();
            }
        }

        public Guid? UpsertIndustryModule(IndustryModuleInputModel industryModuleInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@IndustryModuleId", industryModuleInputModel.IndustryModuleId);
                    vParams.Add("@IndustryId", industryModuleInputModel.IndustryId);
                    vParams.Add("@ModuleId", industryModuleInputModel.ModuleId);
                    vParams.Add("@IsArchived", industryModuleInputModel.IsArchived);
                    vParams.Add("@TimeStamp", industryModuleInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertIndustryModule, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertIndustryModule", "CompanyStructureRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionIndustryModule);
                return null;
            }
        }

        public List<IndustryModuleOutputModel> SearchIndustryModule(IndustryModuleSearchCriteriaInputModel industryModuleSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@IndustryModuleId", industryModuleSearchCriteriaInputModel.IndustryModuleId);
                    vParams.Add("@SearchText", industryModuleSearchCriteriaInputModel.SearchText);
                    vParams.Add("@IsArchived", industryModuleSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<IndustryModuleOutputModel>(StoredProcedureConstants.SpGetIndustryModule, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchIndustryModule", "CompanyStructureRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.SearchIndustryModule);
                return new List<IndustryModuleOutputModel>();
            }
        }

        public List<NumberFormatOutputModel> SearchNumberFormat(NumberFormatSearchCriteriaInputModel numberFormatSearchCriteriaInputModel, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@NumberFormatId", numberFormatSearchCriteriaInputModel.NumberFormatId);
                    vParams.Add("@SearchText", numberFormatSearchCriteriaInputModel.SearchText);
                    vParams.Add("@IsArchived", numberFormatSearchCriteriaInputModel.IsArchived);
                    return vConn.Query<NumberFormatOutputModel>(StoredProcedureConstants.SpGetNumberFormats, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchNumberFormat", "CompanyStructureRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.SearchNumberFormats);
                return new List<NumberFormatOutputModel>();
            }
        }

        public List<DateFormatOutputModel> SearchDateFormats(DateFormatSearchCriteriaInputModel dateFormatSearchCriteriaInputModel, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@DateFormatId ", dateFormatSearchCriteriaInputModel.DateFormatId);
                    vParams.Add("@SearchText", dateFormatSearchCriteriaInputModel.SearchText);
                    vParams.Add("@IsArchived", dateFormatSearchCriteriaInputModel.IsArchived);
                    return vConn.Query<DateFormatOutputModel>(StoredProcedureConstants.SpGetDateFormats, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchDateFormats", "CompanyStructureRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.SearchDateFormats);
                return new List<DateFormatOutputModel>();
            }
        }

        public List<TimeFormatOutputModel> SearchTimeFormats(TimeFormatSearchCriteriaInputModel timeFormatSearchCriteriaInputModel, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@TimeFormatId", timeFormatSearchCriteriaInputModel.TimeFormatId);
                    vParams.Add("@SearchText", timeFormatSearchCriteriaInputModel.SearchText);
                    vParams.Add("@IsArchived", timeFormatSearchCriteriaInputModel.IsArchived);
                    return vConn.Query<TimeFormatOutputModel>(StoredProcedureConstants.SpGetTimeFormats, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchTimeFormats", "CompanyStructureRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.SearchTimeFormats);
                return new List<TimeFormatOutputModel>();
            }
        }

        public UpsertCompanyOutputModel UpsertCompany(CompanyInputModel companyInputModel, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
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
                    vParams.Add("@SiteDomain", companyInputModel.SiteDomain);
                    vParams.Add("@RegisterSiteAddress", companyInputModel.RegistrerSiteAddress);
                    vParams.Add("@CompanyAuthenticationId", companyInputModel.CompanyAuthenticationId);
                    vParams.Add("@UserAuthenticationId", companyInputModel.UserAuthenticationId);
                    vParams.Add("@RoleId", companyInputModel.RoleId);
                    vParams.Add("@RoleListXml", companyInputModel.RoleListXml);
                    return vConn.Query<UpsertCompanyOutputModel>(StoredProcedureConstants.SpUpsertCompany_New, vParams, commandTimeout: 0 , commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCompany", "CompanyStructureRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertCompany);
                return null;
            }
        }

        public Guid? UpsertComopanyDetails(CompanyInputModel companyInputModel,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CompanyName", companyInputModel.CompanyName);
                    vParams.Add("@SiteAddress", companyInputModel.SiteAddress);
                    vParams.Add("@WorkEmail", companyInputModel.WorkEmail);
                    vParams.Add("@IndustryId", companyInputModel.IndustryId);
                    vParams.Add("@MainUseCaseId", companyInputModel.MainUseCaseId);
                    vParams.Add("@TeamSize", companyInputModel.TeamSize);
                    vParams.Add("@CountryId", companyInputModel.CountryId);
                    vParams.Add("@TimeZoneId", companyInputModel.TimeZoneId);
                    vParams.Add("@CurrencyId", companyInputModel.CurrencyId);
                    vParams.Add("@NumberFormatId", companyInputModel.NumberFormatId);
                    vParams.Add("@DateFormatId", companyInputModel.DateFormatId);
                    vParams.Add("@TimeFormatId", companyInputModel.TimeFormatId);
                    vParams.Add("@@PhoneNumber", companyInputModel.PhoneNumber);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@CompanyAuthenticationId", companyInputModel.CompanyAuthenticationId);
                    vParams.Add("@TimeStamp", companyInputModel.TimeStamp, DbType.Binary);
                    return vConn.Query<Guid>(StoredProcedureConstants.SpUpsertCompany, vParams, commandTimeout: 0, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertComopanyDetails", "CompanyStructureRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertCompany);
                return null;
            }
        }

        public string UpdateCompanyDetails(CompanyInputModel companyInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CompanyName", companyInputModel.CompanyName);
                    vParams.Add("@CompanyId", companyInputModel.CompanyId);
                    vParams.Add("@PrimayrAddress", companyInputModel.PrimaryAddress);
                    vParams.Add("@VAT", companyInputModel.VAT);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<string>(StoredProcedureConstants.SpUpdateCompany, vParams, commandTimeout: 0, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateCompanyDetails", "CompanyStructureRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertCompany);
                return sqlException.Message.ToString();
            }
        }

        public virtual CompanyOutputModel GetCompanyDetails(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<CompanyOutputModel>(StoredProcedureConstants.SpCompanyDetails, vParams, commandTimeout: 0, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCompanyDetails", "CompanyStructureRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertCompany);
                return null;
            }
        }

        public void CheckUpsertCompanyValidations(CompanyInputModel companyInputModel, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
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
                    vParams.Add("@DateFormatId", companyInputModel.DateFormatId);
                    vParams.Add("@TimeFormatId", companyInputModel.TimeFormatId);
                    vParams.Add("@FirstName", companyInputModel.FirstName);
                    vParams.Add("@LastName", companyInputModel.LastName);
                    vConn.Query<UpsertCompanyOutputModel>(StoredProcedureConstants.SpCheckValidationsUpsertCompany_New, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CheckUpsertCompanyValidations", "CompanyStructureRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertCompany);
            }
        }

        public void InsertCompanyTestData(UpsertCompanyOutputModel upsertCompanyOutputModel, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CompanyId", upsertCompanyOutputModel.CompanyId);
                    vParams.Add("@UserId", upsertCompanyOutputModel.UserId);
                    vConn.Query<UpsertCompanyOutputModel>(StoredProcedureConstants.SpCompanyTestDataInsertScript, vParams, commandTimeout: 0, commandType: CommandType.StoredProcedure);
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertCompanyTestData", "CompanyStructureRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertCompany);
            }
        }

        public virtual List<CompanyOutputModel> SearchCompanies(CompanySearchCriteriaInputModel companySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
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
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchCompanies", "CompanyStructureRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.SearchCompany);
                return new List<CompanyOutputModel>();
            }
        }

        public List<CompanyOutputModel> SearchCompanies(CompanySearchCriteriaInputModel companySearchCriteriaInputModel, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
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
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchCompanies", "CompanyStructureRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.SearchCompany);
                return new List<CompanyOutputModel>();
            }
        }

        public List<IntroducedByOptionsOutputModel> SearchIntroducedByOptions(IntroducedByOptionsSearchInputModel introducedByOptionsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CompanyIntroducedByOptionId", introducedByOptionsSearchInputModel.CompanyIntroducedByOptionId);
                    vParams.Add("@Option", introducedByOptionsSearchInputModel.Option);
                    vParams.Add("@IsArchived", introducedByOptionsSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<IntroducedByOptionsOutputModel>(StoredProcedureConstants.SpGetCompanyIntroducedByOptions, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchIntroducedByOptions", "CompanyStructureRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.SearchIntroducedByOptions);
                return new List<IntroducedByOptionsOutputModel>();
            }
        }

        public Guid? DeleteCompanyModule(DeleteCompanyModuleModel deleteCompanyModuleModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CompanyModuleId", deleteCompanyModuleModel.CompanyModuleId);
                    vParams.Add("@TimeStamp", deleteCompanyModuleModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
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

        public Guid? DeleteCompanyTestData(DeleteCompanyTestDataModel deleteCompanyTestDataModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CompanyId", loggedInContext.CompanyGuid);
                    vParams.Add("@UserId", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpDeleteCompanyTestData, vParams, commandTimeout: 0, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteCompanyTestData", "CompanyStructureRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionDeleteCompanyModule);
                return null;
            }
        }

        public CompanyThemeModel GetCompanyTheme(string siteUrl, Guid? loggedInUserId, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SiteAddress", siteUrl);
                    vParams.Add("@OperationsPerformedBy", loggedInUserId);
                    return vConn.Query<CompanyThemeModel>(StoredProcedureConstants.SpGetTheme, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCompanyTheme", "CompanyStructureRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionDeleteCompanyModule);
                return null;
            }
        }

        public string IsCompanyExists(string siteUrl, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SiteAddress", siteUrl);
                    return vConn.Query<string>(StoredProcedureConstants.SpCompanyExists, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "IsCompanyExists", "CompanyStructureRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionDeleteCompanyModule);
                return null;
            }
        }

        public void InsertSentMail(EmailGenericModel emailGenericModel, LoggedInContext loggedInContext)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ToMail", emailGenericModel.ToAddresses !=null ? string.Join(",", emailGenericModel.ToAddresses) : "");
                    vParams.Add("@CCMail", emailGenericModel.CCMails !=null ? string.Join(",", emailGenericModel.CCMails) : "");
                    vParams.Add("@BCCMail", emailGenericModel.BCCMails!=null ? string.Join(",", emailGenericModel.BCCMails) : "");
                    vParams.Add("@FromMail", emailGenericModel.SmtpMail);
                    vParams.Add("@Subject", emailGenericModel.Subject);
                    vParams.Add("@MailBody", emailGenericModel.HtmlContent);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vConn.Query<UpsertCompanyOutputModel>(StoredProcedureConstants.SpInsertMail, vParams, commandTimeout: 0, commandType: CommandType.StoredProcedure);
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertSentMail", "CompanyStructureRepository ", sqlException.Message), sqlException);

            }
        }

        public int GetMailsCount(LoggedInContext loggedInContext)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<int>(StoredProcedureConstants.SpGetMailsCount, vParams, commandTimeout: 0, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetMailsCount", "CompanyStructureRepository ", sqlException.Message), sqlException);

                return 0;
            }
        }

        public bool UpsertCompanyConfigurationUrl(CompanyInputModel companyInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@ConfigurationUrl", companyInputModel.ConfigurationUrl);
                    return vConn.Query<bool>(StoredProcedureConstants.SpUpsertCompanyConfigurationUrl, vParams, commandType: CommandType.StoredProcedure).First();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCompanyConfigurationUrl", "CompanyStructureRepository", sqlException.Message),sqlException);
                return false;
            }
        }

        public bool UpdateCompanySettings(CompanyInputModel companyInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
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
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateCompanySettings", "CompanyStructureRepository", sqlException.Message), sqlException);
                return false;
            }
        }

        public string UpsertCompanySignUpDetails(CompanyInputModel registrationInputModel, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Name", registrationInputModel.UserName);
                    vParams.Add("@EmailAddress", registrationInputModel.EmailAddress);
                    vParams.Add("@SiteAddress", registrationInputModel.RegistrerSiteAddress);
                    vParams.Add("@VerificationCode", registrationInputModel.VerificationCode);
                    vParams.Add("@Otp", registrationInputModel.OTP);
                    vParams.Add("@IsResend", registrationInputModel.IsResend);
                    vParams.Add("@IsOtpVerify", registrationInputModel.IsOtpVerify);
                    vParams.Add("@IsVerified", registrationInputModel.IsVerify !=null ? registrationInputModel.IsVerify : false);
                    return vConn.Query<string>(StoredProcedureConstants.SpCompanyRegistrationUserDetails, vParams, commandType: CommandType.StoredProcedure).First();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCompanySignUpDetails", "CompanyStructureRepository", sqlException.Message),sqlException);
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionDeleteCompanyModule);
                return null;
            }
        }
        public string GetCompanyConfigurationUrl(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<string>(StoredProcedureConstants.SpGetCompanyConfigurationUrl, vParams, commandType: CommandType.StoredProcedure).First();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCompanyConfigurationUrl", "CompanyStructureRepository", sqlException.Message),sqlException);
                return string.Empty;
            }
        }

        public bool UpsertEmailVerifyDetails(CompanyInputModel registrationInputModel, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@RegistorId", registrationInputModel.RegistorId);
                    vParams.Add("@IsVerified", true);
                    return vConn.Query<bool>(StoredProcedureConstants.SpUpsertEmailVerifyDetails, vParams, commandType: CommandType.StoredProcedure).First();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmailVerifyDetails", "Company Structure Repository", sqlException.Message),sqlException);
                return false;
            }
        }
    }
}