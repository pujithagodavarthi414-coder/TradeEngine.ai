using Btrak.Dapper.Dal.Helpers;
using Btrak.Models.ProductivityDashboard;
using BTrak.Common;
using Dapper;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Models;
using System;
using Btrak.Models.MyWork;

namespace Btrak.Dapper.Dal.Repositories
{
    public class ProductivityDashboardRepository : BaseRepository
    {
        public List<ProductivityIndexApiReturnModel> GetProductivityIndexForDevelopers(ProductivityDashboardSearchCriteriaInputModel productivityDashboardModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Type", productivityDashboardModel.Type);
                    vParams.Add("@Date", productivityDashboardModel.SelectedDate);
                    vParams.Add("@DateFrom", productivityDashboardModel.DateFrom);
                    vParams.Add("@DateTo", productivityDashboardModel.DateTo);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@PageNo ", productivityDashboardModel.PageNumber);
                    vParams.Add("@PageSize", productivityDashboardModel.PageSize);
                    vParams.Add("@searchText", productivityDashboardModel.SearchText);
                    vParams.Add("@EntityId", productivityDashboardModel.EntityId);
                    vParams.Add("@ProjectId", productivityDashboardModel.ProjectId);
                    vParams.Add("@SortBy", productivityDashboardModel.SortBy);
                    vParams.Add("@OwnerUserId", productivityDashboardModel.OwnerUserId);
                    vParams.Add("@SortDirection", productivityDashboardModel.SortDirection);
                    vParams.Add("@IsAll", productivityDashboardModel.IsAll);
                    vParams.Add("@IsReportingOnly", productivityDashboardModel.IsReportingOnly);
                    vParams.Add("@IsFromDrilldown", productivityDashboardModel.IsFromDrilldown);
                    vParams.Add("@IsMyself", productivityDashboardModel.IsMyself);
                    return vConn.Query<ProductivityIndexApiReturnModel>(StoredProcedureConstants.SpGetProductivityIndexForDevelopersNew, vParams, commandType: CommandType.StoredProcedure)
                      .ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetProductivityIndexForDevelopers", "ProductivityDashboardRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetProductivityIndexForDevelopers);
                return new List<ProductivityIndexApiReturnModel>();
            }
        }

        public List<UserStoryStatusesApiReturnModel> GetUserStoryStatuses(ProductivityDashboardSearchCriteriaInputModel productivityDashboardModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Type", productivityDashboardModel.Type);
                    vParams.Add("@ProjectId", productivityDashboardModel.ProjectId);
                    vParams.Add("@Date", productivityDashboardModel.SelectedDate);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@PageNumber", productivityDashboardModel.PageNumber);
                    vParams.Add("@PageSize", productivityDashboardModel.PageSize);
                    vParams.Add("@SearchText", productivityDashboardModel.SearchText);
                    vParams.Add("@SortBy", productivityDashboardModel.SortBy);
                    vParams.Add("@SortDirection", productivityDashboardModel.SortDirection);
                    vParams.Add("@EntityId", productivityDashboardModel.EntityId);
                    vParams.Add("@IsAll", productivityDashboardModel.IsAll);
                    vParams.Add("@IsReportingOnly", productivityDashboardModel.IsReportingOnly);
                    vParams.Add("@IsMyself", productivityDashboardModel.IsMyself);
                    return vConn.Query<UserStoryStatusesApiReturnModel>(StoredProcedureConstants.SpGetUserStoryStatusDetailsNew, vParams, commandType: CommandType.StoredProcedure)
                      .ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserStoryStatuses", "ProductivityDashboardRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetUserStoryStatuses);
                return new List<UserStoryStatusesApiReturnModel>();
            }
        }

        public List<TestingAgeApiReturnModel> GetQaPerformance(ProductivityDashboardSearchCriteriaInputModel productivityDashboardModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Type", productivityDashboardModel.Type);
                    vParams.Add("@ProjectId", productivityDashboardModel.ProjectId);
                    vParams.Add("@Date", productivityDashboardModel.SelectedDate);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@EntityId", productivityDashboardModel.EntityId);
                    vParams.Add("@PageNumber", productivityDashboardModel.PageNumber);
                    vParams.Add("@PageSize", productivityDashboardModel.PageSize);
                    vParams.Add("@SearchText", productivityDashboardModel.SearchText);
                    vParams.Add("@SortBy", productivityDashboardModel.SortBy);
                    vParams.Add("@SortDirection", productivityDashboardModel.SortDirection);
                    vParams.Add("@IsAll", productivityDashboardModel.IsAll);
                    vParams.Add("@IsReportingOnly", productivityDashboardModel.IsReportingOnly);
                    vParams.Add("@IsMyself", productivityDashboardModel.IsMyself);
                    return vConn.Query<TestingAgeApiReturnModel>(StoredProcedureConstants.SpTimeOfTestingNew, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetQaPerformance", "ProductivityDashboardRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetQaPerformance);
                return new List<TestingAgeApiReturnModel>();
            }
        }

        public List<QaApprovalApiReturnModel> GetUserStoriesWaitingForQaApproval(ProductivityDashboardSearchCriteriaInputModel productivityDashboardModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ProjectId", productivityDashboardModel.ProjectId);
                    vParams.Add("@IsUserstoryOutsideQa", productivityDashboardModel.IsUserstoryOutsideQa);
                    vParams.Add("@OwnerUserId", productivityDashboardModel.OwnerUserId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@PageNumber", productivityDashboardModel.PageNumber);
                    vParams.Add("@PageSize", productivityDashboardModel.PageSize);
                    vParams.Add("@SearchText", productivityDashboardModel.SearchText);
                    vParams.Add("@SortBy", productivityDashboardModel.SortBy);
                    vParams.Add("@SortDirection", productivityDashboardModel.SortDirection);
                    vParams.Add("@EntityId", productivityDashboardModel.EntityId);
                    vParams.Add("@IsAll", productivityDashboardModel.IsAll);
                    vParams.Add("@IsReportingOnly", productivityDashboardModel.IsReportingOnly);
                    vParams.Add("@IsMyself", productivityDashboardModel.IsMyself);
                    return vConn.Query<QaApprovalApiReturnModel>(StoredProcedureConstants.SpGetUserStoriesWaitingForQaApprovalNew, vParams, commandType: CommandType.StoredProcedure)
                      .ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserStoriesWaitingForQaApproval", "ProductivityDashboardRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetUserStoriesWaitingForQaApproval);
                return new List<QaApprovalApiReturnModel>();
            }
        }

        public List<ProductivityTargetStatusSpReturnModel> GetEveryDayTargetStatus(Guid? entityId,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@EntityId", entityId);
                    return vConn.Query<ProductivityTargetStatusSpReturnModel>(StoredProcedureConstants.SpGetEveryDayTargetStatusReport, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEveryDayTargetStatus", "ProductivityDashboardRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEveryDayTargetStatus);
                return new List<ProductivityTargetStatusSpReturnModel>();
            }
        }

        public List<BugReportApiReturnModel> GetBugReport(ProductivityDashboardSearchCriteriaInputModel productivityDashboardModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SelectedDate", productivityDashboardModel.SelectedDate);
                    vParams.Add("@ProjectId", productivityDashboardModel.ProjectId);
                    vParams.Add("@AssigneeId", productivityDashboardModel.AssigneeId);
                    vParams.Add("@ProjectFeatureId", productivityDashboardModel.ProjectFeatureId);
                    vParams.Add("@ShowGoalLevel", productivityDashboardModel.ShowGoalLevel);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@PageNumber", productivityDashboardModel.PageNumber);
                    vParams.Add("@PageSize", productivityDashboardModel.PageSize);
                    vParams.Add("@SearchText", productivityDashboardModel.SearchText);
                    vParams.Add("@SortBy", productivityDashboardModel.SortBy);
                    vParams.Add("@SortDirection", productivityDashboardModel.SortDirection);
                    vParams.Add("@EntityId", productivityDashboardModel.EntityId);
                    return vConn.Query<BugReportApiReturnModel>(StoredProcedureConstants.SpBugReportNew, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetBugReport", "ProductivityDashboardRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetBugReport);
                return new List<BugReportApiReturnModel>();
            }
        }

        public List<EmployeeUserStoriesApiReturnModel> GetEmployeeUserStories(ProductivityDashboardSearchCriteriaInputModel productivityDashboardModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@DeadLineDateFrom", productivityDashboardModel.DeadLineDateFrom);
                    vParams.Add("@DeadLineDateTo", productivityDashboardModel.DeadLineDateTo);
                    vParams.Add("@OwnerUserId", productivityDashboardModel.OwnerUserId);
                    vParams.Add("@UserStoryStatusId",productivityDashboardModel.UserStoryStatusId);
                    vParams.Add("@SortDirection", productivityDashboardModel.SortDirection);
                    vParams.Add("@SearchText", productivityDashboardModel.SearchText);
                    vParams.Add("@SortBy", productivityDashboardModel.SortBy);
                    vParams.Add("@PageNumber", productivityDashboardModel.PageNumber);
                    vParams.Add("@PageSize", productivityDashboardModel.PageSize);
                    vParams.Add("@EntityId", productivityDashboardModel.EntityId);
                    vParams.Add("@ProjectId", productivityDashboardModel.ProjectId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmployeeUserStoriesApiReturnModel>(StoredProcedureConstants.SpEmployeeUserStoryReport, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeUserStories", "ProductivityDashboardRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeUserStories);
                return new List<EmployeeUserStoriesApiReturnModel>();
            }
        }

        public List<EntityDropDownOutputModel> GetEntityDropDown(string searchText,bool isEmployeeList, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SearchText", searchText);
                    vParams.Add("@IsEmployeeList", isEmployeeList);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EntityDropDownOutputModel>(StoredProcedureConstants.SpEntityDropDown, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEntityDropDown", "ProductivityDashboardRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeUserStories);
                return null;
            }
        }
        public List<UserHistoricalWorkReportSearchSpOutputModel> GetProductivityIndexUserStoriesForDevelopers(ProductivityDashboardSearchCriteriaInputModel productivityDashboardModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Type", productivityDashboardModel.Type);
                    vParams.Add("@Date", productivityDashboardModel.SelectedDate);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@UserId", productivityDashboardModel.OwnerUserId);
                    vParams.Add("@IndexType", productivityDashboardModel.IndexType);
                    vParams.Add("@IsAll", productivityDashboardModel.IsAll);
                    vParams.Add("@IsReportingOnly", productivityDashboardModel.IsReportingOnly);
                    vParams.Add("@IsMyself", productivityDashboardModel.IsMyself);
                    vParams.Add("@ProjectId", productivityDashboardModel.ProjectId);
                    return vConn.Query<UserHistoricalWorkReportSearchSpOutputModel>(StoredProcedureConstants.SpGetEmployeeIndexUserStoriesForDevelopers, vParams, commandType: CommandType.StoredProcedure)
                      .ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetProductivityIndexUserStoriesForDevelopers", "ProductivityDashboardRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetProductivityIndexUserstoriesForDevelopers);
                return new List<UserHistoricalWorkReportSearchSpOutputModel>();
            }
        }
    }
}
