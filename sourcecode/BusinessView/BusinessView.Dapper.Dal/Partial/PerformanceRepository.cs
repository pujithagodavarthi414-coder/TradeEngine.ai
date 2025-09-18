using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.Performance;
using Btrak.Models.Probation;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace Btrak.Dapper.Dal.Partial
{
    public partial class PerformanceRepository : BaseRepository
    {
        public Guid? UpsertPerformanceConfiguration(PerformanceConfigurationModel performanceConfiguration, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ConfigurationId", performanceConfiguration.ConfigurationId);
                    vParams.Add("@ConfigurationName", performanceConfiguration.ConfigurationName);
                    vParams.Add("@SelectedRoles", performanceConfiguration.SelectedRoles);
                    vParams.Add("@FormJson", performanceConfiguration.FormJson);
                    vParams.Add("@IsDraft", performanceConfiguration.IsDraft);
                    vParams.Add("@TimeStamp", performanceConfiguration.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", performanceConfiguration.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertPerformanceConfiguration, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPerformanceConfiguration", "PerformanceRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertPerformanceConfiguration);
                return null;
            }
        }

        public List<PerformanceConfigurationOutputModel> GetPerformanceConfigurations(PerformanceConfigurationModel performanceConfiguration, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@IsArchived", performanceConfiguration.IsArchived);
                    vParams.Add("@IsDraft", performanceConfiguration.IsDraft);
                    vParams.Add("@ConsiderRole", performanceConfiguration.ConsiderRole);
                    vParams.Add("@OfUserId", performanceConfiguration.OfUserId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<PerformanceConfigurationOutputModel>(StoredProcedureConstants.SpGetPerformanceConfigurations, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPerformanceConfigurations", "PerformanceRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetPerformanceConfigurations);
                return new List<PerformanceConfigurationOutputModel>();
            }
        }

        public Guid? UpsertPerformance(PerformanceModel performance, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@PerformanceId", performance.PerformanceId);
                    vParams.Add("@ConfigurationId", performance.ConfigurationId);
                    vParams.Add("@FormData", performance.FormData);
                    vParams.Add("@IsDraft", performance.IsDraft);
                    vParams.Add("@IsSubmitted", performance.IsSubmitted);
                    vParams.Add("@IsApproved", performance.IsApproved);
                    vParams.Add("@ApprovedBy", performance.ApprovedBy);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertPerformance, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPerformance", "PerformanceRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertPerformance);
                return null;
            }
        }

        public List<PerformanceOutputModel> GetPerformances(PerformanceModel performanceConfiguration, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@PerformanceId", performanceConfiguration.PerformanceId);
                    vParams.Add("@WaitingForApproval", performanceConfiguration.WaitingForApproval);
                    vParams.Add("@PageNumber", performanceConfiguration.PageNumber);
                    vParams.Add("@PageSize", performanceConfiguration.PageSize);
                    vParams.Add("@IncludeApproved", performanceConfiguration.IncludeApproved);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<PerformanceOutputModel>(StoredProcedureConstants.SpGetPerformances, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPerformances", "PerformanceRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetPerformances);
                return new List<PerformanceOutputModel>();
            }
        }

        public Guid? UpsertPerformanceSubmission(PerformanceSubmissionModel performance, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@PerformanceId", performance.PerformanceId);
                    vParams.Add("@ConfigurationId", performance.ConfigurationId);
                    vParams.Add("@OfUserId", performance.OfUserId);
                    vParams.Add("@IsOpen", performance.IsOpen);
                    vParams.Add("@IsShare", performance.IsShare);
                    vParams.Add("@IsArchived", performance.IsArchived);
                    vParams.Add("@PdfUrl", performance.PdfUrl);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertPerformanceSubmission, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPerformanceSubmission", "PerformanceRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertPerformance);
                return null;
            }
        }

        public Guid? UpsertPerformanceSubmissionDetails(PerformanceSubmissionModel performance, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@PerformanceDetailsId", performance.PerformanceDetailsId);
                    vParams.Add("@PerformanceId", performance.PerformanceId);
                    vParams.Add("@IsCompleted", performance.IsCompleted);
                    vParams.Add("@FormData", performance.FormData);
                    vParams.Add("@SubmissionFrom", performance.SubmissionFrom);
                    vParams.Add("@SubmittedBy", performance.SubmittedBy);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertPerformanceSubmissionDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPerformanceSubmissionDetails", "PerformanceRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertPerformance);
                return null;
            }
        }

        public List<PerformanceSubmissionOutputModel> GetPerformanceSubmissions(PerformanceSubmissionModel performanceConfiguration, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@IsOpen", performanceConfiguration.IsOpen);
                    vParams.Add("@IsArchived", performanceConfiguration.IsArchived);
                    vParams.Add("@OfUserId", performanceConfiguration.OfUserId);
                    vParams.Add("@SortBy", performanceConfiguration.SortBy);
                    vParams.Add("@SearchText", performanceConfiguration.SearchText);
                    vParams.Add("@SortDirection", performanceConfiguration.SortDirection);
                    vParams.Add("@PageNumber", performanceConfiguration.PageNumber);
                    vParams.Add("@PageSize", performanceConfiguration.PageSize);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<PerformanceSubmissionOutputModel>(StoredProcedureConstants.SpGetPerformanceSubmissions, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPerformanceSubmissions", "PerformanceRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetPerformances);
                return new List<PerformanceSubmissionOutputModel>();
            }
        }

        public List<PerformanceSubmissionOutputModel> GetPerformanceSubmissionDetails(PerformanceSubmissionModel performanceConfiguration, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@PerformanceId", performanceConfiguration.PerformanceId);
                    vParams.Add("@SubmissionFrom", performanceConfiguration.SubmissionFrom);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<PerformanceSubmissionOutputModel>(StoredProcedureConstants.SpGetPerformanceSubmissionDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPerformanceSubmissionDetails", "PerformanceRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetPerformances);
                return new List<PerformanceSubmissionOutputModel>();
            }
        }

        public List<PerformanceReportModel> GetPerformanceReports(PerformanceReportModel performanceConfiguration, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EntityId", performanceConfiguration.EntityId);
                    vParams.Add("@UserId", performanceConfiguration.UserId);
                    vParams.Add("@SearchText", performanceConfiguration.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<PerformanceReportModel>(StoredProcedureConstants.SpGetPerformanceReports, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPerformanceReports", "PerformanceRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetPerformances);
                return new List<PerformanceReportModel>();
            }
        }

        public List<UsersBasedOnPermissionOutputModel> GetUsersBasedOnFeaturePermissions(Guid featureId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FeatureId", featureId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<UsersBasedOnPermissionOutputModel>(StoredProcedureConstants.SpGetUsersBasedOnFeaturePermission, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUsersBasedOnFeaturePermissions", "PerformanceRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetUsersBasedOnFeature);
                return new List<UsersBasedOnPermissionOutputModel>();
            }
        }

        public Guid? UpsertProbationConfiguration(ProbationConfigurationModel probationConfiguration, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ConfigurationId", probationConfiguration.ConfigurationId);
                    vParams.Add("@ConfigurationName", probationConfiguration.ConfigurationName);
                    vParams.Add("@SelectedRoles", probationConfiguration.SelectedRoles);
                    vParams.Add("@FormJson", probationConfiguration.FormJson);
                    vParams.Add("@IsDraft", probationConfiguration.IsDraft);
                    vParams.Add("@TimeStamp", probationConfiguration.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", probationConfiguration.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertProbationConfiguration, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertProbationConfiguration", "PerformanceRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertPerformanceConfiguration);
                return null;
            }
        }

        public List<ProbationConfigurationOutputModel> GetProbationConfigurations(ProbationConfigurationModel performanceConfiguration, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@IsArchived", performanceConfiguration.IsArchived);
                    vParams.Add("@IsDraft", performanceConfiguration.IsDraft);
                    vParams.Add("@ConsiderRole", performanceConfiguration.ConsiderRole);
                    vParams.Add("@OfUserId", performanceConfiguration.OfUserId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ProbationConfigurationOutputModel>(StoredProcedureConstants.SpGetProbationConfigurations, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetProbationConfigurations", "PerformanceRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetPerformanceConfigurations);
                return new List<ProbationConfigurationOutputModel>();
            }
        }

        public Guid? UpsertProbationSubmissionDetails(ProbationSubmissionModel probation, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ProbationDetailsId", probation.ProbationDetailsId);
                    vParams.Add("@ProbationId", probation.ProbationId);
                    vParams.Add("@IsCompleted", probation.IsCompleted);
                    vParams.Add("@FormData", probation.FormData);
                    vParams.Add("@SubmissionFrom", probation.SubmissionFrom);
                    vParams.Add("@SubmittedBy", probation.SubmittedBy);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertProbationSubmissionDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertProbationSubmissionDetails", "PerformanceRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertPerformance);
                return null;
            }
        }

        public List<ProbationSubmissionOutputModel> GetProbationSubmissionDetails(ProbationSubmissionModel probationConfiguration, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ProbationId", probationConfiguration.ProbationId);
                    vParams.Add("@SubmissionFrom", probationConfiguration.SubmissionFrom);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ProbationSubmissionOutputModel>(StoredProcedureConstants.SpGetProbationSubmissionDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPerformanceSubmissionDetails", "PerformanceRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetPerformances);
                return new List<ProbationSubmissionOutputModel>();
            }
        }

        public Guid? UpsertProbationSubmission(ProbationSubmissionModel probation, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ProbationId", probation.ProbationId);
                    vParams.Add("@ConfigurationId", probation.ConfigurationId);
                    vParams.Add("@OfUserId", probation.OfUserId);
                    vParams.Add("@IsOpen", probation.IsOpen);
                    vParams.Add("@IsShare", probation.IsShare);
                    vParams.Add("@IsArchived", probation.IsArchived);
                    vParams.Add("@PdfUrl", probation.PdfUrl);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertProbationSubmission, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPerformanceSubmission", "PerformanceRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertPerformance);
                return null;
            }
        }

        public List<ProbationSubmissionOutputModel> GetProbationSubmissions(ProbationSubmissionModel probationConfiguration, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@IsOpen", probationConfiguration.IsOpen);
                    vParams.Add("@IsArchived", probationConfiguration.IsArchived);
                    vParams.Add("@OfUserId", probationConfiguration.OfUserId);
                    vParams.Add("@SortBy", probationConfiguration.SortBy);
                    vParams.Add("@SearchText", probationConfiguration.SearchText);
                    vParams.Add("@SortDirection", probationConfiguration.SortDirection);
                    vParams.Add("@PageNumber", probationConfiguration.PageNumber);
                    vParams.Add("@PageSize", probationConfiguration.PageSize);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ProbationSubmissionOutputModel>(StoredProcedureConstants.SpGetProbationSubmissions, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetProbationSubmissions", "PerformanceRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetPerformances);
                return new List<ProbationSubmissionOutputModel>();
            }
        }
    }
}
