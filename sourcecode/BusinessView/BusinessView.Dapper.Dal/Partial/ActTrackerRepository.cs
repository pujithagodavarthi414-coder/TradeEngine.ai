using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using BTrak.Common;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.ActTracker;
using Dapper;
using Btrak.Models.ActivityTracker;

namespace Btrak.Dapper.Dal.Partial
{
    public class ActTrackerRepository : BaseRepository
    {
        public List<Guid?> UpsertActTrackerRoleConfiguration(ActTrackerRoleConfigurationUpsertInputModel actTrackerRoleConfigurationUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@AppUrlId", actTrackerRoleConfigurationUpsertInputModel.AppUrlId);
                    vParams.Add("@ConsiderPunchCard", actTrackerRoleConfigurationUpsertInputModel.ConsiderPunchCard);
                    vParams.Add("@RoleIdXMl", actTrackerRoleConfigurationUpsertInputModel.RoleIdXml);
                    vParams.Add("@FrequencyIndex", actTrackerRoleConfigurationUpsertInputModel.FrequencyIndex);
                    vParams.Add("@Remove", actTrackerRoleConfigurationUpsertInputModel.Remove);
                    vParams.Add("@IsSelectAll", actTrackerRoleConfigurationUpsertInputModel.SelectAll);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertActTrackerRoleConfiguration, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertActTrackerRoleConfiguration", "ActTrackerRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertActTrackerRoleConfiguration);
                return new List<Guid?>();
            }
        }

        public List<ActTrackerAppUrlOutputModel> GetActTrackerAppUrlType(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ActTrackerAppUrlOutputModel>(StoredProcedureConstants.SpGetActTrackerAppUrlType, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActTrackerAppUrlType", "ActTrackerRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetActTrackerAppUrl);
                return new List<ActTrackerAppUrlOutputModel>();
            }
        }

        public List<Guid?> UpsertActTrackerScreenSHotFrequency(ActTrackerScreenShotFrequencyUpsertInputModel actTrackerScreenShotFrequencyUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ScreenShotFrequency", actTrackerScreenShotFrequencyUpsertInputModel.ScreenShotFrequency);
                    vParams.Add("@Multiplier", actTrackerScreenShotFrequencyUpsertInputModel.Multiplier);
                    vParams.Add("@RoleIdXml", actTrackerScreenShotFrequencyUpsertInputModel.RoleIdXml);
                    vParams.Add("@UserIdXml", actTrackerScreenShotFrequencyUpsertInputModel.UserIdXml);
                    vParams.Add("@FrequencyIndex", actTrackerScreenShotFrequencyUpsertInputModel.FrequencyIndex);
                    vParams.Add("@Remove", actTrackerScreenShotFrequencyUpsertInputModel.Remove);
                    vParams.Add("@IsSelectAll", actTrackerScreenShotFrequencyUpsertInputModel.SelectAll);
                    vParams.Add("@IsUserSelectAll", actTrackerScreenShotFrequencyUpsertInputModel.IsUserSelectAll);
                    vParams.Add("@IsRandomScreenshot", actTrackerScreenShotFrequencyUpsertInputModel.IsRandomScreenshot);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertActTrackerScreenShotFrequency, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertActTrackerScreenSHotFrequency", "ActTrackerRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertActTrackerScreenSHotFrequency);
                return new List<Guid?>();
            }
        }

        public List<ActTrackerRoleDropOutputModel> GetActTrackerRoleDropDown(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ActTrackerRoleDropOutputModel>(StoredProcedureConstants.SpGetRolesActTrackerDropDown, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActTrackerRoleDropDown", "ActTrackerRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetActTrackerRoleDropDown);
                return new List<ActTrackerRoleDropOutputModel>();
            }
        }

        public List<Guid?> UpsertActTrackerRolePermission(ActTrackerRolePermissionUpsertInputModel actTrackerRolePermissionUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@RoleIdXml", actTrackerRolePermissionUpsertInputModel.RoleIdXml);
                    vParams.Add("@IdleScreenShotCaptureTime", actTrackerRolePermissionUpsertInputModel.IdleScreenShotCaptureTime);
                    vParams.Add("@IdleAlertTime", actTrackerRolePermissionUpsertInputModel.IdleAlertTime);
                    vParams.Add("@IsDeleteScreenShots", actTrackerRolePermissionUpsertInputModel.IsDeleteScreenShots);
                    vParams.Add("@IsManualEntryTime", actTrackerRolePermissionUpsertInputModel.IsManualEntryTime);
                    vParams.Add("@IsIdleTime", actTrackerRolePermissionUpsertInputModel.IsIdleTime);
                    vParams.Add("@MinimumIdelTime", actTrackerRolePermissionUpsertInputModel.MinimumIdelTime);
                    vParams.Add("@IsRecordActivity", actTrackerRolePermissionUpsertInputModel.IsRecordActivity);
                    vParams.Add("@IsOfflineTracking", actTrackerRolePermissionUpsertInputModel.IsOfflineTracking);
                    vParams.Add("@IsMouseActivity", actTrackerRolePermissionUpsertInputModel.IsMouseActivity);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertActTrackerRolePermission, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertActTrackerRolePermission", "ActTrackerRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertActTrackerRolePermission);
                return new List<Guid?>();
            }
        }

        public List<ActTrackerRoleDropOutputModel> GetActTrackerRoleDeleteDropDown(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ActTrackerRoleDropOutputModel>(StoredProcedureConstants.SpGetRolesActTrackerDeleteDropDown, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActTrackerRoleDeleteDropDown", "ActTrackerRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetActTrackerRoleDeleteDropDown);
                return new List<ActTrackerRoleDropOutputModel>();
            }
        }

        public List<Guid?> UpsertActTrackerAppUrls(ActTrackerAppUrlsUpsertInputModel actTrackerAppUrlsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@AppUrlName", actTrackerAppUrlsUpsertInputModel.AppUrlName);
                    vParams.Add("@AppUrlImage", actTrackerAppUrlsUpsertInputModel.AppUrlImage);
                    vParams.Add("@ProductiveRoleIdsXMl", actTrackerAppUrlsUpsertInputModel.ProductiveRoleIdsXml);
                    vParams.Add("@UnProductiveRoleIdsXMl", actTrackerAppUrlsUpsertInputModel.UnProductiveRoleIdsXml);
                    vParams.Add("@AppUrlNameId", actTrackerAppUrlsUpsertInputModel.AppUrlNameId);
                    vParams.Add("@IsArchived", actTrackerAppUrlsUpsertInputModel.IsArchive);
                    vParams.Add("@IsApp", actTrackerAppUrlsUpsertInputModel.IsApp);
                    vParams.Add("@ApplicationCategoryId", actTrackerAppUrlsUpsertInputModel.ApplicationCategoryId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertActTrackerAppUrls, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertActTrackerAppUrls", "ActTrackerRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertActTrackerAppUrls);
                return new List<Guid?>();
            }
        }

        public List<ActTrackerAppUrlApiOutputModel> GetActTrackerAppUrls(ActTrackerAppUrlsSearchInputModel actTrackerAppUrlsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@AppUrlsId", actTrackerAppUrlsSearchInputModel?.AppUrlsId ?? null);
                    vParams.Add("@SearchText", actTrackerAppUrlsSearchInputModel?.SearchText ?? null);
                    vParams.Add("@IsProductive", actTrackerAppUrlsSearchInputModel?.IsProductive ?? null);
                    vParams.Add("@IsArchive", actTrackerAppUrlsSearchInputModel?.IsArchived ?? null);
                    vParams.Add("@CompanyIdFromTracker", actTrackerAppUrlsSearchInputModel?.CompanyIdFromTracker ?? null);
                    return vConn.Query<ActTrackerAppUrlApiOutputModel>(StoredProcedureConstants.SpGetActTrackerAppUrls, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActTrackerAppUrls", "ActTrackerRepository ", sqlException.Message), sqlException);
                   SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetActTrackerAppsUrls);
                return new List<ActTrackerAppUrlApiOutputModel>();
            }
        }

        public List<ActTrackerRolePermissionRolesOutputModel> GetActTrackerRolePermissionRoles(ActTrackerRolePermissionRolesInputModel actTrackerRolePermissionRolesInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsDeletedScreenShots", actTrackerRolePermissionRolesInputModel.IsDeleteScreenShots);
                    vParams.Add("@IsManualEntry", actTrackerRolePermissionRolesInputModel.IsManualEntryTime);
                    vParams.Add("@IsRecordActivity", actTrackerRolePermissionRolesInputModel.IsRecordActivity);
                    vParams.Add("@IsIdleTime", actTrackerRolePermissionRolesInputModel.IsIdleTime);
                    vParams.Add("@IsOffileTracking", actTrackerRolePermissionRolesInputModel.IsOffileTracking);
                    return vConn.Query<ActTrackerRolePermissionRolesOutputModel>(StoredProcedureConstants.SpGetActTrackerRolePermissionRoles, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActTrackerRolePermissionRoles", "ActTrackerRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetActTrackerRoleDeleteDropDown);
                return new List<ActTrackerRolePermissionRolesOutputModel>();
            }
        }

        public List<ActTrackerAppReportUsageSearchOutputModel> GetActTrackerAppReportUsage(EmployeeWebAppUsageTimeSearchInputModel employeeWebAppUsageTimeSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@UserId", employeeWebAppUsageTimeSearchInputModel.UserIdXml);
                    vParams.Add("@RoleId", employeeWebAppUsageTimeSearchInputModel.RoleIdXml);
                    vParams.Add("@BranchId", employeeWebAppUsageTimeSearchInputModel.BranchIdXml);
                    vParams.Add("@DateFrom", employeeWebAppUsageTimeSearchInputModel.DateFrom);
                    vParams.Add("@DateTo", employeeWebAppUsageTimeSearchInputModel.DateTo);
                    vParams.Add("@PageNo", employeeWebAppUsageTimeSearchInputModel.PageNumber);
                    vParams.Add("@PageSize", employeeWebAppUsageTimeSearchInputModel.PageSize);
                    vParams.Add("@ApplicationType", employeeWebAppUsageTimeSearchInputModel.ApplicationType);
                    vParams.Add("@IsIdleNotRequired", employeeWebAppUsageTimeSearchInputModel.IsIdleNotRequired);
                    vParams.Add("@SearchText", employeeWebAppUsageTimeSearchInputModel.SearchText);
                    return vConn.Query<ActTrackerAppReportUsageSearchOutputModel>(StoredProcedureConstants.SpGetAppUsageReport, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActTrackerAppReportUsage", "ActTrackerRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetActTrackerRoleDeleteDropDown);
                return new List<ActTrackerAppReportUsageSearchOutputModel>();
            }
        }

        public List<ActTrackerAppReportUsageSearchOutputModel> GetActTrackerAppReportUsageForChart(EmployeeWebAppUsageTimeSearchInputModel employeeWebAppUsageTimeSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@UserId", employeeWebAppUsageTimeSearchInputModel.UserIdXml);
                    vParams.Add("@RoleId", employeeWebAppUsageTimeSearchInputModel.RoleIdXml);
                    vParams.Add("@BranchId", employeeWebAppUsageTimeSearchInputModel.BranchIdXml);
                    vParams.Add("@DateFrom", employeeWebAppUsageTimeSearchInputModel.DateFrom);
                    vParams.Add("@DateTo", employeeWebAppUsageTimeSearchInputModel.DateTo);
                    vParams.Add("@SearchText", employeeWebAppUsageTimeSearchInputModel.SearchText);
                    return vConn.Query<ActTrackerAppReportUsageSearchOutputModel>(StoredProcedureConstants.SpGetAppUsageReportForChart, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActTrackerAppReportUsageForChart", "ActTrackerRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetActTrackerRoleDeleteDropDown);
                return new List<ActTrackerAppReportUsageSearchOutputModel>();
            }
        }

        public ActTrackerScreenshotFrequencySearchOutputModel GetActTrackerUserScreenshotFrequency(string deviceId, List<ValidationMessage> validationMessages, Guid? loggedInUser)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@DeviceId", deviceId);
                    vParams.Add("@OperationsPerformedBy", loggedInUser);
                    return vConn.Query<ActTrackerScreenshotFrequencySearchOutputModel>(StoredProcedureConstants.SpGetActivityTrackerScreenshotFrequency, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActTrackerUserScreenshotFrequency", "ActTrackerRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetActTrackerUserScreenshotFrequency);
                return null;
            }
        }

        public List<ActTrackerScreenshotsOutputModel> GetActTrackerUserActivityScreenshots(EmployeeWebAppUsageTimeSearchInputModel employeeWebAppUsageTimeSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@DateFrom", employeeWebAppUsageTimeSearchInputModel.DateFrom);
                    vParams.Add("@DateTo", employeeWebAppUsageTimeSearchInputModel.DateTo);
                    vParams.Add("@UserIdXml", employeeWebAppUsageTimeSearchInputModel.UserIdXml);
                    vParams.Add("@PageSize", employeeWebAppUsageTimeSearchInputModel.PageSize);
                    vParams.Add("@PageNo", employeeWebAppUsageTimeSearchInputModel.PageNumber);
                    vParams.Add("@IsFullDay", employeeWebAppUsageTimeSearchInputModel.IsApp);
                    vParams.Add("@TimeZone", employeeWebAppUsageTimeSearchInputModel.TimeZone);
                    vParams.Add("@IsForLatestScreenshots", employeeWebAppUsageTimeSearchInputModel.IsForLatestScreenshots);
                    return vConn.Query<ActTrackerScreenshotsOutputModel>(StoredProcedureConstants.SpGetUserActivityScreenShots, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActTrackerUserActivityScreenshots", "ActTrackerRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetActTrackerUserScreenshotFrequency);
                return new List<ActTrackerScreenshotsOutputModel>();
            }
        }

        public List<GetActTrackerRoleConfigurationRolesOutputModel> GetActTrackerRoleConfigurationRoles(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<GetActTrackerRoleConfigurationRolesOutputModel>(StoredProcedureConstants.SpGetRolesActTrackerRoleConfiguration, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActTrackerRoleConfigurationRoles", "ActTrackerRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetActTrackerRoleDropDown);
                return new List<GetActTrackerRoleConfigurationRolesOutputModel>();
            }
        }

        public List<GetActTrackerScreenShotFrequencyRolesOutputModel> GetActTrackerScreenShotFrequencyRoles(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<GetActTrackerScreenShotFrequencyRolesOutputModel>(StoredProcedureConstants.SpGetRolesActTrackerScreenShotFrequency, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActTrackerScreenShotFrequencyRoles", "ActTrackerRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetActTrackerRoleDropDown);
                return new List<GetActTrackerScreenShotFrequencyRolesOutputModel>();
            }
        }

        public List<GetActTrackerScreenShotFrequencyRolesOutputModel> GetActTrackerScreenShotFrequencyUser(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<GetActTrackerScreenShotFrequencyRolesOutputModel>(StoredProcedureConstants.SpGetRolesActTrackerScreenShotFrequencyUsers, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActTrackerScreenShotFrequencyUser", "ActTrackerRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetActTrackerRoleDropDown);
                return new List<GetActTrackerScreenShotFrequencyRolesOutputModel>();
            }
        }

        public string MultipleDeleteScreenShot(ActTrackerScreenshotDeleteInputModel actTrackerScreenshotDeleteInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@ScreenshotId", actTrackerScreenshotDeleteInputModel.ScreenshotXml);
                    vParams.Add("@Reason", actTrackerScreenshotDeleteInputModel.Reason);
                    return vConn.Query<string>(StoredProcedureConstants.SpMultipleDeleteScreenShot, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "MultipleDeleteScreenShot", "ActTrackerRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetActTrackerUserScreenshotFrequency);
                return null;
            }
        }

        public bool? GetActTrackerRecorder(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<bool>(StoredProcedureConstants.SpGetActivityTrackerRecorder, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActTrackerRecorder", "ActTrackerRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetActTrackerUserScreenshotFrequency);
                return null;
            }
        }

        public ActivityTrackerConfigModel GetActTrackerRecorderForTracker(ActivityTrackerInsertStatusInputModel activityTrackerInsertStatusInputModel, List<ValidationMessage> validationMessages, Guid? loggedInUser)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInUser ?? Guid.Empty);
                    vParams.Add("@Mac", activityTrackerInsertStatusInputModel.MacAddressXml);
                    vParams.Add("@DeviceId", activityTrackerInsertStatusInputModel.DeviceId);
                    vParams.Add("@Time", activityTrackerInsertStatusInputModel.Time);
                    vParams.Add("@Date", activityTrackerInsertStatusInputModel.Date);
                    vParams.Add("@OSName", activityTrackerInsertStatusInputModel.OSName);
                    vParams.Add("@OSVersion", activityTrackerInsertStatusInputModel.OSVersion);
                    vParams.Add("@Platform", activityTrackerInsertStatusInputModel.Platform);
                    vParams.Add("@TimeChampVersion", activityTrackerInsertStatusInputModel.TimechampVersion);
                    return vConn.Query<ActivityTrackerConfigModel>(StoredProcedureConstants.SpGetActivityTrackerRecorderForTracker, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActTrackerRecorderForTracker", "ActTrackerRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetActTrackerUserScreenshotFrequency);
                return null;
            }
        }

        public byte[] UpsertActivityTrackerConfigurationState(ActivityTrackerConfigurationStateInputModel activityTrackerConfigurationStateInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@ConfigurationStateId", activityTrackerConfigurationStateInputModel.Id);
                    vParams.Add("@IsTracking", activityTrackerConfigurationStateInputModel.IsTracking);
                    vParams.Add("@IsBasicTracking", activityTrackerConfigurationStateInputModel.IsBasicTracking);
                    vParams.Add("@IsScreenshot", activityTrackerConfigurationStateInputModel.IsScreenshot);
                    vParams.Add("@IsDelete", activityTrackerConfigurationStateInputModel.IsDelete);
                    vParams.Add("@DeleteRoles", activityTrackerConfigurationStateInputModel.DeleteRoles);
                    vParams.Add("@IsRecord", activityTrackerConfigurationStateInputModel.IsRecord);
                    vParams.Add("@RecordRoles", activityTrackerConfigurationStateInputModel.RecordRoles);
                    vParams.Add("@IsIdealTime", activityTrackerConfigurationStateInputModel.IsIdealTime);
                    vParams.Add("@IdealTimeRoles", activityTrackerConfigurationStateInputModel.IdealTimeRoles);
                    vParams.Add("@IsManualTime", activityTrackerConfigurationStateInputModel.IsManualTime);
                    vParams.Add("@ManualTimeRole", activityTrackerConfigurationStateInputModel.ManualTimeRole);
                    vParams.Add("@IsOfflineTracking", activityTrackerConfigurationStateInputModel.IsOfflineTracking);
                    vParams.Add("@OfflineOpen", activityTrackerConfigurationStateInputModel.OfflineOpen);
                    vParams.Add("@IsMouse", activityTrackerConfigurationStateInputModel.IsMouse);
                    vParams.Add("@MouseRoles", activityTrackerConfigurationStateInputModel.MouseRoles);
                    vParams.Add("@TimeStamp", activityTrackerConfigurationStateInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@DisableUrls", activityTrackerConfigurationStateInputModel.DisableUrls);
                    return vConn.Query<byte[]>(StoredProcedureConstants.SpUpsertActivityTrackerConfigurationState, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertActivityTrackerConfigurationState", "ActTrackerRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertActivityTrackerConfigurationState);
                return null;
            }
        }

        public List<ActivityTrackerHistoryOutputModel> GetActivityTrackerHistory(ActivityTrackerHistoryModel activityTrackerHistoryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@PageNumber", activityTrackerHistoryModel.PageNumber);
                    vParams.Add("@PageSize", activityTrackerHistoryModel.PageSize);
                    vParams.Add("@Category", activityTrackerHistoryModel.SelectedCategory);
                    return vConn.Query<ActivityTrackerHistoryOutputModel>(StoredProcedureConstants.SpGetActivityTrackerHistory, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Upsert Activity Tracker Configuration State", "Act tracker repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertActivityTrackerConfigurationState);
                return null;
            }
        }

        public ActivityTrackerUserDetailsOutputModel UpsertActivityTrackerUserConfiguration(ActivityTrackerUserConfigurationInputModel activityTrackerUserConfigurationInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@Id", activityTrackerUserConfigurationInputModel.Id);
                    vParams.Add("@AppUrlId", activityTrackerUserConfigurationInputModel.AppUrlId);
                    vParams.Add("@EmployeeId", activityTrackerUserConfigurationInputModel.EmployeeId);
                    vParams.Add("@UserId", activityTrackerUserConfigurationInputModel.UserId);
                    vParams.Add("@Track", activityTrackerUserConfigurationInputModel.Track);
                    vParams.Add("@ScreenshotFrequency", activityTrackerUserConfigurationInputModel.ScreenshotFrequency);
                    vParams.Add("@Multiplier", activityTrackerUserConfigurationInputModel.Multiplier);
                    vParams.Add("@IsTrack", activityTrackerUserConfigurationInputModel.IsTrack);
                    vParams.Add("@IsScreenshot", activityTrackerUserConfigurationInputModel.IsScreenshot);
                    vParams.Add("@IsKeyboardTracking", activityTrackerUserConfigurationInputModel.IsKeyboardTracking);
                    vParams.Add("@IsMouseTracking", activityTrackerUserConfigurationInputModel.IsMouseTracking);
                    vParams.Add("@TimeStamp", activityTrackerUserConfigurationInputModel.TimeStamp, DbType.Binary);
                    return vConn.Query<ActivityTrackerUserDetailsOutputModel>(StoredProcedureConstants.SpUpsertActivityTrackerUserConfiguration, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertActivityTrackerUserConfiguration", "ActTrackerRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertActivityTrackerUserConfiguration);
                return null;
            }
        }

        public ActivityTrackerConfigurationStateOutputModel GetActivityTrackerConfigurationState(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ActivityTrackerConfigurationStateOutputModel>(StoredProcedureConstants.SpGetActivityTrackerConfigurationState, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActivityTrackerConfigurationState", "ActTrackerRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSpGetActivityTrackerConfigurationState);
                return null;
            }
        }

        public List<ActivityTrackerUserStatusOutputModel> GetActTrackerUserStatus(EmployeeWebAppUsageTimeSearchInputModel employeeWebAppUsageTimeSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@DateFrom", employeeWebAppUsageTimeSearchInputModel.DateFrom);
                    vParams.Add("@DateTo", employeeWebAppUsageTimeSearchInputModel.DateTo);
                    vParams.Add("@IsActive", employeeWebAppUsageTimeSearchInputModel.IsApp);
                    vParams.Add("@IsForScreenshots", employeeWebAppUsageTimeSearchInputModel.IsForScreenshots);
                    vParams.Add("@UserId", employeeWebAppUsageTimeSearchInputModel.UserIdGuid);
                    return vConn.Query<ActivityTrackerUserStatusOutputModel>(StoredProcedureConstants.SpGetActivityTrackerRecorderActiveUser, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActTrackerUserStatus", "ActTrackerRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetActTrackerUserStatus);
                return null;
            }
        }

        public List<ActTrackerScreenshotsOutputModel> GetActTrackerAllUserActivityScreenshots(EmployeeWebAppUsageTimeSearchInputModel employeeWebAppUsageTimeSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@DateFrom", employeeWebAppUsageTimeSearchInputModel.DateFrom);
                    vParams.Add("@DateTo", employeeWebAppUsageTimeSearchInputModel.DateTo);
                    vParams.Add("@UserIdXml", employeeWebAppUsageTimeSearchInputModel.UserIdXml);
                    vParams.Add("@PageSize", employeeWebAppUsageTimeSearchInputModel.PageSize);
                    vParams.Add("@PageNo", employeeWebAppUsageTimeSearchInputModel.PageNumber);
                    vParams.Add("@TimeZone", employeeWebAppUsageTimeSearchInputModel.TimeZone);
                    vParams.Add("@IsFullDay", employeeWebAppUsageTimeSearchInputModel.IsApp);
                    return vConn.Query<ActTrackerScreenshotsOutputModel>(StoredProcedureConstants.SpGetAllUserActivityScreenShots, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActTrackerAllUserActivityScreenshots", "ActTrackerRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetActTrackerUserScreenshotFrequency);
                return new List<ActTrackerScreenshotsOutputModel>();
            }
        }

        public List<ActTrackerScreenshotsOutputModel> GetActTrackerUserActivityScreenshotsBasedOnId(EmployeeWebAppUsageTimeSearchInputModel employeeWebAppUsageTimeSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@DateFrom", employeeWebAppUsageTimeSearchInputModel.DateFrom);
                    vParams.Add("@DateTo", employeeWebAppUsageTimeSearchInputModel.DateTo);
                    vParams.Add("@PageSize", employeeWebAppUsageTimeSearchInputModel.PageSize);
                    vParams.Add("@PageNo", employeeWebAppUsageTimeSearchInputModel.PageNumber);
                    vParams.Add("@IsFullDay", employeeWebAppUsageTimeSearchInputModel.IsApp);
                    vParams.Add("@UserStoryId", employeeWebAppUsageTimeSearchInputModel.UserStoryId);
                    vParams.Add("@TimeZone", employeeWebAppUsageTimeSearchInputModel.TimeZone);
                    vParams.Add("@UserId", employeeWebAppUsageTimeSearchInputModel.SelectedUserId);
                    return vConn.Query<ActTrackerScreenshotsOutputModel>(StoredProcedureConstants.SpGetUserActivityScreenShotsBasedOnId, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Get Act Tracker User Activity Screenshots", "Act tracker repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetActTrackerUserScreenshotFrequency);
                return new List<ActTrackerScreenshotsOutputModel>();
            }
        }

        public List<MostProductiveUsersOutputModel> GetMostProductiveUsers(MostProductiveUsersInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@ApplicationTypeName", inputModel.ApplicationTypeName);
                    vParams.Add("@DateFrom", inputModel.DateFrom);
                    vParams.Add("@DateTo", inputModel.DateTo);
                    return vConn.Query<MostProductiveUsersOutputModel>(StoredProcedureConstants.SpGetMostProductiveUsers, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetMostProductiveUsers", "ActTrackerRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetActTrackerUserStatus);
                return null;
            }
        }

        public List<TrackingUserModel> GetTrackingUsers(TrackingUserModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@Status", inputModel.Status);
                    vParams.Add("@Date", inputModel.Date);
                    return vConn.Query<TrackingUserModel>(StoredProcedureConstants.SpGetTrackingUsers, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTrackingUsers", "ActTrackerRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetActTrackerUserStatus);
                return null;
            }
        }
    }
}
