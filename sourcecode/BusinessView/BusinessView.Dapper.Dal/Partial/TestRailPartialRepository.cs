using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Dapper.Dal.SpModels;
using Btrak.Models;
using Btrak.Models.TestRail;
using BTrak.Common;
using Dapper;

namespace Btrak.Dapper.Dal.Partial
{
    public class TestRailPartialRepository : BaseRepository
    {
        public Guid? UpsertMilestone(MilestoneInputModel milestoneInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@MilestoneId", milestoneInputModel.MilestoneId);
                    vParams.Add("@ProjectId", milestoneInputModel.ProjectId);
                    vParams.Add("@Title", milestoneInputModel.MilestoneTitle);
                    vParams.Add("@ParentMilestoneId", milestoneInputModel.ParentMileStoneId);
                    vParams.Add("@Description", milestoneInputModel.Description);
                    vParams.Add("@StartDate", milestoneInputModel.StartDate);
                    vParams.Add("@EndDate", milestoneInputModel.EndDate);
                    vParams.Add("@IsCompleted", milestoneInputModel.IsCompleted);
                    vParams.Add("@IsStarted", milestoneInputModel.IsStarted);
                    vParams.Add("@IsArchived", milestoneInputModel.IsArchived);
                    vParams.Add("@TimeStamp", milestoneInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertMilestone, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertMilestone", "TestRailPartialRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionMilestoneCouldNotBeCreated);

                return null;
            }
        }

        public List<MilestoneApiReturnModel> SearchMilestones(MilestoneSearchCriteriaInputModel milestoneSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@MilestoneId", milestoneSearchCriteriaInputModel.MilestoneId);
                    vParams.Add("@Title", milestoneSearchCriteriaInputModel.SearchText);
                    vParams.Add("@Description", milestoneSearchCriteriaInputModel.Description);
                    vParams.Add("@ProjectId", milestoneSearchCriteriaInputModel.ProjectId);
                    vParams.Add("@ParentMilestoneId", milestoneSearchCriteriaInputModel.ParentMileStoneId);
                    vParams.Add("@StartDate", milestoneSearchCriteriaInputModel.StartDate);
                    vParams.Add("@EndDate", milestoneSearchCriteriaInputModel.EndDate);
                    vParams.Add("@IsCompleted", milestoneSearchCriteriaInputModel.IsCompleted);
                    vParams.Add("@IsForDropdown", milestoneSearchCriteriaInputModel.IsForDropdown);
                    vParams.Add("@IsArchived", milestoneSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@IsStarted", milestoneSearchCriteriaInputModel.IsStarted);
                    vParams.Add("@IsArchived", milestoneSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@DateFrom", milestoneSearchCriteriaInputModel.DateFrom);
                    vParams.Add("@DateTo", milestoneSearchCriteriaInputModel.DateTo);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<MilestoneApiReturnModel>(StoredProcedureConstants.SpSearchMilestones, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchMilestones", "TestRailPartialRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchMilestones);

                return new List<MilestoneApiReturnModel>();
            }
        }

        public List<DropdownModel> GetMilestoneDropdownList(MilestoneSearchCriteriaInputModel milestoneSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@MilestoneId", milestoneSearchCriteriaInputModel.MilestoneId);
                    vParams.Add("@Title", milestoneSearchCriteriaInputModel.SearchText);
                    vParams.Add("@Description", milestoneSearchCriteriaInputModel.Description);
                    vParams.Add("@ProjectId", milestoneSearchCriteriaInputModel.ProjectId);
                    vParams.Add("@ParentMilestoneId", milestoneSearchCriteriaInputModel.ParentMileStoneId);
                    vParams.Add("@StartDate", milestoneSearchCriteriaInputModel.StartDate);
                    vParams.Add("@EndDate", milestoneSearchCriteriaInputModel.EndDate);
                    vParams.Add("@IsCompleted", milestoneSearchCriteriaInputModel.IsCompleted);
                    vParams.Add("@IsForDropdown", milestoneSearchCriteriaInputModel.IsForDropdown);
                    vParams.Add("@IsArchived", milestoneSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@IsStarted", milestoneSearchCriteriaInputModel.IsStarted);
                    vParams.Add("@IsArchived", milestoneSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@DateFrom", milestoneSearchCriteriaInputModel.DateFrom);
                    vParams.Add("@DateTo", milestoneSearchCriteriaInputModel.DateTo);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<DropdownModel>(StoredProcedureConstants.SpSearchMilestones, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetMilestoneDropdownList", "TestRailPartialRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchMilestones);

                return new List<DropdownModel>();
            }
        }

        public ReportModel GetMilestoneReport(Guid milestoneId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@MilestoneId", milestoneId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ReportModel>(StoredProcedureConstants.SpGetMilestoneReportById, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetMilestoneReport", "TestRailPartialRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetMilestoneReport);

                return null;
            }
        }

        public List<TestRailHistoryModel> GetUserStoryScenarioHistory(TestCaseHistoryInputModel testCaseHistoryInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@UserStoryId", testCaseHistoryInputModel.UserStoryId);
                    vParams.Add("@TestCaseId", testCaseHistoryInputModel.TestCaseId);
                    vParams.Add("@TestRunId", testCaseHistoryInputModel.TestRunId);
                    vParams.Add("@ReportId", testCaseHistoryInputModel.ReportId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<TestRailHistoryModel>(StoredProcedureConstants.SpGetUserStoryScenarioHistory, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserStoryScenarioHistory", "TestRailPartialRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUserStoryHistory);

                return null;
            }
        }

        public Guid? InsertTestCaseHistory(TestCaseHistoryMiniModel testCaseHistoryMiniModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestCaseId", testCaseHistoryMiniModel.TestCaseId);
                    vParams.Add("@TestRunId", testCaseHistoryMiniModel.TestRunId);
                    vParams.Add("@FieldName", testCaseHistoryMiniModel.FieldName);
                    vParams.Add("@ConfigurationId", testCaseHistoryMiniModel.ConfigurationId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpInsertTestCaseHistory, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertTestCaseHistory", "TestRailPartialRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionInsertTestCaseHistory);

                return null;
            }
        }

