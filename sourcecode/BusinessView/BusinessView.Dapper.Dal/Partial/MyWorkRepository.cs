using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.MyWork;
using BTrak.Common;
using Dapper;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Dynamic;
using System.Linq;

namespace Btrak.Dapper.Dal.Partial
{
    public class MyWorkRepository : BaseRepository
    {
        public List<GetMyProjectWorkOutputModel> GetMyProjectsWork(MyProjectWorkModel myProjectWorkModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserStoryId", myProjectWorkModel.UserStoryId);
                    vParams.Add("@ProjectId", myProjectWorkModel.ProjectId);
                    vParams.Add("@ProjectName", myProjectWorkModel.ProjectName);
                    vParams.Add("@GoalId", myProjectWorkModel.GoalId);
                    vParams.Add("@UserStoryName", myProjectWorkModel.UserStoryName);
                    vParams.Add("@EstimatedTime", myProjectWorkModel.EstimatedTime);
                    vParams.Add("@DeadLineDate", myProjectWorkModel.DeadLineDate);
                    vParams.Add("@OwnerUserId", myProjectWorkModel.OwnerUserId);
                    vParams.Add("@DependencyUserId", myProjectWorkModel.DependencyUserId);
                    vParams.Add("@Order", myProjectWorkModel.Order);
                    vParams.Add("@UserStoryStatusId", myProjectWorkModel.UserStoryStatusId);
                    vParams.Add("@ActualDeadLineDate", myProjectWorkModel.ActualDeadLineDate);
                    vParams.Add("@BugPriorityIdsXml", myProjectWorkModel.BugPriorityIdsXml);
                    vParams.Add("@UserStoryTypeId", myProjectWorkModel.UserStoryTypeId);
                    vParams.Add("@ProjectFeatureId", myProjectWorkModel.ProjectFeatureId);
                    vParams.Add("@IsParked", myProjectWorkModel.IsUserStoryParked);
                    vParams.Add("@IsArchived", myProjectWorkModel.IsUserStoryArchived);
                    vParams.Add("@SearchText", myProjectWorkModel.SearchText);
                    vParams.Add("@SortBy", myProjectWorkModel.SortBy);
                    vParams.Add("@SortDirection", myProjectWorkModel.SortDirection);
                    vParams.Add("@PageSize", myProjectWorkModel.PageSize);
                    vParams.Add("@PageNumber", myProjectWorkModel.PageNumber);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@DependencyText", myProjectWorkModel.DependencyText);
                    vParams.Add("@DeadLineDateFrom", myProjectWorkModel.DeadLineDateFrom);
                    vParams.Add("@DeadLineDateTo", myProjectWorkModel.DeadLineDateTo);
                    vParams.Add("@UserStoryUniqueName", myProjectWorkModel.UserStoryUniqueName);
                    vParams.Add("@IncludeArchived", myProjectWorkModel.IncludeArchive);
                    vParams.Add("@IncludeParked", myProjectWorkModel.IncludePark);
                    vParams.Add("@IsStatusMultiselect", myProjectWorkModel.IsStatusMultiSelect);
                    vParams.Add("@UserStoryStatusIdsXml", myProjectWorkModel.UserStoryStatusIdsXml);
                    vParams.Add("@IsMyWorkOnly", myProjectWorkModel.IsMyWorkOnly);
                    vParams.Add("@TeamMemberIdsXml", myProjectWorkModel.TeamMemberIdsXml);
                    vParams.Add("@OwnerUserIdsXml", myProjectWorkModel.OwnerUserIdsXml);
                    vParams.Add("@IsActiveGoalsOnly", myProjectWorkModel.IsActiveGoalsOnly);
                    vParams.Add("@IsForUserStoryoverview", myProjectWorkModel.IsForUserStoryoverview);
                    vParams.Add("@IsFromAdoc", myProjectWorkModel.IsFromAdoc);
                    vParams.Add("@UserStoryIdsXml", myProjectWorkModel.UserStoryIdsXml);
                    vParams.Add("@ParentUserStoryId", myProjectWorkModel.ParentUserStoryId);
                    vParams.Add("@GoalStatusId", myProjectWorkModel.GoalStatusId);
                    return vConn.Query<GetMyProjectWorkOutputModel>(StoredProcedureConstants.SpSearchUserStories, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetMyProjectsWork", "MyWorkRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetMyProjectsWork);
                return new List<GetMyProjectWorkOutputModel>();
            }
        }

