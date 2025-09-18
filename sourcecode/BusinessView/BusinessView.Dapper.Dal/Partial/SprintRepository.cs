using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.Goals;
using Btrak.Models.Sprints;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Dapper.Dal.Partial
{
    public class SprintRepository : BaseRepository
    {
        public Guid? UpsertSprint(SprintUpsertModel sprintsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SprintId", sprintsUpsertInputModel.SprintId);
                    vParams.Add("@SprintName", sprintsUpsertInputModel.SprintName);
                    vParams.Add("@ProjectId", sprintsUpsertInputModel.ProjectId);
                    vParams.Add("@SprintStartDate", sprintsUpsertInputModel.SprintStartDate);
                    vParams.Add("@SprintEndDate", sprintsUpsertInputModel.SprintEndDate);
                    vParams.Add("@BoardTypeId", sprintsUpsertInputModel.BoardTypeId);
                    vParams.Add("@BoardTypeApiId", sprintsUpsertInputModel.BoardTypeApiId);
                    vParams.Add("@TestSuiteId", sprintsUpsertInputModel.TestSuiteId);
                    vParams.Add("@SprintResponsiblePersonId", sprintsUpsertInputModel.SprintResponsiblePersonId);
                    vParams.Add("@Version", sprintsUpsertInputModel.Version);
                    vParams.Add("@TimeZone", sprintsUpsertInputModel.TimeZone);
                    vParams.Add("@Description", sprintsUpsertInputModel.Description);
                    vParams.Add("@IsReplan", sprintsUpsertInputModel.IsReplan);
                    vParams.Add("@TimeStamp", sprintsUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertSprint, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertSprint", "SprintRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionForUpsertSprint);
                return null;
            }
        }

        public List<SprintsApiReturnModel> SearchSprints(SprintSearchCriteriaInputModel sprintSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SprintId", sprintSearchCriteriaInputModel.SprintId);                    
                    vParams.Add("@ProjectId", sprintSearchCriteriaInputModel.ProjectId);
                    vParams.Add("@SprintName", sprintSearchCriteriaInputModel.SprintName);
                    vParams.Add("@SprintUniqueNumber", sprintSearchCriteriaInputModel.SprintUniqueNumber);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@SearchText", sprintSearchCriteriaInputModel.SearchText);

                    vParams.Add("@PageSize", sprintSearchCriteriaInputModel.PageSize);
                    vParams.Add("@PageNumber", sprintSearchCriteriaInputModel.PageNumber);                    
                    vParams.Add("@IsBacklog", sprintSearchCriteriaInputModel.IsBacklog);
                    vParams.Add("@IsComplete", sprintSearchCriteriaInputModel.IsComplete);
                    vParams.Add("@AllSprints", sprintSearchCriteriaInputModel.AllSprints);                                      
                    vParams.Add("@SprintIdsXml", sprintSearchCriteriaInputModel.SprintIdsXml);
                    var result = vConn.Query<SprintsApiReturnModel>(StoredProcedureConstants.SpSearchSprints, vParams, commandType: CommandType.StoredProcedure).ToList();
                    return result;
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchSprints", "SprintRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionForSearchSprints);
                return new List<SprintsApiReturnModel>();
            }
        }

        public List<SprintsApiReturnModel> GetUserStoriesForAllSprints(UserStoriesForAllSprints userStoriesForAllSprints, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SprintId", userStoriesForAllSprints.SprintId);
                    vParams.Add("@ProjectIds", userStoriesForAllSprints.ProjectIds);
                    vParams.Add("@SprintName", userStoriesForAllSprints.SprintName);
                    vParams.Add("@UserStoryId", userStoriesForAllSprints.UserStoryId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@OwnerUserIds", userStoriesForAllSprints.OwnerUserIds);
                    vParams.Add("@PageSize", userStoriesForAllSprints.PageSize);
                    vParams.Add("@PageNumber", userStoriesForAllSprints.PageNumber);
                    vParams.Add("@SprintResponsiblePersonIds", userStoriesForAllSprints.SprintResponsiblePersonIds);
                    vParams.Add("@UserStoryStatusIds", userStoriesForAllSprints.UserStoryStatusIds);
                    vParams.Add("@SprintStatusIds", userStoriesForAllSprints.SprintStatusIds);
                    vParams.Add("@SprintName", userStoriesForAllSprints.SprintName);
                    vParams.Add("@DeadLineDateFrom", userStoriesForAllSprints.DeadLineDateFrom);
                    vParams.Add("@DeadLineDateTo", userStoriesForAllSprints.DeadLineDateTo);
                    vParams.Add("@ProjectFeatureIds", userStoriesForAllSprints.ProjectFeatureIds);
                    vParams.Add("@BugPriorityIds", userStoriesForAllSprints.BugPriorityIds );
                    vParams.Add("@DependencyUserIds", userStoriesForAllSprints.DependencyUserIds);
                    vParams.Add("@BugCausedUserIds", userStoriesForAllSprints.BugCausedUserIds );
                    vParams.Add("@UserStoryTypeIds", userStoriesForAllSprints.UserStoryTypeIds );
                    vParams.Add("@VersionName", userStoriesForAllSprints.VersionName );
                    vParams.Add("@UserStoryName", userStoriesForAllSprints.UserStoryName );
                    vParams.Add("@WorkItemTags", userStoriesForAllSprints.WorkItemTags );
                    vParams.Add("@IncludeArchived ", userStoriesForAllSprints.IncludeArchived );
                    vParams.Add("@IncludeParked ", userStoriesForAllSprints.IncludeParked);
                    vParams.Add("@DeadLineDate", userStoriesForAllSprints.IsArchivedSprint);
                    vParams.Add("@UpdatedDateFrom", userStoriesForAllSprints.DeadLineDate );
                    vParams.Add("@UpdatedDateTo", userStoriesForAllSprints.UpdatedDateFrom );
                    vParams.Add("@CreatedDateFrom", userStoriesForAllSprints.UpdatedDateTo );
                    vParams.Add("@CreatedDateTo", userStoriesForAllSprints.CreatedDateFrom );
                    vParams.Add("@SprintStartDate", userStoriesForAllSprints.SprintStartDate);
                    vParams.Add("@SprintEndDate", userStoriesForAllSprints.SprintEndDate);
                    vParams.Add("@IsActiveSprints", userStoriesForAllSprints.IsActiveSprints);
                    vParams.Add("@IsBacklogSprints", userStoriesForAllSprints.IsBacklogSprints);
                    vParams.Add("@IsReplanSprints", userStoriesForAllSprints.IsReplanSprints);
                    vParams.Add("@IsDeleteSprints", userStoriesForAllSprints.IsDeleteSprints);
                    vParams.Add("@IsCompletedSprints", userStoriesForAllSprints.IsCompletedSprints);
                    var result = vConn.Query<SprintsApiReturnModel>(StoredProcedureConstants.SpGetUserStoriesForAllSprints, vParams, commandType: CommandType.StoredProcedure).ToList();
                    return result;
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserStoriesForAllSprints", "SprintRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionForSearchSprints);
                return new List<SprintsApiReturnModel>();
            }
        }

        public Guid? DeleteSprint(SprintUpsertModel sprintsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SprintId", sprintsUpsertInputModel.SprintId);
                    vParams.Add("@IsArchived", sprintsUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", sprintsUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpDeleteSprint, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteSprint", "SprintRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionForDeleteSprints);
                return null;
            }
        }

        public Guid? CompleteSprint(SprintUpsertModel sprintsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SprintId", sprintsUpsertInputModel.SprintId);
                    vParams.Add("@TimeStamp", sprintsUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpCompleteSprint, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CompleteSprint", "SprintRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionForCompleteSprints);
                return null;
            }
        }

        public List<GoalActivityWithUserStoriesOutputModel> GetSprintActivityWithUserStories(GoalActivityWithUserStoriesInputModel goalActivityWithUserStoriesInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@UserId", goalActivityWithUserStoriesInputModel.UserId);
                    vParams.Add("@SprintId", goalActivityWithUserStoriesInputModel.SprintId);
                    vParams.Add("@ProjectId", goalActivityWithUserStoriesInputModel.ProjectId);
                    vParams.Add("@IsIncludeLogTime", goalActivityWithUserStoriesInputModel.IsIncludeLogTime);
                    vParams.Add("@IsIncludeUserStoryView", goalActivityWithUserStoriesInputModel.IsIncludeUserStoryView);
                    vParams.Add("@PageNo", goalActivityWithUserStoriesInputModel.PageNumber);
                    vParams.Add("@PageSize", goalActivityWithUserStoriesInputModel.PageSize);
                    return vConn.Query<GoalActivityWithUserStoriesOutputModel>(StoredProcedureConstants.SpGetSprintActivityWithUserStories, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetSprintActivityWithUserStories", "SprintRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetGoalActivityWithUserStories);
                return new List<GoalActivityWithUserStoriesOutputModel>();
            }
        }


    }
}
