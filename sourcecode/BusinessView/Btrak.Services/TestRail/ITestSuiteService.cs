using Btrak.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.IO;
using Btrak.Models.TestRail;
using Btrak.Models.File;
using Btrak.Models.Projects;
using System.Web;

namespace Btrak.Services.TestRail 
{
    public interface ITestSuiteService
    {
        Guid? UpsertTestSuite(TestSuiteInputModel testSuiteInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        IList<TestSuiteOverviewModel> SearchTestSuites(TestSuiteSearchCriteriaInputModel testSuiteSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        TestSuiteOverviewModel GetTestSuiteById(Guid? testSuiteId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertCopyOrMoveCases(CopyOrMoveTestCasesApiInputModel copyOrMoveTestCasesApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertTestSuiteSection(TestSuiteSectionInputModel testSuiteSectionInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        IList<TestSuiteSectionApiReturnModel> SearchTestSuiteSections(TestSuiteSectionSearchCriteriaInputModel testSuiteSectionSearchCriteriaInputModel , LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        TestSuiteSectionApiReturnModel GetTestSuiteSectionById(Guid? sectionId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        TestCaseApiReturnModel GetTestCaseById(Guid? testCaseId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, bool RequireBasicInfoOnly = false);
        int? GetTestCasesCountByProject(Guid? projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<DropdownModel> GetSectionsAndSubsections(Guid? suiteId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        TestRailOverviewCountsModel GetTestRailOverviewCountsByProjectId(Guid? projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);


        int? GetTestSuiteCount(Guid? projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertTestCaseTitle(TestCaseTitleInputModel testCaseTitleInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertTestCase(TestCaseInputModel testCaseInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<Guid?> UpsertMultipleTestCases(TestCaseInputModel testCaseInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<TestCaseApiReturnModel> SearchTestCases(SearchTestCaseInputModel searchTestCaseInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<SearchTestCasesModel> SearchRequiredTestCases(SearchTestCaseInputModel searchTestCaseInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        TestCaseApiReturnModel SearchTestCaseDetailsById(SearchTestCaseDetailsInputModel searchTestCaseDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<TestRunSelectedCasesApiReturnModel> SearchTestCasesByTestRunId(SearchTestCaseInputModel searchTestCaseInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<Guid> UpdateMultipleTestCases(TestCaseInputModel testCaseInputModel,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        IList<TestRailProjectApiReturnModel> GetProjectList(ProjectSearchCriteriaInputModel searchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        Guid? UpsertTestCaseStatusMasterValue(TestCaseStatusMasterDataInputModel testCaseStatusMasterDataInputModel, LoggedInContext loggedInContext,List<ValidationMessage> validationMessages);
        Guid? UpsertTestRailConfiguration(TestRailConfigurationInputModel testRailConfigurationInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertTestCaseTypeMasterValue(TestRailMasterDataModel testRailMasterDataInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertTestCasePriorityMasterValue(TestRailMasterDataModel testRailMasterDataInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<DropdownModel> GetAllTestCaseStatuses(TestCaseStatusMasterDataModel testCaseStatusMasterDataModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<DropdownModel> GetAllTestCaseTypes(TestRailMasterDataModel testRailMasterDataModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<DropdownModel> GetAllTestCasePriorities(TestRailMasterDataModel testRailMasterDataModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<DropdownModel> GetAllTestCaseTemplates(TestRailMasterDataModel testRailMasterDataModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        TestCaseStatusMasterDataModel GetTestCaseStatusMasterDataById(Guid? statusId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<TestRailConfigurationReturnModel> GetTestRailConfigurations(TestRailConfigurationInputModel testRailConfigurationInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        TestRailMasterDataModel GetTestCaseTypeMasterDataById(Guid? typeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        TestRailMasterDataModel GetTestCasePriorityMasterDataById(Guid? priorityId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<TestRunSelectedCaseMiniModel> GetTestCasesByFilters(SearchTestCaseInputModel searchTestCaseInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<UploadTestCasesFromExcelModel> ProcessExcelData(string projectName, Stream filename, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        TestSuiteCasesOverviewModel GetTestSuiteCasesOverview(TestSuiteCasesOverviewInputModel testSuiteCasesOverviewInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<TestCaseApiReturnModel> GetUserStoryScenarios(SearchTestCaseInputModel searchTestCaseInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? DeleteTestSuite(Guid? testSuiteId, byte[] timeStamp, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? DeleteTestSuiteSection(Guid? sectionId, byte[] timeStamp, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string DeleteTestCase(TestCaseInputModel testCaseInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<UploadTestCasesFromExcelModel> UploadTestCasesFromCsv(string projectName, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        bool UploadTestSuiteFromCsv(string projectName, HttpRequest httpRequest, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        bool UploadTestSuitesFromCsv(string projectName, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertTestCaseAutomationType(TestCaseAutomationTypeInputModel testCaseAutomationTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<TestCaseAutomationTypeOutputModel> GetAllTestCaseAutomationTypes(TestCaseAutomationTypeSearchCriteriaInputModel testCaseAutomationTypeSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        bool UploadTestSuiteFromXml(string projectName, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string ReplaceImageUrls(string content);
        byte[] GetTestRepoDataForExcel(List<TestSuitesForExportModel> testSuites, TestSuiteDownloadModel exportModel, string site, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<TestSuitesForExportModel> GetTestRepoDataForJson(string projectName, string testSuiteName, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<FileResult> GetImagePaths(string content);
        TestCasesHierarchyApiReturnModel GetTestCasesHierarchy(SearchTestCaseInputModel testSuiteSectionSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        TestRunSelectedCasesApiReturnModel SearchTestRunCaseDetailsById(SearchTestCaseInputModel searchTestCaseInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string ReorderTestCases(List<Guid> testCaseIds, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? MoveCasesToSection(MoveTestCasesModel moveTestCasesModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpdateTestSuiteProject(TestSuiteInputModel testSuiteInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
 