        public List<MyWorkOverViewOutputModel> GetMyWorkOverViewDetails(MyWorkOverViewInputModel myWorkOverViewInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TeamMemberId", myWorkOverViewInputModel.TeamMembersXml);
                    vParams.Add("@UserStoryStatusId", myWorkOverViewInputModel.UserStoryStatusId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<MyWorkOverViewOutputModel>(StoredProcedureConstants.SpGetMyWorkOverViewDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetMyWorkOverViewDetails", "MyWorkRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetMyWorkOverViewDetails);
                return new List<MyWorkOverViewOutputModel>();
            }
        }

        public List<UserHistoricalWorkReportSearchSpOutputModel> GetUserHistoricalWorkReport(UserHistoricalWorkReportSearchInputModel userHistoricalSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@UserId", userHistoricalSearchInputModel.UserId);
                    vParams.Add("@DateTo", userHistoricalSearchInputModel.DateTo);
                    vParams.Add("@DateFrom", userHistoricalSearchInputModel.DateFrom);
                    vParams.Add("@CreateDateFrom", userHistoricalSearchInputModel.CreateDateFrom);
                    vParams.Add("@CreateDateTo", userHistoricalSearchInputModel.CreateDateTo);
                    vParams.Add("@SearchText", userHistoricalSearchInputModel.SearchText);
                    vParams.Add("@PageNumber", userHistoricalSearchInputModel.PageNumber);
                    vParams.Add("@PageSize", userHistoricalSearchInputModel.PageSize);
                    vParams.Add("@SortBy", userHistoricalSearchInputModel.SortBy);
                    vParams.Add("@SortDirection", userHistoricalSearchInputModel.SortDirection);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@LineManagerId", userHistoricalSearchInputModel.LineManagerId);
                    vParams.Add("@BoardTypeId", userHistoricalSearchInputModel.BoardTypeId);
                    vParams.Add("@ProjectId", userHistoricalSearchInputModel.ProjectId);
                    vParams.Add("@NoOfReplansMin", userHistoricalSearchInputModel.NoOfReplansMin);
                    vParams.Add("@NoOfReplansMax", userHistoricalSearchInputModel.NoOfReplansMax);
                    vParams.Add("@IsTableView", userHistoricalSearchInputModel.IsTableView);
                    vParams.Add("@IsProject", userHistoricalSearchInputModel.IsProject);

                    return vConn.Query<UserHistoricalWorkReportSearchSpOutputModel>(StoredProcedureConstants.SpGetUserHistoricalWorkReport, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserHistoricalWorkReport", "MyWorkRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetUserHistoricalWorkReport);
                return new List<UserHistoricalWorkReportSearchSpOutputModel>();
            }
        }
        public List<UserHistoricalWorkReportSearchSpOutputModel> GetUserHistoricalCompletedWorkReport(UserHistoricalWorkReportSearchInputModel userHistoricalSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@UserId", userHistoricalSearchInputModel.UserId);
                    vParams.Add("@DateTo", userHistoricalSearchInputModel.DateTo);
                    vParams.Add("@DateFrom", userHistoricalSearchInputModel.DateFrom);
                    vParams.Add("@CreateDateFrom", userHistoricalSearchInputModel.CreateDateFrom);
                    vParams.Add("@CreateDateTo", userHistoricalSearchInputModel.CreateDateTo);
                    vParams.Add("@SearchText", userHistoricalSearchInputModel.SearchText);
                    vParams.Add("@PageNumber", userHistoricalSearchInputModel.PageNumber);
                    vParams.Add("@PageSize", userHistoricalSearchInputModel.PageSize);
                    vParams.Add("@SortBy", userHistoricalSearchInputModel.SortBy);
                    vParams.Add("@SortDirection", userHistoricalSearchInputModel.SortDirection);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@LineManagerId", userHistoricalSearchInputModel.LineManagerId);
                    vParams.Add("@BoardTypeId", userHistoricalSearchInputModel.BoardTypeId);
                    vParams.Add("@ProjectId", userHistoricalSearchInputModel.ProjectId);
                    vParams.Add("@NoOfReplansMin", userHistoricalSearchInputModel.NoOfReplansMin);
                    vParams.Add("@NoOfReplansMax", userHistoricalSearchInputModel.NoOfReplansMax);
                    vParams.Add("@IsTableView", userHistoricalSearchInputModel.IsTableView);
                    vParams.Add("@IsProject", userHistoricalSearchInputModel.IsProject);

                    return vConn.Query<UserHistoricalWorkReportSearchSpOutputModel>(StoredProcedureConstants.SpGetUserHistoricalCompletedWorkReport, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserHistoricalCompletedWorkReport", "MyWorkRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetUserHistoricalWorkReport);
                return new List<UserHistoricalWorkReportSearchSpOutputModel>();
            }
        }

        public List<EmployeeWorkLogReportOutputmodel> GetEmployeeWorkLogReport(EmployeeWorkLogReportInputModel employeeWorkLogReportInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@UserId", employeeWorkLogReportInputModel.UserId);
                    vParams.Add("@ProjectId", employeeWorkLogReportInputModel.ProjectId);
                    vParams.Add("@GoalId", employeeWorkLogReportInputModel.GoalId);
                    vParams.Add("@DateTo", employeeWorkLogReportInputModel.DateTo);
                    vParams.Add("@DateFrom", employeeWorkLogReportInputModel.DateFrom);
                    vParams.Add("@TimeZone", employeeWorkLogReportInputModel.TimeZone);
                    vParams.Add("@PageNumber", employeeWorkLogReportInputModel.PageNumber);
                    vParams.Add("@PageSize", employeeWorkLogReportInputModel.PageSize);
                    vParams.Add("@SortBy", employeeWorkLogReportInputModel.SortBy);
                    vParams.Add("@SortDirection", employeeWorkLogReportInputModel.SortDirection);
                    vParams.Add("@LineManagerId", employeeWorkLogReportInputModel.LineManagerId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmployeeWorkLogReportOutputmodel>(StoredProcedureConstants.SpGetEmployeeWorkLogReport, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeWorkLogReport", "MyWorkRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeWorkLogReport);
                return new List<EmployeeWorkLogReportOutputmodel>();
            }
        }

        public List<EmployeeYearlyProductivityReportOutputModel> GetEmployeeYearlyProductivityReport(GetEmployeeYearlyProductivityReportInputModel getEmployeeYearlyProductivityReportInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@UserId", getEmployeeYearlyProductivityReportInputModel.UserId);
                    vParams.Add("@ProjectId", getEmployeeYearlyProductivityReportInputModel.ProjectId);
                    vParams.Add("@Date", getEmployeeYearlyProductivityReportInputModel.Date);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmployeeYearlyProductivityReportOutputModel>(StoredProcedureConstants.SpGetYearlyProductivityReport, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeYearlyProductivityReport", "MyWorkRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeYearlyProductivityReport);
                return new List<EmployeeYearlyProductivityReportOutputModel>();
            }
        }

        public List<GetGoalBurnDownChartOutputModel> GetGoalBurnDownChart(GetGoalBurnDownChartInputModel getGoalBurnDownChartInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@UserId", getGoalBurnDownChartInputModel.UserId);
                    vParams.Add("@DateTo", getGoalBurnDownChartInputModel.DateTo);
                    vParams.Add("@DateFrom", getGoalBurnDownChartInputModel.DateFrom);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    if(getGoalBurnDownChartInputModel.IsFromSprint == true)
                    {
                        vParams.Add("@SprintId", getGoalBurnDownChartInputModel.SprintId);
                        vParams.Add("@UserStoryPoints", getGoalBurnDownChartInputModel.UserStoryPoints);
                        vParams.Add("@IsApplyFilters", getGoalBurnDownChartInputModel.IsApplyFilters);
                        return vConn.Query<GetGoalBurnDownChartOutputModel>(StoredProcedureConstants.SpGetSprintBurnDownChart, vParams, commandType: CommandType.StoredProcedure).ToList();
                    } else
                    {
                        vParams.Add("@GoalId", getGoalBurnDownChartInputModel.GoalId);
                        return vConn.Query<GetGoalBurnDownChartOutputModel>(StoredProcedureConstants.SpGetGoalBurnDownChart, vParams, commandType: CommandType.StoredProcedure).ToList();
                    }
                    
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetGoalBurnDownChart", "MyWorkRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetGoalBurnDownChart);
                return new List<GetGoalBurnDownChartOutputModel>();
            }
        }

        public List<GetMyWorkOutputModel> GetMyWork(MyWorkInputModel myWorkInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@IsMyWorkOnly", myWorkInputModel.IsMyWorkOnly);
                    vParams.Add("@IsArchived", myWorkInputModel.IsUserStoryArchived);
                    vParams.Add("@IsParked", myWorkInputModel.IsUserStoryParked);
                    vParams.Add("@ProjectId", myWorkInputModel.ProjectId);
                    vParams.Add("@IsStatusMultiselect", myWorkInputModel.IsStatusMultiselect);
                    vParams.Add("@UserStoryStatusIdsXml", myWorkInputModel.UserStoryStatusIdsXml);
                    vParams.Add("@TeamMemberIdsXml", myWorkInputModel.TeamMemberIdsXml);
       
                    vParams.Add("@TeamMemberIdsXML", myWorkInputModel.TeamMembersXml);
                    vParams.Add("@UserStoryId", myWorkInputModel.UserStoryId);
                    vParams.Add("@IsIncludeCompletedUserStories", myWorkInputModel.IsIncludeCompletedUserStories);
                    vParams.Add("@IsParked", myWorkInputModel.IsParked);

                    vParams.Add("@StatusReportId", myWorkInputModel.Id);
                    vParams.Add("@StatusReportingConfigurationOptionId", myWorkInputModel.StatusReportingConfigurationOptionId);
                    vParams.Add("@Description", myWorkInputModel.Description);
                    vParams.Add("@FilePath", myWorkInputModel.FilePath);
                    vParams.Add("@FileName", myWorkInputModel.FileName);
                    vParams.Add("@CreatedOn", myWorkInputModel.CreatedOn);
                    vParams.Add("@UserIds", myWorkInputModel.AssignedTo);
                    vParams.Add("@IsUnread", myWorkInputModel.IsUnread);

                    vParams.Add("@SearchText", myWorkInputModel.SearchText);
                    vParams.Add("@SearchText", myWorkInputModel.IsArchived);
                    vParams.Add("@PageSize", myWorkInputModel.PageSize);
                    vParams.Add("@PageNumber", myWorkInputModel.PageNumber);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<GetMyWorkOutputModel>(StoredProcedureConstants.SpGetMyWork, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetMyWork", "MyWorkRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetMyWork);
                return new List<GetMyWorkOutputModel>();
            }
        }

        public IEnumerable<dynamic> GetEmployeeLogTimeDetailsReport(EmployeeLogTimeDetailSearchInputModel employeeLogTimeDetailSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@UserId", employeeLogTimeDetailSearchInputModel.UserId);
                    vParams.Add("@DateTo", employeeLogTimeDetailSearchInputModel.DateTo);
                    vParams.Add("@DateFrom", employeeLogTimeDetailSearchInputModel.DateFrom);
                    vParams.Add("@PageNumber", employeeLogTimeDetailSearchInputModel.PageNumber);
                    vParams.Add("@PageSize", employeeLogTimeDetailSearchInputModel.PageSize);
                    vParams.Add("@SortBy", employeeLogTimeDetailSearchInputModel.SortBy);
                    vParams.Add("@SortDirection", employeeLogTimeDetailSearchInputModel.SortDirection);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@ProjectId", employeeLogTimeDetailSearchInputModel.ProjectId);
                    vParams.Add("@BoardTypeId", employeeLogTimeDetailSearchInputModel.BoardTypeId);
                    vParams.Add("@ShowComments", employeeLogTimeDetailSearchInputModel.ShowComments);

                    return vConn.Query<dynamic>(StoredProcedureConstants.SpGetEmployeeLogTimeDetailsReport, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeLogTimeDetailsReport", "MyWorkRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetUserHistoricalWorkReport);
                return new List<ExpandoObject>();
            }
        }

        public IEnumerable<dynamic> GetUsersSpentTimeDetailsReport(EmployeeLogTimeDetailSearchInputModel employeeLogTimeDetailSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@LineManagerId", employeeLogTimeDetailSearchInputModel.LineManagerId);
                    vParams.Add("@ProjectId", employeeLogTimeDetailSearchInputModel.ProjectId);
                    vParams.Add("@DateTo", employeeLogTimeDetailSearchInputModel.DateTo);
                    vParams.Add("@DateFrom", employeeLogTimeDetailSearchInputModel.DateFrom);
                    vParams.Add("@PageNumber", employeeLogTimeDetailSearchInputModel.PageNumber);
                    vParams.Add("@PageSize", employeeLogTimeDetailSearchInputModel.PageSize);
                    vParams.Add("@SortBy", employeeLogTimeDetailSearchInputModel.SortBy);
                    vParams.Add("@TimeZone", employeeLogTimeDetailSearchInputModel.TimeZone);
                    vParams.Add("@SortDirection", employeeLogTimeDetailSearchInputModel.SortDirection);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);

                    return vConn.Query<dynamic>(StoredProcedureConstants.SpGetUsersSpentTimedetailsReport, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUsersSpentTimeDetailsReport", "MyWorkRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetUserHistoricalWorkReport);
                return new List<ExpandoObject>();
            }
        }
        
        public List<WorkItemsDetailsSearchOutPutModel> GetWorkItemsDetailsReport(UserHistoricalWorkReportSearchInputModel userHistoricalSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@UserId", userHistoricalSearchInputModel.UserId);
                    vParams.Add("@SearchText", userHistoricalSearchInputModel.SearchText);
                    vParams.Add("@PageNumber", userHistoricalSearchInputModel.PageNumber);
                    vParams.Add("@PageSize", userHistoricalSearchInputModel.PageSize);
                    vParams.Add("@SortBy", userHistoricalSearchInputModel.SortBy);
                    vParams.Add("@SortDirection", userHistoricalSearchInputModel.SortDirection);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@BoardTypeId", userHistoricalSearchInputModel.BoardTypeId);
                    vParams.Add("@ProjectId", userHistoricalSearchInputModel.ProjectId);
                    vParams.Add("@NoOfReplansMin", userHistoricalSearchInputModel.NoOfReplansMin);
                    vParams.Add("@NoOfReplansMax", userHistoricalSearchInputModel.NoOfReplansMax);
                    vParams.Add("@UserStorySearchText", userHistoricalSearchInputModel.UserStorySearchText);
                    vParams.Add("@GoalSearchText", userHistoricalSearchInputModel.GoalSearchText);
                    vParams.Add("@VerifiedOn", userHistoricalSearchInputModel.VerifiedOn);
                    vParams.Add("@VerifiedBy", userHistoricalSearchInputModel.VerifiedBy);
                    vParams.Add("@IsGoalDealyed", userHistoricalSearchInputModel.IsGoalDealyed);
                    vParams.Add("@IsUserStoryDealyed", userHistoricalSearchInputModel.IsUserStoryDealyed);
                    vParams.Add("@UserStoryTypeId", userHistoricalSearchInputModel.UserStoryTypeId);
                    vParams.Add("@UserStoryPriorityId", userHistoricalSearchInputModel.UserStoryPriorityId);
                    vParams.Add("@BranchId", userHistoricalSearchInputModel.BranchId);

                    return vConn.Query<WorkItemsDetailsSearchOutPutModel>(StoredProcedureConstants.SpGetWorkItemsDetailsReport, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetWorkItemsDetailsReport", "MyWorkRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetUserHistoricalWorkReport);
                return new List<WorkItemsDetailsSearchOutPutModel>();
            }
        }
    }
}
