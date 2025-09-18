using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.Goals;
using Btrak.Models.UserStory;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Models.Sprints;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class UserStoryRepository
    {
        public Guid? UpsertUserStory(UserStoryUpsertInputModel userStoryUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserStoryId", userStoryUpsertInputModel.UserStoryId);
                    vParams.Add("@GoalId", userStoryUpsertInputModel.GoalId);
                    vParams.Add("@UserStoryName", userStoryUpsertInputModel.UserStoryName);
                    vParams.Add("@EstimatedTime", userStoryUpsertInputModel.EstimatedTime);
                    vParams.Add("@DeadLineDate", userStoryUpsertInputModel.DeadLineDate);
                    vParams.Add("@OwnerUserId", userStoryUpsertInputModel.OwnerUserId);
                    vParams.Add("@DependencyUserId", userStoryUpsertInputModel.DependencyUserId);
                    vParams.Add("@Order", userStoryUpsertInputModel.Order);
                    vParams.Add("@UserStoryStatusId", userStoryUpsertInputModel.UserStoryStatusId);
                    vParams.Add("@IsArchived", userStoryUpsertInputModel.IsArchived);
                    vParams.Add("@ArchivedDateTime", userStoryUpsertInputModel.ArchivedDateTime);
                    vParams.Add("@ParkedDateTime", userStoryUpsertInputModel.ParkedDateTime);
                    vParams.Add("@BugPriorityId", userStoryUpsertInputModel.BugPriorityId);
                    vParams.Add("@UserStoryTypeId", userStoryUpsertInputModel.UserStoryTypeId);
                    vParams.Add("@ProjectFeatureId", userStoryUpsertInputModel.ProjectFeatureId);
                    vParams.Add("@BugCausedUserId", userStoryUpsertInputModel.BugCausedUserId);
                    vParams.Add("@UserStoryPriorityId", userStoryUpsertInputModel.UserStoryPriorityId);
                    vParams.Add("@TestSuiteSectionId", userStoryUpsertInputModel.TestSuiteSectionId);
                    vParams.Add("@TestCaseId", userStoryUpsertInputModel.TestCaseId);
                    vParams.Add("@ReviewerUserId", userStoryUpsertInputModel.ReviewerUserId);
                    vParams.Add("@ParentUserStoryId", userStoryUpsertInputModel.ParentUserStoryId);
                    vParams.Add("@TimeZone", userStoryUpsertInputModel.TimeZone);
                    vParams.Add("@Description", userStoryUpsertInputModel.Description);
                    vParams.Add("@TimeStamp", userStoryUpsertInputModel.TimeStamp,DbType.Binary);
                    vParams.Add("@IsForQa", userStoryUpsertInputModel.IsForQa);
                    vParams.Add("@VersionName", userStoryUpsertInputModel.VersionName);
                    vParams.Add("@Tags", userStoryUpsertInputModel.Tag);
                    vParams.Add("@TemplateId", userStoryUpsertInputModel.TemplateId);
                    vParams.Add("@SprintId", userStoryUpsertInputModel.SprintId);
                    vParams.Add("@SprintEstimatedTime", userStoryUpsertInputModel.SprintEstimatedTime);
                    vParams.Add("@RAGStatus", userStoryUpsertInputModel.RAGStatus);
                    vParams.Add("@AuditConductQuestionId", userStoryUpsertInputModel.AuditConductQuestionId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsFromBugs", userStoryUpsertInputModel.IsFromBugs);
                    vParams.Add("@IsAction", userStoryUpsertInputModel.IsAction);
                    vParams.Add("@IsReplan", userStoryUpsertInputModel.IsReplan);
                    vParams.Add("@AuditProjectId", userStoryUpsertInputModel.AuditProjectId);
                    vParams.Add("@ActionCategoryId", userStoryUpsertInputModel.ActionCategoryId);
                    vParams.Add("@UserStoryUniqueName", userStoryUpsertInputModel.UserStoryUniqueName);
                    vParams.Add("@StartDate", userStoryUpsertInputModel.UserStoryStartDate);
                    vParams.Add("@UnLinkActionId", userStoryUpsertInputModel.UnLinkActionId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertUserStory, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertUserStory", "UserStoryRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUserStoryUpsert);
                return null;
            }
        }

        public Guid? UpdateUserStoryGoal(UserStoryUpsertInputModel userStoryUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserStoryId", userStoryUpsertInputModel.UserStoryId);
                    vParams.Add("@GoalId", userStoryUpsertInputModel.GoalId);
                    vParams.Add("@TimeZone", userStoryUpsertInputModel.TimeZone);
                    vParams.Add("@TimeStamp", userStoryUpsertInputModel.TimeStamp);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpdateUserStoryGoal, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateUserStoryGoal", "UserStoryRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUserStoryUpsert);
                return null;
            }
        }

        public Guid? UpdateUserStoryLink(UserStoryUpsertInputModel userStoryUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserStoryId", userStoryUpsertInputModel.UserStoryId);
                    vParams.Add("@ParentUserStoryId", userStoryUpsertInputModel.ParentUserStoryId);
                    vParams.Add("@GoalId", userStoryUpsertInputModel.GoalId);
                    vParams.Add("@IsSprintUserStories", userStoryUpsertInputModel.IsFromSprint);
                    vParams.Add("@TimeStamp", userStoryUpsertInputModel.TimeStamp);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpdateUserStoryLink, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateUserStoryLink", "UserStoryRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUserStoryUpsert);
                return null;
            }
        }

        public List<Guid?> UpsertMultipleUserStory(UserStoryUpsertInputModel userStoryUpsertInputModel, string userStoriesXml, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@GoalId", userStoryUpsertInputModel.GoalId);
                    vParams.Add("@UserStoryName", userStoriesXml);
                    vParams.Add("@EstimatedTime", userStoryUpsertInputModel.EstimatedTime);
                    vParams.Add("@DeadLineDate", userStoryUpsertInputModel.DeadLineDate);
                    vParams.Add("@OwnerUserId", userStoryUpsertInputModel.OwnerUserId);
                    vParams.Add("@DependencyUserId", userStoryUpsertInputModel.DependencyUserId);
                    vParams.Add("@Order", userStoryUpsertInputModel.Order);
                    vParams.Add("@UserStoryStatusId", userStoryUpsertInputModel.UserStoryStatusId);
                    vParams.Add("@ActualDeadLineDate", userStoryUpsertInputModel.DeadLineDate);
                    vParams.Add("@IsArchived", userStoryUpsertInputModel.IsArchived);
                    vParams.Add("@ArchivedDateTime", userStoryUpsertInputModel.ArchivedDateTime);
                    vParams.Add("@BugPriorityId", userStoryUpsertInputModel.BugPriorityId);
                    vParams.Add("@UserStoryTypeId", userStoryUpsertInputModel.UserStoryTypeId);
                    vParams.Add("@ParkedDateTime", userStoryUpsertInputModel.ParkedDateTime);
                    vParams.Add("@ProjectFeatureId", userStoryUpsertInputModel.ProjectFeatureId);
                    vParams.Add("@BugCausedUserId", userStoryUpsertInputModel.BugCausedUserId);
                    vParams.Add("@ReviewerUserId", userStoryUpsertInputModel.ReviewerUserId);
                    vParams.Add("@UserStoryPriorityId", userStoryUpsertInputModel.UserStoryPriorityId);
                    vParams.Add("@IsReplan", userStoryUpsertInputModel.IsReplan);
                    vParams.Add("@GoalReplanTypeId", userStoryUpsertInputModel.GoalReplanId);
                    vParams.Add("@Description", userStoryUpsertInputModel.Description);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@ParentUserStoryId", userStoryUpsertInputModel.ParentUserStoryId);
                    vParams.Add("@TemplateId", userStoryUpsertInputModel.TemplateId);
                    vParams.Add("@SprintId", userStoryUpsertInputModel.SprintId);
                    vParams.Add("@TimeZone", userStoryUpsertInputModel.TimeZone);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertMultipleUserStories, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertMultipleUserStory", "UserStoryRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUserStoryUpsert);
                return new List<Guid?>();
            }
        }

        public List<UserStoryApiReturnModel> SearchUserStories(UserStorySearchCriteriaInputModel userStorySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserStoryId", userStorySearchCriteriaInputModel.UserStoryId);
                    vParams.Add("@ProjectId", userStorySearchCriteriaInputModel.ProjectId);
                    vParams.Add("@ProjectName", userStorySearchCriteriaInputModel.ProjectName);
                    vParams.Add("@GoalId", userStorySearchCriteriaInputModel.GoalId);
                    vParams.Add("@UserStoryName", userStorySearchCriteriaInputModel.UserStoryName);
                    vParams.Add("@EstimatedTime", userStorySearchCriteriaInputModel.EstimatedTime);
                    vParams.Add("@DeadLineDate", userStorySearchCriteriaInputModel.DeadLineDate);
                    vParams.Add("@OwnerUserId", userStorySearchCriteriaInputModel.OwnerUserId);
                    vParams.Add("@DependencyUserId", userStorySearchCriteriaInputModel.DependencyUserId);
                    vParams.Add("@ParentUserStoryId", userStorySearchCriteriaInputModel.ParentUserStoryId);
                    vParams.Add("@Order", userStorySearchCriteriaInputModel.Order);
                    vParams.Add("@UserStoryStatusId", userStorySearchCriteriaInputModel.UserStoryStatusId);
                    vParams.Add("@ActualDeadLineDate", userStorySearchCriteriaInputModel.ActualDeadLineDate);
                    vParams.Add("@BugPriorityIdsXml", userStorySearchCriteriaInputModel.BugPriorityIdsXml);
                    vParams.Add("@UserStoryTypeId", userStorySearchCriteriaInputModel.UserStoryTypeId);
                    vParams.Add("@ProjectFeatureId", userStorySearchCriteriaInputModel.ProjectFeatureId);
                    vParams.Add("@IsParked", userStorySearchCriteriaInputModel.IsUserStoryParked);
                    vParams.Add("@IsArchived", userStorySearchCriteriaInputModel.IsUserStoryArchived);
                    vParams.Add("@SearchText", userStorySearchCriteriaInputModel.SearchText);
                    vParams.Add("@SortBy", userStorySearchCriteriaInputModel.SortBy);
                    vParams.Add("@SortDirection", userStorySearchCriteriaInputModel.SortDirection);
                    vParams.Add("@PageSize", userStorySearchCriteriaInputModel.PageSize);
                    vParams.Add("@PageNumber", userStorySearchCriteriaInputModel.PageNumber);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@DependencyText", userStorySearchCriteriaInputModel.DependencyText);
                    vParams.Add("@DeadLineDateFrom", userStorySearchCriteriaInputModel.DeadLineDateFrom);
                    vParams.Add("@DeadLineDateTo", userStorySearchCriteriaInputModel.DeadLineDateTo);
                    vParams.Add("@IncludeArchived", userStorySearchCriteriaInputModel.IncludeArchive);
                    vParams.Add("@IncludeParked", userStorySearchCriteriaInputModel.IncludePark);
                    vParams.Add("@IsStatusMultiselect", userStorySearchCriteriaInputModel.IsStatusMultiSelect);
                    vParams.Add("@UserStoryStatusIdsXml", userStorySearchCriteriaInputModel.UserStoryStatusIdsXml);
                    vParams.Add("@IsMyWorkOnly", userStorySearchCriteriaInputModel.IsMyWorkOnly);
                    vParams.Add("@TeamMemberIdsXml", userStorySearchCriteriaInputModel.TeamMemberIdsXml);
                    vParams.Add("@UserStoryIdsXml", userStorySearchCriteriaInputModel.UserStoryIdsXml);
                    vParams.Add("@OwnerUserIdsXml", userStorySearchCriteriaInputModel.OwnerUserIdsXml);
                    vParams.Add("@UserStoryUniqueName", userStorySearchCriteriaInputModel.UserStoryUniqueName);
                    vParams.Add("@IsForUserStoryoverview", userStorySearchCriteriaInputModel.IsForUserStoryoverview);
                    vParams.Add("@IsActiveGoalsOnly", userStorySearchCriteriaInputModel.IsActiveGoalsOnly);
                    vParams.Add("@ParentUserStoryId", userStorySearchCriteriaInputModel.ParentUserStoryId);
                    vParams.Add("@GoalStatusId", userStorySearchCriteriaInputModel.GoalStatusId);
                    vParams.Add("@GoalName", userStorySearchCriteriaInputModel.GoalName);
                    vParams.Add("@UserStoryTags", userStorySearchCriteriaInputModel.UserStoryTags);
                    vParams.Add("@IsTracked", userStorySearchCriteriaInputModel.IsTracked);
                    vParams.Add("@IsProductive", userStorySearchCriteriaInputModel.IsProductive);
                    vParams.Add("@UserStoryTypeIdsXml", userStorySearchCriteriaInputModel.UserStoryTypeIdsXml);
                    vParams.Add("@IsNotOnTrack", userStorySearchCriteriaInputModel.IsNotOnTrack);
                    vParams.Add("@IsOnTrack", userStorySearchCriteriaInputModel.IsOnTrack);
                    return vConn.Query<UserStoryApiReturnModel>(StoredProcedureConstants.SpSearchUserStories, vParams,commandTimeout:0, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchUserStories", "UserStoryRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchUserStories);
                return new List<UserStoryApiReturnModel>();
            }
        }

        public List<UserStoryApiReturnModel> SearchWorkItemsByLoggedInId(UserStorySearchCriteriaInputModel userStorySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserStoryId", userStorySearchCriteriaInputModel.UserStoryId);
                    vParams.Add("@ProjectId", userStorySearchCriteriaInputModel.ProjectId);
                    vParams.Add("@SearchText", userStorySearchCriteriaInputModel.SearchText);
                    vParams.Add("@Tags", userStorySearchCriteriaInputModel.Tags);
                    vParams.Add("@UserStoryIdsXml", userStorySearchCriteriaInputModel.UserStoryIdsXml);
                    vParams.Add("@BugPriorityIdsXml", userStorySearchCriteriaInputModel.BugPriorityIdsXml);
                    vParams.Add("@UserStoryStatusIdsXml", userStorySearchCriteriaInputModel.UserStoryStatusIdsXml);
                    vParams.Add("@UserStoryTypeIdsXml", userStorySearchCriteriaInputModel.UserStoryTypeIdsXml);
                    vParams.Add("@UserIdsXml", userStorySearchCriteriaInputModel.UserIdsXml);
                    vParams.Add("@BranchIdsXml", userStorySearchCriteriaInputModel.BranchIdsXml);
                    vParams.Add("@IsAction", userStorySearchCriteriaInputModel.IsAction);
                    vParams.Add("@IsUserActions", userStorySearchCriteriaInputModel.IsUserActions);
                    vParams.Add("@IsIncludeUnAssigned", userStorySearchCriteriaInputModel.IsIncludeUnAssigned);
                    vParams.Add("@IsExcludeOthers", userStorySearchCriteriaInputModel.IsExcludeOtherUs);
                    vParams.Add("@WorkspaceDashboardId", userStorySearchCriteriaInputModel.WorkspaceDashboardId);
                    vParams.Add("@ActionCategoryIdsXml", userStorySearchCriteriaInputModel.ActionCategoryIdsXml);
                    vParams.Add("@PageSize", userStorySearchCriteriaInputModel.PageSize);
                    vParams.Add("@PageNumber", userStorySearchCriteriaInputModel.PageNumber);
                    vParams.Add("@IsSameUser", userStorySearchCriteriaInputModel.IsSameUser);
                    vParams.Add("@BusinessUnitIds", userStorySearchCriteriaInputModel.BusinessUnitIds);
                    vParams.Add("@IsMyWork", userStorySearchCriteriaInputModel.IsMyWork);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<UserStoryApiReturnModel>(StoredProcedureConstants.SpSearchWorkItemsByLoggedInId, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchWorkItemsByLoggedInId", "UserStoryRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchUserStories);
                return new List<UserStoryApiReturnModel>();
            }
        }

        public List<AdhocWorkApiReturnModel> GetReportsForAdhocWork(UserStorySearchCriteriaInputModel userStorySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SearchText", userStorySearchCriteriaInputModel.SearchText);
                    vParams.Add("@SortBy", userStorySearchCriteriaInputModel.SortBy);
                    vParams.Add("@SortDirection", userStorySearchCriteriaInputModel.SortDirection);
                    vParams.Add("@PageSize", userStorySearchCriteriaInputModel.PageSize);
                    vParams.Add("@PageNumber", userStorySearchCriteriaInputModel.PageNumber);
                    vParams.Add("@OwnerUserId", userStorySearchCriteriaInputModel.OwnerUserId);
                    vParams.Add("@ProjectId", userStorySearchCriteriaInputModel.ProjectId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@DependencyText", userStorySearchCriteriaInputModel.DependencyText);
                    vParams.Add("@EntityId", userStorySearchCriteriaInputModel.EntityId);
                    return vConn.Query<AdhocWorkApiReturnModel>(StoredProcedureConstants.SpReportsForAdhocWork, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetReportsForAdhocWork", "UserStoryRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchUserStories);
                return new List<AdhocWorkApiReturnModel>();
            }
        }

        public List<GoalSpReturnModel> GetUserStoriesByGoals(string goalXml, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@GoalIds", goalXml);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<GoalSpReturnModel>(StoredProcedureConstants.SpGetUserStoriesByGoals, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserStoriesByGoals", "UserStoryRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetUserStoriesByGoals);
                return new List<GoalSpReturnModel>();
            }
        }

        public Guid? InsertMultipleUserStoriesUsingFile(Guid? goalId, string userStoriesXml, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@GoalId", goalId);
                    vParams.Add("@UserStoriesXml", userStoriesXml);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpInsertUserStories, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertMultipleUserStoriesUsingFile", "UserStoryRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionInsertMultipleUserStoriesUsingFile);
                return null;
            }
        }


        public UserStoryAutoLogByTimeSheetModel UpsertUserstoryLogTimeBasedOnPunchCard(bool? breakStarted, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@BreakStarted", breakStarted);
                    return vConn.Query<UserStoryAutoLogByTimeSheetModel>(StoredProcedureConstants.SpUpsertUserstoryLogTimeBasedOnPunchCard, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertUserstoryLogTimeBasedOnPunchCard", "UserStoryRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchUserStories);
                return null;
            }
        }



        public List<Guid> UpdateMultipleUserStories(UserStoryInputModel userStoryInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserStoryIdsXml", userStoryInputModel.UserStoryIdsXml);
                    vParams.Add("@EstimatedTime", userStoryInputModel.EstimatedTime);
                    vParams.Add("@UserStoryStatusId", userStoryInputModel.UserStoryStatusId);
                    vParams.Add("@OwnerUserId", userStoryInputModel.OwnerUserId);
                    vParams.Add("@DependencyUserId", userStoryInputModel.DependencyUserId);
                    vParams.Add("@ClearEstimate", userStoryInputModel.ClearEstimate);
                    vParams.Add("@SetBackStatus", userStoryInputModel.SetBackStatus);
                    vParams.Add("@ClearOwner", userStoryInputModel.ClearOwner);
                    vParams.Add("@ClearDependency", userStoryInputModel.ClearDependency);
                    vParams.Add("@GoalId", userStoryInputModel.GoalId);
                    vParams.Add("@SprintId", userStoryInputModel.SprintId);
                    vParams.Add("@TimeZone", userStoryInputModel.TimeZone);
                    vParams.Add("@AmendBy", userStoryInputModel.AmendBy);
                    vParams.Add("@IsFromSrint", userStoryInputModel.IsSprintUserstories);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid>(StoredProcedureConstants.SpUpsertUserStories, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateMultipleUserStories", "UserStoryRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpdateMultipleUserStories);
                return new List<Guid>();
            }
        }

        public List<Guid> UpdateMultipleUserStoriesDeadlineConfigurations(DeadlineConfigurationInputModel deadlineConfigurationInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserStoryIds", deadlineConfigurationInputModel.UserStoryIdsXml);
                    vParams.Add("@GoalId ", deadlineConfigurationInputModel.GoalId);
                    vParams.Add("@Date", deadlineConfigurationInputModel.SelectedDate);
                    vParams.Add("@WorkingHoursPerDay", deadlineConfigurationInputModel.WorkingHoursPerDay);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid>(StoredProcedureConstants.SpUpdateDeadLinesBasedOnEstimations, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateMultipleUserStoriesDeadlineConfigurations", "UserStoryRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpdateMultipleUserStoriesDeadlineConfigurations);
                return new List<Guid>();
            }
        }

        public void ReorderUserStories(string userStoryXml, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Debug(userStoryXml);

                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserStoryIds", userStoryXml);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vConn.Execute(StoredProcedureConstants.SpReOrderUserStories, vParams, commandType: CommandType.StoredProcedure);
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ReorderUserStories", "UserStoryRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionReorderUserStories);
            }
        }

        public Guid? ReOrderWorkflowStatuses(ReOrderWorkflowStatusesInputModel reOrderWorkflowStatusesInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@WorkflowId", reOrderWorkflowStatusesInputModel.WorkflowId);
                    vParams.Add("@UserStoryStatusIds", reOrderWorkflowStatusesInputModel.UserStoryStatusIdsXml);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpReOrderWorkflowStatuses, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ReOrderWorkflowStatuses", "UserStoryRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionReOrderWorkflowStatuses);
                return null;
            }
        }

        public UserStoryCountModel GetCommentsCountByUserStoryId(Guid? userStoryId,string TimeZone, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserStoryId", userStoryId);
                    vParams.Add("@TimeZone", TimeZone);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<UserStoryCountModel>(StoredProcedureConstants.SpCommentsCountByUserStoryId, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCommentsCountByUserStoryId", "UserStoryRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCommentsCountByUserStoryId);
                return null;
            }
        }

        public int? GetBugsCountForUserStory(GetBugsCountBasedOnUserStoryInputModel getBugsCountBasedOnUserStoryInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserStoryId", getBugsCountBasedOnUserStoryInputModel.UserStoryId);
                    vParams.Add("@GoalId", getBugsCountBasedOnUserStoryInputModel.GoalId);
                    vParams.Add("@SprintId", getBugsCountBasedOnUserStoryInputModel.SprintId);
                    vParams.Add("@TestCaseId", getBugsCountBasedOnUserStoryInputModel.TestCaseId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<int?>(StoredProcedureConstants.SpGetBugsCountForUserStory, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetBugsCountForUserStory", "UserStoryRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetBugsCountForUserStory);
                return null;
            }
        }

        public Guid? ArchiveUserStory(ArchiveUserStoryInputModel archiveUserStoryInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserStoryId", archiveUserStoryInputModel.UserStoryId);
                    vParams.Add("@IsArchive", archiveUserStoryInputModel.IsArchive);
                    vParams.Add("@TimeStamp", archiveUserStoryInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@GoalId", archiveUserStoryInputModel.GoalId);
                    vParams.Add("@SprintId", archiveUserStoryInputModel.SprintId);
                    vParams.Add("@IsFromSprint", archiveUserStoryInputModel.IsFromSprint);
                    vParams.Add("@UserStoryStatusId", archiveUserStoryInputModel.UserStoryStatusId);
                    vParams.Add("@TimeZone", archiveUserStoryInputModel.TimeZone);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpArchiveUserStoryNew, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ArchiveUserStory", "UserStoryRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionArchiveUserStory);
                return null;
            }
        }

        public Guid? ParkUserStory(ParkUserStoryInputModel parkUserStoryInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserStoryId", parkUserStoryInputModel.UserStoryId);
                    vParams.Add("@IsParked", parkUserStoryInputModel.IsParked);
                    vParams.Add("@IsFromSprint", parkUserStoryInputModel.IsFromSprint);
                    vParams.Add("@TimeZone", parkUserStoryInputModel.TimeZone);
                    vParams.Add("@TimeStamp", parkUserStoryInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpParkingUserStory, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ParkUserStory", "UserStoryRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionParkUserStory);
                return null;
            }
        }

        public List<UserStoriesForAllGoalsSpReturnModel> GetUserStoriesForAllGoals(UserStoriesForAllGoalsSearchCriteriaInputModel userStoriesForAllGoalsSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@UserStoryId", userStoriesForAllGoalsSearchCriteriaInputModel.UserStoryId);
                    vParams.Add("@GoalId", userStoriesForAllGoalsSearchCriteriaInputModel.GoalId);
                    vParams.Add("@ProjectId", userStoriesForAllGoalsSearchCriteriaInputModel.ProjectId);
                    vParams.Add("@OwnerUserId", userStoriesForAllGoalsSearchCriteriaInputModel.OwnerUserId);
                    vParams.Add("@GoalResponsiblePersonId", userStoriesForAllGoalsSearchCriteriaInputModel.GoalResponsiblePersonId);
                    vParams.Add("@UserStoryStatusId", userStoriesForAllGoalsSearchCriteriaInputModel.UserStoryStatusId);
                    vParams.Add("@GoalStatusId", userStoriesForAllGoalsSearchCriteriaInputModel.GoalStatusId);
                    vParams.Add("@GoalName", userStoriesForAllGoalsSearchCriteriaInputModel.GoalName);
                    vParams.Add("@Tags", userStoriesForAllGoalsSearchCriteriaInputModel.Tags);
                    vParams.Add("@WorkItemTags", userStoriesForAllGoalsSearchCriteriaInputModel.WorkItemTagsXml);
                    vParams.Add("@DeadLineDateFrom", userStoriesForAllGoalsSearchCriteriaInputModel.DeadLineDateFrom);
                    vParams.Add("@DeadLineDateTo", userStoriesForAllGoalsSearchCriteriaInputModel.DeadLineDateTo);
                    vParams.Add("@IsRed", userStoriesForAllGoalsSearchCriteriaInputModel.IsRed);
                    vParams.Add("@IsTracked", userStoriesForAllGoalsSearchCriteriaInputModel.IsTracked);
                    vParams.Add("@IsProductive", userStoriesForAllGoalsSearchCriteriaInputModel.IsProductive);
                    vParams.Add("@IsArchivedGoal", userStoriesForAllGoalsSearchCriteriaInputModel.IsArchivedGoal);
                    vParams.Add("@IsParkedGoal", userStoriesForAllGoalsSearchCriteriaInputModel.IsParkedGoal);
                    vParams.Add("@IncludeArchived", userStoriesForAllGoalsSearchCriteriaInputModel.IsIncludedArchive);
                    vParams.Add("@IncludeParked", userStoriesForAllGoalsSearchCriteriaInputModel.IsIncludedPark);
                    vParams.Add("@SortBy", userStoriesForAllGoalsSearchCriteriaInputModel.SortBy);
                    vParams.Add("@SortDirection", userStoriesForAllGoalsSearchCriteriaInputModel.SortDirection);
                    vParams.Add("@PageSize", userStoriesForAllGoalsSearchCriteriaInputModel.PageSize);
                    vParams.Add("@PageNumber", userStoriesForAllGoalsSearchCriteriaInputModel.PageNumber);
                    vParams.Add("@IsOnTrack", userStoriesForAllGoalsSearchCriteriaInputModel.IsOnTrack);
                    vParams.Add("@IsNotOnTrack", userStoriesForAllGoalsSearchCriteriaInputModel.IsNotOnTrack);

                    vParams.Add("@CreatedDateFrom", userStoriesForAllGoalsSearchCriteriaInputModel.CreatedDateFrom);
                    vParams.Add("@CreatedDateTo", userStoriesForAllGoalsSearchCriteriaInputModel.CreatedDateTo);
                    vParams.Add("@DeadLineDate", userStoriesForAllGoalsSearchCriteriaInputModel.DeadLineDate);
                    vParams.Add("@UserStoryName", userStoriesForAllGoalsSearchCriteriaInputModel.UserStoryName);
                    vParams.Add("@VersionName", userStoriesForAllGoalsSearchCriteriaInputModel.VersionName);
                    vParams.Add("@UserStoryTypeIds", userStoriesForAllGoalsSearchCriteriaInputModel.UserStoryTypeIds);
                    vParams.Add("@BugCausedUserIds", userStoriesForAllGoalsSearchCriteriaInputModel.BugCausedUserIds);
                    vParams.Add("@DependencyUserIds", userStoriesForAllGoalsSearchCriteriaInputModel.DependencyUserIds);
                    vParams.Add("@BugPriorityIds", userStoriesForAllGoalsSearchCriteriaInputModel.BugPriorityIds);
                    vParams.Add("@ProjectFeatureIds", userStoriesForAllGoalsSearchCriteriaInputModel.ProjectFeatureIds);
                    vParams.Add("@UpdatedDateFrom", userStoriesForAllGoalsSearchCriteriaInputModel.UpdatedDateFrom);
                    vParams.Add("@UpdatedDateTo", userStoriesForAllGoalsSearchCriteriaInputModel.UpdatedDateTo);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<UserStoriesForAllGoalsSpReturnModel>(StoredProcedureConstants.SpGetUserStoriesForAllGoals, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserStoriesForAllGoals", "UserStoryRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetUserStoriesForAllGoals);
                return new List<UserStoriesForAllGoalsSpReturnModel>();
            }
        }

        public List<UserStoryHistoryModel> GetUserStoryHistory(Guid userStoryId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserStoryHistoryId", null);
                    vParams.Add("@UserStoryId", userStoryId);
                    vParams.Add("@OldValue", null);
                    vParams.Add("@NewValue", null);
                    vParams.Add("@FieldName", null);
                    vParams.Add("@Description", null);
                    vParams.Add("@SortBy", null);
                    vParams.Add("@SortDirection", null);
                    vParams.Add("@PageSize", null);
                    vParams.Add("@PageNumber", null);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<UserStoryHistoryModel>(StoredProcedureConstants.SpGetUserStoryHistory, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserStoryHistory", "UserStoryRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUserStoryHistory);
                return null;
            }
        }

        public List<Guid> AmendUserStoriesDeadline(UserStoryAmendInputModel userStoryAmmendInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserStoryIdsXml", userStoryAmmendInputModel.UserStoryIdsXml);
                    vParams.Add("@AmendBy", userStoryAmmendInputModel.AmendedDaysCount);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@GoalId", userStoryAmmendInputModel.GoalId);
                    return vConn.Query<Guid>(StoredProcedureConstants.SpUpsertUserStories, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "AmendUserStoriesDeadline", "UserStoryRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionAmendUserStoriesDeadline);
                return new List<Guid>();
            }
        }

        public Guid? UpsertUserStoryTags(UserStoryTagUpsertInputModel userStoryTagUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserStoryId", userStoryTagUpsertInputModel.UserStoryId);
                    vParams.Add("@Tags", userStoryTagUpsertInputModel.Tags);
                    vParams.Add("@TimeZone", userStoryTagUpsertInputModel.TimeZone);
                    vParams.Add("@TimeStamp", userStoryTagUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertUserStoryTag, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertUserStoryTags", "UserStoryRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertUserStoryTags);
                return null;
            }
        }

        public List<UserStoryTagApiReturnModel> SearchUserStoryTags(UserStoryTagSearchInputModel userStoryTagSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserStoryId", userStoryTagSearchInputModel.UserStoryId);
                    vParams.Add("@Tag", userStoryTagSearchInputModel.Tag);
                    vParams.Add("@SearchText", userStoryTagSearchInputModel.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<UserStoryTagApiReturnModel>(StoredProcedureConstants.SpGetUserStoryTags, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchUserStoryTags", "UserStoryRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchUserStoryTags);
                return new List<UserStoryTagApiReturnModel>();
            }
        }

        public List<GetBugsBasedOnUserStoryApiReturnModel> GetBugsBasedOnUserStories(UserStorySearchCriteriaInputModel userStorySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserStoryId", userStorySearchCriteriaInputModel.UserStoryId);
                    vParams.Add("@TestSuiteId", userStorySearchCriteriaInputModel.TestSuiteId);
                    vParams.Add("@SectionId", userStorySearchCriteriaInputModel.SectionId);
                    vParams.Add("@ScenarioId", userStorySearchCriteriaInputModel.ScenarioId);
                    vParams.Add("@GoalId", userStorySearchCriteriaInputModel.GoalId);
                    vParams.Add("@ParentUserStoryId", userStorySearchCriteriaInputModel.ParentUserStoryId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsSprintUserStories", userStorySearchCriteriaInputModel.IsSprintUserStories);
                    return vConn.Query<GetBugsBasedOnUserStoryApiReturnModel>(StoredProcedureConstants.GetBugsBasedOnUserStories, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetBugsBasedOnUserStories", "UserStoryRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetBugsBasedOnUserStories);
                return new List<GetBugsBasedOnUserStoryApiReturnModel>();
            }
        }

        public List<TemplateSearchoutputmodel> GetTemplateUserStories(TemplateSearchInputmodel templateSearchInputmodel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@TemplateId", templateSearchInputmodel.TemplateId);
                    vParams.Add("@UserStoryIdsXml", templateSearchInputmodel.UserStoryIdsXml);
                    return vConn.Query<TemplateSearchoutputmodel>(StoredProcedureConstants.SpGetTemplateUserStories, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTemplateUserStories", "UserStoryRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchUserStories);
                return new List<TemplateSearchoutputmodel>();
            }
        }

        public List<SprintSearchOutPutModel> GetSprintUserStories(SprintSearchInputModel sprintSearchInputmodel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@SprintId", sprintSearchInputmodel.SprintId);
                    vParams.Add("@ParentUserStoryId", sprintSearchInputmodel.ParentUserStoryId);
                    vParams.Add("@ProjectId", sprintSearchInputmodel.ProjectId);
                    vParams.Add("@UserStoryName", sprintSearchInputmodel.UserStoryName);
                    vParams.Add("@UserStoryId", sprintSearchInputmodel.UserStoryId);
                    vParams.Add("@IsArchived", sprintSearchInputmodel.IsArchived);
                    vParams.Add("@IsParked", sprintSearchInputmodel.IsParked);
                    vParams.Add("@UserStoryIdsXml", sprintSearchInputmodel.UserStoryIdsXml);

                    vParams.Add("@ProjectIds", sprintSearchInputmodel.ProjectIds);
                    vParams.Add("@IsActiveSprints", sprintSearchInputmodel.IsActiveSprints);
                    vParams.Add("@IsBacklogSprints", sprintSearchInputmodel.IsBacklogSprints);
                    vParams.Add("@IsReplanSprints", sprintSearchInputmodel.IsReplanSprints);
                    vParams.Add("@IsDeleteSprints", sprintSearchInputmodel.IsDeleteSprints);
                    vParams.Add("@IsCompletedSprints", sprintSearchInputmodel.IsCompletedSprints);
                    vParams.Add("@SprintName", sprintSearchInputmodel.SprintName);
                    vParams.Add("@OwnerUserIds", sprintSearchInputmodel.OwnerUserIds);
                    vParams.Add("@SprintResponsiblePersonIds", sprintSearchInputmodel.SprintResponsiblePersonIds);
                    vParams.Add("@UserStoryStatusIds", sprintSearchInputmodel.UserStoryStatusIds);
                    vParams.Add("@SprintStatusIds", sprintSearchInputmodel.SprintStatusIds);
                    vParams.Add("@DeadLineDateFrom", sprintSearchInputmodel.DeadLineDateFrom);
                    vParams.Add("@DeadLineDateTo", sprintSearchInputmodel.DeadLineDateTo);
                    vParams.Add("@ProjectFeatureIds", sprintSearchInputmodel.ProjectFeatureIds);
                    vParams.Add("@BugPriorityIds", sprintSearchInputmodel.BugPriorityIds);
                    vParams.Add("@DependencyUserIds", sprintSearchInputmodel.DependencyUserIds);
                    vParams.Add("@BugCausedUserIds", sprintSearchInputmodel.BugCausedUserIds);
                    vParams.Add("@UserStoryTypeIds", sprintSearchInputmodel.UserStoryTypeIds);
                    vParams.Add("@VersionName", sprintSearchInputmodel.VersionName);
                    vParams.Add("@WorkItemTags", sprintSearchInputmodel.WorkItemTags);
                    vParams.Add("@IncludeArchived ", sprintSearchInputmodel.IncludeArchived);
                    vParams.Add("@IncludeParked ", sprintSearchInputmodel.IncludeParked);
                    vParams.Add("@DeadLineDate", sprintSearchInputmodel.IsArchivedSprint);
                    vParams.Add("@UpdatedDateFrom", sprintSearchInputmodel.DeadLineDate);
                    vParams.Add("@UpdatedDateTo", sprintSearchInputmodel.UpdatedDateFrom);
                    vParams.Add("@CreatedDateFrom", sprintSearchInputmodel.UpdatedDateTo);
                    vParams.Add("@CreatedDateTo", sprintSearchInputmodel.CreatedDateFrom);
                    vParams.Add("@SprintStartDate", sprintSearchInputmodel.SprintStartDate);
                    vParams.Add("@SprintEndDate", sprintSearchInputmodel.SprintEndDate);
                    return vConn.Query<SprintSearchOutPutModel>(StoredProcedureConstants.SpGetSprintUserStoires, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetSprintUserStories", "UserStoryRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchUserStories);
                return new List<SprintSearchOutPutModel>();
            }
        }


        public TemplateSearchoutputmodel GetTemplateUserStoryById(string templateUserStoryId,  LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@UserStoryId", templateUserStoryId);
                    return vConn.Query<TemplateSearchoutputmodel>(StoredProcedureConstants.SpGetTemplateUserStories, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTemplateUserStoryById", "UserStoryRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchUserStories);
                return new TemplateSearchoutputmodel();
            }
        }

        public SprintSearchOutPutModel GetSprintUserStoryById(Guid? sprintUserStoryId, string sprintUniqueName, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@UserStoryId", sprintUserStoryId);
                    vParams.Add("@SprintUniqueName", sprintUniqueName);
                    return vConn.Query<SprintSearchOutPutModel>(StoredProcedureConstants.SpGetSprintUserStoires, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetSprintUserStoryById", "UserStoryRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchUserStories);
                return new SprintSearchOutPutModel();
            }
        }

        public List<UserStoryApiReturnModel> GetAllUserStories(UserStorySearchCriteriaInputModel userStorySearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@UserStoryId", userStorySearchInputModel.UserStoryId);
                    vParams.Add("@SearchText", userStorySearchInputModel.SearchText);
                    vParams.Add("@ProjectId", userStorySearchInputModel.ProjectId);
                    return vConn.Query<UserStoryApiReturnModel>(StoredProcedureConstants.SpGetAllUserStoires, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllUserStories", "UserStoryRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchUserStories);
                return new List<UserStoryApiReturnModel>();
            }
        }


        public Guid? InsertGoalByTemplateId(Guid? templateId, bool? isFromTemplate, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages,string tags)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@TemplateId", templateId);
                    vParams.Add("@isFromTemplate", isFromTemplate);
                    vParams.Add("@UserStorytags", tags);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpInsertGoalByTemplateId, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertGoalByTemplateId", "UserStoryRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGoalCreationFromTemplate);
                return null;
            }
        }

        public Guid? MoveGoalUserStoryToSprint(Guid? sprintId, Guid? userStoryId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@SprintId", sprintId);
                    vParams.Add("@UserStoryId", userStoryId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpMoveGoalUserStoryToSprint, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "MoveGoalUserStoryToSprint", "UserStoryRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionToMoveUserStoryToSprint);
                return null;
            }
        }

        public Guid? UpdateMultipleUserStoriesGoal(UpdateMultipleUserStoriesGoalInputModel updateMultipleUserStoriesGoalInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserStoryIdsXml", updateMultipleUserStoriesGoalInputModel.UserStoryIdsXml);
                    vParams.Add("@GoalId", updateMultipleUserStoriesGoalInputModel.GoalId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpdateMultipleUserStoriesGoal, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateMultipleUserStoriesGoal", "UserStoryRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpdateMultipleUserStoriesGoal);
                return null;
            }
        }

        public Guid? UpsertUserStoryChannel(UpsertUserStoryChannelInputModel userStoryChannelInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();                   
                    vParams.Add("@UserStoryId", userStoryChannelInputModel.UserStoryId);
                    vParams.Add("@ProjectId", userStoryChannelInputModel.ProjectId);
                    vParams.Add("@GoalId", userStoryChannelInputModel.GoalId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertUserStoryChannel, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertUserStoryChannel", "UserStoryRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertUserStoryChannel);
                return null;
            }
        }

        public List<GetUserStoriesOverviewReturnModel> GetUserStoriesOverview(UserStorySearchCriteriaInputModel userStorySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserStoryId", userStorySearchCriteriaInputModel.UserStoryId);
                    vParams.Add("@ProjectId", userStorySearchCriteriaInputModel.ProjectId);
                    vParams.Add("@ProjectName", userStorySearchCriteriaInputModel.ProjectName);
                    vParams.Add("@GoalId", userStorySearchCriteriaInputModel.GoalId);
                    vParams.Add("@UserStoryName", userStorySearchCriteriaInputModel.UserStoryName);
                    vParams.Add("@EstimatedTime", userStorySearchCriteriaInputModel.EstimatedTime);
                    vParams.Add("@DeadLineDate", userStorySearchCriteriaInputModel.DeadLineDate);
                    vParams.Add("@OwnerUserId", userStorySearchCriteriaInputModel.OwnerUserId);
                    vParams.Add("@DependencyUserId", userStorySearchCriteriaInputModel.DependencyUserId);
                    vParams.Add("@Order", userStorySearchCriteriaInputModel.Order);
                    vParams.Add("@UserStoryStatusId", userStorySearchCriteriaInputModel.UserStoryStatusId);
                    vParams.Add("@ActualDeadLineDate", userStorySearchCriteriaInputModel.ActualDeadLineDate);
                    vParams.Add("@BugPriorityIdsXml", userStorySearchCriteriaInputModel.BugPriorityIdsXml);
                    vParams.Add("@UserStoryTypeId", userStorySearchCriteriaInputModel.UserStoryTypeId);
                    vParams.Add("@ProjectFeatureId", userStorySearchCriteriaInputModel.ProjectFeatureId);
                    vParams.Add("@IsParked", userStorySearchCriteriaInputModel.IsUserStoryParked);
                    vParams.Add("@IsArchived", userStorySearchCriteriaInputModel.IsUserStoryArchived);
                    vParams.Add("@SearchText", userStorySearchCriteriaInputModel.SearchText);
                    vParams.Add("@SortBy", userStorySearchCriteriaInputModel.SortBy);
                    vParams.Add("@SortDirection", userStorySearchCriteriaInputModel.SortDirection);
                    vParams.Add("@PageSize", userStorySearchCriteriaInputModel.PageSize);
                    vParams.Add("@PageNumber", userStorySearchCriteriaInputModel.PageNumber);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@DependencyText", userStorySearchCriteriaInputModel.DependencyText);
                    vParams.Add("@DeadLineDateFrom", userStorySearchCriteriaInputModel.DeadLineDateFrom);
                    vParams.Add("@DeadLineDateTo", userStorySearchCriteriaInputModel.DeadLineDateTo);
                    vParams.Add("@IncludeArchived", userStorySearchCriteriaInputModel.IncludeArchive);
                    vParams.Add("@IncludeParked", userStorySearchCriteriaInputModel.IncludePark);
                    vParams.Add("@IsStatusMultiselect", userStorySearchCriteriaInputModel.IsStatusMultiSelect);
                    vParams.Add("@UserStoryStatusIdsXml", userStorySearchCriteriaInputModel.UserStoryStatusIdsXml);
                    vParams.Add("@IsMyWorkOnly", userStorySearchCriteriaInputModel.IsMyWorkOnly);
                    vParams.Add("@TeamMemberIdsXml", userStorySearchCriteriaInputModel.TeamMemberIdsXml);
                    vParams.Add("@UserStoryUniqueName", userStorySearchCriteriaInputModel.UserStoryUniqueName);
                    vParams.Add("@IsForUserStoryoverview", userStorySearchCriteriaInputModel.IsForUserStoryoverview);
                    vParams.Add("@UserStoryIdsXml", userStorySearchCriteriaInputModel.UserStoryIdsXml);
                    vParams.Add("@OwnerUserIdsXml", userStorySearchCriteriaInputModel.OwnerUserIdsXml);
                    vParams.Add("@IsActiveGoalsOnly", userStorySearchCriteriaInputModel.IsActiveGoalsOnly);
                    vParams.Add("@IsGoalsPage", userStorySearchCriteriaInputModel.IsGoalsPage);
                    vParams.Add("@ParentUserStoryId", userStorySearchCriteriaInputModel.ParentUserStoryId);
                    vParams.Add("@EntityId", userStorySearchCriteriaInputModel.EntityId);
                    vParams.Add("@GoalStatusId", userStorySearchCriteriaInputModel.GoalStatusId);
                    vParams.Add("@GoalTags", userStorySearchCriteriaInputModel.Tags);
                    vParams.Add("@GoalName", userStorySearchCriteriaInputModel.GoalName);
                    vParams.Add("@UserStoryTags", userStorySearchCriteriaInputModel.UserStoryTags);
                    vParams.Add("@UserStoryTypeIdsXml", userStorySearchCriteriaInputModel.UserStoryTypeIdsXml);
                    vParams.Add("@ProjectIdsXml", userStorySearchCriteriaInputModel.ProjectIdsXml);
                    vParams.Add("@GoalStatusIdsXml", userStorySearchCriteriaInputModel.GoalStatusIdsXml);
                    vParams.Add("@IsTracked", userStorySearchCriteriaInputModel.IsTracked);
                    vParams.Add("@IsProductive", userStorySearchCriteriaInputModel.IsProductive);
                    vParams.Add("@IsOnTrack", userStorySearchCriteriaInputModel.IsOnTrack);
                    vParams.Add("@IsNotOnTrack", userStorySearchCriteriaInputModel.IsNotOnTrack);
                    vParams.Add("@GoalResponsiblePersonIdsXml", userStorySearchCriteriaInputModel.GoalResponsiblePersonIdsXml);
                    vParams.Add("@GoalResponsiblePersonId", userStorySearchCriteriaInputModel.GoalResponsiblePersonId);
                    vParams.Add("@IsAction", userStorySearchCriteriaInputModel.IsAction);

                    vParams.Add("@BugCausedUserIds", userStorySearchCriteriaInputModel.BugCausedUserIds);
                    vParams.Add("@DependencyUserIds", userStorySearchCriteriaInputModel.DependencyUserIds);
                    vParams.Add("@ProjectFeatureIds", userStorySearchCriteriaInputModel.ProjectFeatureIds);
                    vParams.Add("@VersionName", userStorySearchCriteriaInputModel.VersionName);
                    vParams.Add("@CreatedDateFrom", userStorySearchCriteriaInputModel.CreatedDateFrom);
                    vParams.Add("@CreatedDateTo", userStorySearchCriteriaInputModel.CreatedDateTo);
                    vParams.Add("@UpdatedDateFrom", userStorySearchCriteriaInputModel.UpdatedDateFrom);
                    vParams.Add("@UpdatedDateTo", userStorySearchCriteriaInputModel.UpdatedDateTo);
                    vParams.Add("@IsForFilters", userStorySearchCriteriaInputModel.IsForFilters);
                    vParams.Add("@UserStoryTagsXml", userStorySearchCriteriaInputModel.UserStoryTagsXml);
                    return vConn.Query<GetUserStoriesOverviewReturnModel>(StoredProcedureConstants.SpSearchUserStories, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserStoriesOverview", "UserStoryRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchUserStories);
                return new List<GetUserStoriesOverviewReturnModel>();
            }
        }

        public List<DelayedTaskDetailsModel> GetDelayedTaskDetails(string companyName, LoggedInContext loggedInContext)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CompanyName", companyName);
                    vParams.Add("@OperationsPerformedBy", loggedInContext?.LoggedInUserId);
                    return vConn.Query<DelayedTaskDetailsModel>(StoredProcedureConstants.SpGetDelayedWorkItems, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDelayedTaskDetails", "UserStoryRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(new List<ValidationMessage>(), sqlException, ValidationMessages.ExceptionUpsertUserStoryChannel);
                return null;
            }
        }

        public List<DelayedTaskDetailsModel> GetDelayedTaskDetailsByDelayedMinutes(string companyName, int minutes,
            LoggedInContext loggedInContext)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CompanyName", companyName);
                    vParams.Add("@Minutes", minutes);
                    vParams.Add("@OperationsPerformedBy", loggedInContext?.LoggedInUserId);
                    return vConn.Query<DelayedTaskDetailsModel>(StoredProcedureConstants.SpGetDelayedWorkItemsByMinutes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDelayedTaskDetailsByDelayedMinutes", "UserStoryRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(new List<ValidationMessage>(), sqlException, ValidationMessages.ExceptionUpsertUserStoryChannel);
                return null;
            }
        }

        public List<DelayedTaskDetailsModel> GetDelayedTaskDetailsByDelayedDays(string companyName, int days,
            LoggedInContext loggedInContext)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CompanyName", companyName);
                    vParams.Add("@Days", days);
                    vParams.Add("@OperationsPerformedBy", loggedInContext?.LoggedInUserId);
                    return vConn.Query<DelayedTaskDetailsModel>(StoredProcedureConstants.SpGetDelayedWorkItemsByDays, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDelayedTaskDetailsByDelayedDays", "UserStoryRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(new List<ValidationMessage>(), sqlException, ValidationMessages.ExceptionUpsertUserStoryChannel);
                return null;
            }
        }

        public UserStoryTypeModel GetWorkItemTypeDetails(string companyName, string workItemTypeName)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CompanyName", companyName);
                    vParams.Add("@WorkItemTypeName", workItemTypeName);
                    return vConn.Query<UserStoryTypeModel>(StoredProcedureConstants.GetWorkItemTypeDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetWorkItemTypeDetails", "UserStoryRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(new List<ValidationMessage>(), sqlException, ValidationMessages.ExceptionUpsertUserStoryChannel);
                return null;
            }
        }

        public List<BugReportOutPutModel> GetSprintsBugReport(BugReportSearchInputModel bugReportInputModel,LoggedInContext loggedInContext,List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SprintId", bugReportInputModel.SprintId);
                    vParams.Add("@UserStoryId", bugReportInputModel.UserStoryId);
                    vParams.Add("@OwnerUserId", bugReportInputModel.OwnerUserId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext?.LoggedInUserId);
                    return vConn.Query<BugReportOutPutModel>(StoredProcedureConstants.SpGetSprintsBugReport, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetSprintsBugReport", "UserStoryRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(new List<ValidationMessage>(), sqlException, ValidationMessages.ExceptionForBugReport);
                return null;
            }
        }

        public bool DeleteLinkedBug(Guid? userStoryId,string TimeZone, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserStoryId", userStoryId);
                    vParams.Add("@TimeZone", TimeZone);
                    vParams.Add("@OperationsPerformedBy", loggedInContext?.LoggedInUserId);
                    var count = vConn.Query<int>(StoredProcedureConstants.SpDeleteLinkedBug, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                    return count > 0;
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteLinkedBug", "UserStoryRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(new List<ValidationMessage>(), sqlException, ValidationMessages.ExceptionDeleteLinkedbugs);
                return false;
            }
        }
    }
}
