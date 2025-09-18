using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.Projects;
using Btrak.Models.TestRail;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace Btrak.Dapper.Dal.Partial
{
    public class TestSuitePartialRepository : BaseRepository
    {
        public List<TestRailProjectApiReturnModel> GetProjectsList(ProjectSearchCriteriaInputModel searchCriteriaInputModel, Guid operationsPerformedBy, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", operationsPerformedBy);
                    vParams.Add("@IsArchived", searchCriteriaInputModel.IsArchived);
                    return vConn.Query<TestRailProjectApiReturnModel>(StoredProcedureConstants.SpGetTestRailDashboardProjects, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetProjectsList", " TestSuitePartialRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionTestRailGetProjectsList);

                return new List<TestRailProjectApiReturnModel>();
            }
        }

        public Guid? UpsertTestSuite(TestSuiteInputModel testSuiteInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestSuiteId", testSuiteInputModel.TestSuiteId);
                    vParams.Add("@ProjectId", testSuiteInputModel.ProjectId);
                    vParams.Add("@TestSuiteName", testSuiteInputModel.TestSuiteName);
                    vParams.Add("@Description", testSuiteInputModel.Description);
                    vParams.Add("@IsArchived", testSuiteInputModel.IsArchived);
                    vParams.Add("@TimeStamp", testSuiteInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertTestSuite, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTestSuite", " TestSuitePartialRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionTestSuiteCouldNotBeCreated);

                return null;
            }
        }

        public Guid? UpdateTestSuiteProject(TestSuiteInputModel testSuiteInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestSuiteId", testSuiteInputModel.TestSuiteId);
                    vParams.Add("@ProjectId", testSuiteInputModel.ProjectId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpdateTestSuiteProject, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTestSuite", " TestSuitePartialRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionTestSuiteCouldNotBeCreated);

                return null;
            }
        }


        public List<TestSuiteOverviewModel> SearchTestSuites(TestSuiteSearchCriteriaInputModel testSuiteSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestSuiteId", testSuiteSearchCriteriaInputModel.TestSuiteId);
                    vParams.Add("@MultipleTestSuiteIdsXml", testSuiteSearchCriteriaInputModel.MultipleTestSuiteIdsXml);
                    vParams.Add("@TestSuiteName", testSuiteSearchCriteriaInputModel.TestSuiteName);
                    vParams.Add("@ProjectId", testSuiteSearchCriteriaInputModel.ProjectId);
                    vParams.Add("@IsArchived", testSuiteSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@SearchText", testSuiteSearchCriteriaInputModel.SearchText);
                    vParams.Add("@DateFrom", testSuiteSearchCriteriaInputModel.DateFrom);
                    vParams.Add("@DateTo", testSuiteSearchCriteriaInputModel.DateTo);
                    return vConn.Query<TestSuiteOverviewModel>(StoredProcedureConstants.SpSearchTestSuites, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchTestSuites", " TestSuitePartialRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchTestSuites);

                return new List<TestSuiteOverviewModel>();
            }
        }

        public Guid? UpsertCopyOrMoveCases(CopyOrMoveTestCasesApiInputModel copyOrMoveTestCasesApiInputModel,  LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestSuiteId", copyOrMoveTestCasesApiInputModel.TestSuiteId);
                    vParams.Add("@AppendToSectionId", copyOrMoveTestCasesApiInputModel.AppendToSectionId);
                    vParams.Add("@TestCasesXml", copyOrMoveTestCasesApiInputModel.TestCasesXml);
                    vParams.Add("@SelectedSectionsXml", copyOrMoveTestCasesApiInputModel.SelectedSectionsxml);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsCopy", copyOrMoveTestCasesApiInputModel.IsCopy);
                    vParams.Add("@IsCasesOnly", copyOrMoveTestCasesApiInputModel.IsCasesOnly);
                    vParams.Add("@IsCasesWithSections", copyOrMoveTestCasesApiInputModel.IsCasesWithSections);
                    vParams.Add("@IsAllParents", copyOrMoveTestCasesApiInputModel.IsAllParents);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertCopyOrMoveCases, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCopyOrMoveCases", " TestSuitePartialRepository", sqlException.Message), sqlException);
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertCopyOrMoveCases);

                return  null;
            }
        }

        public Guid? UpsertTestsuiteSection(TestSuiteSectionInputModel testSuiteSectionInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestSuiteSectionId", testSuiteSectionInputModel.TestSuiteSectionId);
                    vParams.Add("@SectionName", testSuiteSectionInputModel.SectionName);
                    vParams.Add("@TestSuiteId", testSuiteSectionInputModel.TestSuiteId);
                    vParams.Add("@Description", testSuiteSectionInputModel.Description);
                    vParams.Add("@IsArchived", testSuiteSectionInputModel.IsArchived);
                    vParams.Add("@TimeStamp", testSuiteSectionInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@ParentSectionId", testSuiteSectionInputModel.ParentSectionId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertTestsuiteSection, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTestsuiteSection", " TestSuitePartialRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionTestSuiteSectionCouldNotBeCreated);

                return null;
            }
        }

        public string SearchTestSuiteSections(TestSuiteSectionSearchCriteriaInputModel testSuiteSectionSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestSuiteId", testSuiteSectionSearchCriteriaInputModel.TestSuiteId);
                    vParams.Add("@TestRunId", testSuiteSectionSearchCriteriaInputModel.TestRunId);
                    vParams.Add("@TestSuiteSectionId", testSuiteSectionSearchCriteriaInputModel.TestSuiteSectionId);
                    vParams.Add("@Description", testSuiteSectionSearchCriteriaInputModel.Description);
                    vParams.Add("@SectionName", testSuiteSectionSearchCriteriaInputModel.SectionName);
                    vParams.Add("@IsSectionsRequired", testSuiteSectionSearchCriteriaInputModel.IsSectionsRequired);
                    vParams.Add("@IsArchived", testSuiteSectionSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<string>(StoredProcedureConstants.SpSearchTestSuiteSections_New, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchTestSuiteSections", " TestSuitePartialRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchTestSuiteSections);

                return null;
            }
        }

        public List<TestSuiteSectionApiReturnModel> SearchTestSuiteSectionsWithParentSetionId(TestSuiteSectionSearchCriteriaInputModel testSuiteSectionSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestSuiteId", testSuiteSectionSearchCriteriaInputModel.TestSuiteId);
                    vParams.Add("@TestRunId", testSuiteSectionSearchCriteriaInputModel.TestRunId);
                    vParams.Add("@TestSuiteSectionId", testSuiteSectionSearchCriteriaInputModel.TestSuiteSectionId);
                    vParams.Add("@SectionName", testSuiteSectionSearchCriteriaInputModel.SectionName);
                    vParams.Add("@IsSectionsRequired", testSuiteSectionSearchCriteriaInputModel.IsSectionsRequired);
                    vParams.Add("@ParentSectionId", testSuiteSectionSearchCriteriaInputModel.ParentSectionId);
                    vParams.Add("@IsFromTestRunUplaods", testSuiteSectionSearchCriteriaInputModel.IsFromTestRunUplaods);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<TestSuiteSectionApiReturnModel>(StoredProcedureConstants.SpSearchTestSuiteSections, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchTestSuiteSectionsWithParentSetionId", " TestSuitePartialRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchTestSuiteSections);

                return null;
            }
        }

        public Guid? UpsertTestCase(TestCaseInputModel testCaseInputModel, LoggedInContext loggedInContext, string testCaseStepsXml, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestCaseId", testCaseInputModel.TestCaseId);
                    vParams.Add("@Title", testCaseInputModel.Title);
                    vParams.Add("@SectionId", testCaseInputModel.SectionId);
                    vParams.Add("@TemplateId", testCaseInputModel.TemplateId);
                    vParams.Add("@TypeId", testCaseInputModel.TypeId);
                    vParams.Add("@Estimate", testCaseInputModel.Estimate);
                    vParams.Add("@References", testCaseInputModel.References);
                    vParams.Add("@Steps", testCaseInputModel.Steps);
                    vParams.Add("@ExpectedResult", testCaseInputModel.ExpectedResult);
                    vParams.Add("@IsArchived", testCaseInputModel.IsArchived);
                    vParams.Add("@Mission", testCaseInputModel.Mission);
                    vParams.Add("@Goals", testCaseInputModel.Goals);
                    vParams.Add("@PriorityId", testCaseInputModel.PriorityId);
                    vParams.Add("@AutomationTypeId", testCaseInputModel.AutomationTypeId);
                    vParams.Add("@StatusId", testCaseInputModel.StatusId);
                    vParams.Add("@StatusComment", testCaseInputModel.StatusComment);
                    vParams.Add("@AssignToId", testCaseInputModel.AssignToId);
                    vParams.Add("@TestSuiteId", testCaseInputModel.TestSuiteId);
                    vParams.Add("@UserStoryId", testCaseInputModel.UserStoryId);
                    vParams.Add("@Preconditions", testCaseInputModel.Precondition);
                    vParams.Add("@TestCaseStepsXml", testCaseStepsXml);
                    vParams.Add("@AssignToComment", testCaseInputModel.AssignToComment);
                    vParams.Add("@TimeStamp", testCaseInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@StatusComment", testCaseInputModel.StatusComment);
                    vParams.Add("@Version", testCaseInputModel.Version);
                    vParams.Add("@Elapsed", testCaseInputModel.Elapsed);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertTestCase, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTestCase", " TestSuitePartialRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionTestCaseCouldNotBeCreated);

                return null;
            }
        }

        public List<Guid?> UpsertMultipleTestCases(TestCaseInputModel testCaseInputModel, string testCasesXml, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@SectionId", testCaseInputModel.SectionId);
                    vParams.Add("@TestSuiteId", testCaseInputModel.TestSuiteId);
                    vParams.Add("@UserStoryId", testCaseInputModel.UserStoryId);
                    vParams.Add("@TitleXml", testCasesXml);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpInsertMultipleTestCases, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertMultipleTestCases", " TestSuitePartialRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionTestCaseCouldNotBeCreated);

                return null;
            }
        }

        public Guid? UpsertTestCaseTitle(TestCaseTitleInputModel testCaseTitleInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestCaseId", testCaseTitleInputModel.TestCaseId);
                    vParams.Add("@TestSuiteId", testCaseTitleInputModel.TestSuiteId);
                    vParams.Add("@Title", testCaseTitleInputModel.Title);
                    vParams.Add("@TimeStamp", testCaseTitleInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@SectionId", testCaseTitleInputModel.SectionId);
                    //vParams.Add("@FeatureId", AppCommandConstants.ViewTestRailCommandGuid);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertTestCaseTitle, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTestCaseTitle", " TestSuitePartialRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionTestCaseCouldNotBeCreated);

                return null;
            }
        }

        public List<TestCaseOverviewModel> SearchTestCasesBasedOnFilters(TestCaseSearchFilterInputModel testCaseSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestCaseId", testCaseSearchCriteriaInputModel.TestCaseId);
                    vParams.Add("@AutomationTypeId", testCaseSearchCriteriaInputModel.AutomationTypeId);
                    vParams.Add("@CreatedByUserId", testCaseSearchCriteriaInputModel.CreatedByUserId);
                    vParams.Add("@CreatedOn", testCaseSearchCriteriaInputModel.CreatedOn);
                    vParams.Add("@CreatedDateFrom", testCaseSearchCriteriaInputModel.CreatedDateFrom);
                    vParams.Add("@CreatedDateTo", testCaseSearchCriteriaInputModel.CreatedDateTo);
                    vParams.Add("@PriorityId", testCaseSearchCriteriaInputModel.PriorityId);
                    vParams.Add("@SectionId", testCaseSearchCriteriaInputModel.SectionId);
                    vParams.Add("@TemplateId", testCaseSearchCriteriaInputModel.TemplateId);
                    vParams.Add("@TypeId", testCaseSearchCriteriaInputModel.TypeId);
                    vParams.Add("@UpdatedByUserId", testCaseSearchCriteriaInputModel.UpdatedByUserId);
                    vParams.Add("@UpdatedOn", testCaseSearchCriteriaInputModel.UpdatedOn);
                    vParams.Add("@UpdatedDateFrom", testCaseSearchCriteriaInputModel.UpdatedDateFrom);
                    vParams.Add("@UpdatedDateTo", testCaseSearchCriteriaInputModel.UpdatedDateTo);
                    vParams.Add("@IsMatchAll", testCaseSearchCriteriaInputModel.IsMatchAll);
                    vParams.Add("@IsMatchAllEstimate", testCaseSearchCriteriaInputModel.IsMatchAllEstimate);
                    vParams.Add("@EstimateXml", testCaseSearchCriteriaInputModel.EstimateXml);
                    vParams.Add("@IsMatchAllReferences", testCaseSearchCriteriaInputModel.IsMatchAllReferences);
                    vParams.Add("@ReferencesXml", testCaseSearchCriteriaInputModel.ReferencesXml);
                    vParams.Add("@IsMatchAllTitle", testCaseSearchCriteriaInputModel.IsMatchAllTitle);
                    vParams.Add("@TitleXml", testCaseSearchCriteriaInputModel.TitleXml);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<TestCaseOverviewModel>(StoredProcedureConstants.SpGetTestCasesBasedOnFilter, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchTestCasesBasedOnFilters", " TestSuitePartialRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchTestCasesBasedOnFilters);

                return new List<TestCaseOverviewModel>();
            }
        }

        public List<TestCaseApiReturnModel> SearchTestCases(SearchTestCaseInputModel searchTestCaseInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestCaseId", searchTestCaseInputModel.TestCaseId);
                    vParams.Add("@Title", searchTestCaseInputModel.Title);
                    vParams.Add("@SearchText", searchTestCaseInputModel.SearchText);
                    vParams.Add("@SectionId", searchTestCaseInputModel.SectionId);
                    vParams.Add("@TestSuiteId", searchTestCaseInputModel.TestSuiteId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@SortDirection", searchTestCaseInputModel.SortDirection);
                    vParams.Add("@SortBy", searchTestCaseInputModel.SortBy);
                    vParams.Add("@DateFrom", searchTestCaseInputModel.DateFrom);
                    vParams.Add("@DateTo", searchTestCaseInputModel.DateTo);
                    vParams.Add("@CreatedOn", searchTestCaseInputModel.CreatedOn);
                    vParams.Add("@UpdatedOn", searchTestCaseInputModel.UpdatedOn);
                    vParams.Add("@CreatedByFilterXml", searchTestCaseInputModel.CreatedByFilterXml);
                    vParams.Add("@PriorityFilterXml", searchTestCaseInputModel.PriorityFilterXml);
                    vParams.Add("@TemplateFilterXml", searchTestCaseInputModel.TemplateFilterXml);
                    vParams.Add("@UpdatedByFilterXml", searchTestCaseInputModel.UpdatedByFilterXml);
                    vParams.Add("@AutomationTypeFilterXml", searchTestCaseInputModel.AutomationTypeFilterXml);
                    vParams.Add("@EstimateFilterXml", searchTestCaseInputModel.EstimateFilterXml);
                    vParams.Add("@TypeFilterXml", searchTestCaseInputModel.TypeFilterXml);
                    vParams.Add("@TestCaseIdsXml", searchTestCaseInputModel.TestCaseIdsXml);
                    vParams.Add("@IsHierarchical", searchTestCaseInputModel.IsHierarchical);
                    return vConn.Query<TestCaseApiReturnModel>(StoredProcedureConstants.SpSearchTestCases, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchTestCases", " TestSuitePartialRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchTestCases);

                return new List<TestCaseApiReturnModel>();
            }
        }

        public List<SearchTestCasesModel> SearchRequiredTestCases(SearchTestCaseInputModel searchTestCaseInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestCaseId", searchTestCaseInputModel.TestCaseId);
                    vParams.Add("@Title", searchTestCaseInputModel.Title);
                    vParams.Add("@SearchText", searchTestCaseInputModel.SearchText);
                    vParams.Add("@SectionId", searchTestCaseInputModel.SectionId);
                    vParams.Add("@TestSuiteId", searchTestCaseInputModel.TestSuiteId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@SortDirection", searchTestCaseInputModel.SortDirection);
                    vParams.Add("@SortBy", searchTestCaseInputModel.SortBy);
                    vParams.Add("@DateFrom", searchTestCaseInputModel.DateFrom);
                    vParams.Add("@DateTo", searchTestCaseInputModel.DateTo);
                    vParams.Add("@CreatedOn", searchTestCaseInputModel.CreatedOn);
                    vParams.Add("@UpdatedOn", searchTestCaseInputModel.UpdatedOn);
                    vParams.Add("@CreatedByFilterXml", searchTestCaseInputModel.CreatedByFilterXml);
                    vParams.Add("@PriorityFilterXml", searchTestCaseInputModel.PriorityFilterXml);
                    vParams.Add("@TemplateFilterXml", searchTestCaseInputModel.TemplateFilterXml);
                    vParams.Add("@UpdatedByFilterXml", searchTestCaseInputModel.UpdatedByFilterXml);
                    vParams.Add("@AutomationTypeFilterXml", searchTestCaseInputModel.AutomationTypeFilterXml);
                    vParams.Add("@EstimateFilterXml", searchTestCaseInputModel.EstimateFilterXml);
                    vParams.Add("@TypeFilterXml", searchTestCaseInputModel.TypeFilterXml);
                    vParams.Add("@TestCaseIdsXml", searchTestCaseInputModel.TestCaseIdsXml);
                    vParams.Add("@IsHierarchical", searchTestCaseInputModel.IsHierarchical);
                    return vConn.Query<SearchTestCasesModel>(StoredProcedureConstants.SpSearchTestCases, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchRequiredTestCases", " TestSuitePartialRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchTestCases);

                return new List<SearchTestCasesModel>();
            }
        }

        public List<TestCaseApiReturnModel> GetUserStoryScenarios(SearchTestCaseInputModel searchTestCaseInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestCaseId", searchTestCaseInputModel.TestCaseId);
                    vParams.Add("@UserStoryId", searchTestCaseInputModel.UserStoryId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@TestCaseIdsXml", searchTestCaseInputModel.TestCaseIdsXml);
                    return vConn.Query<TestCaseApiReturnModel>(StoredProcedureConstants.SpGetUserStoryScenarios, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserStoryScenarios", " TestSuitePartialRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchTestCases);

                return new List<TestCaseApiReturnModel>();
            }
        }


        public List<TestRunSelectedCaseMiniModel> GetTestCasesByFilters(SearchTestCaseInputModel searchTestCaseInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestCaseId", searchTestCaseInputModel.TestCaseId);
                    vParams.Add("@SearchText", searchTestCaseInputModel.SearchText);
                    vParams.Add("@SectionId", searchTestCaseInputModel.SectionId);
                    vParams.Add("@TestSuiteId", searchTestCaseInputModel.TestSuiteId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@CreatedOn", searchTestCaseInputModel.CreatedOn);
                    vParams.Add("@UpdatedOn", searchTestCaseInputModel.UpdatedOn);
                    vParams.Add("@CreatedByFilterXml", searchTestCaseInputModel.CreatedByFilterXml);
                    vParams.Add("@PriorityFilterXml", searchTestCaseInputModel.PriorityFilterXml);
                    vParams.Add("@TemplateFilterXml", searchTestCaseInputModel.TemplateFilterXml);
                    vParams.Add("@UpdatedByFilterXml", searchTestCaseInputModel.UpdatedByFilterXml);
                    vParams.Add("@AutomationTypeFilterXml", searchTestCaseInputModel.AutomationTypeFilterXml);
                    vParams.Add("@EstimateFilterXml", searchTestCaseInputModel.EstimateFilterXml);
                    vParams.Add("@TypeFilterXml", searchTestCaseInputModel.TypeFilterXml);
                    vParams.Add("@MultipleSectionIds", searchTestCaseInputModel.MultipleSectionIds);
                    return vConn.Query<TestRunSelectedCaseMiniModel>(StoredProcedureConstants.SpGetTestCasesByFilters, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTestCasesByFilters", " TestSuitePartialRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchTestCases);

                return new List<TestRunSelectedCaseMiniModel>();
            }
        }

        public List<TestRunSelectedCaseMiniModel> GetTestRunCasesByFilters(SearchTestCaseInputModel searchTestCaseInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestRunId", searchTestCaseInputModel.TestRunId);
                    vParams.Add("@TestCaseId", searchTestCaseInputModel.TestCaseId);
                    vParams.Add("@IsArchived", searchTestCaseInputModel.IsArchived);
                    vParams.Add("@SectionId", searchTestCaseInputModel.SectionId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@SortDirection", searchTestCaseInputModel.SortDirection);
                    vParams.Add("@SortBy", searchTestCaseInputModel.SortBy);
                    vParams.Add("@Title", searchTestCaseInputModel.SearchText);
                    vParams.Add("@DateFrom", searchTestCaseInputModel.DateFrom);
                    vParams.Add("@DateTo", searchTestCaseInputModel.DateTo);
                    vParams.Add("@CreatedOn", searchTestCaseInputModel.CreatedOn);
                    vParams.Add("@UpdatedOn", searchTestCaseInputModel.UpdatedOn);
                    vParams.Add("@CreatedByFilterXml", searchTestCaseInputModel.CreatedByFilterXml);
                    vParams.Add("@PriorityFilterXml", searchTestCaseInputModel.PriorityFilterXml);
                    vParams.Add("@TemplateFilterXml", searchTestCaseInputModel.TemplateFilterXml);
                    vParams.Add("@UpdatedByFilterXml", searchTestCaseInputModel.UpdatedByFilterXml);
                    vParams.Add("@AutomationTypeFilterXml", searchTestCaseInputModel.AutomationTypeFilterXml);
                    vParams.Add("@EstimateFilterXml", searchTestCaseInputModel.EstimateFilterXml);
                    vParams.Add("@TypeFilterXml", searchTestCaseInputModel.TypeFilterXml);
                    vParams.Add("@StatusFilterXml", searchTestCaseInputModel.StatusFilterXml);
                    vParams.Add("@StatusId", searchTestCaseInputModel.StatusId);
                    return vConn.Query<TestRunSelectedCaseMiniModel>(StoredProcedureConstants.SpGetTestRunCasesByFilters, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTestRunCasesByFilters", " TestSuitePartialRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchTestCases);

                return new List<TestRunSelectedCaseMiniModel>();
            }
        }

        public TestCaseApiReturnModel SearchTestCaseDeatailsById(SearchTestCaseDetailsInputModel searchTestCaseInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestCaseId", searchTestCaseInputModel.TestCaseId);
                    vParams.Add("@SectionId", searchTestCaseInputModel.SectionId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<TestCaseApiReturnModel>(StoredProcedureConstants.SpSearchTestCaseDetailsById, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchTestCaseDeatailsById", " TestSuitePartialRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchTestCases);

                return null;
            }
        }

        public void ReorderTestCases(string testCaseIdsXml, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestCaseIds", testCaseIdsXml);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vConn.Execute(StoredProcedureConstants.SpReorderTestCases, vParams, commandType: CommandType.StoredProcedure);
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ReorderTestCases", " TestSuitePartialRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchTestCases);
            }
        }

        public Guid? MoveCasesToSection(MoveTestCasesModel moveTestCasesModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestCaseIds", moveTestCasesModel.TestCaseIdsXml);
                    vParams.Add("@SectionId", moveTestCasesModel.SectionId);
                    vParams.Add("@IsCopy", moveTestCasesModel.IsCopy);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpMoveCasesToSection, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "MoveCasesToSection", " TestSuitePartialRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionMoveTestCases);

                return null;
            }
        }

        public List<Guid> GetTestSuiteSections(SearchTestCaseInputModel searchTestCaseInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestCaseId", searchTestCaseInputModel.TestCaseId);
                    vParams.Add("@TestRunId", searchTestCaseInputModel.TestRunId);
                    vParams.Add("@SectionId", searchTestCaseInputModel.SectionId);
                    vParams.Add("@TemplateId", searchTestCaseInputModel.TemplateId);
                    vParams.Add("@TypeId", searchTestCaseInputModel.TypeId);
                    vParams.Add("@Estimate", searchTestCaseInputModel.Estimate);
                    vParams.Add("@IsArchived", searchTestCaseInputModel.IsArchived);
                    vParams.Add("@PriorityId", searchTestCaseInputModel.PriorityId);
                    vParams.Add("@AutomationTypeId", searchTestCaseInputModel.AutomationTypeId);
                    vParams.Add("@TestCaseIdentity", searchTestCaseInputModel.TestCaseIdentity);
                    vParams.Add("@TestSuiteId", searchTestCaseInputModel.TestSuiteId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@SortDirection", searchTestCaseInputModel.SortDirection);
                    vParams.Add("@SortBy", searchTestCaseInputModel.SortBy);
                    vParams.Add("@Title", searchTestCaseInputModel.SearchText);
                    vParams.Add("@DateFrom", searchTestCaseInputModel.DateFrom);
                    vParams.Add("@DateTo", searchTestCaseInputModel.DateTo);
                    vParams.Add("@CreatedOn", searchTestCaseInputModel.CreatedOn);
                    vParams.Add("@UpdatedOn", searchTestCaseInputModel.UpdatedOn);
                    vParams.Add("@CreatedByFilterXml", searchTestCaseInputModel.CreatedByFilterXml);
                    vParams.Add("@UpdatedByFilterXml", searchTestCaseInputModel.UpdatedByFilterXml);
                    vParams.Add("@AutomationTypeFilterXml", searchTestCaseInputModel.AutomationTypeFilterXml);
                    vParams.Add("@EstimateFilterXml", searchTestCaseInputModel.EstimateFilterXml);
                    vParams.Add("@TypeFilterXml", searchTestCaseInputModel.TypeFilterXml);
                    vParams.Add("@PriorityFilterXml", searchTestCaseInputModel.PriorityFilterXml);
                    vParams.Add("@TemplateFilterXml", searchTestCaseInputModel.TemplateFilterXml);
                    vParams.Add("@IsFiltersRequiered", searchTestCaseInputModel.IsFiltersRequired);
                    return vConn.Query<Guid>(StoredProcedureConstants.SpGetTestSuiteSections, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTestSuiteSections", " TestSuitePartialRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchTestSuiteSections);

                return new List<Guid>();
            }
        }

        public List<TestRunSelectedCasesApiReturnModel> SearchTestCasesByTestRunId(SearchTestCaseInputModel searchTestCaseInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestRunId", searchTestCaseInputModel.TestRunId);
                    vParams.Add("@TestCaseId", searchTestCaseInputModel.TestCaseId);
                    vParams.Add("@IsArchived", searchTestCaseInputModel.IsArchived);
                    vParams.Add("@IsTestRunSelectedCases", searchTestCaseInputModel.IsTestRunSelectedCases);
                    vParams.Add("@SectionId", searchTestCaseInputModel.SectionId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@SortDirection", searchTestCaseInputModel.SortDirection);
                    vParams.Add("@SortBy", searchTestCaseInputModel.SortBy);
                    vParams.Add("@Title", searchTestCaseInputModel.SearchText);
                    vParams.Add("@DateFrom", searchTestCaseInputModel.DateFrom);
                    vParams.Add("@DateTo", searchTestCaseInputModel.DateTo);
                    vParams.Add("@CreatedOn", searchTestCaseInputModel.CreatedOn);
                    vParams.Add("@UpdatedOn", searchTestCaseInputModel.UpdatedOn);
                    vParams.Add("@CreatedByFilterXml", searchTestCaseInputModel.CreatedByFilterXml);
                    vParams.Add("@PriorityFilterXml", searchTestCaseInputModel.PriorityFilterXml);
                    vParams.Add("@TemplateFilterXml", searchTestCaseInputModel.TemplateFilterXml);
                    vParams.Add("@UpdatedByFilterXml", searchTestCaseInputModel.UpdatedByFilterXml);
                    vParams.Add("@AutomationTypeFilterXml", searchTestCaseInputModel.AutomationTypeFilterXml);
                    vParams.Add("@EstimateFilterXml", searchTestCaseInputModel.EstimateFilterXml);
                    vParams.Add("@TypeFilterXml", searchTestCaseInputModel.TypeFilterXml);
                    vParams.Add("@StatusFilterXml", searchTestCaseInputModel.StatusFilterXml);
                    vParams.Add("@IsHierarchical", searchTestCaseInputModel.IsHierarchical);
                    vParams.Add("@StatusId", searchTestCaseInputModel.StatusId);
                    return vConn.Query<TestRunSelectedCasesApiReturnModel>(StoredProcedureConstants.SpSearchTestRunTestCases, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchTestCasesByTestRunId", " TestSuitePartialRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchTestCases);

                return new List<TestRunSelectedCasesApiReturnModel>();
            }
        }

        public TestRunSelectedCasesApiReturnModel SearchTestRunCaseDetailsById(SearchTestCaseInputModel searchTestCaseInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestRunId", searchTestCaseInputModel.TestRunId);
                    vParams.Add("@TestCaseId", searchTestCaseInputModel.TestCaseId);
                    vParams.Add("@SectionId", searchTestCaseInputModel.SectionId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<TestRunSelectedCasesApiReturnModel>(StoredProcedureConstants.SpSearchTestRunCaseDetailsById, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchTestRunCaseDetailsById", " TestSuitePartialRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchTestCases);

                return new TestRunSelectedCasesApiReturnModel();
            }
        }

        public List<TestRunSelectedCaseMiniModel> GetTestRunSelectedCases(Guid? testRunId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestRunId", testRunId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<TestRunSelectedCaseMiniModel>(StoredProcedureConstants.SpGetTestRunSelectedCases, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTestRunSelectedCases", " TestSuitePartialRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchTestCases);

                return new List<TestRunSelectedCaseMiniModel>();
            }
        }

        public List<Guid?> GetTestRunSelectedSections(Guid? testRunId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestRunId", testRunId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpGetTestRunSelectedSections, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTestRunSelectedSections", " TestSuitePartialRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchTestCases);

                return new List<Guid?>();
            }
        }

        public List<Guid> UpdateMultipleTestCases(TestCaseInputModel testCaseInputModel, LoggedInContext loggedInContext, string testCaseIdsXml, string testCaseStepsXml, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestCaseId", testCaseInputModel.TestCaseId);
                    vParams.Add("@TestSuiteId", testCaseInputModel.TestSuiteId);
                    vParams.Add("@Title", testCaseInputModel.Title);
                    vParams.Add("@SectionId", testCaseInputModel.SectionId);
                    vParams.Add("@TemplateId", testCaseInputModel.TemplateId);
                    vParams.Add("@TypeId", testCaseInputModel.TypeId);
                    vParams.Add("@PriorityId", testCaseInputModel.PriorityId);
                    vParams.Add("@Estimate", testCaseInputModel.Estimate);
                    vParams.Add("@References", testCaseInputModel.References);
                    vParams.Add("@AutomationTypeId", testCaseInputModel.AutomationTypeId);
                    vParams.Add("@Preconditions", testCaseInputModel.Precondition);
                    vParams.Add("@Steps", testCaseInputModel.Steps);
                    vParams.Add("@Mission", testCaseInputModel.Mission);
                    vParams.Add("@Goals", testCaseInputModel.Goals);
                    vParams.Add("@ExpectedResult", testCaseInputModel.ExpectedResult);
                    vParams.Add("@IsArchived", testCaseInputModel.IsArchived);
                    vParams.Add("@StatusId", testCaseInputModel.StatusId);
                    vParams.Add("@IsSection", testCaseInputModel.IsSection);
                    vParams.Add("@AssignToId", testCaseInputModel.AssignToId);
                    vParams.Add("@TimeStamp", testCaseInputModel.TimeStamp);
                    vParams.Add("@FeatureId", testCaseInputModel.FeatureId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@TestCaseStepsXml", testCaseStepsXml);
                    vParams.Add("@TestCaseIdsXml", testCaseIdsXml);
                    return vConn.Query<Guid>(StoredProcedureConstants.SpUpdateMultipleTestCases, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateMultipleTestCases", " TestSuitePartialRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpdateMultipleTestCases);

                return new List<Guid>();
            }
        }

        public List<DropdownModel> GetSectionsAndSubsections(Guid? suiteId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestSuiteId", suiteId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<DropdownModel>(StoredProcedureConstants.SpGetSectionsAndSubsections, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetSectionsAndSubsections", " TestSuitePartialRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetSectionsAndSubsections);

                return new List<DropdownModel>();
            }
        }

        public TestRailOverviewCountsModel GetTestRailOverviewCountsByProjectId(Guid? projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@ProjectId", projectId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<TestRailOverviewCountsModel>(StoredProcedureConstants.SpGetTestRailDashboardProjects, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTestRailOverviewCountsByProjectId", " TestSuitePartialRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionTestRailGetProjectsList);

                return null;
            }
        }

        public Guid? UpsertTestCaseStatusMasterValue(TestCaseStatusMasterDataInputModel testCaseStatusMasterDataInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestCaseStatusId", testCaseStatusMasterDataInputModel.StatusId);
                    vParams.Add("@Status", testCaseStatusMasterDataInputModel.Status);
                    vParams.Add("@IsArchived", testCaseStatusMasterDataInputModel.IsArchived);
                    vParams.Add("@TimeZone", testCaseStatusMasterDataInputModel.TimeZone);
                    vParams.Add("@TimeStamp", testCaseStatusMasterDataInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@StatusHexValue", testCaseStatusMasterDataInputModel.StatusHexValue);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);

                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertTestCaseStatus, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTestCaseStatusMasterValue", " TestSuitePartialRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertTestCaseStatusMasterValue);

                return null;
            }
        }

        public Guid? UpsertTestRailConfiguration(TestRailConfigurationInputModel testRailConfigurationInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestRailConfigurationId", testRailConfigurationInputModel.TestRailConfigurationId);
                    vParams.Add("@ConfigurationName", testRailConfigurationInputModel.ConfigurationName);
                    vParams.Add("@IsArchived", testRailConfigurationInputModel.IsArchived);
                    vParams.Add("@TimeZone", testRailConfigurationInputModel.TimeZone);
                    vParams.Add("@TimeStamp", testRailConfigurationInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@ConfigurationTime", testRailConfigurationInputModel.ConfigurationTime);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);

                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertTestRailConfiguration, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTestRailConfiguration", " TestSuitePartialRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertTestRailConfiguration);

                return null;
            }
        }

        public Guid? UpsertTestCaseTypeMasterValue(TestRailMasterDataModel testRailMasterDataInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestCaseTypeId", testRailMasterDataInputModel.Id);
                    vParams.Add("@TypeName", testRailMasterDataInputModel.Value);
                    vParams.Add("@TimeStamp", testRailMasterDataInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", testRailMasterDataInputModel.IsArchived);
                    vParams.Add("TimeZone", testRailMasterDataInputModel.TimeZone);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("IsDefault", testRailMasterDataInputModel.IsDefault);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertTestCaseType, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTestCaseTypeMasterValue", " TestSuitePartialRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertTestCaseTypeMasterValue);

                return null;
            }
        }

        public Guid? UpsertTestCasePriorityMasterValue(TestRailMasterDataModel testRailMasterDataInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestCasePriorityId", testRailMasterDataInputModel.Id);
                    vParams.Add("@PriorityType", testRailMasterDataInputModel.Value);
                    vParams.Add("@TimeStamp", testRailMasterDataInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", testRailMasterDataInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertTestCasePriority, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTestCasePriorityMasterValue", "TestSuitePartialRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertTestCasePriorityMasterValue);

                return null;
            }
        }

        public List<TestCaseStatusMasterDataModel> GetAllTestCaseStatuses(TestCaseStatusMasterDataModel testCaseStatusMasterDataModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestCaseStatusId", testCaseStatusMasterDataModel.StatusId);
                    vParams.Add("@Status", testCaseStatusMasterDataModel.Status);
                    vParams.Add("@IsArchived", testCaseStatusMasterDataModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<TestCaseStatusMasterDataModel>(StoredProcedureConstants.SpGetTestCaseStatuses, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllTestCaseStatuses", "TestSuitePartialRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllTestCaseStatuses);

                return new List<TestCaseStatusMasterDataModel>();
            }
        }

        public List<TestRailConfigurationReturnModel> GetTestRailConfigurations(TestRailConfigurationInputModel testRailConfigurationInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestRailConfigurationId", testRailConfigurationInputModel.TestRailConfigurationId);
                    vParams.Add("@ConfigurationName", testRailConfigurationInputModel.ConfigurationName);
                    vParams.Add("@IsArchived", testRailConfigurationInputModel.IsArchived);
                    vParams.Add("@ConfigurationTime", testRailConfigurationInputModel.ConfigurationTime);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<TestRailConfigurationReturnModel>(StoredProcedureConstants.SpGetTestRailConfigurations, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTestRailConfigurations", "TestSuitePartialRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetTestRailConfigurations);

                return new List<TestRailConfigurationReturnModel>();
            }
        }

        public List<TestRailMasterDataModel> GetAllTestCaseTypes(TestRailMasterDataModel testRailMasterDataModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestCaseTypeId", testRailMasterDataModel.Id);
                    vParams.Add("@TypeName", testRailMasterDataModel.Value);
                    vParams.Add("@IsArchived", testRailMasterDataModel.IsArchived);
                    vParams.Add("@IsDefault", testRailMasterDataModel.IsDefault);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<TestRailMasterDataModel>(StoredProcedureConstants.SpGetTestCaseTypes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllTestCaseTypes", "TestSuitePartialRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllTestCaseTypes);

                return new List<TestRailMasterDataModel>();
            }
        }

        public List<TestRailMasterDataModel> GetAllTestCasePriorities(TestRailMasterDataModel testRailMasterDataModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestCasePriorityId", testRailMasterDataModel.Id);
                    vParams.Add("@PriorityType", testRailMasterDataModel.Value);
                    vParams.Add("@IsArchived", testRailMasterDataModel.IsArchived);
                    vParams.Add("@IsDefault", testRailMasterDataModel.IsDefault);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<TestRailMasterDataModel>(StoredProcedureConstants.SpGetTestCasePriorities, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllTestCasePriorities", "TestSuitePartialRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllTestCasePriorities);

                return new List<TestRailMasterDataModel>();
            }
        }

        public List<TestRailMasterDataModel> GetAllTestCaseTemplates(TestRailMasterDataModel testRailMasterDataModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestCaseTemplateId", testRailMasterDataModel.Id);
                    vParams.Add("@TemplateType", testRailMasterDataModel.Value);
                    vParams.Add("@IsArchived", testRailMasterDataModel.IsArchived);
                    vParams.Add("@IsDefault", testRailMasterDataModel.IsDefault);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<TestRailMasterDataModel>(StoredProcedureConstants.SpGetTestCaseTemplates, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllTestCaseTemplates", "TestSuitePartialRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllTestCaseTemplates);

                return new List<TestRailMasterDataModel>();
            }
        }

        public Guid? UploadTestCases(string projectName, UploadTestCasesFromExcelModel row, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@Suite", row.Suite);
                    vParams.Add("@ProjectName", projectName);
                    vParams.Add("@Section", row.Section);
                    vParams.Add("@SectionHierarchy", row.SectionHierarchy);
                    vParams.Add("@Title", row.Title);
                    vParams.Add("@Template", row.Template);
                    vParams.Add("@AutomationType", row.AutomationType);
                    vParams.Add("@Priority", row.Priority);
                    vParams.Add("@Type", row.Type);
                    vParams.Add("@Estimate", row.Estimate);
                    vParams.Add("@References", row.References);
                    vParams.Add("@Steps", row.InlineSteps);
                    vParams.Add("@ExpectedResult", row.ExpectedResult);
                    vParams.Add("@Forecast", row.Forecast);
                    vParams.Add("@Mission", row.Mission);
                    vParams.Add("@Goals", row.Goals);
                    vParams.Add("@Preconditions", row.Preconditions);
                    vParams.Add("@CreatedDateTime", row.CreatedOn);
                    vParams.Add("@UpdatedDateTime", row.UpdatedOn);
                    vParams.Add("@TestCaseStepsXml", row.TestCaseStepsXml);
                    //vParams.Add("@TestCaseIdentity", row.ID);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    //var Error = vConn.Query<Error>(StoredProcedureConstants.SpUploadTestRailData, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUploadTestRailData, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                    //var error =  vConn.Query<Error>(StoredProcedureConstants.SpUploadTestRailData, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                    //if (error?.ErrorMessage != null)
                    //{
                    //    return row.ID;
                    //}
                    //return null;
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadTestCases", "TestSuitePartialRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUploadTestCases);

                return null;
            }
        }

        public Guid? DeleteTestSuite(TestSuiteInputModel testSuiteInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestSuiteId", testSuiteInputModel.TestSuiteId);
                    vParams.Add("@TimeStamp", testSuiteInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpDeleteTestSuite, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteTestSuite", "TestSuitePartialRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionDeleteTestSuite);

                return null;
            }
        }

        public Guid? DeleteTestSuiteSection(TestSuiteSectionInputModel testSuiteSectionInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestSuiteSectionId", testSuiteSectionInputModel.TestSuiteSectionId);
                    vParams.Add("@TimeStamp", testSuiteSectionInputModel.TimeStamp);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpDeleteTestSuiteSection, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteTestSuiteSection", "TestSuitePartialRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionDeleteTestSuiteSection);

                return null;
            }
        }

        public string DeleteTestCase(TestCaseInputModel testCaseInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestCaseId", testCaseInputModel.MultipleTestCaseIds);
                    vParams.Add("@TimeStamp", testCaseInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<string>(StoredProcedureConstants.SpDeleteTestCase, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteTestCase", "TestSuitePartialRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionDeleteTestCase);

                return null;
            }
        }

        public Guid? UpsertTestCaseAutomationType(TestCaseAutomationTypeInputModel testCaseAutomationTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestCaseAutomationTypeId", testCaseAutomationTypeInputModel.TestCaseAutomationTypeId);
                    vParams.Add("@AutomationTypeName", testCaseAutomationTypeInputModel.AutomationTypeName);
                    vParams.Add("@TimeStamp", testCaseAutomationTypeInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", testCaseAutomationTypeInputModel.IsArchived);
                    vParams.Add("@TimeZone", testCaseAutomationTypeInputModel.TimeZone);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsDefault", testCaseAutomationTypeInputModel.IsDefault);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertTestCaseAutomationType, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTestCaseAutomationType", "TestSuitePartialRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertTestCaseAutomationType);

                return null;
            }
        }

        public List<TestCaseAutomationTypeOutputModel> GetAllTestCaseAutomationTypes(TestCaseAutomationTypeSearchCriteriaInputModel testCaseAutomationTypeSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TestCaseAutomationTypeId", testCaseAutomationTypeSearchCriteriaInputModel.TestCaseAutomationTypeId);
                    vParams.Add("@AutomationTypeName", testCaseAutomationTypeSearchCriteriaInputModel.AutomationTypeName);
                    vParams.Add("@IsArchived", testCaseAutomationTypeSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@SearchText", testCaseAutomationTypeSearchCriteriaInputModel.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<TestCaseAutomationTypeOutputModel>(StoredProcedureConstants.SpGetTestCaseAutomationTypes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllTestCaseAutomationTypes", "TestSuitePartialRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllTestCaseAutomationTypes);

                return new List<TestCaseAutomationTypeOutputModel>();
            }
        }

    }
}
