using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.CompanyStructure;
using Btrak.Models.Employee;
using Btrak.Models.MasterData;
using Btrak.Models.SoftLabelConfigurations;
using Btrak.Models.User;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Models.PayRoll;

namespace Btrak.Dapper.Dal.Partial
{
    public class MasterDataManagementRepository : BaseRepository
    {
        public List<GetStatesOutputModel> GetStates(GetStatesSearchCriteriaInputModel getStatesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@StateId", getStatesSearchCriteriaInputModel.StateId);
                    vParams.Add("@SearchText", getStatesSearchCriteriaInputModel.SearchText);
                    vParams.Add("@IsArchived", getStatesSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<GetStatesOutputModel>(StoredProcedureConstants.SpGetStates, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetStates", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetStates);
                return new List<GetStatesOutputModel>();
            }
        }

    public bool GetCompanyWorkItemStartFunctionalityRequired(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
    {
      try
      {
        using (IDbConnection vConn = OpenConnection())
        {
          DynamicParameters vParams = new DynamicParameters();
          vParams.Add("@CompanyGuid", loggedInContext.CompanyGuid);
          vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
         return vConn.Query<bool>(StoredProcedureConstants.GetCompanyWorkItemStartFunctionalityRequired, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();        
        }
      }
      catch (SqlException sqlException)
      {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCompanyWorkItemStartFunctionalityRequired", "MasterDataManagementRepository", sqlException.Message), sqlException);

                return false;
      }
    }
        public bool GetAddOrEditCustomAppIsRequired(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CompanyGuid", loggedInContext.CompanyGuid);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<bool>(StoredProcedureConstants.SpGetCustomAppAddOrEditIsRequired, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAddOrEditCustomAppIsRequired", "MasterDataManagementRepository", sqlException.Message), sqlException);

                return false; ;
            }
        }
        public List<EmploymentStatusOutputModel> GetEmploymentStatus(EmploymentStatusSearchCriteriaInputModel getEmploymentStatusSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EmploymentStatusId", getEmploymentStatusSearchCriteriaInputModel.EmploymentStatusId);
                    vParams.Add("@EmploymentStatusName", getEmploymentStatusSearchCriteriaInputModel.EmploymentStatusName);
                    vParams.Add("@SearchText", getEmploymentStatusSearchCriteriaInputModel.SearchText);
                    vParams.Add("@IsArchived", getEmploymentStatusSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmploymentStatusOutputModel>(StoredProcedureConstants.SpGetEmploymentStatus, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmploymentStatus", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetEmploymentStatus);
                return new List<EmploymentStatusOutputModel>();
            }
        }

        public List<GetLicenceTypesOutputModel> GetLicenceTypes(GetLicenceTypesSearchCriteriaInputModel getLicenceTypesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@LicenceTypeId", getLicenceTypesSearchCriteriaInputModel.LicenceTypeId);
                    vParams.Add("@SearchText", getLicenceTypesSearchCriteriaInputModel.SearchText);
                    vParams.Add("@LicenceTypeName", getLicenceTypesSearchCriteriaInputModel.LicenceTypeName);
                    vParams.Add("@IsArchived", getLicenceTypesSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<GetLicenceTypesOutputModel>(StoredProcedureConstants.SpGetLicenceTypes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetLicenceTypes", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetLicenceTypes);
                return new List<GetLicenceTypesOutputModel>();
            }
        }

        public List<NationalityApiReturnModel> GetNationalities(NationalitySearchInputModel nationalitySearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@NationalityId", nationalitySearchInputModel.NationalityId);
                    vParams.Add("@SearchText", nationalitySearchInputModel.SearchText);
                    vParams.Add("@IsArchived", nationalitySearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<NationalityApiReturnModel>(StoredProcedureConstants.SpGetNationalities, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetNationalities", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetNationalities);
                return new List<NationalityApiReturnModel>();
            }
        }

        public List<ReportingMethodsOutputModel> GetReportingMethods(ReportingMethodsSearchCriteriaInputModel getReportingMethodsSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ReportingMethodId", getReportingMethodsSearchCriteriaInputModel.ReportingMethodId);
                    vParams.Add("@SearchText", getReportingMethodsSearchCriteriaInputModel.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsArchived", getReportingMethodsSearchCriteriaInputModel.IsArchived);
                    return vConn.Query<ReportingMethodsOutputModel>(StoredProcedureConstants.SpGetReportingMethods, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetReportingMethods", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetReportingMethods);
                return new List<ReportingMethodsOutputModel>();
            }
        }

        public List<PayFrequencyOutputModel> GetPayFrequency(PayFrequencySearchCriteriaInputModel payFrequencySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@PayFrequencyId", payFrequencySearchCriteriaInputModel.PayFrequencyId);
                    vParams.Add("@IsArchived", payFrequencySearchCriteriaInputModel.IsArchived);
                    vParams.Add("@SearchText", payFrequencySearchCriteriaInputModel.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<PayFrequencyOutputModel>(StoredProcedureConstants.SpGetPayFrequency, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPayFrequency", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetPayFrequency);
                return new List<PayFrequencyOutputModel>();
            }
        }

        public List<EducationLevelsOutputModel> GetEducationLevels(EducationLevelSearchInputModel educationLevelSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EducationLevelId", educationLevelSearchInputModel.EducationLevelId);
                    vParams.Add("@SearchText", educationLevelSearchInputModel.SearchText);
                    vParams.Add("@IsArchived", educationLevelSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EducationLevelsOutputModel>(StoredProcedureConstants.SpGetEducationLevels, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEducationLevels", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetEducationLevels);
                return new List<EducationLevelsOutputModel>();
            }
        }

        public List<EducationLevelsDropDownOutputModel> GetEducationLevelsDropDown(string searchText, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SearchText", searchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EducationLevelsDropDownOutputModel>(StoredProcedureConstants.SpGetEducationLevelsDropDown, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEducationLevelsDropDown", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllEducatonLevelsDropDown);
                return new List<EducationLevelsDropDownOutputModel>();
            }
        }

        public List<SkillsOutputModel> GetSkills(SkillsSearchCriteriaInputModel skillsSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SkillId", skillsSearchCriteriaInputModel.SkillId);
                    vParams.Add("@IsArchived", skillsSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@SearchText", skillsSearchCriteriaInputModel.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<SkillsOutputModel>(StoredProcedureConstants.SpGetSkills, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetSkills", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetSkills);
                return new List<SkillsOutputModel>();
            }
        }

        public List<CompetenciesOutputModel> GetCompetencies(GetCompetenciesSearchCriteriaInputModel getCompetenciesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CompetencyId", getCompetenciesSearchCriteriaInputModel.CompetencyId);
                    vParams.Add("@SearchText", getCompetenciesSearchCriteriaInputModel.SearchText);
                    vParams.Add("@IsArchived", getCompetenciesSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<CompetenciesOutputModel>(StoredProcedureConstants.SpGetCompetencies, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCompetencies", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetSkills);
                return new List<CompetenciesOutputModel>();
            }
        }

        public List<LanguageFluenciesOutputModel> GetLanguageFluencies(GetLanguageFluenciesSearchCriteriaInputModel getLanguageFluenciesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@LanguageFluencyId", getLanguageFluenciesSearchCriteriaInputModel.LanguageFluencyId);
                    vParams.Add("@SearchText", getLanguageFluenciesSearchCriteriaInputModel.SearchText);
                    vParams.Add("@IsArchived", getLanguageFluenciesSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<LanguageFluenciesOutputModel>(StoredProcedureConstants.SpGetLanguageFluencies, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetLanguageFluencies", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetLanguageFluencies);
                return new List<LanguageFluenciesOutputModel>();
            }
        }

        public List<LanguagesOutputModel> GetLanguages(GetLanguagesSearchCriteriaInputModel getLanguagesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@LanguageId", getLanguagesSearchCriteriaInputModel.LanguageId);
                    vParams.Add("@LanguageName", getLanguagesSearchCriteriaInputModel.LanguageName);
                    vParams.Add("@SearchText", getLanguagesSearchCriteriaInputModel.SearchText);
                    vParams.Add("@IsArchived", getLanguagesSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<LanguagesOutputModel>(StoredProcedureConstants.SpGetLanguages, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetLanguages", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetLanguages);
                return new List<LanguagesOutputModel>();
            }
        }

        public Guid? UpsertSubscriptionPaidByOption(SubscriptionPaidByUpsertInputModel subscriptionPaidByUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SubscriptionPaidById", subscriptionPaidByUpsertInputModel.SubscriptionPaidById);
                    vParams.Add("@SubscriptionPaidByName", subscriptionPaidByUpsertInputModel.SubscriptionPaidByName);
                    vParams.Add("@IsArchived", subscriptionPaidByUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", subscriptionPaidByUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertSubscriptionPaidByOption, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertSubscriptionPaidByOption", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertSubscriptionPaidBy);
                return null;
            }
        }

        public List<SubscriptionPaidByApiReturnModel> GetSubscriptionPaidByOptions(SubscriptionPaidBySearchCriteriaInputModel subscriptionPaidBySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SubscriptionPaidById", subscriptionPaidBySearchCriteriaInputModel.SubscriptionPaidById);
                    vParams.Add("@SearchText", subscriptionPaidBySearchCriteriaInputModel.SearchText);
                    vParams.Add("@IsArchived", subscriptionPaidBySearchCriteriaInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<SubscriptionPaidByApiReturnModel>(StoredProcedureConstants.SpGetSubscriptionPaidByOptions, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetSubscriptionPaidByOptions", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetSubscriptionPaidBys);
                return new List<SubscriptionPaidByApiReturnModel>();
            }
        }

        public List<MembershipApiReturnModel> GetMemberships(MembershipSearchCriteriaInputModel membershipSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@MemberShipId", membershipSearchCriteriaInputModel.MemberShipId);
                    vParams.Add("@MemberShipType", membershipSearchCriteriaInputModel.MemberShipType);
                    vParams.Add("@SearchText", membershipSearchCriteriaInputModel.SearchText);
                    vParams.Add("@IsArchived", membershipSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsArchived", membershipSearchCriteriaInputModel.IsArchived);
                    return vConn.Query<MembershipApiReturnModel>(StoredProcedureConstants.SpGetMemberships, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetMemberships", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetMemberships);
                return new List<MembershipApiReturnModel>();
            }
        }

        public Guid? UpsertTimeFormat(TimeFormatInputModel timeFormatInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@TimeFormatId", timeFormatInputModel.TimeFormatId);
                    vParams.Add("@TimeFormatDisplayText", timeFormatInputModel.TimeFormatName);
                    vParams.Add("@IsArchived", timeFormatInputModel.IsArchived);
                    vParams.Add("@TimeStamp", timeFormatInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertTimeFormat, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTimeFormat", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertTimeFormat);
                return null;
            }
        }

        public Guid? UpsertDateFormat(DateFormatInputModel dateFormatInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@DateFormatId", dateFormatInputModel.DateFormatId);
                    vParams.Add("@DateFormatText", dateFormatInputModel.DateFormatName);
                    vParams.Add("@IsArchived", dateFormatInputModel.IsArchived);
                    vParams.Add("@TimeStamp", dateFormatInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertDateFormat, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertDateFormat", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertDateFormat);
                return null;
            }
        }

        public Guid? UpsertMainUseCase(MainUseCaseInputModel mainUseCaseInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@MainUseCaseId", mainUseCaseInputModel.MainUseCaseId);
                    vParams.Add("@MainUseCaseName", mainUseCaseInputModel.MainUseCaseName);
                    vParams.Add("@IsArchived", mainUseCaseInputModel.IsArchived);
                    vParams.Add("@TimeStamp", mainUseCaseInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertMainUseCase, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertMainUseCase", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionMainUseCase);
                return null;
            }
        }

        public List<GetAccessibleIpAddressesOutputModel> GetAccessibleIpAddresses(GetAccessibleIpAddressesSearchCriteriaInputModel getAccessibleIpAddressesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@AccessisbleIpAdressesId", getAccessibleIpAddressesSearchCriteriaInputModel.AccessibleIpAddressesId);
                    vParams.Add("@IpAddress", getAccessibleIpAddressesSearchCriteriaInputModel.IpAddress);
                    vParams.Add("@Name", getAccessibleIpAddressesSearchCriteriaInputModel.Name);
                    vParams.Add("@SearchText", getAccessibleIpAddressesSearchCriteriaInputModel.SearchText);
                    vParams.Add("@IsArchived", getAccessibleIpAddressesSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<GetAccessibleIpAddressesOutputModel>(StoredProcedureConstants.SpGetAccessibleIpAddresses, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAccessibleIpAddresses", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAccessibleIpAddresses);
                return new List<GetAccessibleIpAddressesOutputModel>();
            }
        }

        public List<GetScriptsOutputModel> GetScripts(GetScriptsInputModel getScriptsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ScriptId", getScriptsInputModel.ScriptId);
                    vParams.Add("@Name", getScriptsInputModel.ScriptName);
                    vParams.Add("@Version", getScriptsInputModel.Version);
                    vParams.Add("@IsLatest", getScriptsInputModel.IsLatest);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<GetScriptsOutputModel>(StoredProcedureConstants.SpGetScripts, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetScripts", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAccessibleIpAddresses);
                return new List<GetScriptsOutputModel>();
            }
        }

        public List<GetScriptsOutputModel> GetScripts(GetScriptsInputModel getScriptsInputModel, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ScriptId", getScriptsInputModel.ScriptId);
                    vParams.Add("@Name", getScriptsInputModel.ScriptName);
                    vParams.Add("@Version", getScriptsInputModel.Version);
                    vParams.Add("@IsLatest", getScriptsInputModel.IsLatest);
                    return vConn.Query<GetScriptsOutputModel>(StoredProcedureConstants.SpGetScriptForDownload, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetScripts", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAccessibleIpAddresses);
                return new List<GetScriptsOutputModel>();
            }
        }

        public Guid? UpsertNumberFormat(NumberFormatInputModel numberFormatInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@NumberFormatId", numberFormatInputModel.NumberFormatId);
                    vParams.Add("@NumberFormat", numberFormatInputModel.NumberFormat);
                    vParams.Add("@IsArchived", numberFormatInputModel.IsArchived);
                    vParams.Add("@TimeStamp", numberFormatInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertNumberFormat, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertNumberFormat", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertNumberFormat);
                return null;
            }
        }

        public Guid? UpsertScript(GetScriptsInputModel scriptsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ScriptId", scriptsInputModel.ScriptId);
                    vParams.Add("@Name", scriptsInputModel.ScriptName);
                    vParams.Add("@Version", scriptsInputModel.Version);
                    vParams.Add("@Description", scriptsInputModel.Description);
                    vParams.Add("@ScriptUrl", scriptsInputModel.ScriptUrl);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertScript, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertScript", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertScript);
                return null;
            }
        }

        public void DeleteScript(Guid scriptId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ScriptId", scriptId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vConn.Query(StoredProcedureConstants.SpDeleteScript, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteScript", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertScript);
            }
        }

        public Guid? UpsertCompanyIntroducedByOption(CompanyIntroducedByOptionInputModel companyIntroducedByOptionInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@IntroducedByOptionId", companyIntroducedByOptionInputModel.CompanyIntroducedByOptionId);
                    vParams.Add("@Option", companyIntroducedByOptionInputModel.Option);
                    vParams.Add("@IsArchived", companyIntroducedByOptionInputModel.IsArchived);
                    vParams.Add("@TimeStamp", companyIntroducedByOptionInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertCompanyIntroducedByOption, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCompanyIntroducedByOption", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertCompanyIntroducedByOption);
                return null;
            }
        }

        public Guid? UpsertState(StateInputModel stateInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@StateId", stateInputModel.StateId);
                    vParams.Add("@StateName", stateInputModel.StateName);
                    vParams.Add("@IsArchived", stateInputModel.IsArchived);
                    vParams.Add("@TimeStamp", stateInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertState, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertState", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertState);
                return null;
            }
        }

        public Guid? UpsertReferenceType(ReferenceTypeInputModel referenceTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ReferenceTypeId", referenceTypeInputModel.ReferenceTypeId);
                    vParams.Add("@ReferenceTypeName", referenceTypeInputModel.ReferenceTypeName);
                    vParams.Add("@IsArchived", referenceTypeInputModel.IsArchived);
                    vParams.Add("@TimeStamp", referenceTypeInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertReferenceType, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertReferenceType", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertReferenceType);
                return null;
            }
        }

        public List<ReferenceTypeOutputModel> GetReferenceTypes(ReferenceTypeSearchCriteriaInputModel referenceTypeSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ReferenceTypeId", referenceTypeSearchCriteriaInputModel.ReferenceTypeId);
                    vParams.Add("@SearchText", referenceTypeSearchCriteriaInputModel.SearchText);
                    vParams.Add("@IsArchived", referenceTypeSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ReferenceTypeOutputModel>(StoredProcedureConstants.SpGetReferenceTypes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetReferenceTypes", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetReferenceTypes);
                return new List<ReferenceTypeOutputModel>();
            }
        }

        public Guid? UpsertLicenseType(LicenseTypeInputModel licenseTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@LicenseTypeId", licenseTypeInputModel.LicenceTypeId);
                    vParams.Add("@LicenseTypeName", licenseTypeInputModel.LicenceTypeName);
                    vParams.Add("@IsArchived", licenseTypeInputModel.IsArchived);
                    vParams.Add("@TimeStamp", licenseTypeInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertLicenseType, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertLicenseType", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertLicenseType);
                return null;
            }
        }

        public Guid? UpsertHoliday(HolidayInputModel holidayInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@HolidayId", holidayInputModel.HolidayId);
                    vParams.Add("@Reason", holidayInputModel.Reason);
                    vParams.Add("@Date", holidayInputModel.Date);
                    vParams.Add("@CountryId", holidayInputModel.CountryId);
                    vParams.Add("@IsArchived", holidayInputModel.IsArchived);
                    vParams.Add("@IsWeekOff", holidayInputModel.IsWeekOff);
                    vParams.Add("@DateFrom", holidayInputModel.DateFrom);
                    vParams.Add("@DateTo", holidayInputModel.DateTo);
                    vParams.Add("@WeekOffDays", holidayInputModel.WeekOffDays);
                    vParams.Add("@BranchId", holidayInputModel.BranchId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@TimeStamp", holidayInputModel.TimeStamp, DbType.Binary);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertHoliday, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertHoliday", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertHoliday);
                return null;
            }
        }

        public List<GetAllNationalitiesOutputModel> GetAllNationalities(GetAllNationalitiesSearchCriteriaInputModel getAllNationalitiesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@NationalityId", getAllNationalitiesSearchCriteriaInputModel.NationalityId);
                    vParams.Add("@SearchText", getAllNationalitiesSearchCriteriaInputModel.SearchText);
                    vParams.Add("@IsArchived", getAllNationalitiesSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<GetAllNationalitiesOutputModel>(StoredProcedureConstants.SpGetAllNationalities, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllNationalities", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllNationalities);
                return new List<GetAllNationalitiesOutputModel>();
            }
        }

        public List<GendersOutputModel> GetGenders(GendersSearchCriteriaInputModel gendersSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@GenderId", gendersSearchCriteriaInputModel.GenderId);
                    vParams.Add("@SearchText", gendersSearchCriteriaInputModel.SearchText);
                    vParams.Add("@IsArchived", gendersSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<GendersOutputModel>(StoredProcedureConstants.SpGetGenders, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetGenders", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetGenders);
                return new List<GendersOutputModel>();
            }
        }

        public List<MaritalStatusesOutputModel> GetMaritalStatuses(MaritalStatusesSearchCriteriaInputModel maritalStatusesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@MaritalStatusId", maritalStatusesSearchCriteriaInputModel.MaritalStatusId);
                    vParams.Add("@SearchText", maritalStatusesSearchCriteriaInputModel.SearchText);
                    vParams.Add("@IsArchived", maritalStatusesSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<MaritalStatusesOutputModel>(StoredProcedureConstants.SpGetMaritalStatuses, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetMaritalStatuses", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetMaritalStatuses);
                return new List<MaritalStatusesOutputModel>();
            }
        }

        public List<HolidaysOutputModel> GetHolidays(HolidaySearchCriteriaInputModel holidaySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@HolidayId", holidaySearchCriteriaInputModel.HolidayId);
                    vParams.Add("@Reason", holidaySearchCriteriaInputModel.Reason);
                    vParams.Add("@Date", holidaySearchCriteriaInputModel.Date);
                    vParams.Add("@CountryId", holidaySearchCriteriaInputModel.CountryId);
                    vParams.Add("@IsArchived", holidaySearchCriteriaInputModel.IsArchived);
                    vParams.Add("@BranchId", holidaySearchCriteriaInputModel.BranchId);
                    vParams.Add("@IsWeekOff", holidaySearchCriteriaInputModel.IsWeekOff);
                    vParams.Add("@PageNumber", holidaySearchCriteriaInputModel.PageNumber);
                    vParams.Add("@PageSize", holidaySearchCriteriaInputModel.PageSize);
                    vParams.Add("@SortBy", holidaySearchCriteriaInputModel.SortBy);
                    vParams.Add("@SortDirection", holidaySearchCriteriaInputModel.SortDirection);
                    vParams.Add("@DateFrom", holidaySearchCriteriaInputModel.DateFrom);
                    vParams.Add("@DateTo", holidaySearchCriteriaInputModel.DateTo);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<HolidaysOutputModel>(StoredProcedureConstants.SpGetHolidays, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetHolidays", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetHolidays);
                return new List<HolidaysOutputModel>();
            }
        }

        public Guid? UpsertEducationLevel(EducationLevelUpsertModel educationLevelUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@EducationLevelId", educationLevelUpsertModel.EducationLevelId);
                    vParams.Add("@EducationLevel", educationLevelUpsertModel.EducationLevelName);
                    vParams.Add("@IsArchived", educationLevelUpsertModel.IsArchived);
                    vParams.Add("@TimeStamp", educationLevelUpsertModel.TimeStamp,DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertEdcationLevel, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEducationLevel", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertEducationLevel);
                return null;
            }
        }

        public Guid? UpsertReportingMethod(ReportingMethodUpsertModel reportingMethodUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@ReportingMethodId", reportingMethodUpsertModel.ReportingMethodId);
                    vParams.Add("@ReportingMethodType", reportingMethodUpsertModel.ReportingMethodName);
                    vParams.Add("@IsArchived", reportingMethodUpsertModel.IsArchived);
                    vParams.Add("@TimeStamp", reportingMethodUpsertModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertReportingMethod, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertReportingMethod", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertReportingMethod);
                return null;
            }
        }

        public Guid? UpsertMembership(MembershipUpsertModel membershipUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@MembershipId", membershipUpsertModel.MembershipId);
                    vParams.Add("@MembershipType", membershipUpsertModel.MembershipName);
                    vParams.Add("@IsArchived", membershipUpsertModel.IsArchived);
                    vParams.Add("@TimeStamp", membershipUpsertModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertMembership, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertMembership", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertMembership);
                return null;
            }
        }

        public Guid? UpsertEmploymentStatus(EmploymentStatusInputModel employmentStatusInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EmploymentStatusId", employmentStatusInputModel.EmploymentStatusId);
                    vParams.Add("@EmploymentStatusName", employmentStatusInputModel.EmploymentStatusName);
                    vParams.Add("@TimeStamp", employmentStatusInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", employmentStatusInputModel.IsArchived);
                    vParams.Add("@IsPermanent", employmentStatusInputModel.IsPermanent);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertEmploymentStatus, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmploymentStatus", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionEmploymentStatus);
                return null;
            }
        }

        public Guid? UpsertPayFrequency(PayFrequencyUpsertModel payFrequencyUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@PayFrequencyId", payFrequencyUpsertModel.PayFrequencyId);
                    vParams.Add("@PayFrequencyName", payFrequencyUpsertModel.PayFrequencyName);
                    vParams.Add("@TimeStamp", payFrequencyUpsertModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", payFrequencyUpsertModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@CronExpression", payFrequencyUpsertModel.CronExpression);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertPayFrequency, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPayFrequency", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionPayFrequency);
                return null;
            }
        }

        public Guid? UpsertNationality(NationalityUpsertModel nationalityUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@NationalityId", nationalityUpsertModel.NationalityId);
                    vParams.Add("@NationalityName", nationalityUpsertModel.NationalityName);
                    vParams.Add("@TimeStamp", nationalityUpsertModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", nationalityUpsertModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertNationality, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertNationality", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionNationality);
                return null;
            }
        }

        public Guid? UpsertLanguage(LanguageUpsertModel languageUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@LanguageId", languageUpsertModel.LanguageId);
                    vParams.Add("@LanguageName", languageUpsertModel.LanguageName);
                    vParams.Add("@TimeStamp", languageUpsertModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", languageUpsertModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertLanguage, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertLanguage", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionLanguage);
                return null;
            }
        }

        public Guid? UpsertJobCategories(JobCategoriesUpsertModel jobCategoriesUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@JobCategory", jobCategoriesUpsertModel.JobCategoryName);
                    vParams.Add("@JobCategoryId", jobCategoriesUpsertModel.JobCategoryId);
                    vParams.Add("@TimeStamp", jobCategoriesUpsertModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", jobCategoriesUpsertModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertJobCategory, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertJobCategories", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionLanguage);
                return null;
            }
        }
        
        public List<JobCategorySearchOutputModel> SearchJobCategoryDetails(JobCategorySearchInputModel jobCategorySearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@JobCategoryId", jobCategorySearchInputModel.JobCategoryId);
                    vParams.Add("@JobCategory", jobCategorySearchInputModel.JobCategoryName);
                    vParams.Add("@SearchText", jobCategorySearchInputModel.SearchText);
                    vParams.Add("@IsArchived", jobCategorySearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<JobCategorySearchOutputModel>(StoredProcedureConstants.SpGetJobCategoryDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchJobCategoryDetails", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetJobCategories);
                return new List<JobCategorySearchOutputModel>();
            }
        }

        public List<AppSettingsOutputModel> GetAppsettings(Appsettings appSettingSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@AppsettingsId", appSettingSearchInputModel.AppsettingsId);
                    vParams.Add("@SearchText", appSettingSearchInputModel.SearchText);
                    vParams.Add("@AppSettingsName", appSettingSearchInputModel.AppSettingsName);
                    vParams.Add("@IsArchived", appSettingSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    
                    return vConn.Query<AppSettingsOutputModel>(StoredProcedureConstants.SpGetAppSettings, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAppsettings", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAppSetting);
                return new List<AppSettingsOutputModel>();
            }
        }

        public Guid? UpsertAppSettings(AppSettingsUpsertInputModel appSettingsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@AppsettingsId", appSettingsUpsertInputModel.AppSettingsId);
                    vParams.Add("@AppsettingsName", appSettingsUpsertInputModel.AppSettingsName);
                    vParams.Add("@AppsettingsValue", appSettingsUpsertInputModel.AppSettingsValue);
                    vParams.Add("@IsArchived", appSettingsUpsertInputModel.IsArchived);
                    vParams.Add("@IsSystemLevel", appSettingsUpsertInputModel.IsSystemLevel);
                    vParams.Add("@TimeStamp", appSettingsUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertAppSettings, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertAppSettings", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertAppSetting);
                return null;
            }
        }

        public Guid? UpsertCompanySettings(CompanySettingsUpsertInputModel companySettingsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CompanySettingsId", companySettingsUpsertInputModel.CompanySettingsId);
                    vParams.Add("@Key", companySettingsUpsertInputModel.Key);
                    vParams.Add("@Value", companySettingsUpsertInputModel.Value);
                    vParams.Add("@Description", companySettingsUpsertInputModel.Description);
                    vParams.Add("@IsArchived", companySettingsUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", companySettingsUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsVisible", companySettingsUpsertInputModel.IsVisible);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertCompanySettings, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCompanySettings", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertCompanySettings);
                return null;
            }
        }

        public virtual List<CompanySettingsSearchOutputModel> GetCompanySettings(CompanySettingsSearchInputModel companySettingsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
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
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCompanySettings", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCompanySettings);
                return new List<CompanySettingsSearchOutputModel>();
            }
        }

        public Guid? ValidateAndUpsertGoogleUser(GoogleNewUserModel googleNewUser, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FirstName", googleNewUser.FirstName);
                    vParams.Add("@SurName", googleNewUser.SurName);
                    vParams.Add("@UserDomain", googleNewUser.UserDomain);
                    vParams.Add("@Email", googleNewUser.Email);
                    vParams.Add("@Password", googleNewUser.Password);
                    vParams.Add("@ProfileImage", googleNewUser.ProfileImage);
                    vParams.Add("@SiteAddress", googleNewUser.SiteAddress);
                    vParams.Add("@CanByPassUserCompanyValidation", googleNewUser.CanByPassUserCompanyValidation);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpValidateAndUpsertGoogleUser, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ValidateAndUpsertGoogleUser", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionLoggedInUser);
                return null;
            }
        }
        public List<LeaveFrequencySearchOutputModel> GetLeaveFrequencies(LeaveFrequencySearchInputModel leaveFrequencySearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@LeaveFrequencyId ", leaveFrequencySearchInputModel.LeaveFrequencyId);
                    vParams.Add("@DateFrom ", leaveFrequencySearchInputModel.FromDate);
                    vParams.Add("@DateTo ", leaveFrequencySearchInputModel.ToDate);
                    vParams.Add("@NoOfLeaves", leaveFrequencySearchInputModel.NoOfLeaves);
                    vParams.Add("@IsArchived", leaveFrequencySearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@LeaveTypeId", leaveFrequencySearchInputModel.LeaveTypeId);
                    vParams.Add("@IsToGetLeaveTypes", leaveFrequencySearchInputModel.IsToGetLeaveTypes);
                    vParams.Add("@PageNumber", leaveFrequencySearchInputModel.PageNumber);
                    vParams.Add("@Date", leaveFrequencySearchInputModel.Date);
                    vParams.Add("@SearchText", leaveFrequencySearchInputModel.SearchText);
                    vParams.Add("@PageSize", leaveFrequencySearchInputModel.PageSize);
                    vParams.Add("@SortBy", leaveFrequencySearchInputModel.SortBy);
                    vParams.Add("@SortDirection", leaveFrequencySearchInputModel.SortDirection);
                    return vConn.Query<LeaveFrequencySearchOutputModel>(StoredProcedureConstants.SpGetLeaveFrequencies, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetLeaveFrequencies", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetLeaveFrequencies);
                return new List<LeaveFrequencySearchOutputModel>();
            }
        }

        public Guid? UpsertLeaveFrequency(LeaveFrequencyUpsertInputModel leaveFrequencyUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@LeaveFrequencyId", leaveFrequencyUpsertInputModel.LeaveFrequencyId);
                    vParams.Add("@DateFrom", leaveFrequencyUpsertInputModel.DateFrom);
                    vParams.Add("@DateTo", leaveFrequencyUpsertInputModel.DateTo);
                    vParams.Add("@NoOfLeaves", leaveFrequencyUpsertInputModel.NoOfLeaves);
                    vParams.Add("@IsArchived", leaveFrequencyUpsertInputModel.IsArchived);
                    vParams.Add("@LeaveTypeId", leaveFrequencyUpsertInputModel.LeaveTypeId);
                    vParams.Add("@EncashMentTypeId", leaveFrequencyUpsertInputModel.EncashmentTypeId);
                    vParams.Add("@LeaveFormulaId", leaveFrequencyUpsertInputModel.LeaveFormulaId);
                    vParams.Add("@NoOfDaysToBeIntimated", leaveFrequencyUpsertInputModel.NoOfDaysToBeIntimated);
                    vParams.Add("@IsToCarryForward", leaveFrequencyUpsertInputModel.IsToCarryForward);
                    vParams.Add("@RestrictionTypeId", leaveFrequencyUpsertInputModel.RestrictionTypeId);
                    vParams.Add("@CarryForwardLeavesCount", leaveFrequencyUpsertInputModel.CarryForwardLeavesCount);
                    vParams.Add("@PayableLeavesCount", leaveFrequencyUpsertInputModel.PayableLeavesCount);
                    vParams.Add("@IsToIncludeHolidays", leaveFrequencyUpsertInputModel.IsToIncludeHolidays);
                    vParams.Add("@IsToRepeatTheInterval", leaveFrequencyUpsertInputModel.IsToRepeatInterval);
                    vParams.Add("@IsPaid", leaveFrequencyUpsertInputModel.IsPaid);
                    vParams.Add("@IsAutoApproval", leaveFrequencyUpsertInputModel.IsAutoApproval);
                    vParams.Add("@IsEncashable", leaveFrequencyUpsertInputModel.IsEncashable);
                    vParams.Add("@EmploymentTypeId", leaveFrequencyUpsertInputModel.EmploymentStatusId);
                    vParams.Add("@EncashedLeavesCount", leaveFrequencyUpsertInputModel.EncashedLeavesCount);
                    vParams.Add("@TimeStamp", leaveFrequencyUpsertInputModel.LeaveFrequencyTimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertLeaveFrequencies, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertLeaveFrequency", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertLeaveFrequencies);
                return null;
            }
        }
        public List<UserStoryTypeDropDownOutputModel> GetUserStoryTypeDropDown(bool? isArchived, string searchText, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@IsArchived", isArchived);
                    vParams.Add("@SearchText", searchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<UserStoryTypeDropDownOutputModel>(StoredProcedureConstants.SpGetUserStoryTypeDropDown, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserStoryTypeDropDown", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetUserStoryTypeDropDown);
                return new List<UserStoryTypeDropDownOutputModel>();
            }
        }
        public List<LeaveFormulSearchOutputModel> GetLeaveFormula(LeaveFormulaSearchInputModel leaveFormulaSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@LeaveFormulaId ", leaveFormulaSearchInputModel.LeaveFormulaId);
                    vParams.Add("@NoOfDays ", leaveFormulaSearchInputModel.NoOfDays);
                    vParams.Add("@NoOfLeaves ", leaveFormulaSearchInputModel.NoOfLeaves);
                    vParams.Add("@IsArchived", leaveFormulaSearchInputModel.IsArchived);
                    vParams.Add("@Formula", leaveFormulaSearchInputModel.Formula);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<LeaveFormulSearchOutputModel>(StoredProcedureConstants.SpGetLeaveFormula, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetLeaveFormula", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetLeaveFormula);
                return new List<LeaveFormulSearchOutputModel>();
            }
        }

        public Guid? UpsertLeaveFormula(LeaveFormulaUpsertInputModel leaveFormulaUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@LeaveFormulaId", leaveFormulaUpsertInputModel.LeaveFormulaId);
                    vParams.Add("@Formula", leaveFormulaUpsertInputModel.Formula);
                    vParams.Add("@SalaryTypeId", leaveFormulaUpsertInputModel.SalaryTypeId);
                    vParams.Add("@NoOfDays", leaveFormulaUpsertInputModel.NoOfDays);
                    vParams.Add("@NoOfLeaves", leaveFormulaUpsertInputModel.NoOfLeaves);
                    vParams.Add("@IsArchived", leaveFormulaUpsertInputModel.IsArchived);
                    vParams.Add("@PayroleId", leaveFormulaUpsertInputModel.PayroleId);
                    vParams.Add("@TimeStamp", leaveFormulaUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertLeaveFormula, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertLeaveFormula", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertLeaveFrequencies);
                return null;
            }
        }

        public List<EncashmentTypeSearchOutputModel> GetEncashmentTypes(SearchCriteriaInputModelBase searchCriteriaInputModelBase , LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SearchText ", searchCriteriaInputModelBase.SearchText);
                    vParams.Add("@EncashmentTypeId ", null);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EncashmentTypeSearchOutputModel>(StoredProcedureConstants.SpGetEncashmentTypes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEncashmentTypes", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEncashmentTypes);
                return new List<EncashmentTypeSearchOutputModel>();
            }
        }

        public List<RestrictionTypeSearchOutputModel> GetRestictiontypes(RestrictionTypeSearchInputModel restrictionTypeSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SearchText ", restrictionTypeSearchInputModel.SearchText);
                    vParams.Add("@RestrictionTypeId ", restrictionTypeSearchInputModel.RestrictionTypeId);
                    vParams.Add("@IsArchived ", restrictionTypeSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<RestrictionTypeSearchOutputModel>(StoredProcedureConstants.SpGetRestrictionTypes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetRestictiontypes", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetRestrictionTypes);
                return new List<RestrictionTypeSearchOutputModel>();
            }
        }

        public Guid? UpsertRestrictiontype(RestrictionTypeUpsertInputModel restrictionTypeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@RestrictionTypeId ", restrictionTypeUpsertInputModel.RestrictionTypeId);
                    vParams.Add("@Restriction ", restrictionTypeUpsertInputModel.RestrictionType);
                    vParams.Add("@IsArchived ", restrictionTypeUpsertInputModel.IsArchived);
                    vParams.Add("@LeavesCount ", restrictionTypeUpsertInputModel.LeavesCount);
                    vParams.Add("@IsWeekly ", restrictionTypeUpsertInputModel.IsWeekly);
                    vParams.Add("@IsMonthly ", restrictionTypeUpsertInputModel.IsMonthly);
                    vParams.Add("@IsQuarterly ", restrictionTypeUpsertInputModel.IsQuarterly);
                    vParams.Add("@IsHalfYearly ", restrictionTypeUpsertInputModel.IsHalfYearly);
                    vParams.Add("@IsYearly ", restrictionTypeUpsertInputModel.IsYearly);
                    vParams.Add("@TimeStamp", restrictionTypeUpsertInputModel.TimeStamp,DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query <Guid?>(StoredProcedureConstants.SpUpserttRestrictionTypes, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertRestrictiontype", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertRestrictionTypes);
                return null;
            }
        }

        public List<ModuleDetailsModel> GetModulesList(ModuleDetailsModel moduleDetailsModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ModuleId", moduleDetailsModel.ModuleId);
                    vParams.Add("@ModuleName", moduleDetailsModel.ModuleName);
                    vParams.Add("@SortBy", moduleDetailsModel.SortBy);
                    vParams.Add("@SortDirection", moduleDetailsModel.SortDirection);
                    vParams.Add("@PageSize", moduleDetailsModel.PageSize);
                    vParams.Add("@PageNumber", moduleDetailsModel.PageNumber);
                    vParams.Add("@IsArchived", moduleDetailsModel.IsArchived);
                    vParams.Add("@IsForCustomApp", moduleDetailsModel.IsForCustomApp);
                    vParams.Add("@SearchText", moduleDetailsModel.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ModuleDetailsModel>(StoredProcedureConstants.SpGetModules, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetModulesList", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetUserStoryTypeDropDown);
                return new List<ModuleDetailsModel>();
            }
        }

        public List<ModuleDetailsModel> GetCompanyModulesList(ModuleDetailsModel moduleDetailsModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CompanyModuleId", moduleDetailsModel.CompanyModuleId);
                    vParams.Add("@ModuleId", moduleDetailsModel.ModuleId);
                    vParams.Add("@SortBy", moduleDetailsModel.SortBy);
                    vParams.Add("@SortDirection", moduleDetailsModel.SortDirection);
                    vParams.Add("@PageSize", moduleDetailsModel.PageSize);
                    vParams.Add("@PageNumber", moduleDetailsModel.PageNumber);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ModuleDetailsModel>(StoredProcedureConstants.SpGetCompanyModules, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCompanyModulesList", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetUserStoryTypeDropDown);
                return new List<ModuleDetailsModel>();
            }
        }

        public Guid? UpsertCompanyModule(ModuleDetailsModel moduleDetailsModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CompanyModuleId", moduleDetailsModel.CompanyModuleId);
                    vParams.Add("@ModuleIdXml", moduleDetailsModel.ModuleIdXml);
                    vParams.Add("@IsActive", moduleDetailsModel.IsActive);
                    vParams.Add("@IsEnabled", moduleDetailsModel.IsEnabled);
                    vParams.Add("@IsFromSupportUser", moduleDetailsModel.IsFromSupportUser);
                    vParams.Add("@TimeStamp", moduleDetailsModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertCompanyModule, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCompanyModule", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertCompanySettings);
                return null;
            }
        }

        public string UpsertCompanyLogo(UploadProfileImageInputModel uploadProfileImageInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@LogoData", uploadProfileImageInputModel.ProfileImage);
                    vParams.Add("@LogoType", uploadProfileImageInputModel.LogoType);
                    vParams.Add("@TimeStamp", uploadProfileImageInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<string>(StoredProcedureConstants.SpUpsertCompanyLogo, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCompanyLogo", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertCompanySettings);
                return null;
            }
        }


        public List<ProfessionalTaxRange> GetProfessionalTaxRanges(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {

                     DynamicParameters vParams = new DynamicParameters();
                     vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                  
                     return vConn.Query<ProfessionalTaxRange>(StoredProcedureConstants.SpGetProfessionalTaxRanges, vParams,commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetProfessionalTaxRanges", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetProfessionalTaxRange);
                return new List<ProfessionalTaxRange>();
            }
        }

        public List<TaxSlabs> GetTaxSlabs(TaxSlabs taxSlabs, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@TaxSlabName", taxSlabs.Name);

                    return vConn.Query<TaxSlabs>(StoredProcedureConstants.SpGetTaxSlabs, vParams,commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTaxSlabs", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetTaxSlabs);
                return new List<TaxSlabs>();
            }
        }

        public Guid? UpsertProfessionalTaxRanges(ProfessionalTaxRange professionalTaxRange, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Id", professionalTaxRange.Id);
                    vParams.Add("@FromRange", professionalTaxRange.FromRange);
                    vParams.Add("@ToRange", professionalTaxRange.ToRange);
                    vParams.Add("@TaxAmount", professionalTaxRange.TaxAmount);
                    vParams.Add("@IsArchived", professionalTaxRange.IsArchived);
                    vParams.Add("@BranchId", professionalTaxRange.BranchId);
                    vParams.Add("@ActiveFrom", professionalTaxRange.ActiveFrom);
                    vParams.Add("@ActiveTo", professionalTaxRange.ActiveTo);

                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertProfessionalTaxRange, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertProfessionalTaxRanges", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertProfessionalTaxRanges);
                return null;
            }
        }

        public Guid? UpsertTaxSlabs(TaxSlabsUpsertInputModel taxSlab, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {

            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                  
                    vParams.Add("@TaxSlabId", taxSlab.TaxSlabId);
                    vParams.Add("@Name", taxSlab.Name);
                    vParams.Add("@FromRange", taxSlab.FromRange);
                    vParams.Add("@ToRange", taxSlab.ToRange);
                    vParams.Add("@TaxPercentage", taxSlab.TaxPercentage);
                    vParams.Add("@ActiveFrom", taxSlab.ActiveFrom);
                    vParams.Add("@ActiveTo", taxSlab.ActiveTo);
                    vParams.Add("@MinAge", taxSlab.MinAge);
                    vParams.Add("@MaxAge", taxSlab.MaxAge);
                    vParams.Add("@ForMale", taxSlab.ForMale);
                    vParams.Add("@ForFemale", taxSlab.ForFemale);
                    vParams.Add("@Handicapped", taxSlab.Handicapped);
                    vParams.Add("@Order", taxSlab.Order);
                    vParams.Add("@IsArchived", taxSlab.IsArchived);
                    vParams.Add("@ParentId", taxSlab.ParentId);
                    vParams.Add("@CountryId", taxSlab.CountryId);
                    vParams.Add("@PayRollTemplateIds", taxSlab.PayRollTempalteXml);
                    vParams.Add("@TimeStamp", taxSlab.TimeStamp, DbType.Binary);
                    vParams.Add("@IsFlatRate", taxSlab.IsFlatRate);
                    vParams.Add("@TaxCalculationTypeId", taxSlab.TaxCalculationTypeId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    

                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertTaxSlabs, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTaxSlabs", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.UpsertTaxSlabs);
                return null;
            }
        }

        public Guid? UpsertSoftLabelConfigurations(UpsertSoftLabelConfigurationsModel softLabelUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SoftLabelConfigurationId", softLabelUpsertInputModel.SoftLabelConfigurationId);
                    vParams.Add("@ProjectLabel", softLabelUpsertInputModel.ProjectLabel);
                    vParams.Add("@GoalLabel", softLabelUpsertInputModel.GoalLabel);
                    vParams.Add("@EmployeeLabel", softLabelUpsertInputModel.EmployeeLabel);
                    vParams.Add("@UserStoryLabel", softLabelUpsertInputModel.UserStoryLabel);
                    vParams.Add("@DeadlineLabel", softLabelUpsertInputModel.DeadlineLabel);
                    vParams.Add("@ProjectsLabel", softLabelUpsertInputModel.ProjectsLabel);
                    vParams.Add("@GoalsLabel", softLabelUpsertInputModel.GoalsLabel);
                    vParams.Add("@EmployeesLabel", softLabelUpsertInputModel.EmployeesLabel);
                    vParams.Add("@UserStoriesLabel", softLabelUpsertInputModel.UserStoriesLabel);
                    vParams.Add("@DeadlinesLabel", softLabelUpsertInputModel.DeadlinesLabel);
                    vParams.Add("@ScenarioLabel", softLabelUpsertInputModel.ScenarioLabel);
                    vParams.Add("@ScenariosLabel", softLabelUpsertInputModel.ScenariosLabel);
                    vParams.Add("@RunLabel", softLabelUpsertInputModel.RunLabel);
                    vParams.Add("@RunsLabel", softLabelUpsertInputModel.RunsLabel);
                    vParams.Add("@VersionLabel", softLabelUpsertInputModel.VersionLabel);
                    vParams.Add("@VersionsLabel", softLabelUpsertInputModel.VersionsLabel);
                    vParams.Add("@TestReportLabel", softLabelUpsertInputModel.TestReportLabel);
                    vParams.Add("@TestReportsLabel", softLabelUpsertInputModel.TestReportsLabel);
                    vParams.Add("@EstimatedTimeLabel", softLabelUpsertInputModel.EstimatedTimeLabel);
                    vParams.Add("@EstimationsLabel", softLabelUpsertInputModel.EstimationsLabel);
                    vParams.Add("@EstimationLabel", softLabelUpsertInputModel.EstimationLabel);
                    vParams.Add("@EstimatesLabel", softLabelUpsertInputModel.EstimatesLabel);
                    vParams.Add("@EstimateLabel", softLabelUpsertInputModel.EstimateLabel);
                    vParams.Add("@AuditLabel", softLabelUpsertInputModel.AuditLabel);
                    vParams.Add("@AuditsLabel", softLabelUpsertInputModel.AuditsLabel);
                    vParams.Add("@ConductLabel", softLabelUpsertInputModel.ConductLabel);
                    vParams.Add("@ConductsLabel", softLabelUpsertInputModel.ConductsLabel);
                    vParams.Add("@ActionLabel", softLabelUpsertInputModel.ActionLabel);
                    vParams.Add("@ActionsLabel", softLabelUpsertInputModel.ActionsLabel);
                    vParams.Add("@TimelineLabel", softLabelUpsertInputModel.TimelineLabel);
                    vParams.Add("@AuditActivityLabel", softLabelUpsertInputModel.AuditActivityLabel);
                    vParams.Add("@AuditAnalyticsLabel", softLabelUpsertInputModel.AuditAnalyticsLabel);
                    vParams.Add("@AuditReportLabel", softLabelUpsertInputModel.AuditReportLabel);
                    vParams.Add("@AuditReportsLabel", softLabelUpsertInputModel.AuditReportsLabel);
                    vParams.Add("@ReportLabel", softLabelUpsertInputModel.ReportLabel);
                    vParams.Add("@ReportsLabel", softLabelUpsertInputModel.ReportsLabel);
                    vParams.Add("@AuditQuestionLabel", softLabelUpsertInputModel.AuditQuestionLabel);
                    vParams.Add("@AuditQuestionsLabel", softLabelUpsertInputModel.AuditQuestionsLabel);
                    vParams.Add("@ClientLabel", softLabelUpsertInputModel.ClientLabel);
                    vParams.Add("@ClientsLabel", softLabelUpsertInputModel.ClientsLabel);
                    vParams.Add("@IsArchived", softLabelUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", softLabelUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertSoftLabelConfigurations, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertSoftLabelConfigurations", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertSoftLabelConfigurations);
                return null;
            }
        }

        public List<SoftLabelApiReturnModel> GetSoftLabelConfigurations(SoftLabelsSearchInputModel softLabelsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SoftLabelConfigurationId", softLabelsSearchInputModel.SoftLabelConfigurationId);
                    vParams.Add("@SearchText", softLabelsSearchInputModel.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<SoftLabelApiReturnModel>(StoredProcedureConstants.SpGetSoftLabelConfigurations, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetSoftLabelConfigurations", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetSoftLabelConfigurations);
                return new List<SoftLabelApiReturnModel>();
            }
        }

        public List<RateSheetOutputModel> GetRateSheets(RateSheetSearchCriteriaInputModel rateSheetSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@RateSheetId", rateSheetSearchCriteriaInputModel.RateSheetId);
                    vParams.Add("@RateSheetName", rateSheetSearchCriteriaInputModel.RateSheetName);
                    vParams.Add("@RateSheetForId", rateSheetSearchCriteriaInputModel.RateSheetForId);
                    vParams.Add("@SearchText", rateSheetSearchCriteriaInputModel.SearchText);
                    vParams.Add("@IsArchived", rateSheetSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@SortBy", rateSheetSearchCriteriaInputModel.SortBy);
                    vParams.Add("@SortDirection", rateSheetSearchCriteriaInputModel.SortDirection);
                    vParams.Add("@PageNo", rateSheetSearchCriteriaInputModel.PageNumber);
                    vParams.Add("@PageSize", rateSheetSearchCriteriaInputModel.PageSize);
                    return vConn.Query<RateSheetOutputModel>(StoredProcedureConstants.SpGetAllRateSheets, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetRateSheets", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetRateSheets);
                return new List<RateSheetOutputModel>();
            }
        }

        public List<RateSheetForOutputModel> GetRateSheetForNames(RateSheetForSearchCriteriaInputModel rateSheetForSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<RateSheetForOutputModel>(StoredProcedureConstants.SpGetAllRateSheetForNames, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetRateSheetForNames", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetRateSheetForNames);
                return new List<RateSheetForOutputModel>();
            }
        }


        public Guid? UpsertRateSheet(RateSheetInputModel rateSheetInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@RateSheetId", rateSheetInputModel.RateSheetId);
                    vParams.Add("@RateSheetName", rateSheetInputModel.RateSheetName);
                    vParams.Add("@RateSheetForId", rateSheetInputModel.RateSheetForId);
                    vParams.Add("@RatePerHour", rateSheetInputModel.RatePerHour);
                    vParams.Add("@RatePerHourMon", rateSheetInputModel.RatePerHourMon);
                    vParams.Add("@RatePerHourTue", rateSheetInputModel.RatePerHourTue);
                    vParams.Add("@RatePerHourWed", rateSheetInputModel.RatePerHourWed);
                    vParams.Add("@RatePerHourThu", rateSheetInputModel.RatePerHourThu);
                    vParams.Add("@RatePerHourFri", rateSheetInputModel.RatePerHourFri);
                    vParams.Add("@RatePerHourSat", rateSheetInputModel.RatePerHourSat);
                    vParams.Add("@RatePerHourSun", rateSheetInputModel.RatePerHourSun);
                    vParams.Add("@TimeStamp", rateSheetInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", rateSheetInputModel.IsArchived);
                    vParams.Add("@Priority", rateSheetInputModel.Priority);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertRateSheet, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertRateSheet", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionRateSheet);
                return null;
            }
        }


        public List<PeakHourOutputModel> GetPeakHours(PeakHourSearchCriteriaInputModel peakHourSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@PeakHourId", peakHourSearchCriteriaInputModel.PeakHourId);
                    vParams.Add("@SearchText", peakHourSearchCriteriaInputModel.SearchText);
                    vParams.Add("@IsArchived", peakHourSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@SortBy", peakHourSearchCriteriaInputModel.SortBy);
                    vParams.Add("@SortDirection", peakHourSearchCriteriaInputModel.SortDirection);
                    vParams.Add("@PageNo", peakHourSearchCriteriaInputModel.PageNumber);
                    vParams.Add("@PageSize", peakHourSearchCriteriaInputModel.PageSize);
                    return vConn.Query<PeakHourOutputModel>(StoredProcedureConstants.SpGetAllPeakHours, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPeakHours", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetPeakHours);
                return new List<PeakHourOutputModel>();
            }
        }

        public Guid? UpsertPeakHour(PeakHourInputModel peakHourInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@PeakHourId", peakHourInputModel.PeakHourId);
                    vParams.Add("@PeakHourOn", peakHourInputModel.PeakHourOn);
                    vParams.Add("@FilterType", peakHourInputModel.FilterType);
                    vParams.Add("@PeakHourFrom", peakHourInputModel.PeakHourFrom);
                    vParams.Add("@PeakHourTo", peakHourInputModel.PeakHourTo);
                    vParams.Add("@IsPeakHour", peakHourInputModel.IsPeakHour);
                    vParams.Add("@TimeStamp", peakHourInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", peakHourInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertPeakHour, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPeakHour", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionPeakHour);
                return null;
            }
        }

        public List<WeekdayOutputModel> GetWeekdays(WeekdaySearchCriteriaInputModel weekdaySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@WeekDayId", weekdaySearchCriteriaInputModel.WeekDayId);
                    vParams.Add("@WeekDayName", weekdaySearchCriteriaInputModel.WeekDayName);
                    vParams.Add("@IsHalfDay", weekdaySearchCriteriaInputModel.IsHalfDay);
                    vParams.Add("@IsWeekEnd", weekdaySearchCriteriaInputModel.IsWeekEnd);
                    vParams.Add("@IsArchived", weekdaySearchCriteriaInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<WeekdayOutputModel>(StoredProcedureConstants.SpGetWeekdays, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetWeekdays", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetWeekdays);
                return new List<WeekdayOutputModel>();
            }
        }

        public Guid? UpsertSpecificDay(SpecificDayInputModel specificDayInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@SpecificDayId", specificDayInputModel.SpecificDayId);
                    vParams.Add("@Reason", specificDayInputModel.Reason);
                    vParams.Add("@Date", specificDayInputModel.Date);
                    vParams.Add("@IsArchived", specificDayInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@TimeStamp", specificDayInputModel.TimeStamp, DbType.Binary);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertSpecificDay, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertSpecificDay", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertSpecificDay);
                return null;
            }
        }

        public List<SpecificDayOutPutModel> GetSpecificDays(SpecificDaySearchCriteriaInputModel specificDaySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@SpecificDayId", specificDaySearchCriteriaInputModel.SpecificDayId);
                    vParams.Add("@IsArchived", specificDaySearchCriteriaInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<SpecificDayOutPutModel>(StoredProcedureConstants.SpGetSpecificDays, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetSpecificDays", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetSpecificDays);
                return new List<SpecificDayOutPutModel>();
            }
        }

        public DocumentSettingsSearchOutputModel GetDocumentStorageSettings(CompanySettingsSearchInputModel companySettingsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CompanySettingsId", companySettingsSearchInputModel.CompanySettingsId);
                    vParams.Add("@Key", companySettingsSearchInputModel.Key);
                    vParams.Add("@Value", companySettingsSearchInputModel.Value);
                    vParams.Add("@IsArchived", companySettingsSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<DocumentSettingsSearchOutputModel>(StoredProcedureConstants.SpGetDocumentStorageSettings, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDocumentStorageSettings", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCompanySettings);
                return new DocumentSettingsSearchOutputModel();
            }
        }

        public List<CompanyHierarchyModel> GetCompanyHierarchicalStructure(CompanyHierarchyModel companySettingsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<CompanyHierarchyModel>(StoredProcedureConstants.SpGetCompanyHierarchicalStructure, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCompanyHierarchicalStructure", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCompanySettings);
                return new List<CompanyHierarchyModel>();
            }
        }

        public Guid? UpsertCompanyStructure(CompanyHierarchyModel companySettingsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EntityId", companySettingsSearchInputModel.EntityId);
                    vParams.Add("@EntityName", companySettingsSearchInputModel.EntityName);
                    vParams.Add("@IsEntity", companySettingsSearchInputModel.IsEntity);
                    vParams.Add("@IsGroup", companySettingsSearchInputModel.IsGroup);
                    vParams.Add("@IsBranch", companySettingsSearchInputModel.IsBranch);
                    vParams.Add("@IsCountry", companySettingsSearchInputModel.IsCountry);
                    vParams.Add("@IsHeadOffice", companySettingsSearchInputModel.IsHeadOffice);
                    vParams.Add("@TimeStamp", companySettingsSearchInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@ParentEntityId", companySettingsSearchInputModel.ParentEntityId);
                    vParams.Add("@ChildEntityId", companySettingsSearchInputModel.ChildEntityId);
                    vParams.Add("@CurrencyId", companySettingsSearchInputModel.CurrencyId);
                    vParams.Add("@CountryId", companySettingsSearchInputModel.CountryId);
                    vParams.Add("@TimeZoneId", companySettingsSearchInputModel.TimeZoneId);
                    vParams.Add("@IsArchive", companySettingsSearchInputModel.IsArchive);
                    vParams.Add("@DefaultPayrollTemplateId", companySettingsSearchInputModel.DefaultPayrollTemplateId);
                    vParams.Add("@Address", companySettingsSearchInputModel.Address);
                    vParams.Add("@Description", companySettingsSearchInputModel.Description);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid>(StoredProcedureConstants.SpUpsertCompanyStructure, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCompanyStructure", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCompanySettings);
                return null;
            }
        }

        public Guid? UpsertBusinessUnit(BusinessUnitModel businessUnitModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@BusinessUnitId", businessUnitModel.BusinessUnitId);
                    vParams.Add("@BusinessUnitName", businessUnitModel.BusinessUnitName);
                    vParams.Add("@TimeStamp", businessUnitModel.TimeStamp, DbType.Binary);
                    vParams.Add("@ParentBusinessUnitId", businessUnitModel.ParentBusinessUnitId);
                    vParams.Add("@EmployeeIdsXML", businessUnitModel.EmployeeIdsXML);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid>(StoredProcedureConstants.SpUpsertBusinessUnit, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertBusinessUnit", "Master Data Management Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionInBusinessUnits);
                return null;
            }
        }
        public Guid? DeleteBusinessUnit(BusinessUnitModel businessUnitModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@BusinessUnitId", businessUnitModel.BusinessUnitId);
                    vParams.Add("@TimeStamp", businessUnitModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid>(StoredProcedureConstants.SpDeleteBusinessUnit, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteBusinessUnit", "Master Data Management Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionInBusinessUnits);
                return null;
            }
        }

        public List<SearchEntityApiOutputModel> SearchEntities(Guid? entityId,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EntityId", entityId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<SearchEntityApiOutputModel>(StoredProcedureConstants.SpSearchEntities, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchEntities", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCompanySettings);
                return new List<SearchEntityApiOutputModel>();
            }
        }

        public List<SearchBusinessUnitApiOutputModel> SearchBusinessUnits(BusinessUnitModel businessUnitModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@BusinessUnitId", businessUnitModel.BusinessUnitId);
                    vParams.Add("@BusinessUnitName", businessUnitModel.BusinessUnitName);
                    vParams.Add("@ParentBusinessUnitId", businessUnitModel.ParentBusinessUnitId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<SearchBusinessUnitApiOutputModel>(StoredProcedureConstants.SpSearchBusinessUnits, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchBusinessUnits", "Master Data Management Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionInBusinessUnits);
                return new List<SearchBusinessUnitApiOutputModel>();
            }
        }
        public List<BusinessUnitDropDownModel> GetBusinessUnitDropDown(BusinessUnitDropDownModel businessUnitModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@BusinessUnitId", businessUnitModel.BusinessUnitId);
                    vParams.Add("@BusinessUnitName", businessUnitModel.BusinessUnitName);
                    vParams.Add("@IsFromHR", businessUnitModel.IsFromHR);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<BusinessUnitDropDownModel>(StoredProcedureConstants.SpGetBusinessUnitDropDown, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetBusinessUnitDropDown", "Master Data Management Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionInBusinessUnits);
                return new List<BusinessUnitDropDownModel>();
            }
        }

    }
}
