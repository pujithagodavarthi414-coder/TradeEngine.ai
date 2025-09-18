using Btrak.Dapper.Dal.Helpers;
using Btrak.Models.StatusReportingConfiguration;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Models;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class StatusReportingRepository
    {
        public List<StatusReportingOptionsApiReturnModel> GetStatusConfigurationOptions(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<StatusReportingOptionsApiReturnModel>(StoredProcedureConstants.SpGetStatusConfigurationOptions, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetStatusConfigurationOptions", "StatusReportingRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetStatusConfigurationOptions);
                return new List<StatusReportingOptionsApiReturnModel>();
            }
        }

        public List<ReportToApiReturnModel> GetReportToMembers(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ReportToApiReturnModel>(StoredProcedureConstants.SpGetEmployeeReportToMembers, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetReportToMembers", "StatusReportingRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetReportToMembers);
                return new List<ReportToApiReturnModel>();
            }
        }

        public Guid? UpsertReportSeenStatus(StatusReportSeenUpsertInputModel reportSeenUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@StatusReportId", reportSeenUpsertInputModel.StatusReportId);
                    vParams.Add("@SeenStatus", reportSeenUpsertInputModel.SeenStatus);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertReportSeenStatus, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertReportSeenStatus", "StatusReportingRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertReportSeenStatus);
                return null;
            }
        }

        public Guid? UpsertStatusReportingConfiguration(StatusReportingConfigurationUpsertInputModel statusReportingConfiguration, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@StatusReportingConfigurationId", statusReportingConfiguration.Id);
                    vParams.Add("@ConfigurationName", statusReportingConfiguration.ConfigurationName);
                    vParams.Add("@GenericFormId", statusReportingConfiguration.GenericFormId);
                    vParams.Add("@UserIds", statusReportingConfiguration.EmployeeIds);
                    vParams.Add("@StatusReportingOptionIds", statusReportingConfiguration.StatusConfigurationOptions);
                    vParams.Add("@IsArchived", statusReportingConfiguration.IsArchived);
                    vParams.Add("@TimeStamp", statusReportingConfiguration.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertStatusReportingConfiguration, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertStatusReportingConfiguration", "StatusReportingRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertStatusReportingConfiguration);
                return null;
            }
        }

        public List<StatusReportingConfigurationApiReturnModel> GetStatusReportingConfigurations(StatusReportingConfigurationSearchCriteriaInputModel statusReportingConfiguration, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@SearchText", statusReportingConfiguration.ConfigurationName);
                    vParams.Add("@AssignedBy", statusReportingConfiguration.AssignedByUserId);
                    vParams.Add("@FormTypeId", statusReportingConfiguration.FormTypeId);
                    vParams.Add("@GenericFormId", statusReportingConfiguration.GenericFormId);
                    vParams.Add("@Pagesize", statusReportingConfiguration.PageSize);
                    vParams.Add("@StatusReportingConfigurationId", statusReportingConfiguration.StatusReportingConfigurationId);
                    vParams.Add("@IsArchived", statusReportingConfiguration.IsArchived);
                    vParams.Add("@Pagenumber", statusReportingConfiguration.PageNumber);
                    return vConn.Query<StatusReportingConfigurationApiReturnModel>(StoredProcedureConstants.SpGetStatusReportingConfigurations, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetStatusReportingConfigurations", "StatusReportingRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetStatusReportingConfigurations);
                return new List<StatusReportingConfigurationApiReturnModel>();
            }
        }

        public List<StatusReportingConfigurationFormApiReturnModel> GetStatusReportingConfigurationForms(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<StatusReportingConfigurationFormApiReturnModel>(StoredProcedureConstants.SpGetStatusReportingConfigurationForms, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetStatusReportingConfigurationForms", "StatusReportingRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetStatusReportingConfigurationForms);
                return new List<StatusReportingConfigurationFormApiReturnModel>();
            }
        }

        public Guid? CreateStatusReport(StatusReportUpsertInputModel statusReport, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@StatusReportingConfigurationOptionId", statusReport.StatusReportingConfigurationOptionId);
                    vParams.Add("@FilePath", statusReport.FilePath);
                    vParams.Add("@FileName", statusReport.FileName);
                    vParams.Add("@FormDataJson", statusReport.FormDataJson);
                    vParams.Add("@Description", statusReport.Description);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsArchived", statusReport.IsArchived);
                    vParams.Add("@SubmittedDateTime", statusReport.SubmittedDateTime);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertStatusReport, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateStatusReport", "StatusReportingRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionCreateStatusReport);
                return null;
            }
        }

        public List<StatusReportApiReturnModel> GetStatusReportings(StatusReportSearchCriteriaInputModel statusReport, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@StatusReportId", statusReport.Id);
                    vParams.Add("@StatusReportingConfigurationOptionId", statusReport.StatusReportingConfigurationOptionId);
                    vParams.Add("@Description", statusReport.Description);
                    vParams.Add("@FilePath", statusReport.FilePath);
                    vParams.Add("@FileName", statusReport.FileName);
                    vParams.Add("@PageSize", statusReport.PageSize);
                    vParams.Add("@PageNumber", statusReport.PageNumber);
                    vParams.Add("@CreatedOn", statusReport.CreatedOn);
                    vParams.Add("@IsUnread", statusReport.IsUnread);
                    vParams.Add("@UserIds", statusReport.AssignedTo);
                    vParams.Add("@SearchText", statusReport.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<StatusReportApiReturnModel>(StoredProcedureConstants.SpGetStatusReports, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetStatusReportings", "StatusReportingRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetStatusReportings);
                return new List<StatusReportApiReturnModel>();
            }
        }
    }
}