        public Guid? UpsertTestRun(TestRunInputModel testRunInputModel, LoggedInContext loggedInContext, string selectedCasesXml, string selectedSectionsXml, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestRunId", testRunInputModel.TestRunId);
                    vParams.Add("@ProjectId", testRunInputModel.ProjectId);
                    vParams.Add("@IsFromUpload", testRunInputModel.IsFromUpload);
                    vParams.Add("@TestSuiteId", testRunInputModel.TestSuiteId);
                    vParams.Add("@Name", testRunInputModel.TestRunName);
                    vParams.Add("@MilestoneId", testRunInputModel.MilestoneId);
                    vParams.Add("@AssignToId", testRunInputModel.AssignToId);
                    vParams.Add("@Description", testRunInputModel.Description);
                    vParams.Add("@IsIncludeAllCases", testRunInputModel.IsIncludeAllCases);
                    vParams.Add("@SelectedCasesXml", selectedCasesXml);
                    vParams.Add("@SelectedSectionsXml", selectedSectionsXml);
                    vParams.Add("@IsArchived", testRunInputModel.IsArchived);
                    vParams.Add("@IsCompleted", testRunInputModel.IsCompleted);
                    vParams.Add("@TimeStamp", testRunInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertTestRun, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTestRun", "TestRailPartialRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertTestRun);
                
                return null;
            }
        }

        public Guid? DeleteTestRun(TestRunInputModel testRunInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestRunId", testRunInputModel.TestRunId);
                    vParams.Add("@TimeStamp", testRunInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpDeleteTestRun, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteTestRun", "TestRailPartialRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionDeleteTestRun);

                return null;
            }
        }

        public List<TestRunApiReturnModel> SearchTestRuns(TestRunSearchCriteriaInputModel testRunSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestRunId", testRunSearchCriteriaInputModel.TestRunId);
                    vParams.Add("@ProjectId", testRunSearchCriteriaInputModel.ProjectId);
                    vParams.Add("@TestSuiteId", testRunSearchCriteriaInputModel.TestSuiteId);
                    vParams.Add("@Name", testRunSearchCriteriaInputModel.TestRunName);
                    vParams.Add("@MilestoneId", testRunSearchCriteriaInputModel.MilestoneId);
                    vParams.Add("@AssignToId", testRunSearchCriteriaInputModel.AssignToId);
                    vParams.Add("@Description", testRunSearchCriteriaInputModel.Description);
                    vParams.Add("@IsIncludeAllCases", testRunSearchCriteriaInputModel.IsIncludeAllCases);
                    vParams.Add("@IsArchived", testRunSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@IsCompleted", testRunSearchCriteriaInputModel.IsCompleted);
                    vParams.Add("@DateFrom", testRunSearchCriteriaInputModel.DateFrom);
                    vParams.Add("@DateTo", testRunSearchCriteriaInputModel.DateTo);
                    vParams.Add("@SortBy", testRunSearchCriteriaInputModel.SortBy);
                    vParams.Add("@SortDirection", testRunSearchCriteriaInputModel.SortDirection);
                    vParams.Add("@SearchText", testRunSearchCriteriaInputModel.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@TestrunIdsXml", testRunSearchCriteriaInputModel.TestrunIdsXml);
                    return vConn.Query<TestRunApiReturnModel>(StoredProcedureConstants.SpSearchTestRuns, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchTestRuns", "TestRailPartialRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchTestRuns);
                
                return new List<TestRunApiReturnModel>();
            }
        }

        public IList<ProjectMemberSpEntity> GetProjectMemberDropdown(Guid projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@ProjectId", projectId);
                    vParams.Add("@PageSize", 1000);
                    vParams.Add("@IsArchived", false);
                    //vParams.Add("@FeatureId", AppCommandConstants.ViewTestRailCommandGuid);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ProjectMemberSpEntity>(StoredProcedureConstants.SpGetProjectMembers, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetProjectMemberDropdown", "TestRailPartialRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetProjectMemberDropdown);

                return new List<ProjectMemberSpEntity>();
            }
        }

        public Guid? UpsertTestPlan(TestPlanInputModel testPlanInputModel, LoggedInContext loggedInContext, string testSuiteIdsXml, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestPlanId", testPlanInputModel.TestPlanId);
                    vParams.Add("@ProjectId", testPlanInputModel.ProjectId);
                    vParams.Add("@Name", testPlanInputModel.TestPlanName);
                    vParams.Add("@MilestoneId", testPlanInputModel.MilestoneId);
                    vParams.Add("@Description", testPlanInputModel.Description);
                    vParams.Add("@IsArchived", testPlanInputModel.IsArchived);
                    vParams.Add("@IsCompleted", testPlanInputModel.IsCompleted);
                    vParams.Add("@TestSuiteIdsXml", testSuiteIdsXml);
                    vParams.Add("@TimeStamp", testPlanInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertTestPlan, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTestPlan", "TestRailPartialRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertTestPlan);
                
                return null;
            }
        }

        public List<TestPlanApiReturnModel> SearchTestPlans(TestPlanSearchCriteriaInputModel testPlanSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestPlanId", testPlanSearchCriteriaInputModel.TestPlanId);
                    vParams.Add("@ProjectId", testPlanSearchCriteriaInputModel.ProjectId);
                    vParams.Add("@Name", testPlanSearchCriteriaInputModel.TestPlanName);
                    vParams.Add("@MilestoneId", testPlanSearchCriteriaInputModel.MilestoneId);
                    vParams.Add("@Description", testPlanSearchCriteriaInputModel.Description);
                    vParams.Add("@IsArchived", testPlanSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@IsCompleted", testPlanSearchCriteriaInputModel.IsCompleted);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<TestPlanApiReturnModel>(StoredProcedureConstants.SpSearchTestPlans, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchTestPlans", "TestRailPartialRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchTestPlans);
                
                return new List<TestPlanApiReturnModel>();
            }
        }

        public List<TestRunAndPlansOverviewModel> GetTestRunsAndTestPlans(Guid projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@ProjectId", projectId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<TestRunAndPlansOverviewModel>(StoredProcedureConstants.SpGetTestRunsAndTestPlans, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTestRunsAndTestPlans", "TestRailPartialRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetTestRunsAndTestPlans);

                return new List<TestRunAndPlansOverviewModel>();
            }
        }

        public ReportModel GetTestRunReport(Guid? testRunId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestRunId", testRunId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ReportModel>(StoredProcedureConstants.SpGetTestRunReportById, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTestRunReport", "TestRailPartialRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetTestRunReport);
                
                return null;
            }
        }

        public ReportModel GetTestPlanReport(Guid? testPlanId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestPlanId", testPlanId);
                    //vParams.Add("@FeatureId", AppCommandConstants.ViewTestRailCommandGuid);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ReportModel>(StoredProcedureConstants.SpGetTestPlanReportById, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTestPlanReport", "TestRailPartialRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetTestPlanReport);
                
                return null;
            }
        }

        public Guid? UpdateTestCaseStatus(TestCaseStatusInputModel testCaseStatusInputModel, LoggedInContext loggedInContext, string stepStatusXml, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestCaseId", testCaseStatusInputModel.TestCaseId);
                    vParams.Add("@TestRunId", testCaseStatusInputModel.TestRunId);
                    vParams.Add("@StatusId", testCaseStatusInputModel.StatusId);
                    vParams.Add("@StatusComment", testCaseStatusInputModel.StatusComment);
                    vParams.Add("@AssignToId", testCaseStatusInputModel.AssignToId);
                    vParams.Add("@AssignToComment", testCaseStatusInputModel.AssignToComment);
                    vParams.Add("@Version", testCaseStatusInputModel.Version);
                    vParams.Add("@Elapsed", testCaseStatusInputModel.Elapsed);
                    vParams.Add("@StepStatusXml", stepStatusXml);
                    vParams.Add("@TimeStamp", testCaseStatusInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpTestCaseStatusUpdate, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateTestCaseStatus", "TestRailPartialRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpdateTestCaseStatus);

                return null;
            }
        }

        public Guid? UpsertUserStoryScenario(TestCaseStatusInputModel testCaseStatusInputModel, LoggedInContext loggedInContext, string stepStatusXml, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestCaseId", testCaseStatusInputModel.TestCaseId);
                    vParams.Add("@UserStoryId", testCaseStatusInputModel.UserStoryId);
                    vParams.Add("@StatusId", testCaseStatusInputModel.StatusId);
                    vParams.Add("@StepStatusXml", stepStatusXml);
                    vParams.Add("@IsArchived", testCaseStatusInputModel.IsArchived);
                    vParams.Add("@TimeZone", testCaseStatusInputModel.TimeZone);
                    vParams.Add("@TimeStamp", testCaseStatusInputModel.UserStoryScenarioTimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertUserStoryScenario, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertUserStoryScenario", "TestRailPartialRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpdateTestCaseStatus);

                return null;
            }
        }

        public List<Guid> UpdateTestRunResultForMultipleTestCases(string testCaseIdsXml, TestCaseAssignInputModel testCaseAssignInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestCaseIdsXml", testCaseIdsXml);
                    vParams.Add("@AssignToId", testCaseAssignInputModel.AssignToId);
                    vParams.Add("@StatusId", testCaseAssignInputModel.StatusId);
                    vParams.Add("@StatusComment", testCaseAssignInputModel.StatusComment);
                    vParams.Add("@TestRunId", testCaseAssignInputModel.TestRunId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid>(StoredProcedureConstants.SpUpdateAssignForMultipleTestCases, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateTestRunResultForMultipleTestCases", "TestRailPartialRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetTestRailConfigurations);
                
                return new List<Guid>();
            }
        }

        public List<TestTeamStatusReportingRetunrModel> GetTestTeamStatusReporting(TestTeamStatusReportingInputModel testTeamStatusReportingInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@UserId", testTeamStatusReportingInputModel.UserId);
                    vParams.Add("@ProjectId", testTeamStatusReportingInputModel.ProjectId);
                    vParams.Add("@DateFrom", testTeamStatusReportingInputModel.DateFrom);
                    vParams.Add("@DateTo", testTeamStatusReportingInputModel.DateTo);                  
                    vParams.Add("@CreatedOn", testTeamStatusReportingInputModel.CreatedOn);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<TestTeamStatusReportingRetunrModel>(StoredProcedureConstants.SpGetTestTeamStatusReporing, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTestTeamStatusReporting", "TestRailPartialRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetTestTeamStatusReporting);

                return new List<TestTeamStatusReportingRetunrModel>();
            }
        }


        public void InsertTestRailHistory(TestRailHistoryModel testRailHistoryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestCaseId", testRailHistoryModel.TestCaseId);
                    vParams.Add("@StepId", testRailHistoryModel.StepId);
                    vParams.Add("@TestRunId", testRailHistoryModel.TestRunId);
                    vParams.Add("@OldValue", testRailHistoryModel.OldValue);
                    vParams.Add("@NewValue", testRailHistoryModel.NewValue);
                    vParams.Add("@FieldName", testRailHistoryModel.FieldName);
                    vParams.Add("@Description", testRailHistoryModel.Description);
                    vParams.Add("@CreatedDateTime", testRailHistoryModel.CreatedDateTime);
                    vParams.Add("@FilePath", testRailHistoryModel.FilePath);
                    vParams.Add("@IsFromUpload", testRailHistoryModel.IsFromUpload);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vConn.Query(StoredProcedureConstants.SpInsertTestCaseHistory, vParams, commandType: CommandType.StoredProcedure);
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertTestRailHistory", "TestRailPartialRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpdateMultipleTestCases);
            }
        }

        public ReportModel GetProjectOverviewReport(Guid projectId, int timeFrame, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@ProjectId", projectId);
                    vParams.Add("@TimeFrame", timeFrame);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ReportModel>(StoredProcedureConstants.SpGetProjectOverviewReportById, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetProjectOverviewReport", "TestRailPartialRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetProjectOverviewReport);
                
                return null;
            }
        }

        public Guid? UpsertTestRailAudit(TestRailAuditModel testRailAuditModel, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@AuditJson", testRailAuditModel.AuditJson);
                    vParams.Add("@OperationsPerformedBy", testRailAuditModel.CreatedByUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertTestRailAudit, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTestRailAudit", "TestRailPartialRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertTestRailAudit);
                
                return null;
            }
        }
        
        public List<TestRailAuditJsonModel> GetTestRailAudits(TestRailAuditSearchModel testRailAuditSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@Activity", testRailAuditSearchModel.Activity);
                    vParams.Add("@PageNumber", testRailAuditSearchModel.PageNumber);
                    vParams.Add("@PageSize", testRailAuditSearchModel.PageSize);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<TestRailAuditJsonModel>(StoredProcedureConstants.SpGetAllTestRailAudits, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTestRailAudits", "TestRailPartialRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetTestRailAudits);
                
                return new List<TestRailAuditJsonModel>();
            }
        }

        public Guid? DeleteMilestone(MilestoneInputModel milestoneInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@MilestoneId", milestoneInputModel.MilestoneId);
                    vParams.Add("@TimeStamp", milestoneInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpDeleteMilestone, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteMilestone", "TestRailPartialRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionDeleteMilestone);

                return null;
            }
        }

        public Guid? UploadTestRunFromCsv(string projectName, string testRunName, UploadTestRunsFromExcelModel testRunInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestSuiteName", testRunInputModel.TestSuiteName);
                    vParams.Add("@ProjectName", projectName);
                    vParams.Add("@TestCaseTitle", testRunInputModel.Title);
                    vParams.Add("@AssignToName", testRunInputModel.AssignedTo);
                    vParams.Add("@TestCaseStatus", testRunInputModel.Status);
                    vParams.Add("@SectionHierarchy", testRunInputModel.SectionHierarchy);
                    vParams.Add("@TestCaseComment", testRunInputModel.Comment);
                    vParams.Add("@Version", testRunInputModel.Version);
                    vParams.Add("@Elapsed", testRunInputModel.Elapsed);
                    vParams.Add("@StepStatusXml", testRunInputModel.TestCaseStepsXml);
                    vParams.Add("@TestRunName", testRunName);
                    vParams.Add("@CreatedDateTime", testRunInputModel.TestedOn);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.UploadTestRunData, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadTestRunFromCsv", "TestRailPartialRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionDeleteMilestone);

                return null;
            }
        }

        public Guid? UpsertTestRailReport(ReportInputModel reportInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestRailReportId", reportInputModel.TestRailReportId);
                    vParams.Add("@ProjectId", reportInputModel.ProjectId);
                    vParams.Add("@MilestoneId", reportInputModel.MilestoneId);
                    vParams.Add("@TestRunId", reportInputModel.TestRunId);
                    vParams.Add("@Description", reportInputModel.Description);
                    vParams.Add("@TestPlanId", reportInputModel.TestPlanId);
                    vParams.Add("@TestRailOptionId", reportInputModel.TestRailOptionId);
                    vParams.Add("@ReportName", reportInputModel.ReportName);
                    vParams.Add("@IsArchived", reportInputModel.IsArchived);
                    vParams.Add("@PdfUrl", reportInputModel.PdfUrl);
                    vParams.Add("@TimeStamp", reportInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertTestRailReport, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTestRailReport", "TestRailPartialRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertReport);

                return null;
            }
        }

        public List<ReportsApiReturnModel> GetTestRailReports(ReportSearchCriteriaInputModel reportSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@ReportId", reportSearchCriteriaInputModel.ReportId);
                    vParams.Add("@ProjectId", reportSearchCriteriaInputModel.ProjectId);
                    vParams.Add("@MilestoneId", reportSearchCriteriaInputModel.MilestoneId);
                    vParams.Add("@Name", reportSearchCriteriaInputModel.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ReportsApiReturnModel>(StoredProcedureConstants.SpGetTestRailReports, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTestRailReports", "TestRailPartialRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetReports);

                return null;
            }
        }

        public ReportsApiReturnModel GetTestRailReportById(ReportSearchCriteriaInputModel reportSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@ReportId", reportSearchCriteriaInputModel.ReportId);
                    vParams.Add("@ProjectId", reportSearchCriteriaInputModel.ProjectId);
                    vParams.Add("@MilestoneId", reportSearchCriteriaInputModel.MilestoneId);
                    vParams.Add("@IsForPdf", reportSearchCriteriaInputModel.IsForPdf);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ReportsApiReturnModel>(StoredProcedureConstants.SpGetTestRailReportById, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTestRailReportById", "TestRailPartialRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetReportById);

                return null;
            }
        }

        public List<ReportsHierarchyReturnModel> GetReportHierarchicalCases(ReportSearchCriteriaInputModel reportSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters(); 
                    vParams.Add("@ReportId", reportSearchCriteriaInputModel.ReportId);
                    vParams.Add("@ProjectId", reportSearchCriteriaInputModel.ProjectId);
                    vParams.Add("@MilestoneId", reportSearchCriteriaInputModel.MilestoneId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ReportsHierarchyReturnModel>(StoredProcedureConstants.SpGetHierarchicalCases, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetReportHierarchicalCases", "TestRailPartialRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetReportById);

                return null;
            }
        }

        public List<TestTeamStatusReportingRetunrModel> GetTestTeamStatusReportingProjectWise(TestTeamStatusReportingInputModel testTeamStatusReportingInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@UserId", testTeamStatusReportingInputModel.UserId);
                    vParams.Add("@DateFrom", testTeamStatusReportingInputModel.DateFrom);
                    vParams.Add("@DateTo", testTeamStatusReportingInputModel.DateTo);
                    vParams.Add("@CreatedOn", testTeamStatusReportingInputModel.CreatedOn);
                    vParams.Add("@SelectedDate", testTeamStatusReportingInputModel.SelectedDate);
                    vParams.Add("@ProjectId", testTeamStatusReportingInputModel.ProjectId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<TestTeamStatusReportingRetunrModel>(StoredProcedureConstants.SpGetTestTeamStatusReporingProjectWise, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTestTeamStatusReportingProjectWise", "TestRailPartialRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetTestTeamStatusReporting);

                return new List<TestTeamStatusReportingRetunrModel>();
            }
        }
    }
}
