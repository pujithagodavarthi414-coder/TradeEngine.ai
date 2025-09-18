using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.ActivityTracker;
using Btrak.Models.ActTracker;
using Btrak.Models.Chat;
using Btrak.Models.ScheduledConfigurations;
using Btrak.Models.User;
using BTrak.Common;
using Dapper;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace Btrak.Dapper.Dal.Repositories
{
    public class ActivityTrackerRepository : BaseRepository
    {
        public string InsertUserActivityTime(string userTime, string deviceId, List<ValidationMessage> validationMessages, Guid? loggedInUser)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserTime", userTime);
                    vParams.Add("@DeviceId", deviceId);
                    vParams.Add("@OperationsPerformedBy", loggedInUser ?? Guid.Empty);
                    return vConn.Query<string>(StoredProcedureConstants.SpInsertUserActivityTime, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertUserActivityTime", "ActivityTrackerRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUserActivityTime);
                return $"insert proc failed to insert data for userId: {loggedInUser}, exception: {sqlException.Message}, payload: {userTime}";
            }
        }

        public string InsertUserMouseMovementsAndKeyStrokes(InsertUserActivityInputModel insertUserActivityInputModel, List<ValidationMessage> validationMessages, Guid? loggedInUser)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@TrackedDateTime", insertUserActivityInputModel.ActivityTime);
                    vParams.Add("@MouseMovement", insertUserActivityInputModel.MouseMovements);
                    vParams.Add("@KeyStroke", insertUserActivityInputModel.KeyStrokes);
                    vParams.Add("@UserIdleRecordXml", insertUserActivityInputModel.UserIdleRecordXml);
                    vParams.Add("@UserId", loggedInUser ?? Guid.Empty);
                    vParams.Add("@DeviceId", insertUserActivityInputModel.DeviceId);
                    return vConn.Query<string>(StoredProcedureConstants.SpInsertUserActivityTrackerStatus, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertUserMouseMovementsAndKeyStrokes", "ActivityTrackerRepository", sqlException.Message) + " with data - " + JsonConvert.SerializeObject(insertUserActivityInputModel, Formatting.Indented), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUserActivityTime);
                return null;
            }
        }

        public void ActivityTrackerData(string procedureName)
        {
            var watch = System.Diagnostics.Stopwatch.StartNew();
            try
            {
                LoggingManager.Info("Entering into ActivityTrackerData repo to execute proc with name " + procedureName + " on utc date " + DateTime.UtcNow);
                using (IDbConnection vConn = OpenConnection())
                {
                    vConn.Query(procedureName, commandTimeout: 0, commandType: CommandType.StoredProcedure); //TODO
                    watch.Stop();
                    var elapsedMs = watch.ElapsedMilliseconds;
                    LoggingManager.Info("Webjob in ActivityTrackerData repo to execute proc with name " + procedureName + " took " + elapsedMs + " time in milliseconds");
                }
            }
            catch (SqlException sqlException)
            {
                watch.Stop();
                var elapsedMs = watch.ElapsedMilliseconds;
                LoggingManager.Error("Webjob in ActivityTrackerData repo to execute proc with name " + procedureName + " took " + elapsedMs + " time in milliseconds and stopped due to exception");
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ActivityTrackerData", "ActivityTrackerRepository", sqlException.Message), sqlException);
            }
        }

        public string InsertUserActivityScreenShot(InsertUserActivityScreenShotInputModel insertUserActivityScreenShotInputModel, string macAddress, List<ValidationMessage> validationMessages, Guid? loggedInUser)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ScreenShotName", insertUserActivityScreenShotInputModel.ScreenShotName);
                    vParams.Add("@ScreenShotUrl", insertUserActivityScreenShotInputModel.ScreenShotUrl);
                    vParams.Add("@ScreenShotDate", insertUserActivityScreenShotInputModel.ScreenShotDate);
                    vParams.Add("@ApplicationName", insertUserActivityScreenShotInputModel.ApplicationName);
                    vParams.Add("@KeyStroke", double.IsNaN(insertUserActivityScreenShotInputModel.KeyStroke) ? 0 : insertUserActivityScreenShotInputModel.KeyStroke);
                    vParams.Add("@MouseMovement", double.IsNaN(insertUserActivityScreenShotInputModel.MouseMovements) ? 0 : insertUserActivityScreenShotInputModel.MouseMovements);
                    vParams.Add("@MAC", insertUserActivityScreenShotInputModel.Mac ?? string.Empty);
                    vParams.Add("@ApplicationName", string.IsNullOrEmpty(insertUserActivityScreenShotInputModel.ApplicationName) ? insertUserActivityScreenShotInputModel.ScreenShotName : insertUserActivityScreenShotInputModel.ApplicationName);
                    vParams.Add("@OperationsPerformedBy", loggedInUser ?? Guid.Empty);
                    vParams.Add("@TimeZone", insertUserActivityScreenShotInputModel.TimeZone);
                    vParams.Add("@DeviceId", insertUserActivityScreenShotInputModel.DeviceId);
                    return vConn.Query<string>(StoredProcedureConstants.SpUpsertUserActivityScreenShot, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertUserActivityScreenShot", "ActivityTrackerRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUserActivityScreenShot);
                return null;
            }
        }

        public ActivityTrackerScreenShotValidationModel CanAcceptScreenShotOrNot(ActivityTrackerScreenShotValidationInputModel activityTrackerScreenShotValidationInputModel, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@MACAddress", activityTrackerScreenShotValidationInputModel.MacAddresses);
                    vParams.Add("@DeviceId", activityTrackerScreenShotValidationInputModel.DeviceId);
                    vParams.Add("@ScreenShotDate", activityTrackerScreenShotValidationInputModel.ScreenShotDate);
                    vParams.Add("@OperationsPerformedBy", activityTrackerScreenShotValidationInputModel.UserId ?? Guid.Empty);
                    vParams.Add("@TimeZone", activityTrackerScreenShotValidationInputModel.TimeZone);
                    return vConn.Query<ActivityTrackerScreenShotValidationModel>(StoredProcedureConstants.SpCanAcceptScreenShot, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CanAcceptScreenShotOrNot", "ActivityTrackerRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUserActivityScreenShot);
                return null;
            }
        }

        public TrackerInsertValidatorReturnModel TrackerInsertValidator(TrackerInsertValidatorInputModel trackerInsertValidatorInputModel, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    //vParams.Add("@MacAddress", trackerInsertValidatorInputModel.MacAddress);
                    vParams.Add("@DeviceId", trackerInsertValidatorInputModel.DeviceId);
                    vParams.Add("@TriggeredDate", trackerInsertValidatorInputModel.TriggeredDate);
                    vParams.Add("@UserId", trackerInsertValidatorInputModel.UserId ?? Guid.Empty);
                    //vParams.Add("@TimeZone", trackerInsertValidatorInputModel.TimeZone);
                    return vConn.Query<TrackerInsertValidatorReturnModel>(StoredProcedureConstants.SpTrackerInsertValidator, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "TrackerInsertValidator", "ActivityTrackerRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionTrackerActivityValidator);

                return null;
            }
        }

        public string UpsertActivityTrackerStatus(string deviceId, List<ValidationMessage> validationMessages, Guid? loggedInUser, string userIpAddress, string timeZone)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@DeviceId", deviceId);
                    vParams.Add("@OperationsPerformedBy", loggedInUser ?? Guid.Empty);
                    vParams.Add("@UserIpAddress", userIpAddress);
                    vParams.Add("@TimeZone", timeZone);
                    return vConn.Query<string>(StoredProcedureConstants.SpUpsertActivityTrackerStatus, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertActivityTrackerStatus", "ActivityTrackerRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUserActivityScreenShot);
                return null;
            }
        }

        public List<TimeUsageOfApplicationApiOutputModel> GetTotalTimeUsageOfApplicationsByUsers(TimeUsageOfApplicationSearchInputModel timeUsageOfApplicationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@UserId", timeUsageOfApplicationSearchInputModel.UserIdXml);
                    vParams.Add("@RoleId", timeUsageOfApplicationSearchInputModel.RoleIdXml);
                    vParams.Add("@BranchId", timeUsageOfApplicationSearchInputModel.BranchIdXml);
                    vParams.Add("@DateFrom", timeUsageOfApplicationSearchInputModel.DateFrom);
                    vParams.Add("@DateTo", timeUsageOfApplicationSearchInputModel.DateTo);
                    vParams.Add("@PageNo", timeUsageOfApplicationSearchInputModel.PageNumber);
                    vParams.Add("@PageSize", timeUsageOfApplicationSearchInputModel.PageSize);
                    vParams.Add("@SortBy", timeUsageOfApplicationSearchInputModel.SortBy);
                    vParams.Add("@IsForDashboard", timeUsageOfApplicationSearchInputModel.IsForDashboard);
                    vParams.Add("@SortDirection", timeUsageOfApplicationSearchInputModel.SortDirection);
                    return vConn.Query<TimeUsageOfApplicationApiOutputModel>(StoredProcedureConstants.SpGetTotalTimeUsageOfApplications, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTotalTimeUsageOfApplicationsByUsers", "ActivityTrackerRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetTotalTimeUsageofApplicationByUsers);
                return new List<TimeUsageOfApplicationApiOutputModel>();
            }
        }
        
        public List<GetTimeUsageDrillDownOutputModel> GetTimeUsageDrillDown(TimeUsageDrillDownSearchInputModel timeUsageDrillDownSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@UserId", timeUsageDrillDownSearchInputModel.UserId);
                    vParams.Add("@Date", timeUsageDrillDownSearchInputModel.Date);
                    vParams.Add("@PageNo", timeUsageDrillDownSearchInputModel.PageNumber);
                    vParams.Add("@PageSize", timeUsageDrillDownSearchInputModel.PageSize);
                    vParams.Add("@SortBy", timeUsageDrillDownSearchInputModel.SortBy);
                    vParams.Add("@SortDirection", timeUsageDrillDownSearchInputModel.SortDirection);
                    vParams.Add("@ApplicatonType", timeUsageDrillDownSearchInputModel.ApplicationType);
                    return vConn.Query<GetTimeUsageDrillDownOutputModel>(StoredProcedureConstants.SpGetTimeUsageDrillDown, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTimeUsageDrillDown", "ActivityTrackerRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetTimeUsageDrillDown);
                return null;
            }
        }

        public int GetTotalTeamMembers(TimeUsageDrillDownSearchInputModel timeUsageDrillDownSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);

                    return vConn.Query<int>(StoredProcedureConstants.SPGetTotalTeam, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTimeUsageDrillDown", "ActivityTrackerRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetTimeUsageDrillDown);
                return 0;
            }
        }
        public List<EmployeeSearchOutputModel> GetEmployees(EmployeeSearchInputModel employeeSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@RoleId", employeeSearchInputModel.RoleIdXml);
                    vParams.Add("@BranchId", employeeSearchInputModel.BranchIdXml);
                    vParams.Add("@IsAllEmployee", employeeSearchInputModel.IsAllEmployee);
                    return vConn.Query<EmployeeSearchOutputModel>(StoredProcedureConstants.SpGetEmployeesByRoles, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployees", "ActivityTrackerRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployees);
                return null;
            }

        }

        public List<EmployeeWebAppUsageTimeOutputModel> GetWebAppUsageTime(EmployeeWebAppUsageTimeSearchInputModel employeeWebAppUsageTimeSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@UserId", employeeWebAppUsageTimeSearchInputModel.UserIdXml);
                    vParams.Add("@RoleId", employeeWebAppUsageTimeSearchInputModel.RoleIdXml);
                    vParams.Add("@BranchId", employeeWebAppUsageTimeSearchInputModel.BranchIdXml);
                    vParams.Add("@DateFrom", employeeWebAppUsageTimeSearchInputModel.DateFrom);
                    vParams.Add("@DateTo", employeeWebAppUsageTimeSearchInputModel.DateTo);
                    vParams.Add("@SearchText", employeeWebAppUsageTimeSearchInputModel.SearchText);
                    vParams.Add("@PageNo", employeeWebAppUsageTimeSearchInputModel.PageNumber);
                    vParams.Add("@PageSize", employeeWebAppUsageTimeSearchInputModel.PageSize);
                    vParams.Add("@IsApp", employeeWebAppUsageTimeSearchInputModel.IsApp);
                    vParams.Add("@SortBy", employeeWebAppUsageTimeSearchInputModel.SortBy);
                    vParams.Add("@SortDirection", employeeWebAppUsageTimeSearchInputModel.SortDirection);
                    if (employeeWebAppUsageTimeSearchInputModel.IsDetailedView == true)
                    {
                        return vConn.Query<EmployeeWebAppUsageTimeOutputModel>(StoredProcedureConstants.SpGetDetailedView, vParams, commandType: CommandType.StoredProcedure).ToList();
                    }
                    else
                    {
                        return vConn.Query<EmployeeWebAppUsageTimeOutputModel>(StoredProcedureConstants.SpGetWebAppUsageTime, vParams, commandType: CommandType.StoredProcedure).ToList();
                    }
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetWebAppUsageTime", "ActivityTrackerRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetWebAppUsageTime);
                return null;
            }
        }

        public List<MessageDto> GetChatActivityTrackerRecorder(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, bool? isSingle = null)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@isSingle", isSingle);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<MessageDto>(StoredProcedureConstants.SpGetChatActivityTrackerRecorder, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetChatActivityTrackerRecorder", "ActivityTrackerRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetWebAppUsageTime);
                return null;
            }
        }

        public ActivityTrackerInformationOutputModel GetActivityTrackerInformation(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ActivityTrackerInformationOutputModel>(StoredProcedureConstants.SpGetActivityTrackerInformation, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActivityTrackerInformation", "ActivityTrackerRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetWebAppUsageTime);
                return null;
            }
        }

        public TrackedInformationOfUserStoryOutputModel GetTrackedInformationOfUserStory(TrackedInformationOfUserStorySearchInputModel trackedInformationOfUserStorySearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@UserId", trackedInformationOfUserStorySearchInputModel.UserId);
                    vParams.Add("@DateFrom", trackedInformationOfUserStorySearchInputModel.DateFrom);
                    vParams.Add("@DateTo", trackedInformationOfUserStorySearchInputModel.DateTo);
                    return vConn.Query<TrackedInformationOfUserStoryOutputModel>(StoredProcedureConstants.SpGetTrackedInformationOfUserStory, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTrackedInformationOfUserStory", "ActivityTrackerRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetTrackedInformationOfUserStory);
                return null;
            }
        }

        public List<EmployeeTrackerOutputModel> GetAppUsageCompleteReport(EmployeeTrackerSearchInputModel employeeTrackerSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@UserId", employeeTrackerSearchInputModel.UserIdXml);
                    //vParams.Add("@BranchId", employeeTrackerSearchInputModel.BranchId);
                    vParams.Add("@DateFrom", employeeTrackerSearchInputModel.DateFrom);
                    vParams.Add("@DateTo", employeeTrackerSearchInputModel.DateTo);
                    return vConn.Query<EmployeeTrackerOutputModel>(StoredProcedureConstants.SpGetAppUsageCompleteReport, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAppUsageCompleteReport", "ActivityTrackerRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAppUsageCompleteReport);
                return null;
            }
        }

        public List<ApplicationCategoryModel> GetApplicationCategory(ApplicationCategoryModel applicationCategoryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@ApplicationCategoryId", applicationCategoryModel.ApplicationCategoryId);
                    vParams.Add("@ApplicationCategoryName", applicationCategoryModel.ApplicationCategoryName);
                    vParams.Add("@IsArchived", applicationCategoryModel.IsArchived);
                    return vConn.Query<ApplicationCategoryModel>(StoredProcedureConstants.SpGetApplicationCategory, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetApplicationCategory", "ActivityTrackerRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionInApplicationCategory);
                return null;
            }
        }

        public Guid? UpsertApplicationCategory(ApplicationCategoryModel applicationCategoryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@ApplicationCategoryId", applicationCategoryModel.ApplicationCategoryId);
                    vParams.Add("@ApplicationCategoryName", applicationCategoryModel.ApplicationCategoryName);
                    vParams.Add("@TimeStamp", applicationCategoryModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", applicationCategoryModel.IsArchived);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertApplicationCategory, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertApplicationCategory", "ActivityTrackerRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionInApplicationCategory);
                return null;
            }
        }

        public List<EmployeeTrackerUserstoryOutputModel> GetAppUsageUserStoryReport(EmployeeTrackerSearchInputModel employeeTrackerSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@UserId", employeeTrackerSearchInputModel.UserIdXml);
                    vParams.Add("@StartDate", employeeTrackerSearchInputModel.DateFrom);
                    vParams.Add("@EndDate", employeeTrackerSearchInputModel.DateTo);
                    return vConn.Query<EmployeeTrackerUserstoryOutputModel>(StoredProcedureConstants.SpGetAppUsageUserStoryReport, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAppUsageUserStoryReport", "ActivityTrackerRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAppUsageUserStoryReport);
                return null;
            }
        }

        public List<EmployeeTrackerTimesheetOutputModel> GetAppUsageTimesheetReport(EmployeeTrackerSearchInputModel employeeTrackerSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@UserId", employeeTrackerSearchInputModel.UserIdXml);
                    vParams.Add("@StartDate", employeeTrackerSearchInputModel.DateFrom);
                    vParams.Add("@EndDate", employeeTrackerSearchInputModel.DateTo);
                    return vConn.Query<EmployeeTrackerTimesheetOutputModel>(StoredProcedureConstants.SpGetAppUsageTimesheetReport, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAppUsageTimesheetReport", "ActivityTrackerRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAppUsageTimesheetReport);
                return null;
            }
        }

        public List<TrackerUserTimelineModel> GetUserTrackerTimeline(EmployeeTrackerSearchInputModel employeeTrackerSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@UserId", employeeTrackerSearchInputModel.UserIdXml);
                    vParams.Add("@DateFrom", employeeTrackerSearchInputModel.DateFrom);
                    vParams.Add("@DateTo", employeeTrackerSearchInputModel.DateTo);
                    vParams.Add("@OnDate", employeeTrackerSearchInputModel.OnDate);
                    return vConn.Query<TrackerUserTimelineModel>(StoredProcedureConstants.SpGetUserTrackerTimeline, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserTrackerTimeline", "ActivityTrackerRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetUserTrackerTimeline);
                return new List<TrackerUserTimelineModel>();
            }
        }

        public List<ActivityReportOutputModel> GetActivityReport(ActivityReportInputModel activityReportInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@OnDate", activityReportInputModel.OnDate);
                    vParams.Add("@IsApp", activityReportInputModel.IsApp);
                    return vConn.Query<ActivityReportOutputModel>(StoredProcedureConstants.SpGetActivityReport, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActivityReport", "ActivityTrackerRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAppUsageTimesheetReport);
                return new List<ActivityReportOutputModel>();
            }
        }

        public List<ActivityReportOutputModel> GetActivityReportForCategories(ActivityReportInputModel activityReportInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@OnDate", activityReportInputModel.OnDate);
                    vParams.Add("@MySelf", activityReportInputModel.MySelf);
                    return vConn.Query<ActivityReportOutputModel>(StoredProcedureConstants.SPGetActivityReportForCategories, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActivityReportForCategories", "ActivityTrackerRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAppUsageTimesheetReport);
                return new List<ActivityReportOutputModel>();
            }
        }
        public List<ActivityReportOutputModel> GetLeadLevelActivityReport(ActivityReportInputModel activityReportInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@OnDate", activityReportInputModel.OnDate);
                    vParams.Add("@IsProductiveApps", activityReportInputModel.IsProductiveApps);
                    return vConn.Query<ActivityReportOutputModel>(StoredProcedureConstants.SpGetLeadLevelActivityReport, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetLeadLevelActivityReport", "ActivityTrackerRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAppUsageTimesheetReport);
                return new List<ActivityReportOutputModel>();
            }
        }

        public List<ScheduledConfigurationsModel> GetScheduledConfigurations(List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    return vConn.Query<ScheduledConfigurationsModel>(StoredProcedureConstants.SpGetScheduledConfigurations, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserTrackerTimeline", "ActivityTrackerRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetUserTrackerTimeline);
                return new List<ScheduledConfigurationsModel>();
            }
        }

        public List<ActivityTrackerUsageOutputModel> GetUserActivityTrackerUsageReport(ActivityTrackerUsageInputModel activityTrackerUsageInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@UserId", activityTrackerUsageInputModel.UserId);
                    vParams.Add("@Date", activityTrackerUsageInputModel.UsageDate);
                    vParams.Add("@GetIds", activityTrackerUsageInputModel.GetIds);
                    return vConn.Query<ActivityTrackerUsageOutputModel>(StoredProcedureConstants.SpGetIdleTimeOfAnUser, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserActivityTrackerUsageReport", "ActivityTrackerRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAppUsageTimesheetReport);
                return null;
            }
        }

        public ActivityTrackerTrackingStateOutputModel UpsertUserActivityToken(ActivityTrackerTokenInputModel activityTrackerTokenInputModel, Guid? loggedInUserId, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInUserId ?? Guid.Empty);
                    vParams.Add("@ActivityToken", activityTrackerTokenInputModel.ActivityToken);
                    vParams.Add("@DeviceId", activityTrackerTokenInputModel.DeviceId);
                    return vConn.Query<ActivityTrackerTrackingStateOutputModel>(StoredProcedureConstants.SpUpsertUserActivityToken, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertUserActivityToken", "ActivityTrackerRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertUserActivityToken);
                return new ActivityTrackerTrackingStateOutputModel();
            }
        }

        public void UpdateUserActivityInIdleTime(Guid? userId, DateTime trackedDate, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserId", userId);
                    vParams.Add("@Date", trackedDate);
                    vConn.Query(StoredProcedureConstants.UpdateActivityOfAnUser, vParams, commandType: CommandType.StoredProcedure);
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateUserActivityInIdleTime", "ActivityTrackerRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, sqlException.Message);
            }
        }

        public void UpdateUserTrackerData(Guid? userId, string trackedDate, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserId", userId);
                    vParams.Add("@Date", trackedDate);
                    vConn.Query(StoredProcedureConstants.SpTrackerSummaryDataInsert, vParams, commandType: CommandType.StoredProcedure);
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateUserTrackerData", "ActivityTrackerRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, sqlException.Message);
            }
        }

        public List<EmployeeTrackerOutputModel> GetIdleAndInactiveTimeForEmployee(EmployeeTrackerSearchInputModel employeeTrackerSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@UserId", employeeTrackerSearchInputModel.UserIdXml);
                    vParams.Add("@StartDate", employeeTrackerSearchInputModel.DateFrom);
                    vParams.Add("@EndDate", employeeTrackerSearchInputModel.DateTo);
                    return vConn.Query<EmployeeTrackerOutputModel>(StoredProcedureConstants.SpGetIdleAndInactiveTimeForEmployee, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetIdleAndInactiveTimeForEmployee", "ActivityTrackerRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetIdleAndInactiveTimeForEmployee);
                return null;
            }
        }

        public List<ActivityTrackerDesktopsModel> GetTrackerDesktops(ActivityTrackerDesktopsModel activityTrackerDesktopsModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@SearchText", activityTrackerDesktopsModel.SearchText);
                    vParams.Add("@CompanyUrl", activityTrackerDesktopsModel.CompanyUrl);
                    vParams.Add("@UserId", activityTrackerDesktopsModel.UserId);
                    return vConn.Query<ActivityTrackerDesktopsModel>(StoredProcedureConstants.SpGetTrackerDesktops, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTrackerDesktops", "ActivityTrackerRepository", sqlException.Message), sqlException);
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetActivityTrackerDesktops);
                return null;
            }
        }

        public bool UpserActivityTrackerUsage(InsertUserActivityInputModel insertUserActivityInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IdsXML", insertUserActivityInputModel.IdsXML);
                    return vConn.Execute(StoredProcedureConstants.SpUpserActivityTrackerUsage, vParams, commandType: CommandType.StoredProcedure) == -1;
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpserActivityTrackerUsage", "ActivityTrackerRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, null);
                return false;
            }
        }

        public List<ActivityTrackerMode> GetActivityTrackerModes(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ActivityTrackerMode>(StoredProcedureConstants.SpGetActivityTrackerModes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActivityTrackerModes", "ActivityTrackerRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetActivityTrackerModes);
                return null;
            }
        }

        public bool UpsertActivityTrackerModeConfig(ActivityTrackerModeConfigurationInputModel config, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@ConfigId", config.Id);
                    vParams.Add("@CompanyId", config.CompanyId);
                    vParams.Add("@RoleIds", config.RolesIds != null && config.RolesIds.Count > 0 ? string.Join(",", config.RolesIds) : null);
                    vParams.Add("@ModeId", config.ModeId);
                    vParams.Add("@PunchCardBased", config.PunchCardBased);
                    vParams.Add("@ShiftBased", config.ShiftBased);
                    return vConn.Query<bool>(StoredProcedureConstants.SpUpsertActivityTrackerModeConfig, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertActivityTrackerModeConfig", "ActivityTrackerRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetActivityTrackerModes);
                return false;
            }
        }

        public TrackerModeOutputModel GetModeType(TrackerModeInputModel input, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@DeviceId", input.DeviceId);
                    vParams.Add("@DesktopName", input.DesktopName);
                    vParams.Add("@HostAddress", input.HostAddress);
                    vParams.Add("@OSName", input.OSName);
                    vParams.Add("@OSVersion", input.OSVersion);
                    vParams.Add("@Platform", input.Platform);
                    vParams.Add("@TimeChampVersion", input.TimechampVersion);
                    return vConn.Query<TrackerModeOutputModel>(StoredProcedureConstants.SpGetModeType, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActivityTrackerModeConfig", "ActivityTrackerRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetModeType);
                return null;
            }
        }

        public List<ActivityTrackerModeConfigurationOutputModel> GetActivityTrackerModeConfig(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ActivityTrackerModeConfigurationOutputModel>(StoredProcedureConstants.SpGetActivityTrackerModeConfig, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActivityTrackerModeConfig", "ActivityTrackerRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetActivityTrackerModes);
                return null;
            }
        }

        public List<UserDailyReminderModel> GetUserTrackerReports(DateTime onDate, Guid? companyId, Guid? leadLevelUserId, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Date", onDate);
                    vParams.Add("@CompanyId", companyId);
                    vParams.Add("@LeadLevelUserId", leadLevelUserId);
                    return vConn.Query<UserDailyReminderModel>(StoredProcedureConstants.SpUserDailyTrackerReport, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserTrackerReports", "ActivityTrackerRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, "Cannot get tracker reports, please contact administrator");
                return null;
            }
        }

        public CompanySummaryReportModel GetCompanyLevelSummaryReport(DateTime onDate, Guid? companyId, Guid? leadLevelUserId, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Date", onDate);
                    vParams.Add("@CompanyId", companyId);
                    return vConn.Query<CompanySummaryReportModel>(StoredProcedureConstants.SpGetCompanyLevelSummaryReport, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCompanyLevelSummaryReport", "ActivityTrackerRepository", sqlException.Message), sqlException);
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, "GetCompanyLevelSummaryReport, please contact administrator");
                return null;
            }
        }

        public List<UserOutputModel> GetUsersCelebratingTheirBirthday(DateTime onDate, Guid companyId, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Date", onDate);
                    vParams.Add("@CompanyId", companyId);
                    return vConn.Query<UserOutputModel>(StoredProcedureConstants.SpGetUsersBirthday, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActivityTrackerModeConfig", "ActivityTrackerRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetActivityTrackerModes);
                return null;
            }
        }

        public List<TeamActivityOutputModel> GetTeamActivity(TeamActivityInputModel teamActivityInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@OnDate", teamActivityInputModel.OnDate);
                    vParams.Add("@BranchIds", teamActivityInputModel.BranchIdXml);
                    vParams.Add("@RoleIds", teamActivityInputModel.RoleIdXml);
                    vParams.Add("@DateFrom", teamActivityInputModel.DateFrom);
                    vParams.Add("@IsForSummary", teamActivityInputModel.IsForSummary);
                    vParams.Add("@DateTo", teamActivityInputModel.DateTo);
                    vParams.Add("@UserIds", teamActivityInputModel.UserIdXml);
                    return vConn.Query<TeamActivityOutputModel>(StoredProcedureConstants.SpGetTeamActivity, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActivityReport", "ActivityTrackerRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAppUsageTimesheetReport);
                return new List<TeamActivityOutputModel>();
            }
        }

        public string GetUserStartTime(ActivityKpiSearchModel activityKpiSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Date", activityKpiSearchModel.Date);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<string>(StoredProcedureConstants.SpGetUserStartTime, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Start Time", "ActivityTrackerRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetTimeUsageDrillDown);
                return null;
            }
        }
        public string GetUserFinishTime(ActivityKpiSearchModel activityKpiSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Date", activityKpiSearchModel.Date);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<string>(StoredProcedureConstants.SpGetUserFinishTime, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Finish Time", "ActivityTrackerRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetTimeUsageDrillDown);
                return null;
            }
        }
        public int GetLateEmployee(ActivityKpiSearchModel activityKpiSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Date", activityKpiSearchModel.Date);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<int>(StoredProcedureConstants.SpGetLateEmployees, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAlteEmployee", "ActivityTrackerRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetActivityTrackerModes);
                return 0;
            }
        }
        public int GetPresentEmployees(ActivityKpiSearchModel activityKpiSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Date", activityKpiSearchModel.Date);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<int>(StoredProcedureConstants.SpGetPresentEmployees, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAlteEmployee", "ActivityTrackerRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetActivityTrackerModes);
                return 0;
            }
        }

        public int GetAbsentEmployees(ActivityKpiSearchModel activityKpiSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Date", activityKpiSearchModel.Date);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<int>(StoredProcedureConstants.SpGetAbsentEmployees, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAlteEmployee", "ActivityTrackerRepository", sqlException.Message), sqlException);
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetActivityTrackerModes);
                return 0;
            }
        }

        public string GetProductiveTime(ActivityKpiSearchModel activityKpiSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Date", activityKpiSearchModel.Date);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<string>(StoredProcedureConstants.SpGetProductiveTime, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetProductiveTime", "ActivityTrackerRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetTotalTimeUsageofApplicationByUsers);
                return null;
            }
        }

        public string GetUnproductiveTime(ActivityKpiSearchModel activityKpiSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Date", activityKpiSearchModel.Date);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<string>(StoredProcedureConstants.SpGetUnproductiveTime, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUnproductiveTime", "ActivityTrackerRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetTotalTimeUsageofApplicationByUsers);
                return null;
            }
        }

        public string GetIdleTime(ActivityKpiSearchModel activityKpiSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Date", activityKpiSearchModel.Date);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<string>(StoredProcedureConstants.SpGetIdleTime, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetIdleTime", "ActivityTrackerRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetTotalTimeUsageofApplicationByUsers);
                return null;
            }
        }


        public string GetNeutralTime(ActivityKpiSearchModel activityKpiSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Date", activityKpiSearchModel.Date);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<string>(StoredProcedureConstants.SpGetNeutralTime, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetNeutralTime", "ActivityTrackerRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetTotalTimeUsageofApplicationByUsers);
                return null;
            }
        }


        public string GetDeskTime(ActivityKpiSearchModel activityKpiSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Date", activityKpiSearchModel.Date);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<string>(StoredProcedureConstants.SpGetDeskTime, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDeskTime", "ActivityTrackerRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetTotalTimeUsageofApplicationByUsers);
                return null;
            }
        }

        public List<AvailabilityCalendarOutputModel> GetAvailabilityCalendar(AvailabilityCalendarInputModel availabilityCalendarInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@DateFrom", availabilityCalendarInputModel.DateFrom);
                    vParams.Add("@DateTo", availabilityCalendarInputModel.DateTo);
                    vParams.Add("@UserId", availabilityCalendarInputModel.UserId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<AvailabilityCalendarOutputModel>(StoredProcedureConstants.SpGetAvailabilityCalendar, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAvailabilityCalendar", "ActivityTrackerRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAvailabilityCalendar);
                return new List<AvailabilityCalendarOutputModel>();
            }
        }

        public CompanyStatus GetCompanyStatus(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<CompanyStatus>(StoredProcedureConstants.SpGetCompanyStatus, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCompanyStatus", "ActivityTrackerRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCompanyStatus);
                return null;
            }
        }
    }
}