using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.Widgets;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace Btrak.Dapper.Dal.Partial
{
    public class WidgetRepository : BaseRepository
    {
        public Guid? UpsertWidget(WidgetInputModel widgetInputs, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@WidgetId", widgetInputs.WidgetId);
                    vParams.Add("@WidgetName", widgetInputs.WidgetName);
                    vParams.Add("@Description", widgetInputs.Description);
                    vParams.Add("@RoleIds", widgetInputs.RoleIdsXml);
                    vParams.Add("@IsArchived", widgetInputs.IsArchived);
                    vParams.Add("@TimeStamp", widgetInputs.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@TagsXml", widgetInputs.TagIdsXml);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertWidget, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertWidget", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionWidgetUpsert);
                return null;
            }
        }
        public Guid? UpsertChildWidget(Guid childWidgetId, Guid parentId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@WidgetId", childWidgetId);
                    vParams.Add("@parentId", parentId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertChildWidget, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertWidget", "WidgetRepository", sqlException.Message), sqlException);



                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionWidgetUpsert);
                return null;
            }
        }
        public Guid? UpsertImportWidget(WidgetInputModel widgetInputs, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@WidgetId", widgetInputs.WidgetId);
                    vParams.Add("@RoleIds", widgetInputs.RoleIdsXml);
                    vParams.Add("@Description", widgetInputs.Description);
                    vParams.Add("@IsCustomWidget", widgetInputs.IsCustomWidget);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@TagsXml", widgetInputs.TagIdsXml);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertImportWidget, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertWidget", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionWidgetUpsert);
                return null;
            }
        }

        public List<WidgetApiReturnModel> GetWidgets(WidgetSearchCriteriaInputModel widgetSearchCriteriaInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@WidgetId", widgetSearchCriteriaInput.WidgetId);
                    vParams.Add("@SearchText", widgetSearchCriteriaInput.SearchText);
                    vParams.Add("@IsArchived", widgetSearchCriteriaInput.IsArchived);
                    vParams.Add("@IsExport", widgetSearchCriteriaInput.IsExoport);
                    vParams.Add("@WidgetName", widgetSearchCriteriaInput.WidgetName);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<WidgetApiReturnModel>(StoredProcedureConstants.SpGetWidgets, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetWidgets", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetWidgets);
                return new List<WidgetApiReturnModel>();
            }
        }


        public List<TagApiReturnModel> GetWidgetTags(bool? isFromSearch, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("isFromSearch", isFromSearch);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<TagApiReturnModel>(StoredProcedureConstants.SpGetWidgetTags, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetWidgetTags", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetWidgets);
                return new List<TagApiReturnModel>();
            }
        }

        public Guid? UpsertDashboardConfiguration(DashboardConfigurationInputModel dashboardConfigurationInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@DashboardConfigurationId", dashboardConfigurationInputModel.DashboardConfigurationId);
                    vParams.Add("@DashboardId", dashboardConfigurationInputModel.DashboardId);
                    vParams.Add("@DefaultDashboardRoles", dashboardConfigurationInputModel.DefaultDashboardRoles);
                    vParams.Add("@ViewRoles", dashboardConfigurationInputModel.ViewRoles);
                    vParams.Add("@EditRoles", dashboardConfigurationInputModel.EditRoles);
                    vParams.Add("@DeleteRoles", dashboardConfigurationInputModel.DeleteRoles);
                    vParams.Add("@TimeStamp", dashboardConfigurationInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertDashboardConfiguration, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertDashboardConfiguration", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionDashboardConfigurationUpsert);
                return null;
            }
        }

        public List<DashboardConfigurationReturnModel> GetDashboardConfigurations(DashboardConfigurationInputModel dashboardConfigurationInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@DashboardConfigurationId", dashboardConfigurationInputModel.DashboardConfigurationId);
                    vParams.Add("@DashboardId", dashboardConfigurationInputModel.DashboardId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<DashboardConfigurationReturnModel>(StoredProcedureConstants.SpGetDashboardConfigurations, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDashboardConfigurations", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionDashboardConfigurationsGet);
                return new List<DashboardConfigurationReturnModel>();
            }
        }

        public List<WidgetApiReturnModel> GetWidgetsBasedOnUser(WidgetSearchCriteriaInputModel widgetSearchCriteriaInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@WidgetId", widgetSearchCriteriaInput.WidgetId);
                    vParams.Add("@SearchText", widgetSearchCriteriaInput.SearchText);
                    vParams.Add("@IsArchived", widgetSearchCriteriaInput.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    if (widgetSearchCriteriaInput.IsExoport == true)
                    {
                        return vConn.Query<WidgetApiReturnModel>(StoredProcedureConstants.SpGetWidgetsBasedOnUserForExport, vParams, commandType: CommandType.StoredProcedure, commandTimeout: 0).ToList();
                    }
                    vParams.Add("@SearchTag", widgetSearchCriteriaInput.Tags);
                    vParams.Add("@PageNumber", widgetSearchCriteriaInput.PageNumber);
                    vParams.Add("@PageSize", widgetSearchCriteriaInput.PageSize);
                    vParams.Add("@SortBy", widgetSearchCriteriaInput.SortBy);
                    vParams.Add("@SortDirection", widgetSearchCriteriaInput.SortDirection);
                    vParams.Add("@TagId", widgetSearchCriteriaInput.TagId);
                    vParams.Add("@IsFavouriteWidget", widgetSearchCriteriaInput.IsFavouriteWidget);
                    vParams.Add("@IsFromSearch", widgetSearchCriteriaInput.IsFromSearch);
                    vParams.Add("@IsQuery", widgetSearchCriteriaInput.IsQuery);
                    return vConn.Query<WidgetApiReturnModel>(StoredProcedureConstants.SpGetWidgetsBasedOnUser, vParams, commandType: CommandType.StoredProcedure, commandTimeout: 0).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetWidgetsBasedOnUser", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetWidgets);
                return new List<WidgetApiReturnModel>();
            }
        }

        public List<WidgetTagsAndWorkspaceReturnModel> GetWidgetTagsAndWorkspaces(List<WidgetTagsAndWorkspaceModel> widgetSearchCriteriaInput, string widgetXml, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@WidgetDetailsXML", widgetXml);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<WidgetTagsAndWorkspaceReturnModel>(StoredProcedureConstants.SpGetWidgetTagsAndWorkspaces, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetWidgetTagsAndWorkspaces", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetWidgets);
                return new List<WidgetTagsAndWorkspaceReturnModel>();
            }
        }

        public Guid? AddWidgetToFavourites(FavouriteWidgetsInputModel widgetSearchCriteriaInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@WidgetId", widgetSearchCriteriaInput.WidgetId);
                    vParams.Add("@IsFavouriteWidget", widgetSearchCriteriaInput.IsFavouriteWidget);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpAddWidgetToFavourites, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "AddWidgetToFavourites", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetWidgets);
                return null;
            }
        }

        public List<WidgetApiReturnModel> GetAllWidgets(WidgetSearchCriteriaInputModel widgetSearchCriteriaInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@WidgetId", widgetSearchCriteriaInput.WidgetId);
                    vParams.Add("@SearchText", widgetSearchCriteriaInput.SearchText);
                    vParams.Add("@IsArchived", widgetSearchCriteriaInput.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@PageNumber", widgetSearchCriteriaInput.PageNumber);
                    vParams.Add("@PageSize", widgetSearchCriteriaInput.PageSize);
                    vParams.Add("@SortBy", widgetSearchCriteriaInput.SortBy);
                    vParams.Add("@SortDirection", widgetSearchCriteriaInput.SortDirection);
                    return vConn.Query<WidgetApiReturnModel>(StoredProcedureConstants.SpGetAllWidgets, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllWidgets", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetWidgets);
                return new List<WidgetApiReturnModel>();
            }
        }

        public bool IsValidProcedure(string procName, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ProcName", procName);
                    return vConn.Query<bool>(StoredProcedureConstants.SpGetIsVAlidProc, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "IsValidProcedure", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetIsProcValid);
                return false;
            }
        }

        public Guid? UpsertWorkspace(WorkspaceInputModel workspaceInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@WorkspaceId", workspaceInput.WorkspaceId);
                    vParams.Add("@WorkspaceName", workspaceInput.WorkspaceName);
                    vParams.Add("@Description", workspaceInput.Description);
                    vParams.Add("@RoleIds", workspaceInput.SelectedRoleIds);
                    vParams.Add("@EditRoles", workspaceInput.EditRoleIds);
                    vParams.Add("@DeleteRoles", workspaceInput.DeleteRoleIds);
                    vParams.Add("@IsArchived", workspaceInput.IsArchived);
                    vParams.Add("@IsHidden", workspaceInput.IsHidden);
                    vParams.Add("@IsCustomizedFor", workspaceInput.IsCustomizedFor);
                    vParams.Add("@IsListView", workspaceInput.IsListView);
                    vParams.Add("@TimeStamp", workspaceInput.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@MenuItemId", workspaceInput.MenuItemId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertWorkspace, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertWorkspace", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionWorkspaceUpsert);
                return null;
            }
        }

        public Guid? InsertDuplicateDashboard(WorkspaceInputModel workspaceInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@WorkspaceId", workspaceInput.WorkspaceId);
                    vParams.Add("@WorkspaceName", workspaceInput.WorkspaceName);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpInsertDuplicateDashboard, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertDuplicateDashboard", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionWorkspaceUpsert);
                return null;
            }
        }

        public List<WorkspaceApiReturnModel> GetWorkspaces(WorkspaceSearchCriteriaInputModel workspaceSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@WorkspaceId", workspaceSearchCriteriaInputModel.WorkspaceId);
                    vParams.Add("@SearchText", workspaceSearchCriteriaInputModel.SearchText);
                    vParams.Add("@IsArchived", workspaceSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@IsHidden", workspaceSearchCriteriaInputModel.IsHidden);
                    vParams.Add("@WorkspaceName", workspaceSearchCriteriaInputModel.WorkspaceName);
                    vParams.Add("@IsFromExport", workspaceSearchCriteriaInputModel.IsFromExport);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@MenuItemId", workspaceSearchCriteriaInputModel.MenuItemId);
                    return vConn.Query<WorkspaceApiReturnModel>(StoredProcedureConstants.SpGetWorkspaces, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetWorkspaces", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetWorkspaces);
                return new List<WorkspaceApiReturnModel>();
            }
        }

        public Guid? DeleteWorkspace(WorkspaceInputModel workspaceInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@WorkspaceId", workspaceInputModel.WorkspaceId);
                    vParams.Add("@Timestamp", workspaceInputModel.TimeStamp);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpDeleteWorkspace, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteWorkspace", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetDashboards);
                return null;
            }
        }

        public Guid? UpdateDashboard(DashboardInputModel dashboardInputModel, string dashboardXml, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@WorkspaceId", dashboardInputModel.WorkspaceId);
                    vParams.Add("@WidgetContent", dashboardXml);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpdateDashboard, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateDashboard", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionDashboardUpsert);
                return null;
            }
        }

        public Guid? InsertDashboard(DashboardInputModel dashboardInputModel, string dashboardXml, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@WorkspaceId", dashboardInputModel.WorkspaceId);
                    vParams.Add("@WidgetContent", dashboardXml);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsFromImport", dashboardInputModel.IsFromImport);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpInsertDashboard, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertDashboard", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionDashboardUpsert);
                return null;
            }
        }

        public Guid? SetDefaultDashboardForUser(DashboardInputModel dashboardInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@DashboardId", dashboardInputModel.WorkspaceId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@DefaultForAll", dashboardInputModel.IsDefaultforAll);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpSetDefaultDashboardForUser, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SetDefaultDashboardForUser", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSetDefaultUserDashboard);
                return null;
            }
        }

        public CustomAppDashboardPersistanceModel GetCustomAppDashboardPersistanceForUser(CustomAppDashboardPersistanceModel persistanceModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@DashboardId", persistanceModel.DashboardId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<CustomAppDashboardPersistanceModel>(StoredProcedureConstants.SpGetCustomAppPersistanceForUser, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCustomAppDashboardPersistanceForUser", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCustomAppDashboardPersistance);
                return null;
            }
        }

        public Guid? SetCustomAppDashboardPersistanceForUser(CustomAppDashboardPersistanceModel persistanceModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@DashboardId", persistanceModel.DashboardId);
                    vParams.Add("@CustomApplicationId", persistanceModel.CustomApplicationId);
                    vParams.Add("@CustomFormId", persistanceModel.CustomFormId);
                    vParams.Add("@DashboardIdToNavigate", persistanceModel.DashboardIdToNavigate);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@QuerytoFilter", persistanceModel.QuerytoFilter);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpSetCustomAppPersistanceForUser, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SetCustomAppDashboardPersistanceForUser", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSetCustomAppDashboardPersistance);
                return null;
            }
        }


        public Guid? UpdateDashboardName(DashboardModel dashboardModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@DashboardId", dashboardModel.DashboardId);
                    vParams.Add("@DashboardName", dashboardModel.DashboardName);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpdateDashboardName, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateDashboardName", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpdateDashboardName);
                return null;
            }
        }

        public Guid? UpsertDynamicModule(DynamicModuleUpsertModel dynamicModuleUpsertModel , LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@DynamicModuleId", dynamicModuleUpsertModel.DynamicModuleId);
                    vParams.Add("@DynamicModuleName", dynamicModuleUpsertModel.DynamicModuleName);
                    vParams.Add("@DynamicTabsXML", dynamicModuleUpsertModel.DynamicTabsXML);
                    vParams.Add("@ModuleIcon", dynamicModuleUpsertModel.ModuleIcon);
                    vParams.Add("@ViewRole", dynamicModuleUpsertModel.ViewRole);
                    vParams.Add("@EditRole", dynamicModuleUpsertModel.EditRole);
                    vParams.Add("@IsArchived", dynamicModuleUpsertModel.IsArchived);
                    vParams.Add("@TimeStamp", dynamicModuleUpsertModel.TimeStamp , DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertDynamicModule, vParams, commandType: CommandType.StoredProcedure, commandTimeout: 0).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertDynamicModule", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.DynamicModuleNameExists);
                return null;
            }
        }

        public List<DashboardApiReturnModel> GetDashboards(DashboardSearchCriteriaInputModel dashboardSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@DashboardId", dashboardSearchCriteriaInputModel.DashboardId);
                    vParams.Add("@WorkspaceId", dashboardSearchCriteriaInputModel.WorkspaceId);
                    vParams.Add("@IsArchived", dashboardSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@CustomWidgetId", dashboardSearchCriteriaInputModel.CustomWidgetId);
                    vParams.Add("@AppName", dashboardSearchCriteriaInputModel.AppName);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@DashboardName", dashboardSearchCriteriaInputModel.DashboardName);
                    vParams.Add("@IsFromExport", dashboardSearchCriteriaInputModel.IsFromExport);
                    return vConn.Query<DashboardApiReturnModel>(StoredProcedureConstants.SpGetDashboards, vParams, commandTimeout: 0, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDashboards", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetDashboards);
                return new List<DashboardApiReturnModel>();
            }
        }

        public Guid? GetCustomizedDashboardId(DashboardSearchCriteriaInputModel dashboardSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@IsCustomizedFor", dashboardSearchCriteriaInputModel.IsCustomizedFor);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpGetCustomizedDashboardId, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCustomizedDashboardId", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCustomDashboardId);
                return null;
            }
        }

        public List<SubQueryTypeModel> GetSubQueryTypes(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<SubQueryTypeModel>(StoredProcedureConstants.SpGetSubQueryTypes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetSubQueryTypes", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCustomDashboardId);
                return null;
            }
        }

        public List<ColumnFormatTypeModel> GetColumnFormatTypes(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ColumnFormatTypeModel>(StoredProcedureConstants.SpGetColumnFormatTypes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetColumnFormatTypes", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCustomDashboardId);
                return null;
            }
        }

        public List<ColumnFormatTypeModel> GetColumnFormatTypesById(Guid? ColumnFormatTypeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@ColumnFormatTypeId", ColumnFormatTypeId);
                    return vConn.Query<ColumnFormatTypeModel>(StoredProcedureConstants.SpGetColumnFormatTypesById, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetColumnFormatTypesById", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCustomDashboardId);
                return null;
            }
        }

        public List<ColumnFormatTypeModel> GetColumnFormatById(Guid? ColumnFormatTypeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@ColumnFormatTypeId", ColumnFormatTypeId);

                    return vConn.Query<ColumnFormatTypeModel>(StoredProcedureConstants.SpGetColumnFormatById, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetColumnFormatTypesById", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCustomDashboardId);
                return null;
            }
        }


        public Guid? UpsertCustomWidget(CustomWidgetsInputModel widgetInputs, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CustomWidgetId", widgetInputs.CustomWidgetId);
                    vParams.Add("@CustomWidgetName", widgetInputs.CustomWidgetName);
                    vParams.Add("@Description", widgetInputs.Description);
                    vParams.Add("@WidgetQuery", widgetInputs.WidgetQuery);
                    vParams.Add("@RoleIds", widgetInputs.RoleIdsXml);
                    vParams.Add("@DefaultColumnsXml", widgetInputs.DefaultColumnsXml);
                    vParams.Add("@ChartsDeatils", widgetInputs.ChartsDetailsXml);
                    vParams.Add("@IsArchived", widgetInputs.IsArchived);
                    vParams.Add("@IsProc", widgetInputs.IsProc);
                    vParams.Add("@IsApi", widgetInputs.IsApi);
                    vParams.Add("@IsEditable", widgetInputs.IsEditable);
                    vParams.Add("@ProcName", widgetInputs.ProcName);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@TagsXml", widgetInputs.TagIdsXml);
                    vParams.Add("@ModuleIdsXML", widgetInputs.ModuleIdsXML);
                    vParams.Add("@IsQuery", widgetInputs.IsQuery);
                    vParams.Add("@IsMongoQuery", widgetInputs.IsMongoQuery);
                    vParams.Add("@CollectionName", widgetInputs.CollectionName);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertCustomWidget, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCustomWidget", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionCustomWidgetUpsert);
                return null;
            }
        }

        public List<CustomWidgetsApiReturnModel> GetCustomWidgets(CustomWidgetSearchCriteriaInputModel widgetSearchCriteriaInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CustomWidgetId", widgetSearchCriteriaInput.CustomWidgetId);
                    vParams.Add("@DashboardId", widgetSearchCriteriaInput.DashboardId);
                    vParams.Add("@SearchText", widgetSearchCriteriaInput.SearchText);
                    vParams.Add("@IsArchived", widgetSearchCriteriaInput.IsArchived);
                    vParams.Add("@IsExport", widgetSearchCriteriaInput.IsExport);
                    vParams.Add("@CustomWidgetName", widgetSearchCriteriaInput.CustomWidgetName);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsQuery", widgetSearchCriteriaInput.IsQuery);
                    return vConn.Query<CustomWidgetsApiReturnModel>(StoredProcedureConstants.SpGetCustomWidgets, vParams,commandTimeout:300, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCustomWidgets", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCustomWidgets);
                return new List<CustomWidgetsApiReturnModel>();
            }
        }


        public List<CustomWidgetsApiReturnModel> GetBasicCustomWidgetDetails(CustomWidgetSearchCriteriaInputModel widgetSearchCriteriaInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CustomWidgetId", widgetSearchCriteriaInput.CustomWidgetId);
                    vParams.Add("@DashboardId", widgetSearchCriteriaInput.DashboardId);
                    vParams.Add("@SearchText", widgetSearchCriteriaInput.SearchText);
                    vParams.Add("@IsArchived", widgetSearchCriteriaInput.IsArchived);
                    vParams.Add("@IsExport", widgetSearchCriteriaInput.IsExport);
                    vParams.Add("@CustomWidgetName", widgetSearchCriteriaInput.CustomWidgetName);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<CustomWidgetsApiReturnModel>(StoredProcedureConstants.SpGetBasicCustomWidgets, vParams, commandTimeout: 0, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetBasicCustomWidgetDetails", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCustomWidgets);
                return new List<CustomWidgetsApiReturnModel>();
            }
        }

        public Guid? UpsertCustomHtmlApp(CustomHtmlAppInputModel widgetInputs, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CustomHtmlAppId", widgetInputs.CustomHtmlAppId);
                    vParams.Add("@CustomHtmlAppName", widgetInputs.CustomHtmlAppName);
                    vParams.Add("@Description", widgetInputs.Description);
                    vParams.Add("@HtmlCode", widgetInputs.HtmlCode);
                    vParams.Add("@RoleIds", widgetInputs.RoleIdsXml);
                    vParams.Add("@ModuleIdsXml", widgetInputs.ModuleIdsXml);
                    vParams.Add("@IsArchived", widgetInputs.IsArchived);
                    vParams.Add("@FileUrls", widgetInputs.FileUrls);
                    vParams.Add("@TimeStamp", widgetInputs.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertCustomHtmlApp, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCustomHtmlApp", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionCustomWidgetUpsert);
                return null;
            }
        }

        public Guid? UpsertCustomAppFilter(DashboardInputModel dashboardInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@DashboardId", dashboardInputModel.Id);
                    vParams.Add("@FilterQuery", dashboardInputModel.FilterQuery);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpInsertCustomAppFilter, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCustomAppFilter", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCustomWidgets);
                return null;
            }
        }

        public Guid? UpsertDashboardFilter(DynamicDashboardFilterModel dashboardFilterModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ReferenceId", dashboardFilterModel.ReferenceId);
                    vParams.Add("@FiltersXml", dashboardFilterModel.FiltersXml);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertDashboardFilter, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertDashboardFilter", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertDashboardFilters);
                return null;
            }
        }

        public List<FilterKeyValuePair> GetDashboardFilters(DynamicDashboardFilterModel dashboardFilterModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@DashboardId", dashboardFilterModel.DashboardId);
                    vParams.Add("@DashboardAppId", dashboardFilterModel.DashboardAppId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<FilterKeyValuePair>(StoredProcedureConstants.SpGetDashboardFilters, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDashboardFilters", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetDashboardFilters);
                return null;
            }
        }

        public List<FilterKeyValuePair> GetAllDashboardFilters(DynamicDashboardFilterModel dashboardFilterModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@DashboardId", dashboardFilterModel.DashboardId);
                    vParams.Add("@DashboardAppId", dashboardFilterModel.DashboardAppId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<FilterKeyValuePair>(StoredProcedureConstants.SpGetAllDashboardFilters, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllDashboardFilters", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllDashboardFilters);
                return null;
            }
        }

        public List<CustomWidgetHeaderModel> GetCustomQueryHeaders(WidgetDynamicQueryModel widgetDynamicQueryModel, string filterQuery, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@WidgetQuery", widgetDynamicQueryModel.DynamicQuery);
                    vParams.Add("@FilterQuery", filterQuery);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@CustomWidgetId", widgetDynamicQueryModel.CustomWidgetId);
                    return vConn.Query<CustomWidgetHeaderModel>(StoredProcedureConstants.SpGetCustomQueryHeaders, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCustomQueryHeaders", "WidgetRepository", sqlException.Message), sqlException);

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = sqlException.Message
                });
                //SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionExecuteCustomQuery);
                return new List<CustomWidgetHeaderModel>();
            }
        }

        public bool ModifyCustomAppColumns(WidgetDynamicQueryModel widgetDynamicQueryModel, string filterQuery, bool isDataRequired, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@WidgetQuery", widgetDynamicQueryModel.DynamicQuery);
                    vParams.Add("@FilterQuery", filterQuery);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@CustomWidgetId", widgetDynamicQueryModel.CustomWidgetId);
                    return vConn.Query<bool>(StoredProcedureConstants.SpModifyCustomAppHeaders, vParams,commandTimeout:0, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ModifyCustomAppColumns", "WidgetRepository", sqlException.Message), sqlException);

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = sqlException.Message
                });
                return false;
            }
        }

        public WidgetHeadersWithData GetCustomQueryHeaders(WidgetDynamicQueryModel widgetDynamicQueryModel, string filterQuery, bool isDataRequired, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@WidgetQuery", widgetDynamicQueryModel.DynamicQuery);
                    vParams.Add("@FilterQuery", filterQuery);
                    vParams.Add("@IsDataRequired", isDataRequired);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@CustomWidgetId", widgetDynamicQueryModel.CustomWidgetId);
                    return vConn.Query<WidgetHeadersWithData>(StoredProcedureConstants.SpGetCustomQueryHeaders, vParams,commandTimeout:0, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCustomQueryHeaders", "WidgetRepository", sqlException.Message), sqlException);

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = sqlException.Message
                });
                return null;
            }
        }

        public string GetCustomQueryData(WidgetDynamicQueryModel dynamicQueryModel, string filterQuery, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@WidgetQuery", dynamicQueryModel.DynamicQuery);
                    vParams.Add("@FilterQuery", filterQuery);
                    return vConn.Query<string>(StoredProcedureConstants.SpExecuteDynamicQuery, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCustomQueryData", "WidgetRepository", sqlException.Message), sqlException);

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = sqlException.Message
                });
                //SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionExecuteCustomQuery);
                return null;
            }
        }

        public bool? CustomWidgetNameValidator(CustomWidgetsInputModel widgetInputs, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                int commandTimeOut = Convert.ToInt32(ConfigurationManager.AppSettings["CommandTimeOut"]);

                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CustomWidgetId", widgetInputs.CustomWidgetId);
                    vParams.Add("@CustomWidgetName", widgetInputs.CustomWidgetName);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<bool?>(StoredProcedureConstants.SpCustomWidgetNameValidator, vParams, commandType: CommandType.StoredProcedure, commandTimeout: commandTimeOut).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CustomWidgetNameValidator", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionExecuteCustomQuery);
                return null;
            }
        }

        public UpsertCronExpressionApiReturnModel UpsertCronExpression(CronExpressionInputModel cronExpressionInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CronExpressionId", cronExpressionInputModel.CronExpressionId);
                    vParams.Add("@CronExpression", cronExpressionInputModel.CronExpression);
                    vParams.Add("@CronExpressionDescription", cronExpressionInputModel.CronExpressionDescription);
                    vParams.Add("@CronExpressionName", cronExpressionInputModel.CronExpressionName);
                    vParams.Add("@IsArchived", cronExpressionInputModel.IsArchived);
                    vParams.Add("@CustomWidgetId", cronExpressionInputModel.CustomWidgetId);
                    vParams.Add("@SelectedCharts", cronExpressionInputModel.SelectedCharts);
                    vParams.Add("@TemplateUrl", cronExpressionInputModel.TemplateUrl);
                    vParams.Add("@TemplateType", cronExpressionInputModel.TemplateType);
                    vParams.Add("@ChartsUrls", cronExpressionInputModel.ChartsUrls);
                    vParams.Add("@RunNow", cronExpressionInputModel.RunNow);
                    vParams.Add("@JobId", cronExpressionInputModel.JobId);
                    vParams.Add("@ScheduleEndDate", cronExpressionInputModel.ScheduleEndDate);
                    vParams.Add("@ConductStartDate", cronExpressionInputModel.ConductStartDate);
                    vParams.Add("@ConductEndDate", cronExpressionInputModel.ConductEndDate);
                    vParams.Add("@IsPaused", cronExpressionInputModel.IsPaused);
                    vParams.Add("@ResponsibleUserId", cronExpressionInputModel.ResponsibleUserId);
                    vParams.Add("@TimeZone", cronExpressionInputModel.TimeZone);
                   // vParams.Add("@IsForTimesheet", cronExpressionInputModel.IsForTimeSheet);
                    vParams.Add("@TimeStamp", cronExpressionInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<UpsertCronExpressionApiReturnModel>(StoredProcedureConstants.UpsertCronExpression, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCronExpression", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertCronExpression);
                return null;
            }
        }

        public Guid? ArchiveCronExpression(ArchivedRecurringExpressionModel archivedCronExpressionModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CustomWidgetId", archivedCronExpressionModel.CustomWidgetId);
                    vParams.Add("@CronExpressionId", archivedCronExpressionModel.CronExpressionId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsArchived", archivedCronExpressionModel.IsArchived);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpArchivedCronExpression, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ArchiveCronExpression", "WidgetRepository", sqlException.Message), sqlException);

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = sqlException.Message
                });
                return null;
            }
        }

        public CronExpressionApiReturnModel GetCronExpressionDetails(Guid? CustomWidgetId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CustomWidgetId", CustomWidgetId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<CronExpressionApiReturnModel>(StoredProcedureConstants.GetCronExpressionDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCronExpressionDetails", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertCronExpression);
                return null;
            }
        }

        public Guid? UpsertDashboardVisuaizationType(DashboardInputModel dashboardModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@DashboardId", dashboardModel.Id);
                    vParams.Add("@WorkspaceId", dashboardModel.WorkspaceId);
                    vParams.Add("@CustomAppVisualizationId", dashboardModel.CustomAppVisualizationId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.UpsertDashboardVisuaizationType, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertDashboardVisuaizationType", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertDashboardVisuaizationType);
                return null;
            }
        }

        public Guid? UpsertCustomWidgetSubQuery(CustomWidgetSearchCriteriaInputModel widgetInputs, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CustomWidgetId", widgetInputs.CustomWidgetId);
                    vParams.Add("@SubQueryType", widgetInputs.SubQueryType);
                    vParams.Add("@SubQuery", widgetInputs.SubQuery);
                    vParams.Add("@CompanyGuid", loggedInContext.CompanyGuid);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.UpsertCustomWidgetSubQuery, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCustomWidgetSubQuery", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertDashboardVisuaizationType);
                return null;
            }
        }

        public Guid? SetAsDefaultDashboardPersistance(WorkspaceInputModel workspaceModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@WorkspaceId", workspaceModel.WorkspaceId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsListView", workspaceModel?.IsListView);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpSetAsDefaultDashboardPersistance, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SetAsDefaultDashboardPersistance", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSetAsDefaultDashboardPersistance);
                return null;
            }
        }

        public Guid? ResetToDefaultDashboard(Guid? workspaceId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@WorkspaceId", workspaceId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpResetToDefaultDashboard, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ResetToDefaultDashboard", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionResetToDefaultDashboard);
                return null;
            }
        }
        public Guid? UpsertWorkspaceDashboardFilter(WorkspaceDashboardFilterInputModel workspaceDashboardFilterInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@WorkspaceDashboardFilterId", workspaceDashboardFilterInputModel.WorkspaceDashboardFilterId);
                    vParams.Add("@WorkspaceDashboardId", workspaceDashboardFilterInputModel.WorkspaceDashboardId);
                    vParams.Add("@FilterJson", workspaceDashboardFilterInputModel.FilterJson);
                    vParams.Add("@IsCalenderView", workspaceDashboardFilterInputModel.IsCalenderView);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertWorkspaceDashboardFilter, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertWorkspaceDashboardFilter", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertWorkspaceDashboardFilter);
                return null;
            }
        }

        public List<WorkspaceDashboardFilterOutputModel> GetWorkspaceDashboardFilters(WorkspaceDashboardFilterInputModel workspaceDashboardFilterInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@WorkspaceDashboardFilterId", workspaceDashboardFilterInputModel.WorkspaceDashboardFilterId);
                    vParams.Add("@WorkspaceDashboardId", workspaceDashboardFilterInputModel.WorkspaceDashboardId);
                    vParams.Add("@IsCalenderView", workspaceDashboardFilterInputModel.IsCalenderView);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<WorkspaceDashboardFilterOutputModel>(StoredProcedureConstants.SpGetWorkspaceDashboardFilters, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetWorkspaceDashboardFilters", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetWorkspaceDashboardFilters);
                return new List<WorkspaceDashboardFilterOutputModel>();
            }
        }

        public List<CustomeHtmlAppDetailsOutputModel> GetCustomeHtmlAppDetails(Guid? customHtmlAppId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CustomHtmlAppId", customHtmlAppId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<CustomeHtmlAppDetailsOutputModel>(StoredProcedureConstants.SpGetCustomeHtmlAppDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCustomeHtmlAppDetails", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetDashboards);
                return new List<CustomeHtmlAppDetailsOutputModel>();
            }
        }

        public Guid? UpsertProcInputsAndOuputs(ProcInputsAndOutputModel procInputsAndOutputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CustomStoredProcId", procInputsAndOutputModel.CustomStoredProcId);
                    vParams.Add("@CustomWidgetId", procInputsAndOutputModel.CustomWidgetId);
                    vParams.Add("@ProcName", procInputsAndOutputModel.ProcName);
                    vParams.Add("@Inputs", procInputsAndOutputModel.InputsJson);
                    vParams.Add("@Outputs", procInputsAndOutputModel.OutputsJson);
                    vParams.Add("@Legends", procInputsAndOutputModel.LegendsJson);
                    vParams.Add("@TimeStamp", procInputsAndOutputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertInputsAndOutputsForProc, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertProcInputsAndOuputs", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionWidgetUpsert);
                return null;
            }
        }

        public ProcInputsAndOutputModel GetProcInputsAndOuputs(ProcInputsAndOutputModel procInputsAndOutputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CustomStoredProcId", procInputsAndOutputModel.CustomStoredProcId);
                    vParams.Add("@CustomWidgetId", procInputsAndOutputModel.CustomWidgetId);
                    //vParams.Add("@Inputs", procInputsAndOutputModel.InputsJson);
                    //vParams.Add("@Outputs", procInputsAndOutputModel.OutputsJson);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ProcInputsAndOutputModel>(StoredProcedureConstants.SpGetInputsAndOutputsForProc, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetProcInputsAndOuputs", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionWidgetUpsert);
                return null;
            }
        }

        public void ReorderTags(string tagIdsXml, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TagIds", tagIdsXml);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vConn.Execute(StoredProcedureConstants.SPReorderTags, vParams, commandType: CommandType.StoredProcedure);
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ReorderTags", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionReorderQuestions);
            }
        }
        public void SetAsDefaultDashboardView(WorkspaceInputModel workspace, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@WorkspaceId", workspace?.WorkspaceId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsDefaultView", workspace?.IsListView);
                    vConn.Query<Guid?>(StoredProcedureConstants.SpSetAsDefaultDashboardView, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SetAsDefaultDashboardView", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSetAsDefaultDashboardView);
            }
        }

        public void SetDashboardsOrder(DashboardOrderSearchCriteriaInputModel dashboardInputModel, string dashboardIdsXml, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@WorkspaceId", dashboardInputModel?.WorkspaceId);
                    vParams.Add("@DashboardIdXml", dashboardIdsXml);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vConn.Query<Guid?>(StoredProcedureConstants.SpSetAsCustomDashboardOrder, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SetDashboardsOrder", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSetAsDefaultDashboardView);
            }
        }


        public Guid? UpsertCustomAppApiDetails(CustomApiAppInputModel customApiAppInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CustomWidgetId", customApiAppInputModel.CustomWidgetId);
                    vParams.Add("@HttpMethod", customApiAppInputModel.HttpMethod);
                    vParams.Add("@ApiUrl", customApiAppInputModel.ApiUrl);
                    vParams.Add("@ApiHeadersJson", customApiAppInputModel.ApiHeadersJson);
                    vParams.Add("@ApiOutputsJson", customApiAppInputModel.ApiOutputsJson);
                    vParams.Add("@BodyJson", customApiAppInputModel.BodyJson);
                    vParams.Add("@OutputRoot", customApiAppInputModel.OutputRoot);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertCustomAppApiDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCustomAppApiDetails", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertCustomAppApiDetails);
                return null;
            }
        }

        public CustomApiAppInputModel GetCustomAppApiDetails(CustomApiAppInputModel customApiAppInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CustomWidgetId", customApiAppInputModel.CustomWidgetId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<CustomApiAppInputModel>(StoredProcedureConstants.SpGetCustomAppApiDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCustomAppApiDetails", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCustomAppApiDetails);
                return null;
            }
        }

        public bool IsHavingSystemAppAccess(string widgetName, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@WidgetName", widgetName);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<bool>(StoredProcedureConstants.SpIsHavingSystemAppAccess, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "IsHavingSystemAppAccess", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetWidgets);
                return false;
            }
        }
        public Guid? GetWidgetIdByName(Guid CompanyId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@CompanyId", CompanyId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpGetWidgetIdByName, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetWidgetIdByName", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetWidgets);
                return Guid.Empty;
            }
        }

        public List<DynamicModuleUpsertModel> GetDynamicModules(DynamicModuleUpsertModel dynamicModule, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@DynamicModuleId", dynamicModule.DynamicModuleId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<DynamicModuleUpsertModel>(StoredProcedureConstants.SpGetDynamicModule, vParams, commandTimeout: 0, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDynamicModules", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetDashboards);
                return new List<DynamicModuleUpsertModel>();
            }
        }
        public List<DynamicTabs> GetDynamicModuleTabs(DynamicModuleUpsertModel dynamicModule, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@DynamicModuleId", dynamicModule.DynamicModuleId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<DynamicTabs>(StoredProcedureConstants.SpGetDynamicModuleTabs, vParams, commandTimeout: 0, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDynamicModules", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetDashboards);
                return new List<DynamicTabs>();
            }
        }
    }
}
