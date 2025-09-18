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

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class GoalRepository
    {
        public Guid? UpsertGoal(GoalUpsertInputModel goalUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@GoalId", goalUpsertInputModel.GoalId);
                    vParams.Add("@GoalName", goalUpsertInputModel.GoalName);
                    vParams.Add("@GoalShortName", goalUpsertInputModel.GoalShortName);
                    vParams.Add("@ProjectId", goalUpsertInputModel.ProjectId);
                    vParams.Add("@BoardTypeId", goalUpsertInputModel.BoardTypeId);
                    vParams.Add("@BoardTypeApiId", goalUpsertInputModel.BoardTypeApiId);
                    vParams.Add("@OnboardDate", goalUpsertInputModel.OnboardProcessDate);
                    vParams.Add("@GoalResponsiblePersonId", goalUpsertInputModel.GoalResponsibleUserId);
                    vParams.Add("@ConfigurationId", goalUpsertInputModel.ConfigurationId);
                    vParams.Add("@TobeTracked", goalUpsertInputModel.IsToBeTracked);
                    vParams.Add("@IsProductiveBoard", goalUpsertInputModel.IsProductiveBoard);
                    vParams.Add("@ConsideredHoursId", goalUpsertInputModel.ConsiderEstimatedHoursId);
                    vParams.Add("@IsApproved", goalUpsertInputModel.IsApproved);
                    vParams.Add("@IsArchived", goalUpsertInputModel.IsArchived);
                    vParams.Add("@IsLocked", goalUpsertInputModel.IsLocked);
                    vParams.Add("@IsParked", goalUpsertInputModel.IsParked);
                    vParams.Add("@GoalBudget", goalUpsertInputModel.GoalBudget);
                    vParams.Add("@Version", goalUpsertInputModel.Version);
                    vParams.Add("@IsCompleted", goalUpsertInputModel.IsCompleted);
                    vParams.Add("@TestSuiteId", goalUpsertInputModel.TestSuiteId);
                    vParams.Add("@Description", goalUpsertInputModel.Description);
                    vParams.Add("@TimeZone", goalUpsertInputModel.TimeZone);
                    vParams.Add("@TimeStamp", goalUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@EndDate", goalUpsertInputModel.EndDate);
                    vParams.Add("@EstimatedTime", goalUpsertInputModel.GoalEstimateTime);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertGoal, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertGoal", "GoalRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGoalUpsert);
                return null;
            }
        }

        public List<GoalSpReturnModel> SearchGoals(GoalSearchCriteriaInputModel goalSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@GoalId", goalSearchCriteriaInputModel.GoalId);
                    vParams.Add("@GoalUniqueNumber", goalSearchCriteriaInputModel.GoalUniqueNumber);
                    vParams.Add("@GoalName", goalSearchCriteriaInputModel.GoalName);
                    vParams.Add("@GoalShortName", goalSearchCriteriaInputModel.GoalShortName);
                    vParams.Add("@IsArchived", goalSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@ArchivedDateTime", goalSearchCriteriaInputModel.ArchivedDateTime);
                    vParams.Add("@ProjectId", goalSearchCriteriaInputModel.ProjectId);
                    vParams.Add("@BoardTypeId", goalSearchCriteriaInputModel.BoardTypeId);
                    vParams.Add("@BoardTypeApiId", goalSearchCriteriaInputModel.BoardTypeApiId);
                    vParams.Add("@OnboardDate", goalSearchCriteriaInputModel.OnboardProcessDate);
                    vParams.Add("@GoalResponsiblePersonId", goalSearchCriteriaInputModel.GoalResponsibleUserId);
                    vParams.Add("@ConfigurationId", goalSearchCriteriaInputModel.ConfigurationId);
                    vParams.Add("@TobeTracked", goalSearchCriteriaInputModel.IsToBeTracked);
                    vParams.Add("@IsProductiveBoard", goalSearchCriteriaInputModel.IsProductiveBoard);
                    vParams.Add("@ConsideredHoursId", goalSearchCriteriaInputModel.ConsiderEstimatedHoursId);
                    vParams.Add("@IsParked", goalSearchCriteriaInputModel.IsParked);
                    vParams.Add("@ParkedDateTime", goalSearchCriteriaInputModel.ParkedDateTime);
                    vParams.Add("@IsApproved", goalSearchCriteriaInputModel.IsApproved);
                    vParams.Add("@IsLocked", goalSearchCriteriaInputModel.IsLocked);
                    vParams.Add("@IsCompleted", goalSearchCriteriaInputModel.IsCompleted);
                    vParams.Add("@GoalBudget", goalSearchCriteriaInputModel.GoalBudget);
                    vParams.Add("@GoalStatusId", goalSearchCriteriaInputModel.GoalStatusId);
                    vParams.Add("@GoalStatus", goalSearchCriteriaInputModel.GoalStatus);
                    vParams.Add("@GoalStatusColor", goalSearchCriteriaInputModel.GoalStatusColor);
                    vParams.Add("@Version", goalSearchCriteriaInputModel.Version);
                    vParams.Add("@PageNumber", goalSearchCriteriaInputModel.PageNumber);
                    vParams.Add("@PageSize", goalSearchCriteriaInputModel.PageSize);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsGoalsBasedOnGrp", goalSearchCriteriaInputModel.IsGoalsBasedOnGrp);
                    vParams.Add("@IsGoalsBasedOnProject", goalSearchCriteriaInputModel.IsGoalsBasedOnProject);
                    vParams.Add("@SearchText", goalSearchCriteriaInputModel.SearchText);
                    vParams.Add("@SortBy", goalSearchCriteriaInputModel.SortBy);
                    vParams.Add("@SortDirection", goalSearchCriteriaInputModel.SortDirection);
                    vParams.Add("@GoalIdsXml", goalSearchCriteriaInputModel.GoalIdsXml);
                    vParams.Add("@IsUnique", goalSearchCriteriaInputModel.IsUnique);
                    return vConn.Query<GoalSpReturnModel>(StoredProcedureConstants.SpSearchGoalsNew, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchGoals", "GoalRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchGoals);
                return new List<GoalSpReturnModel>();
            }
        }

        public List<UserStoriesAllGoalsApiReturnModel> UserStoriesForAllGoals(GoalSearchCriteriaInputModel goalSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserStoryId", goalSearchCriteriaInputModel.UserStoryId);
                    vParams.Add("@GoalId", goalSearchCriteriaInputModel.GoalId);
                    vParams.Add("@ProjectId", goalSearchCriteriaInputModel.ProjectId);
                    vParams.Add("@OwnerUserId", goalSearchCriteriaInputModel.OwnerUserId);
                    vParams.Add("@GoalResponsiblePersonId", goalSearchCriteriaInputModel.GoalResponsibleUserId);
                    vParams.Add("@UserStoryStatusId", goalSearchCriteriaInputModel.UserStoryStatusId);
                    vParams.Add("@GoalStatusId", goalSearchCriteriaInputModel.GoalStatusId);
                    vParams.Add("@GoalName", goalSearchCriteriaInputModel.GoalName);
                    vParams.Add("@DeadLineDateFrom", goalSearchCriteriaInputModel.DeadLineDateFrom);
                    vParams.Add("@DeadLineDateTo", goalSearchCriteriaInputModel.DeadLineDateTo);
                    vParams.Add("@IsRed", goalSearchCriteriaInputModel.IsRed);
                    vParams.Add("@IsWarning", goalSearchCriteriaInputModel.IsWarning);
                    vParams.Add("@IsTracked", goalSearchCriteriaInputModel.IsTracked);
                    vParams.Add("@IsProductive", goalSearchCriteriaInputModel.IsProductive);
                    vParams.Add("@IsArchivedGoal", goalSearchCriteriaInputModel.IsArchivedGoal);
                    vParams.Add("@IsParkedGoal", goalSearchCriteriaInputModel.IsGoalParked);
                    vParams.Add("@IncludeArchived", goalSearchCriteriaInputModel.IncludeArchived);
                    vParams.Add("@IncludeParked", goalSearchCriteriaInputModel.IncludeParked);
                    vParams.Add("@SortBy", goalSearchCriteriaInputModel.SortBy);
                    vParams.Add("@SortDirection", goalSearchCriteriaInputModel.SortDirection);
                    vParams.Add("@PageNumber", goalSearchCriteriaInputModel.PageNumber);
                    vParams.Add("@PageSize", goalSearchCriteriaInputModel.PageSize);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<UserStoriesAllGoalsApiReturnModel>(StoredProcedureConstants.SpUserStoriesForAllGoals, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UserStoriesForAllGoals", "GoalRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUserStoriesForAllGoals);
                return new List<UserStoriesAllGoalsApiReturnModel>();
            }
        }

        public List<GoalsToArchiveApiReturnModel> GetGoalsToArchive(GoalsToArchiveSearchCriteriaInputModel goalsToArchiveSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@PageNumber", goalsToArchiveSearchCriteriaInputModel.PageNumber);
                    vParams.Add("@PageSize", goalsToArchiveSearchCriteriaInputModel.PageSize);
                    vParams.Add("@SearchText", goalsToArchiveSearchCriteriaInputModel.SearchText);
                    vParams.Add("@SortBy", goalsToArchiveSearchCriteriaInputModel.SortBy);
                    vParams.Add("@SortDirection", goalsToArchiveSearchCriteriaInputModel.SortDirection);
                    vParams.Add("@EntityId", goalsToArchiveSearchCriteriaInputModel.EntityId);
                    vParams.Add("@ProjectId", goalsToArchiveSearchCriteriaInputModel.ProjectId);
                    return vConn.Query<GoalsToArchiveApiReturnModel>(StoredProcedureConstants.SpGetGoalsToArchiveNew, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetGoalsToArchive", "GoalRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetGoalsToArchive);
                return new List<GoalsToArchiveApiReturnModel>();
            }
        }

        public void ArchiveGoal(ArchiveGoalInputModel archiveGoalInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@GoalId", archiveGoalInputModel.GoalId);
                    vParams.Add("@TimeZone", archiveGoalInputModel.TimeZone);
                    vParams.Add("@IsArchived", archiveGoalInputModel.Archive);
                    vParams.Add("@TimeStamp", archiveGoalInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    //TODO: Productionize stored procedure
                    vConn.Query(StoredProcedureConstants.SpDeleteGoal, vParams, commandType: CommandType.StoredProcedure);
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "archiveGoalInputModel", "GoalRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionArchiveGoal);
            }
        }

        public void ParkGoal(ParkGoalInputModel parkGoalInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@GoalId", parkGoalInputModel.GoalId);
                    vParams.Add("@TimeZone", parkGoalInputModel.TimeZone);
                    vParams.Add("@IsGoalPark", parkGoalInputModel.Park);
                    vParams.Add("@TimeStamp", parkGoalInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    //TODO: Productionize stored procedure
                    vConn.Query(StoredProcedureConstants.SpParkOrResumeGoal, vParams, commandType: CommandType.StoredProcedure);
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ParkGoal", "GoalRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionParkGoal);
            }
        }

        public GoalUpdateReturnModel GetGoalStatus(Guid? goalId, Guid loggedInContext)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@GoalId", goalId);
                return vConn.Query<GoalUpdateReturnModel>(StoredProcedureConstants.SpGetGoalStatus, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }

        public List<LeastPerformingGoalByResponsiblePerson> GetLeastPerformingGoal(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<LeastPerformingGoalByResponsiblePerson>(StoredProcedureConstants.SpGetLeastPerformingGoal, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetLeastPerformingGoal", "GoalRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetGoalsToArchive);
                return new List<LeastPerformingGoalByResponsiblePerson>();
            }
        }

        public List<LeastPerformingGoalByResponsiblePerson> GetGoalBurnDownChart(Guid? goalId,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@goalId", goalId);
                    vParams.Add("@OperationsPerfromedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<LeastPerformingGoalByResponsiblePerson>(StoredProcedureConstants.SpGetGoalBurnDown, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetGoalBurnDownChart", "GoalRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetGoalBurnDownChart);
                return new List<LeastPerformingGoalByResponsiblePerson>();
            }
        }

        public List<LeastPerformingGoalByResponsiblePerson> GetDeveloperBurnDownChartInGoal(Guid? goalId,Guid? userId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@goalId", goalId);
                    vParams.Add("@userId", userId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<LeastPerformingGoalByResponsiblePerson>(StoredProcedureConstants.SpGetLeastPerformingGoal, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDeveloperBurnDownChartInGoal", "GoalRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetDeveloperBurnDownChartInGoal);
                return new List<LeastPerformingGoalByResponsiblePerson>();
            }
        }


        /// <summary>
        /// Gets template.
        /// </summary>
        public string GetHtmlTemplateByName(string templateName, Guid? companyId)
        {
            using (IDbConnection vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@TemplateName", templateName);
                vParams.Add("@CompanyId", companyId);
                return vConn.Query<string>(StoredProcedureConstants.SpGetTemplate, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }
        
        public GoalSpReturnModel SearchGoalDetails(SearchGoalDetailsInputModel searchGoalDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@GoalId", searchGoalDetailsInputModel.GoalId);
                    vParams.Add("@GoalUniqueName", searchGoalDetailsInputModel.GoalUniqueName);
                    vParams.Add("@IsArchived", searchGoalDetailsInputModel.IsArchived);
                    vParams.Add("@SortBy", searchGoalDetailsInputModel.SortBy);
                    vParams.Add("@SortDirection", searchGoalDetailsInputModel.SortDirection);
                    vParams.Add("@PageNumber", searchGoalDetailsInputModel.PageNumber);
                    vParams.Add("@PageSize", searchGoalDetailsInputModel.PageSize);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<GoalSpReturnModel>(StoredProcedureConstants.SpSearchGoalDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchGoalDetails", "GoalRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchGoalDetails);
                return new GoalSpReturnModel();
            }
        }

        public Guid? UpsertGoalTags(GoalTagUpsertInputModel goalTagUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@GoalId", goalTagUpsertInputModel.GoalId);
                    vParams.Add("@Tags", goalTagUpsertInputModel.Tags);
                    vParams.Add("@TimeStamp", goalTagUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertGoalTag, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertGoalTags", "GoalRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertGoalTags);
                return null;
            }
        }

        public List<GoalTagApiReturnModel> SearchGoalTags(GoalTagSearchInputModel goalTagSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@GoalId", goalTagSearchInputModel.GoalId);
                    vParams.Add("@Tag", goalTagSearchInputModel.Tag);
                    vParams.Add("@SearchText", goalTagSearchInputModel.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<GoalTagApiReturnModel>(StoredProcedureConstants.SpGetGoalTags, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchGoalTags", "GoalRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchGoalTags);
                return new List<GoalTagApiReturnModel>();
            }
        }

        public List<HeatMapSpOutputModel> GetDeveloperHeatMap(Guid? goalId, Guid? userId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@goalId", goalId);
                    vParams.Add("@userId", userId);
                    vParams.Add("@OperatinsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<HeatMapSpOutputModel>(StoredProcedureConstants.SpGetUserStoryHeatMap, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDeveloperHeatMap", "GoalRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetDeveloperHeatMap);
                return new List<HeatMapSpOutputModel>();
            }
        }

        public List<HeatMapSpOutputModel> GetGoalHeatMap(Guid? goalId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@goalId", goalId);
                    vParams.Add("@OperatinsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<HeatMapSpOutputModel>(StoredProcedureConstants.SpGetUserStoryHeatMap, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetGoalHeatMap", "GoalRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetGoalHeatMap);
                return new List<HeatMapSpOutputModel>();
            }
        }

        public List<GoalActivityOutputModel> GetGoalActivity(Guid? goalId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@goalId", goalId);
                    vParams.Add("@OperationPerformedByUserId", loggedInContext.LoggedInUserId);
                    return vConn.Query<GoalActivityOutputModel>(StoredProcedureConstants.SpGetGoalActivity, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetGoalActivity", "GoalRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetGoalActivity);
                return new List<GoalActivityOutputModel>();
            }
        }

        public List<DeveloperSpentTimeReportSpOutputModel> GetDeveloperSpentTimeReport(Guid? goalId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@goalId", goalId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<DeveloperSpentTimeReportSpOutputModel>(StoredProcedureConstants.SpGetSpentTimeReport, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDeveloperSpentTimeReport", "GoalRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetDeveloperSpentTimeReport);
                return new List<DeveloperSpentTimeReportSpOutputModel>();
            }
        }

        public List<GetRunningTeamLeadGoalsOutputModel> GetActivelyRunningTeamLeadGoals(Guid? entityId,Guid? projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@EntityId", entityId);
                    vParams.Add("@ProjectId", projectId);
                    return vConn.Query<GetRunningTeamLeadGoalsOutputModel>(StoredProcedureConstants.SpGetActivelyRunningGoalsUnderTeamLead, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActivelyRunningTeamLeadGoals", "GoalRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetActivelyRunningTeamLeadGoals);
                return new List<GetRunningTeamLeadGoalsOutputModel>();
            }
        }

        public List<GetRunningProjectGoalsOutputModel> GetActivelyRunningProjectGoals(Guid? entityId,Guid? projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@entityId", entityId);
                    vParams.Add("@projectId", projectId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<GetRunningProjectGoalsOutputModel>(StoredProcedureConstants.SpGetActivelyRunningGoalsUnderProject, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActivelyRunningProjectGoals", "GoalRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetActivelyRunningProjectGoals);
                return new List<GetRunningProjectGoalsOutputModel>();
            }
        }

        public List<GoalActivityWithUserStoriesOutputModel> GetGoalActivityWithUserStories(GoalActivityWithUserStoriesInputModel goalActivityWithUserStoriesInputModel,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@UserId", goalActivityWithUserStoriesInputModel.UserId);
                    vParams.Add("@GoalId", goalActivityWithUserStoriesInputModel.GoalId);
                    vParams.Add("@ProjectId", goalActivityWithUserStoriesInputModel.ProjectId);
                    vParams.Add("@IsIncludeLogTime", goalActivityWithUserStoriesInputModel.IsIncludeLogTime);
                    vParams.Add("@IsIncludeUserStoryView", goalActivityWithUserStoriesInputModel.IsIncludeUserStoryView);
                    vParams.Add("@IsFromActivity", goalActivityWithUserStoriesInputModel.IsFromActivity);
                    vParams.Add("@DateFrom", goalActivityWithUserStoriesInputModel.DateFrom);
                    vParams.Add("@DateTo", goalActivityWithUserStoriesInputModel.DateTo);
                    vParams.Add("@PageNo", goalActivityWithUserStoriesInputModel.PageNumber);
                    vParams.Add("@PageSize", goalActivityWithUserStoriesInputModel.PageSize);
                    return vConn.Query<GoalActivityWithUserStoriesOutputModel>(StoredProcedureConstants.SpGetGoalActivityWithUserStories, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetGoalActivityWithUserStories", "GoalRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetGoalActivityWithUserStories);
                return new List<GoalActivityWithUserStoriesOutputModel>();
            }
        }

        public List<UserStoryStatusReportSearchSpOutputModel> GetUserStoryStatusReport(UserStoryStatusReportInputModel statusInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@userId", statusInputModel.UserId);
                    vParams.Add("@DateFrom", statusInputModel.DateFrom);
                    vParams.Add("@DateTo", statusInputModel.DateTo);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    if(statusInputModel.SprintId != null && statusInputModel.SprintId != Guid.Empty)
                    {
                        vParams.Add("@SprintId", statusInputModel.SprintId);
                        return vConn.Query<UserStoryStatusReportSearchSpOutputModel>(StoredProcedureConstants.SpGetUserStoryStatusReportForSprints, vParams, commandType: CommandType.StoredProcedure).ToList();
                    } else
                    {
                        vParams.Add("@goalId", statusInputModel.GoalId);
                        vParams.Add("@TimeZone", statusInputModel.TimeZone);
                        return vConn.Query<UserStoryStatusReportSearchSpOutputModel>(StoredProcedureConstants.SpGetUserStoryStatusReport, vParams, commandType: CommandType.StoredProcedure).ToList();
                    }
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserStoryStatusReport", "GoalRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetUserStoryStatusReport);
                return new List<UserStoryStatusReportSearchSpOutputModel>();
            }
        }

        public List<GetGoalCommentsOutputModel> GetGoalComments(GoalCommnetsSearchInputModel getGoalCommnetsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@GoalId", getGoalCommnetsInputModel.GoalId);
                    vParams.Add("@GoalCommentId", getGoalCommnetsInputModel.GoalCommentId);
                    vParams.Add("@SearchText", getGoalCommnetsInputModel.SearchText);
                    vParams.Add("@IsArchived", getGoalCommnetsInputModel.IsArchived);
                    vParams.Add("@OperatinsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<GetGoalCommentsOutputModel>(StoredProcedureConstants.SpGetGoalComments, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetGoalComments", "GoalRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetUserStoryStatusReport);
                return new List<GetGoalCommentsOutputModel>();
            }
        }

        public Guid? UpsertGoalComment(GoalCommentUpsertInputModel goalCommentUpsertInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@GoalId", goalCommentUpsertInput.GoalId);
                    vParams.Add("@GoalCommentId", goalCommentUpsertInput.GoalCommentid);
                    vParams.Add("@TimeStamp", goalCommentUpsertInput.TimeStamp);
                    vParams.Add("@Comments", goalCommentUpsertInput.Comment);
                    vParams.Add("@IsArchived", goalCommentUpsertInput.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertGoalComment, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertGoalComment", "GoalRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertGoalComment);
                return new Guid();
            }
        }

        public Guid? UpsertGoalFilterDetails(UpsertGoalFilterModel goalFilterUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@GoalFilterId", goalFilterUpsertInputModel.GoalFilterId);
                    vParams.Add("@GoalFilterName", goalFilterUpsertInputModel.GoalFilterName);
                    vParams.Add("@IsPublic", goalFilterUpsertInputModel.IsPublic);
                    vParams.Add("@GoalFilterDetailsId", goalFilterUpsertInputModel.GoalFilterDetailsId);
                    vParams.Add("@GoalFilterJson", goalFilterUpsertInputModel.GoalFilterDetailsJson);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertGoalFilterDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertGoalFilterDetails", "GoalRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertGoalFilter);
                return null;
            }
        }

        public void ArchiveGoalFilter(ArchiveGoalFilterModel archiveGoalFilterModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@GoalFilterId", archiveGoalFilterModel.GoalFilterId);
                    vParams.Add("@IsArchived", archiveGoalFilterModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    //TODO: Productionize stored procedure
                    vConn.Query(StoredProcedureConstants.SpArchiveGoalFilter, vParams, commandType: CommandType.StoredProcedure);
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ArchiveGoalFilter", "GoalRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionForArchiveGoalFilters);
            }
        }

        public List<GoalFilterApiReturnModel> SearchGoalsFilters(GoalFilterSerachCriterisInputModel goalFilterSearchCriteriaModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@GoalFilterId", goalFilterSearchCriteriaModel.GoalFilterId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<GoalFilterApiReturnModel>(StoredProcedureConstants.SpGetGoalFiltersList, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchGoalsFilters", "GoalRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetGoalFilterList);
                return new List<GoalFilterApiReturnModel>();
            }
        }

    }
}