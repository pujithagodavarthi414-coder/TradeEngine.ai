using Btrak.Dapper.Dal.Partial;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.CompanyStructure;
using Btrak.Models.File;
using Btrak.Models.MasterData;
using Btrak.Models.Projects;
using Btrak.Models.SystemManagement;
using Btrak.Models.TestRail;
using Btrak.Services.Audit;
using Btrak.Services.CompanyStructure;
using Btrak.Services.Email;
using Btrak.Services.FileUploadDownload;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.TestRailValidationHelpers;
using Btrak.Services.Projects;
using BTrak.Common;
using CsvHelper;
using DocumentFormat.OpenXml;
using DocumentFormat.OpenXml.Packaging;
using Hangfire;
using Microsoft.Azure;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Blob;
using Newtonsoft.Json;
using OfficeOpenXml;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Web;
using System.Xml;
using static BTrak.Common.Enumerators;

namespace Btrak.Services.TestRail
{
    public class TestSuiteService : ITestSuiteService
    {
        private readonly IAuditService _auditService;
        private readonly IProjectService _projectService;
        private readonly TestSuitePartialRepository _testSuitePartialRepository;
        private readonly FileRepository _fileRepository;
        private readonly ITestRailFileService _testRailFileService;
        private readonly IOverviewService _overviewService;
        private readonly TestSuiteValidationHelper _testSuiteValidationHelper;
        private readonly IFileStoreService _fileStoreService;
        private readonly UserRepository _userRepository;
        private readonly GoalRepository _goalRepository;
        private readonly ICompanyStructureService _companyStructureService;
        private readonly IEmailService _emailService;
        private readonly MasterDataManagementRepository _masterDataManagementRepository = new MasterDataManagementRepository();

        public TestSuiteService(IAuditService auditService, IProjectService projectService, TestSuitePartialRepository testSuitePartialRepository, ITestRailFileService testRailFileService, IOverviewService overviewService, TestSuiteValidationHelper testSuiteValidationHelper, IFileStoreService fileStoreService, UserRepository userRepository, GoalRepository goalRepository, ICompanyStructureService companyStructureService,
            FileRepository fileRepository, IEmailService emailService)
        {
            _auditService = auditService;
            _projectService = projectService;
            _testSuitePartialRepository = testSuitePartialRepository;
            _testRailFileService = testRailFileService;
            _overviewService = overviewService;
            _testSuiteValidationHelper = testSuiteValidationHelper;
            _fileStoreService = fileStoreService;
            _userRepository = userRepository;
            _goalRepository = goalRepository;
            _companyStructureService = companyStructureService;
            _fileRepository = fileRepository;
            _emailService = emailService;
        }

        public IList<TestRailProjectApiReturnModel> GetProjectList(ProjectSearchCriteriaInputModel searchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Project List", "TestSuite Service"));

            validationMessages = CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetProjectsCommandId, "Get Project List", loggedInContext);

            var projectsList = _testSuitePartialRepository.GetProjectsList(searchCriteriaInputModel, loggedInContext.LoggedInUserId, validationMessages);

            return validationMessages.Count > 0 ? null : projectsList;
        }

        public Guid? UpsertTestSuite(TestSuiteInputModel testSuiteInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Test Suite", "testSuiteInputModel", testSuiteInputModel, "Test Suite Service"));

            _testSuiteValidationHelper.UpsertTestSuiteCheckValidation(loggedInContext, validationMessages, testSuiteInputModel);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            Guid? testSuiteId = _testSuitePartialRepository.UpsertTestSuite(testSuiteInputModel, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (testSuiteId != null)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Test Suite audit saving", "testSuiteId", testSuiteId, "Test suite Service"));

                var testRailAuditJsonModel = new TestRailAuditJsonModel
                {
                    Title = testSuiteInputModel.TestSuiteName,
                    TitleId = testSuiteId,
                    Action = testSuiteInputModel.TestSuiteId == null ? "Created" : testSuiteInputModel.IsArchived ? "Deleted" : "Updated",
                    TabName = "Test Suite",
                    ColorCode = "#72bd42"
                };

                _overviewService.SaveTestRailAudit(testRailAuditJsonModel, loggedInContext, validationMessages);

                _auditService.SaveAudit(AppCommandConstants.UpsertTestSuiteCommandId, testSuiteInputModel, loggedInContext);

                LoggingManager.Debug("TestSuite is created/updated successfully with the Id:" + testSuiteId + " on  " + DateTime.Now);

                return testSuiteId;
            }
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Test Suite Failed", "Test suite Service"));

            return null;
        }

        public Guid? UpdateTestSuiteProject(TestSuiteInputModel testSuiteInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Update Test Suite Project", "testSuiteInputModel", testSuiteInputModel, "Test Suite Service"));

            Guid? testSuiteId = _testSuitePartialRepository.UpdateTestSuiteProject(testSuiteInputModel, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (testSuiteId != null)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Update Test Suite Project audit saving", "testSuiteId", testSuiteId, "Test suite Service"));

                var testRailAuditJsonModel = new TestRailAuditJsonModel
                {
                    Title = testSuiteInputModel.TestSuiteName,
                    TitleId = testSuiteId,
                    Action = testSuiteInputModel.TestSuiteId == null ? "Created" : testSuiteInputModel.IsArchived ? "Deleted" : "Updated",
                    TabName = "Test Suite",
                    ColorCode = "#72bd42"
                };

                _overviewService.SaveTestRailAudit(testRailAuditJsonModel, loggedInContext, validationMessages);

                _auditService.SaveAudit(AppCommandConstants.UpsertTestSuiteCommandId, testSuiteInputModel, loggedInContext);

                LoggingManager.Debug("TestSuite is created/updated successfully with the Id:" + testSuiteId + " on  " + DateTime.Now);

                return testSuiteId;
            }
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Test Suite Failed", "Test suite Service"));

            return null;
        }

        public IList<TestSuiteOverviewModel> SearchTestSuites(TestSuiteSearchCriteriaInputModel testSuiteSearchInputCriteriaModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Search Test Suites", "testSuiteSearchInputCriteriaModel", testSuiteSearchInputCriteriaModel, "Test Suite Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            testSuiteSearchInputCriteriaModel.MultipleTestSuiteIdsXml = testSuiteSearchInputCriteriaModel.MultipleTestSuiteIds != null && testSuiteSearchInputCriteriaModel.MultipleTestSuiteIds.Count > 0 ? Utilities.GetXmlFromObject(testSuiteSearchInputCriteriaModel.MultipleTestSuiteIds) : null;

            _auditService.SaveAudit(AppCommandConstants.SearchTestSuitesCommandId, testSuiteSearchInputCriteriaModel, loggedInContext);

            var testSuites = _testSuitePartialRepository.SearchTestSuites(testSuiteSearchInputCriteriaModel, loggedInContext, validationMessages);

            return validationMessages.Count > 0 ? null : testSuites;
        }

        public Guid? UpsertCopyOrMoveCases(CopyOrMoveTestCasesApiInputModel copyOrMoveTestCasesApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertCopyOrMoveCases", "copyOrMoveTestCasesApiInputModel", copyOrMoveTestCasesApiInputModel, "Test Suite Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            string testCaseIdsXml = string.Empty;


            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (copyOrMoveTestCasesApiInputModel.TestCasesList != null && copyOrMoveTestCasesApiInputModel.TestCasesList.Count > 0)
            {
                testCaseIdsXml = Utilities.GetXmlFromObject(copyOrMoveTestCasesApiInputModel.TestCasesList);
            }
            else
            {
                testCaseIdsXml = null;
            }

            if (copyOrMoveTestCasesApiInputModel.SelectedSections != null && copyOrMoveTestCasesApiInputModel.SelectedSections.Count > 0)
            {
                copyOrMoveTestCasesApiInputModel.SelectedSectionsxml = Utilities.GetXmlFromObject(copyOrMoveTestCasesApiInputModel.SelectedSections);
            }
            else
            {
                copyOrMoveTestCasesApiInputModel.SelectedSectionsxml = null;
            }
            copyOrMoveTestCasesApiInputModel.TestCasesXml = testCaseIdsXml;

            _auditService.SaveAudit(AppCommandConstants.SearchTestSuitesCommandId, copyOrMoveTestCasesApiInputModel, loggedInContext);

            var testCaseId = _testSuitePartialRepository.UpsertCopyOrMoveCases(copyOrMoveTestCasesApiInputModel, loggedInContext, validationMessages);

            if (testCaseId != null && testCaseId != Guid.Empty)
            {
                BackgroundJob.Enqueue(() => UpdateFolderAndStoreSizeByFolderId(testCaseId, loggedInContext));
            }

            return validationMessages.Count > 0 ? null : testCaseId;
        }


        public TestSuiteOverviewModel GetTestSuiteById(Guid? testSuiteId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertCopyOrMoveCases", "testSuiteId", testSuiteId, "Test Suite Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            TestSuiteSearchCriteriaInputModel testSuiteSearchCriteriaInputModel = new TestSuiteSearchCriteriaInputModel
            {
                TestSuiteId = testSuiteId
            };

            _auditService.SaveAudit(AppCommandConstants.GetTestSuiteByIdCommandId, testSuiteId, loggedInContext);

            List<TestSuiteOverviewModel> testsuites = _testSuitePartialRepository.SearchTestSuites(testSuiteSearchCriteriaInputModel, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            return testsuites.Count > 0 ? testsuites[0] : null;
        }

        public Guid? UpsertTestSuiteSection(TestSuiteSectionInputModel testSuiteSectionInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Test Suite Section", "testSuiteSectionInputModel", testSuiteSectionInputModel, "Test Suite Service"));

            _testSuiteValidationHelper.UpsertTestSuiteSectionCheckValidation(loggedInContext, validationMessages, testSuiteSectionInputModel);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            Guid? testSuiteSectionId = _testSuitePartialRepository.UpsertTestsuiteSection(testSuiteSectionInputModel, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (testSuiteSectionId != null)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Test Suite Section audit saving", "Test suite Service"));

                _auditService.SaveAudit(AppCommandConstants.UpsertTestSuiteSectionCommandId, testSuiteSectionInputModel, loggedInContext);

                if (testSuiteSectionInputModel.TestSuiteSectionId == testSuiteSectionId)
                {
                    LoggingManager.Debug("Test Suite Section is updated successfully with the Id :" + testSuiteSectionId);
                }
                else
                {
                    LoggingManager.Debug("Test Suite Section is inserted successfully with the Id :" + testSuiteSectionId);
                }

                return testSuiteSectionId;
            }
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Test Suite Section Failed", "Test suite Service"));
            return null;
        }

        public IList<TestSuiteSectionApiReturnModel> SearchTestSuiteSections(TestSuiteSectionSearchCriteriaInputModel testSuiteSectionSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Search Test Suite Sections", "testSuiteSectionSearchCriteriaInputModel", testSuiteSectionSearchCriteriaInputModel, "Test Suite Service"));

            CommonValidationHelper.CheckValidationForSearchCriteria(loggedInContext, testSuiteSectionSearchCriteriaInputModel, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.SearchTestSuiteSectionsCommandId, testSuiteSectionSearchCriteriaInputModel, loggedInContext);

            var testSuiteSections = _testSuitePartialRepository.SearchTestSuiteSectionsWithParentSetionId(testSuiteSectionSearchCriteriaInputModel, loggedInContext, validationMessages);

            return validationMessages.Count > 0 ? null : testSuiteSections;
        }

        public TestSuiteSectionApiReturnModel GetTestSuiteSectionById(Guid? sectionId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Test Suite Section By Id", "sectionId", sectionId, "Test Suite Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetTestSuiteSectionByIdCommandId, sectionId, loggedInContext);

            TestSuiteSectionSearchCriteriaInputModel testSuiteSectionSearchCriteriaInputModel = new TestSuiteSectionSearchCriteriaInputModel
            {
                TestSuiteSectionId = sectionId
            };

            _testSuitePartialRepository.SearchTestSuiteSections(testSuiteSectionSearchCriteriaInputModel, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            return new TestSuiteSectionApiReturnModel();
        }

        public Guid? UpsertTestCase(TestCaseInputModel testCaseInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Test Case started", "TestCaseInputModel", testCaseInputModel, "Test Suite Service"));

            string testCaseStepsXml = string.Empty;

            _testSuiteValidationHelper.UpsertTestCaseCheckValidation(loggedInContext, validationMessages, testCaseInputModel);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (testCaseInputModel.TestCaseSteps != null && testCaseInputModel.TestCaseSteps.Count > 0)
            {
                testCaseStepsXml = Utilities.GetXmlFromObject(testCaseInputModel.TestCaseSteps);
            }
            else
            {
                testCaseStepsXml = null;
            }

            var testCaseId = _testSuitePartialRepository.UpsertTestCase(testCaseInputModel, loggedInContext, testCaseStepsXml, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (testCaseId != null && !testCaseInputModel.IsArchived)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Test Case audit saving", "Test suite Service"));

                TestCaseApiReturnModel testCase = GetTestCaseById(testCaseId, loggedInContext, validationMessages);

                if (validationMessages.Count > 0)
                {
                    return null;
                }

                if (testCaseInputModel.PreConditionFilePaths != null)
                {
                    var consTestRailFileModel = new TestRailFileModel
                    {
                        TestRailId = testCase.TestCaseId,
                        IsTestCasePreCondition = true,
                        FilePathList = testCaseInputModel.PreConditionFilePaths,
                        FilePathXml = Utilities.GetXmlFromObject(testCaseInputModel.PreConditionFilePaths)
                    };
                    _testRailFileService.UpsertFile(consTestRailFileModel, loggedInContext, validationMessages);
                    if (validationMessages.Count > 0)
                    {
                        return null;
                    }
                }

                if (testCaseInputModel.TestCaseSteps != null && testCaseInputModel.TestCaseSteps?.Count > 0)
                {
                    foreach (var step in testCaseInputModel.TestCaseSteps.Zip(testCase.TestCaseSteps, Tuple.Create))
                    {
                        if (step.Item1.StepFilePaths != null)
                        {
                            var stepTestRailFileModel = new TestRailFileModel
                            {
                                TestRailId = step.Item2.StepId,
                                IsTestCaseStep = true,
                                FilePathList = step.Item1.StepFilePaths,
                                FilePathXml = Utilities.GetXmlFromObject(step.Item1.StepFilePaths)
                            };
                            _testRailFileService.UpsertFile(stepTestRailFileModel, loggedInContext, validationMessages);
                            if (validationMessages.Count > 0)
                            {
                                return null;
                            }
                        }
                    }
                }

                if (testCaseInputModel.FilePaths != null)
                {
                    var testRailFileModel = new TestRailFileModel
                    {
                        TestRailId = testCase.TestCaseId,
                        IsTestCase = true,
                        FilePathList = testCaseInputModel.FilePaths,
                        FilePathXml = Utilities.GetXmlFromObject(testCaseInputModel.FilePaths)
                    };

                    _testRailFileService.UpsertFile(testRailFileModel, loggedInContext, validationMessages);
                    if (validationMessages.Count > 0)
                    {
                        return null;
                    }
                }
            }

            if (testCaseId != Guid.Empty)
            {
                _auditService.SaveAudit(AppCommandConstants.UpsertTestCaseCommandId, testCaseInputModel, loggedInContext);

                if (testCaseInputModel.TestCaseId == testCaseId)
                {
                    LoggingManager.Debug("Test Case updated successfully with the Id:" + testCaseId);
                }
                else
                {
                    LoggingManager.Debug("Test Case inserted successfully with the Id:" + testCaseId);
                }

                return testCaseId;
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Test Case", "Test suite Service"));
            return null;
        }

        public List<Guid?> UpsertMultipleTestCases(TestCaseInputModel testCaseInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Test Case started", "TestCaseInputModel", testCaseInputModel, "Test Suite Service"));

            testCaseInputModel.MultipleTestCasesTitles = testCaseInputModel.Title?.Trim().Split('\n');

            _testSuiteValidationHelper.UpsertMultipleTestCaseCheckValidation(loggedInContext, validationMessages, testCaseInputModel);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            string testCasesXml = Utilities.GetXmlFromObject(testCaseInputModel.MultipleTestCasesTitles);

            var multipleTestCasesIds = _testSuitePartialRepository.UpsertMultipleTestCases(testCaseInputModel, testCasesXml, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            testCaseInputModel.MultipleTestCasesIds = multipleTestCasesIds;

            if (multipleTestCasesIds != null)
            {
                _auditService.SaveAudit(AppCommandConstants.UpsertMultipleTestCasesCommandId, testCaseInputModel, loggedInContext);

                LoggingManager.Debug("Multiple Test Cases were inserted successfully with the Ids:" + multipleTestCasesIds.ToString());

                return multipleTestCasesIds;
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Multiple Test Case", "Test suite Service"));
            return null;
        }

        public Guid? UpsertTestCaseTitle(TestCaseTitleInputModel testCaseTitleInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Test Case Title", "testCaseTitleInputModel", testCaseTitleInputModel, "Test Suite Service"));

            _testSuiteValidationHelper.UpsertTestCaseTitleCheckValidation(loggedInContext, validationMessages, testCaseTitleInputModel);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            Guid? testCaseId = _testSuitePartialRepository.UpsertTestCaseTitle(testCaseTitleInputModel, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (testCaseId != null)
            {
                _auditService.SaveAudit(AppCommandConstants.UpsertTestCaseTitleCommandId, testCaseTitleInputModel, loggedInContext);

                if (testCaseTitleInputModel.TestCaseId == testCaseId)
                {
                    LoggingManager.Debug("Test Case Title is updated Successfully with the Id:" + testCaseId);
                }
                else
                {
                    LoggingManager.Debug("Test Case Title is Inserted Successfully with the Id:" + testCaseId);
                }

                return testCaseId;
            }

            return null;
        }

        public List<TestCaseApiReturnModel> SearchTestCases(SearchTestCaseInputModel searchTestCaseInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Search Test Cases", "testCaseSearchCriteriaInputModel", searchTestCaseInputModel, "Test Suite Service"));

            searchTestCaseInputModel.CreatedByFilterXml = searchTestCaseInputModel.CreatedByFilter != null && searchTestCaseInputModel.CreatedByFilter.Count > 0 ? Utilities.GetXmlFromObject(searchTestCaseInputModel.CreatedByFilter) : null;

            searchTestCaseInputModel.PriorityFilterXml = searchTestCaseInputModel.PriorityFilter != null && searchTestCaseInputModel.PriorityFilter.Count > 0 ? Utilities.GetXmlFromObject(searchTestCaseInputModel.PriorityFilter) : null;

            searchTestCaseInputModel.TemplateFilterXml = searchTestCaseInputModel.TemplateFilter != null && searchTestCaseInputModel.TemplateFilter.Count > 0 ? Utilities.GetXmlFromObject(searchTestCaseInputModel.TemplateFilter) : null;

            searchTestCaseInputModel.UpdatedByFilterXml = searchTestCaseInputModel.UpdatedByFilter != null && searchTestCaseInputModel.UpdatedByFilter.Count > 0 ? Utilities.GetXmlFromObject(searchTestCaseInputModel.UpdatedByFilter) : null;

            searchTestCaseInputModel.AutomationTypeFilterXml = searchTestCaseInputModel.AutomationTypeFilter != null && searchTestCaseInputModel.AutomationTypeFilter.Count > 0 ? Utilities.GetXmlFromObject(searchTestCaseInputModel.AutomationTypeFilter) : null;

            searchTestCaseInputModel.EstimateFilterXml = searchTestCaseInputModel.EstimateFilter != null && searchTestCaseInputModel.EstimateFilter.Count > 0 ? Utilities.GetXmlFromObject(searchTestCaseInputModel.EstimateFilter) : null;

            searchTestCaseInputModel.TypeFilterXml = searchTestCaseInputModel.TypeFilter != null && searchTestCaseInputModel.TypeFilter.Count > 0 ? Utilities.GetXmlFromObject(searchTestCaseInputModel.TypeFilter) : null;

            searchTestCaseInputModel.TestCaseIdsXml = searchTestCaseInputModel.MultipleTestCaseIds != null && searchTestCaseInputModel.MultipleTestCaseIds.Count > 0 ? Utilities.GetXmlFromObject(searchTestCaseInputModel.MultipleTestCaseIds) : null;

            searchTestCaseInputModel.SortDirectionAsc = true;

            var testCaseList = _testSuitePartialRepository.SearchTestCases(searchTestCaseInputModel, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (testCaseList.Count > 0)
            {
                Parallel.ForEach(testCaseList, testCase =>
                {
                    if (testCase.TestCaseStepsXml != null)
                    {
                        testCase.TestCaseSteps = Utilities.GetObjectFromXml<TestCaseStepMiniModel>(testCase.TestCaseStepsXml, "TestCaseStepMiniModel");
                    }
                });
            }

            return testCaseList;
        }

        public List<SearchTestCasesModel> SearchRequiredTestCases(SearchTestCaseInputModel searchTestCaseInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Search Test Cases", "testCaseSearchCriteriaInputModel", searchTestCaseInputModel, "Test Suite Service"));

            searchTestCaseInputModel.CreatedByFilterXml = searchTestCaseInputModel.CreatedByFilter != null && searchTestCaseInputModel.CreatedByFilter.Count > 0 ? Utilities.GetXmlFromObject(searchTestCaseInputModel.CreatedByFilter) : null;

            searchTestCaseInputModel.PriorityFilterXml = searchTestCaseInputModel.PriorityFilter != null && searchTestCaseInputModel.PriorityFilter.Count > 0 ? Utilities.GetXmlFromObject(searchTestCaseInputModel.PriorityFilter) : null;

            searchTestCaseInputModel.TemplateFilterXml = searchTestCaseInputModel.TemplateFilter != null && searchTestCaseInputModel.TemplateFilter.Count > 0 ? Utilities.GetXmlFromObject(searchTestCaseInputModel.TemplateFilter) : null;

            searchTestCaseInputModel.UpdatedByFilterXml = searchTestCaseInputModel.UpdatedByFilter != null && searchTestCaseInputModel.UpdatedByFilter.Count > 0 ? Utilities.GetXmlFromObject(searchTestCaseInputModel.UpdatedByFilter) : null;

            searchTestCaseInputModel.AutomationTypeFilterXml = searchTestCaseInputModel.AutomationTypeFilter != null && searchTestCaseInputModel.AutomationTypeFilter.Count > 0 ? Utilities.GetXmlFromObject(searchTestCaseInputModel.AutomationTypeFilter) : null;

            searchTestCaseInputModel.EstimateFilterXml = searchTestCaseInputModel.EstimateFilter != null && searchTestCaseInputModel.EstimateFilter.Count > 0 ? Utilities.GetXmlFromObject(searchTestCaseInputModel.EstimateFilter) : null;

            searchTestCaseInputModel.TypeFilterXml = searchTestCaseInputModel.TypeFilter != null && searchTestCaseInputModel.TypeFilter.Count > 0 ? Utilities.GetXmlFromObject(searchTestCaseInputModel.TypeFilter) : null;

            searchTestCaseInputModel.TestCaseIdsXml = searchTestCaseInputModel.MultipleTestCaseIds != null && searchTestCaseInputModel.MultipleTestCaseIds.Count > 0 ? Utilities.GetXmlFromObject(searchTestCaseInputModel.MultipleTestCaseIds) : null;

            searchTestCaseInputModel.SortDirectionAsc = true;

            var testCaseList = _testSuitePartialRepository.SearchRequiredTestCases(searchTestCaseInputModel, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            return testCaseList;
        }

        public string ReorderTestCases(List<Guid> testCaseIds, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "ReorderTestCases", "SearchTestCaseDetailsInputModel", testCaseIds, "Test Suite Service"));

            string testCaseIdsXml;

            if (testCaseIds != null && testCaseIds.Count > 0)
            {
                testCaseIdsXml = Utilities.ConvertIntoListXml(testCaseIds);
            }
            else
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyReorderTestCaseIds
                });

                return null;
            }

            _testSuitePartialRepository.ReorderTestCases(testCaseIdsXml, loggedInContext, validationMessages);

            return "Success";
        }

        public Guid? MoveCasesToSection(MoveTestCasesModel moveTestCasesModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "MoveCasesToSection", "SearchTestCaseDetailsInputModel", moveTestCasesModel, "Test Suite Service"));

            if (moveTestCasesModel.TestCaseIds != null && moveTestCasesModel.TestCaseIds.Count > 0)
            {
                moveTestCasesModel.TestCaseIdsXml = Utilities.ConvertIntoListXml(moveTestCasesModel.TestCaseIds);
            }
            else
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyMoveTestCaseIds
                });

                return null;
            }

            return _testSuitePartialRepository.MoveCasesToSection(moveTestCasesModel, loggedInContext, validationMessages);
        }

        public List<TestCaseApiReturnModel> GetUserStoryScenarios(SearchTestCaseInputModel searchTestCaseInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get UserStory Scenarios", "searchTestCaseInputModel", searchTestCaseInputModel, "Test Suite Service"));

            searchTestCaseInputModel.TestCaseIdsXml = searchTestCaseInputModel.MultipleTestCaseIds != null && searchTestCaseInputModel.MultipleTestCaseIds.Count > 0 ? Utilities.GetXmlFromObject(searchTestCaseInputModel.MultipleTestCaseIds) : null;

            var testCaseList = _testSuitePartialRepository.GetUserStoryScenarios(searchTestCaseInputModel, loggedInContext, validationMessages);


            Parallel.ForEach(testCaseList, testcasedata =>
            {
                testcasedata.ReferencesList = testcasedata.References?.Trim().Split(',').ToList();

            });

            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (testCaseList.Count > 0)
            {
                Parallel.ForEach(testCaseList, testCase =>
                {
                    if (testCase.TestCaseStepsXml != null)
                    {
                        testCase.TestCaseSteps = Utilities.GetObjectFromXml<TestCaseStepMiniModel>(testCase.TestCaseStepsXml, "TestCaseStepMiniModel");
                    }
                });
            }

            return testCaseList;
        }

        public List<TestRunSelectedCaseMiniModel> GetTestCasesByFilters(SearchTestCaseInputModel searchTestCaseInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get TestCases By Filters", "testCaseSearchCriteriaInputModel", searchTestCaseInputModel, "Test Suite Service"));

            if (searchTestCaseInputModel.ClearFilter == true)
            {
                return new List<TestRunSelectedCaseMiniModel>();
            }

            searchTestCaseInputModel.CreatedByFilterXml = searchTestCaseInputModel.CreatedByFilter != null && searchTestCaseInputModel.CreatedByFilter.Count > 0 ? Utilities.GetXmlFromObject(searchTestCaseInputModel.CreatedByFilter) : null;

            searchTestCaseInputModel.PriorityFilterXml = searchTestCaseInputModel.PriorityFilter != null && searchTestCaseInputModel.PriorityFilter.Count > 0 ? Utilities.GetXmlFromObject(searchTestCaseInputModel.PriorityFilter) : null;

            searchTestCaseInputModel.TemplateFilterXml = searchTestCaseInputModel.TemplateFilter != null && searchTestCaseInputModel.TemplateFilter.Count > 0 ? Utilities.GetXmlFromObject(searchTestCaseInputModel.TemplateFilter) : null;

            searchTestCaseInputModel.UpdatedByFilterXml = searchTestCaseInputModel.UpdatedByFilter != null && searchTestCaseInputModel.UpdatedByFilter.Count > 0 ? Utilities.GetXmlFromObject(searchTestCaseInputModel.UpdatedByFilter) : null;

            searchTestCaseInputModel.AutomationTypeFilterXml = searchTestCaseInputModel.AutomationTypeFilter != null && searchTestCaseInputModel.AutomationTypeFilter.Count > 0 ? Utilities.GetXmlFromObject(searchTestCaseInputModel.AutomationTypeFilter) : null;

            searchTestCaseInputModel.EstimateFilterXml = searchTestCaseInputModel.EstimateFilter != null && searchTestCaseInputModel.EstimateFilter.Count > 0 ? Utilities.GetXmlFromObject(searchTestCaseInputModel.EstimateFilter) : null;

            searchTestCaseInputModel.TypeFilterXml = searchTestCaseInputModel.TypeFilter != null && searchTestCaseInputModel.TypeFilter.Count > 0 ? Utilities.GetXmlFromObject(searchTestCaseInputModel.TypeFilter) : null;

            searchTestCaseInputModel.TestCaseIdsXml = searchTestCaseInputModel.MultipleTestCaseIds != null && searchTestCaseInputModel.MultipleTestCaseIds.Count > 0 ? Utilities.GetXmlFromObject(searchTestCaseInputModel.MultipleTestCaseIds) : null;

            searchTestCaseInputModel.StatusFilterXml = searchTestCaseInputModel.StatusFilter != null && searchTestCaseInputModel.StatusFilter.Count > 0 ? Utilities.GetXmlFromObject(searchTestCaseInputModel.StatusFilter) : null;

            var testCaseList = new List<TestRunSelectedCaseMiniModel>();

            if (searchTestCaseInputModel.IsForRuns == true)
            {
                testCaseList = _testSuitePartialRepository.GetTestRunCasesByFilters(searchTestCaseInputModel, loggedInContext, validationMessages);
            }

            else
            {
                testCaseList = _testSuitePartialRepository.GetTestCasesByFilters(searchTestCaseInputModel, loggedInContext, validationMessages);
            }

            if (validationMessages.Count > 0)
            {
                return null;
            }

            return testCaseList;
        }

        public TestCaseApiReturnModel SearchTestCaseDetailsById(SearchTestCaseDetailsInputModel searchTestCaseDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Search TestCase Details By Id", "SearchTestCaseDetailsInputModel", searchTestCaseDetailsInputModel, "Test Suite Service"));

            var testCaseDetails = _testSuitePartialRepository.SearchTestCaseDeatailsById(searchTestCaseDetailsInputModel, loggedInContext, validationMessages);


            if (testCaseDetails != null)
            {
                testCaseDetails.ReferencesList = testCaseDetails.References?.Trim().Split(',').ToList();
            }

            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (testCaseDetails != null && testCaseDetails.TestCaseStepsXml != null)
            {
                testCaseDetails.TestCaseSteps = Utilities.GetObjectFromXml<TestCaseStepMiniModel>(testCaseDetails.TestCaseStepsXml, "TestCaseStepMiniModel");
            }
            if (testCaseDetails.TestCaseHistoryXml != null)
            {
                //testCase.TestCaseHistory = Utilities.GetObjectFromXml<TestCaseHistoryMiniModel>(testCase.TestCaseHistoryXml, "TestCaseHistoryModel");
                testCaseDetails.TestCaseHistory = JsonConvert.DeserializeObject<TestCaseHistoryMiniModel[]>(testCaseDetails.TestCaseHistoryXml).ToList();
            }

            return testCaseDetails;
        }

        public List<TestRunSelectedCasesApiReturnModel> SearchTestCasesByTestRunId(SearchTestCaseInputModel searchTestCaseInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Search Test Cases By TestRunId", "testCaseSearchCriteriaInputModel", searchTestCaseInputModel, "Test Suite Service"));

            searchTestCaseInputModel.CreatedByFilterXml = searchTestCaseInputModel.CreatedByFilter != null && searchTestCaseInputModel.CreatedByFilter.Count > 0 ? Utilities.GetXmlFromObject(searchTestCaseInputModel.CreatedByFilter) : null;

            searchTestCaseInputModel.PriorityFilterXml = searchTestCaseInputModel.PriorityFilter != null && searchTestCaseInputModel.PriorityFilter.Count > 0 ? Utilities.GetXmlFromObject(searchTestCaseInputModel.PriorityFilter) : null;

            searchTestCaseInputModel.TemplateFilterXml = searchTestCaseInputModel.TemplateFilter != null && searchTestCaseInputModel.TemplateFilter.Count > 0 ? Utilities.GetXmlFromObject(searchTestCaseInputModel.TemplateFilter) : null;

            searchTestCaseInputModel.UpdatedByFilterXml = searchTestCaseInputModel.UpdatedByFilter != null && searchTestCaseInputModel.UpdatedByFilter.Count > 0 ? Utilities.GetXmlFromObject(searchTestCaseInputModel.UpdatedByFilter) : null;

            searchTestCaseInputModel.AutomationTypeFilterXml = searchTestCaseInputModel.AutomationTypeFilter != null && searchTestCaseInputModel.AutomationTypeFilter.Count > 0 ? Utilities.GetXmlFromObject(searchTestCaseInputModel.AutomationTypeFilter) : null;

            searchTestCaseInputModel.EstimateFilterXml = searchTestCaseInputModel.EstimateFilter != null && searchTestCaseInputModel.EstimateFilter.Count > 0 ? Utilities.GetXmlFromObject(searchTestCaseInputModel.EstimateFilter) : null;

            searchTestCaseInputModel.TypeFilterXml = searchTestCaseInputModel.TypeFilter != null && searchTestCaseInputModel.TypeFilter.Count > 0 ? Utilities.GetXmlFromObject(searchTestCaseInputModel.TypeFilter) : null;

            searchTestCaseInputModel.StatusFilterXml = searchTestCaseInputModel.StatusFilter != null && searchTestCaseInputModel.StatusFilter.Count > 0 ? Utilities.GetXmlFromObject(searchTestCaseInputModel.StatusFilter) : null;

            searchTestCaseInputModel.SortDirectionAsc = true;

            var testCaseList = _testSuitePartialRepository.SearchTestCasesByTestRunId(searchTestCaseInputModel, loggedInContext, validationMessages);



            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (testCaseList.Count > 0)
            {
                Parallel.ForEach(testCaseList, testCase =>
                {
                    if (testCase.TestCaseStepsXml != null)
                    {
                        //testCase.TestCaseSteps = Utilities.GetObjectFromXml<TestCaseStepMiniModel>(testCase.TestCaseStepsXml, "TestCaseStepModel");
                        testCase.TestCaseSteps = JsonConvert.DeserializeObject<TestCaseStepMiniModel[]>(testCase.TestCaseStepsXml).ToList();

                    }

                    if (testCase.TestCaseHistoryXml != null)
                    {
                        //testCase.TestCaseHistory = Utilities.GetObjectFromXml<TestCaseHistoryMiniModel>(testCase.TestCaseHistoryXml, "TestCaseHistoryModel");
                        testCase.TestCaseHistory = JsonConvert.DeserializeObject<TestCaseHistoryMiniModel[]>(testCase.TestCaseHistoryXml).ToList();
                    }
                });
            }

            return testCaseList;
        }

        public TestRunSelectedCasesApiReturnModel SearchTestRunCaseDetailsById(SearchTestCaseInputModel searchTestCaseInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Search Test Cases By TestRunId", "testCaseSearchCriteriaInputModel", searchTestCaseInputModel, "Test Suite Service"));


            var testCaseDetails = _testSuitePartialRepository.SearchTestRunCaseDetailsById(searchTestCaseInputModel, loggedInContext, validationMessages);

            testCaseDetails.ReferencesList = testCaseDetails.References?.Trim().Split(',').ToList();

            if (validationMessages.Count > 0)
            {
                return null;
            }
            else
            {
                if (testCaseDetails.TestCaseStepsXml != null)
                {
                    //testCase.TestCaseSteps = Utilities.GetObjectFromXml<TestCaseStepMiniModel>(testCase.TestCaseStepsXml, "TestCaseStepModel");
                    testCaseDetails.TestCaseSteps = JsonConvert.DeserializeObject<TestCaseStepMiniModel[]>(testCaseDetails.TestCaseStepsXml).ToList();
                }

                if (testCaseDetails.TestCaseHistoryXml != null)
                {
                    //testCase.TestCaseHistory = Utilities.GetObjectFromXml<TestCaseHistoryMiniModel>(testCase.TestCaseHistoryXml, "TestCaseHistoryModel");
                    testCaseDetails.TestCaseHistory = JsonConvert.DeserializeObject<TestCaseHistoryMiniModel[]>(testCaseDetails.TestCaseHistoryXml).ToList();
                }
            }
            return testCaseDetails;
        }

        public List<Guid> UpdateMultipleTestCases(TestCaseInputModel testCaseInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Update Multiple Test Cases", "testCaseInputModel", testCaseInputModel, "Test Suite Service"));

            _testSuiteValidationHelper.UpdateMultipleTestCasesCheckValidation(loggedInContext, validationMessages, testCaseInputModel);

            var testCaseIdsXml = string.Empty;
            var testCaseStepsXml = string.Empty;

            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (testCaseInputModel.TestCaseIds != null)
            {
                testCaseIdsXml = Utilities.GetXmlFromObject(testCaseInputModel.TestCaseIds);
            }

            if (testCaseInputModel.TestCaseSteps != null)
            {
                testCaseStepsXml = Utilities.GetXmlFromObject(testCaseInputModel.TestCaseSteps);
            }

            var testCaseList = _testSuitePartialRepository.UpdateMultipleTestCases(testCaseInputModel, loggedInContext, testCaseIdsXml, testCaseStepsXml, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (testCaseList.Count > 0)
            {
                _auditService.SaveAudit(AppCommandConstants.UpdateMultipleTestCasesCommandId, testCaseInputModel, loggedInContext);

                LoggingManager.Debug("Multiple test Cases has been updated successfully");

                return testCaseList;
            }

            return null;
        }

        public TestCaseApiReturnModel GetTestCaseById(Guid? testCaseId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, bool RequireBasicInfoOnly = false)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get TestCase By Id", "testCaseId", testCaseId, "TestSuite Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetTestCaseByIdCommandId, testCaseId, loggedInContext);

            SearchTestCaseDetailsInputModel searchTestCaseInputModel = new SearchTestCaseDetailsInputModel
            {
                TestCaseId = testCaseId,
                IsArchived = false
            };

            var testCaseModel = _testSuitePartialRepository.SearchTestCaseDeatailsById(searchTestCaseInputModel, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (testCaseModel != null && testCaseModel.TestCaseStepsXml != null)
            {
                if (testCaseModel.TestCaseStepsXml != null)
                {
                    testCaseModel.TestCaseSteps = Utilities.GetObjectFromXml<TestCaseStepMiniModel>(testCaseModel.TestCaseStepsXml, "TestCaseStepMiniModel");
                }
            }

            if (!RequireBasicInfoOnly && testCaseModel != null)
            {
                if (testCaseModel.TestCaseSteps != null)
                {

                    foreach (var step in testCaseModel.TestCaseSteps)
                    {
                        var stepTestRailFileModel = new TestRailFileModel
                        {
                            TestRailId = step.StepId,
                            IsTestCaseStep = true
                        };
                        var stepConditionFiles = _testRailFileService.SearchTestRailFiles(stepTestRailFileModel, loggedInContext);

                        var stepConditionFilePaths = new List<string>();

                        foreach (var file in stepConditionFiles)
                        {
                            stepConditionFilePaths.Add(file.FilePath);
                        }

                        step.StepFilePaths = stepConditionFilePaths;
                    }
                }

                var consTestRailFileModel = new TestRailFileModel
                {
                    TestRailId = testCaseId,
                    IsTestCasePreCondition = true
                };

                var preConditionFiles = _testRailFileService.SearchTestRailFiles(consTestRailFileModel, loggedInContext);

                var preConditionFilePaths = new List<string>();

                foreach (var file in preConditionFiles)
                {
                    preConditionFilePaths.Add(file.FilePath);
                }

                testCaseModel.PreConditionFilePaths = preConditionFilePaths;

                var testRailFileModel = new TestRailFileModel
                {
                    TestRailId = testCaseId,
                    IsTestCase = true
                };

                var testCaseFiles = _testRailFileService.SearchTestRailFiles(testRailFileModel, loggedInContext);

                var filePaths = new List<string>();

                foreach (var file in testCaseFiles)
                {
                    filePaths.Add(file.FilePath);
                }

                testCaseModel.FilePaths = filePaths;
            }

            return testCaseModel;
        }

        public List<DropdownModel> GetSectionsAndSubsections(Guid? suiteId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Sections And Subsections", "testSuiteId", suiteId, "TestSuite Service"));

            _testSuiteValidationHelper.GetSectionsAndSubSectionsCheckValidation(loggedInContext, validationMessages, suiteId);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetSectionsAndSubSectionsCommandId, suiteId, loggedInContext);

            List<DropdownModel> sectionsAndSubsectionsList = _testSuitePartialRepository.GetSectionsAndSubsections(suiteId, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            return sectionsAndSubsectionsList;
        }

        public int? GetTestSuiteCount(Guid? projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Test Suite Count", "ProjectId", projectId, "Test Suite Service"));

            _testSuiteValidationHelper.ProjectIdValidation(loggedInContext, validationMessages, projectId);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            var testSuiteSearchCriteriaInputModel = new TestSuiteSearchCriteriaInputModel
            {
                ProjectId = projectId,
                PageNumber = 1
            };

            var testSuiteList = _testSuitePartialRepository.SearchTestSuites(testSuiteSearchCriteriaInputModel, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetTestSuiteCountCommandId, projectId, loggedInContext);

            return testSuiteList.Count > 0 ? testSuiteList[0].TotalCount : null;
        }

        public int? GetTestCasesCountByProject(Guid? projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get TestCases Count By Project", "ProjectId", projectId, "TestSuite Service"));

            _testSuiteValidationHelper.ProjectIdValidation(loggedInContext, validationMessages, projectId);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetTestCasesCountByProjectCommandId, projectId, loggedInContext);

            var testRailCounts = _testSuitePartialRepository.GetTestRailOverviewCountsByProjectId(projectId, loggedInContext, validationMessages);

            return validationMessages.Count > 0 ? null : testRailCounts.CasesCount;
        }

        public TestRailOverviewCountsModel GetTestRailOverviewCountsByProjectId(Guid? projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get TestRail Overview Counts By ProjectId", "ProjectId", projectId, "TestSuite Service"));

            _testSuiteValidationHelper.ProjectIdValidation(loggedInContext, validationMessages, projectId);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetTestRailOverviewCountsByProjectIdCommandId, projectId, loggedInContext);

            TestRailOverviewCountsModel testRailOverviewCounts = _testSuitePartialRepository.GetTestRailOverviewCountsByProjectId(projectId, loggedInContext, validationMessages);

            return validationMessages.Count > 0 ? null : testRailOverviewCounts;
        }

        public Guid? UpsertTestCaseStatusMasterValue(TestCaseStatusMasterDataInputModel testCaseStatusMasterDataInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert TestCase Status Master Value", "testCaseStatusMasterDataInputModel", testCaseStatusMasterDataInputModel, "Test Suite Service"));

            _testSuiteValidationHelper.UpsertTestCaseStatusMasterValueValidation(loggedInContext, validationMessages, testCaseStatusMasterDataInputModel);

            if (validationMessages.Count > 0)
            {
                return null;
            }
            if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                testCaseStatusMasterDataInputModel.TimeZone = userTimeDetails?.TimeZone;
            }
            if (testCaseStatusMasterDataInputModel.TimeZone == null)
            {
                var indianTimeDetails = TimeZoneHelper.GetIstTime();
                testCaseStatusMasterDataInputModel.TimeZone = indianTimeDetails?.TimeZone;
            }

            Guid? statusId = _testSuitePartialRepository.UpsertTestCaseStatusMasterValue(testCaseStatusMasterDataInputModel, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (statusId != Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert TestCase Status Master Value audit saving", "Test suite Service"));

                _auditService.SaveAudit(AppCommandConstants.UpsertTestCaseStatusMasterValueCommandId, testCaseStatusMasterDataInputModel, loggedInContext);

                if (testCaseStatusMasterDataInputModel.StatusId == statusId)
                {
                    LoggingManager.Debug("Test Case Status Master Value is updated Successfully with the Id : " + testCaseStatusMasterDataInputModel.StatusId);
                }
                else
                {
                    LoggingManager.Debug("Test Case Status Master Value is created Successfully with the Id : " + testCaseStatusMasterDataInputModel.StatusId);
                }
                return statusId;
            }
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert TestCase Status Master Value Failed", "Test suite Service"));

            return null;
        }

        public Guid? UpsertTestRailConfiguration(TestRailConfigurationInputModel testRailConfigurationInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert TestCase Status Master Value", "testRailConfigurationInputModel", testRailConfigurationInputModel, "Test Suite Service"));

            Guid? configurationId = _testSuitePartialRepository.UpsertTestRailConfiguration(testRailConfigurationInputModel, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }
            if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                testRailConfigurationInputModel.TimeZone = userTimeDetails?.TimeZone;
            }
            if (testRailConfigurationInputModel.TimeZone == null)
            {
                var indianTimeDetails = TimeZoneHelper.GetIstTime();
                testRailConfigurationInputModel.TimeZone = indianTimeDetails?.TimeZone;
            }


            if (configurationId != Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert TestRail Configuration audit saving", "Test suite Service"));

                _auditService.SaveAudit(AppCommandConstants.UpsertTestRailConfigurationCommandId, testRailConfigurationInputModel, loggedInContext);

                if (testRailConfigurationInputModel.TestRailConfigurationId == configurationId)
                {
                    LoggingManager.Debug("Test rail Configuration is updated Successfully with the Id : " + testRailConfigurationInputModel.TestRailConfigurationId);
                }
                else
                {
                    LoggingManager.Debug("Test rail Configuration is created Successfully with the Id : " + testRailConfigurationInputModel.TestRailConfigurationId);
                }
                return configurationId;
            }
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Test rail Configuration Failed", "Test suite Service"));

            return null;
        }

        public Guid? UpsertTestCaseTypeMasterValue(TestRailMasterDataModel testRailMasterDataInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert TestCase Type Master Value", "testRailMasterDataInputModel", testRailMasterDataInputModel, "Test Suite Service"));

            _testSuiteValidationHelper.UpsertTestCaseTypeMasterValueValidation(loggedInContext, validationMessages, testRailMasterDataInputModel);

            if (validationMessages.Count > 0)
            {
                return null;
            }
            if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                testRailMasterDataInputModel.TimeZone = userTimeDetails?.TimeZone;
            }
            if (testRailMasterDataInputModel.TimeZone == null)
            {
                var indianTimeDetails = TimeZoneHelper.GetIstTime();
                testRailMasterDataInputModel.TimeZone = indianTimeDetails?.TimeZone;
            }


            Guid? typeId = _testSuitePartialRepository.UpsertTestCaseTypeMasterValue(testRailMasterDataInputModel, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (typeId != null)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert TestCase Type Master Value audit saving", "Test suite Service"));

                _auditService.SaveAudit(AppCommandConstants.UpsertTestCaseTypeMasterValueCommandId, testRailMasterDataInputModel, loggedInContext);

                if (testRailMasterDataInputModel.Id == typeId)
                {
                    LoggingManager.Debug("Test Case Status Type Value is updated Successfully with the Id : " + testRailMasterDataInputModel.Id);
                }
                else
                {
                    LoggingManager.Debug("Test Case Status Type Value is inserted Successfully with the Id : " + testRailMasterDataInputModel.Id);
                }

                return typeId;
            }
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert TestCase Type Master Value Failed", "Test suite Service"));

            return null;
        }

        public Guid? UpsertTestCasePriorityMasterValue(TestRailMasterDataModel testRailMasterDataInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert TestCase Priority Master Value", "testRailMasterDataInputModel", testRailMasterDataInputModel, "Test Suite Service"));

            _testSuiteValidationHelper.UpsertTestCasePriorityMasterValueValidation(loggedInContext, validationMessages, testRailMasterDataInputModel);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            Guid? priorityId = _testSuitePartialRepository.UpsertTestCasePriorityMasterValue(testRailMasterDataInputModel, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (priorityId != null)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert TestCase Priority Master Value audit saving", "Test suite Service"));

                _auditService.SaveAudit(AppCommandConstants.UpsertTestCasePriorityMasterValueCommandId, testRailMasterDataInputModel, loggedInContext);

                if (testRailMasterDataInputModel.Id == priorityId)
                {
                    LoggingManager.Debug("Test Case priority Value is updated successfully with the Id:" + priorityId);
                }
                else
                {
                    LoggingManager.Debug("Test Case priority Value is created successfully with the Id:" + priorityId);
                }

                return priorityId;
            }
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert TestCase Priority Master Value Failed", "Test suite Service"));

            return null;
        }

        public List<DropdownModel> GetAllTestCaseStatuses(TestCaseStatusMasterDataModel testCaseStatusMasterDataModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get All Test Case Status", "TestSuite Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.GetAllTestCaseStatusesCommandId, testCaseStatusMasterDataModel, loggedInContext);

            List<TestCaseStatusMasterDataModel> statusesDetailedList = _testSuitePartialRepository.GetAllTestCaseStatuses(testCaseStatusMasterDataModel, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            List<DropdownModel> statuses = statusesDetailedList.Select(x => new DropdownModel { Id = x.StatusId, Value = x.Status, TimeStamp = x.TimeStamp, TestCaseStatus = x.TestCaseStatus, StatusHexValue = x.StatusHexValue, StatusShortName = x.StatusShortName }).ToList();

            return statuses;
        }

        public List<DropdownModel> GetAllTestCaseTypes(TestRailMasterDataModel testRailMasterDataModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get All Test Case Type", "testRailMasterDataModel", testRailMasterDataModel, "TestSuite Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.GetAllTestCaseTypesCommandId, testRailMasterDataModel, loggedInContext);

            List<TestRailMasterDataModel> typesDetailedList = _testSuitePartialRepository.GetAllTestCaseTypes(testRailMasterDataModel, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            List<DropdownModel> types = typesDetailedList.Select(x => new DropdownModel { Id = x.Id, Value = x.Value, TestCaseType = x.TestCaseType, TimeStamp = x.TimeStamp, IsDefault = x.IsDefault }).ToList();

            return types;
        }

        public List<DropdownModel> GetAllTestCasePriorities(TestRailMasterDataModel testRailMasterDataModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get All Test Case Priorities", "testRailMasterDataModel", testRailMasterDataModel, "TestSuite Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.GetAllTestCasePrioritiesCommandId, testRailMasterDataModel, loggedInContext);

            List<TestRailMasterDataModel> prioritiesDetailedList = _testSuitePartialRepository.GetAllTestCasePriorities(testRailMasterDataModel, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            List<DropdownModel> priorities = prioritiesDetailedList.Select(x => new DropdownModel { Id = x.Id, Value = x.Value }).ToList();

            return priorities;
        }

        public TestCaseStatusMasterDataModel GetTestCaseStatusMasterDataById(Guid? statusId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Test Case Status Master Data By Id", "TestSuite Service"));

            _testSuiteValidationHelper.TestCaseStatusIdValidation(loggedInContext, validationMessages, statusId);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            TestCaseStatusMasterDataModel testCaseStatusMasterDataModel = new TestCaseStatusMasterDataModel
            {
                StatusId = statusId
            };

            _auditService.SaveAudit(AppCommandConstants.GetTestCaseStatusMasterDataByIdCommandId, statusId, loggedInContext);

            var testCaseStatuses = _testSuitePartialRepository.GetAllTestCaseStatuses(testCaseStatusMasterDataModel, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            return testCaseStatuses.Count > 0 ? testCaseStatuses[0] : null;
        }

        public List<TestRailConfigurationReturnModel> GetTestRailConfigurations(TestRailConfigurationInputModel testRailConfigurationInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetTestRailConfigurations", "TestSuite Service"));

            _auditService.SaveAudit(AppCommandConstants.GetTestRailConfigurationsCommandId, testRailConfigurationInputModel, loggedInContext);

            List<TestRailConfigurationReturnModel> testRailConfigurations = _testSuitePartialRepository.GetTestRailConfigurations(testRailConfigurationInputModel, loggedInContext, validationMessages).ToList();

            if (validationMessages.Count > 0)
            {
                return null;
            }

            return testRailConfigurations;
        }

        public TestRailMasterDataModel GetTestCaseTypeMasterDataById(Guid? typeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Test Case Type Master Data By Id", "TestSuite Service"));

            _testSuiteValidationHelper.TestCaseTypeIdValidation(loggedInContext, validationMessages, typeId);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetTestCaseTypeMasterDataByIdCommandId, typeId, loggedInContext);

            TestRailMasterDataModel testRailMasterDataModel = new TestRailMasterDataModel
            {
                Id = typeId
            };

            List<TestRailMasterDataModel> typesList = _testSuitePartialRepository.GetAllTestCaseTypes(testRailMasterDataModel, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (typesList.Count > 0)
            {
                return typesList[0];
            }

            validationMessages.Add(new ValidationMessage
            {
                ValidationMessageType = MessageTypeEnum.Error,
                ValidationMessaage = string.Format(ValidationMessages.NotFoundTestCaseTypeWithTheId, typeId)
            });

            return null;
        }

        public TestRailMasterDataModel GetTestCasePriorityMasterDataById(Guid? priorityId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Test Case Priority Master Data By Id", "TestSuite Service"));

            _testSuiteValidationHelper.TestCasePriorityIdValidation(loggedInContext, validationMessages, priorityId);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetTestCasePriorityMasterDataByIdCommandId, priorityId, loggedInContext);

            TestRailMasterDataModel testRailMasterDataModel = new TestRailMasterDataModel
            {
                Id = priorityId
            };

            List<TestRailMasterDataModel> priorities = _testSuitePartialRepository.GetAllTestCasePriorities(testRailMasterDataModel, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (priorities.Count > 0)
            {
                return priorities[0];
            }

            validationMessages.Add(new ValidationMessage
            {
                ValidationMessageType = MessageTypeEnum.Error,
                ValidationMessaage = string.Format(ValidationMessages.NotFoundTestCasePriorityWithTheId, priorityId)
            });

            return null;
        }

        public List<DropdownModel> GetAllTestCaseTemplates(TestRailMasterDataModel testRailMasterDataModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get All Test Case Templates", "testRailMasterDataModel", testRailMasterDataModel, "TestSuite Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.GetAllTestCaseTemplatesCommandId, testRailMasterDataModel, loggedInContext);

            List<TestRailMasterDataModel> templatesDetailedList = _testSuitePartialRepository.GetAllTestCaseTemplates(testRailMasterDataModel, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            List<DropdownModel> templates = templatesDetailedList.Select(x => new DropdownModel { Id = x.Id, Value = x.Value }).ToList();

            return templates;
        }


        public List<UploadTestCasesFromExcelModel> ProcessExcelData(string projectName, Stream fileStream, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Process Excel Data", "Process Excel Data"));

            var excelResult = new List<UploadTestCasesFromExcelModel>();

            using (var excelPackage = new ExcelPackage(fileStream))
            {
                var worksheet = excelPackage.Workbook.Worksheets[1];

                int rowsCount = worksheet.Dimension.End.Row;

                for (int i = 2; i <= rowsCount; i++)
                {
                    var row = new UploadTestCasesFromExcelModel
                    {
                        ID = worksheet.Cells[i, 1]?.Text ?? string.Empty,
                        Title = worksheet.Cells[i, 2]?.Text ?? string.Empty,
                        AutomationType = worksheet.Cells[i, 3]?.Text ?? string.Empty,
                        CreatedBy = worksheet.Cells[i, 4]?.Text ?? string.Empty,
                        CreatedOn = worksheet.Cells[i, 5]?.Text ?? string.Empty,
                        Estimate = worksheet.Cells[i, 6]?.Text ?? string.Empty,
                        ExpectedResult = worksheet.Cells[i, 7]?.Text ?? string.Empty,
                        Forecast = worksheet.Cells[i, 8]?.Text ?? string.Empty,
                        Goals = worksheet.Cells[i, 9]?.Text ?? string.Empty,
                        Mission = worksheet.Cells[i, 10]?.Text ?? string.Empty,
                        Preconditions = worksheet.Cells[i, 11]?.Text ?? string.Empty,
                        Priority = worksheet.Cells[i, 12]?.Text ?? string.Empty,
                        References = worksheet.Cells[i, 13]?.Text ?? string.Empty,
                        Section = worksheet.Cells[i, 14]?.Text ?? string.Empty,
                        SectionDepth = worksheet.Cells[i, 15]?.Text ?? string.Empty,
                        SectionDescription = worksheet.Cells[i, 16]?.Text ?? string.Empty,
                        SectionHierarchy = worksheet.Cells[i, 17]?.Text ?? string.Empty,
                        Steps = worksheet.Cells[i, 18]?.Text ?? string.Empty,
                        InlineSteps = worksheet.Cells[i, 19]?.Text ?? string.Empty,
                        StepsExpectedResult = worksheet.Cells[i, 20]?.Text ?? string.Empty,
                        StepText = worksheet.Cells[i, 21]?.Text ?? string.Empty,
                        Suite = worksheet.Cells[i, 22]?.Text ?? string.Empty,

                        Template = worksheet.Cells[i, 24]?.Text ?? string.Empty,
                        Type = worksheet.Cells[i, 25]?.Text ?? string.Empty,
                        UpdatedBy = worksheet.Cells[i, 26]?.Text ?? string.Empty,
                        UpdatedOn = worksheet.Cells[i, 27]?.Text ?? string.Empty
                    };

                    List<TestCaseStepMiniModel> testCaseStepMiniModels = new List<TestCaseStepMiniModel>();

                    var stepTextMatches = Regex.Matches(row.StepText, @"([\d]+\. )(.*?)(?=([\d]+\.)|($))", RegexOptions.Singleline);

                    var stepExpectedResultMatches = Regex.Matches(row.StepsExpectedResult, @"([\d]+\. )(.*?)(?=([\d]+\.)|($))", RegexOptions.Singleline);

                    for (int j = 0; j < stepExpectedResultMatches.Count; j++)
                    {
                        TestCaseStepMiniModel testCaseStepMiniModel = new TestCaseStepMiniModel
                        {
                            StepText = stepTextMatches[j].Groups[2].Value,
                            StepExpectedResult = stepExpectedResultMatches[j].Groups[2].Value
                        };

                        testCaseStepMiniModels.Add(testCaseStepMiniModel);
                    }

                    row.TestCaseStepsXml = Utilities.GetXmlFromObject(testCaseStepMiniModels);

                    var testCaseId = _testSuitePartialRepository.UploadTestCases(projectName, row, loggedInContext, validationMessages);

                    if (validationMessages.Count > 0)
                    {
                        return null;
                    }

                    if (testCaseId != null)
                    {
                        excelResult.Add(row);
                    }
                }
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Process Excel Data", "Excel import"));

            return excelResult;
        }

        public TestSuiteCasesOverviewModel GetTestSuiteCasesOverview(TestSuiteCasesOverviewInputModel testSuiteCasesOverviewInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get TestSuite Cases Overview", "TestSuiteCasesOverviewInputModel", testSuiteCasesOverviewInputModel, "Test Suite Service"));

            _testSuiteValidationHelper.TestSuiteIdValidation(testSuiteCasesOverviewInputModel.TestSuiteId, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetTestSuiteCasesOverviewCommandId, testSuiteCasesOverviewInputModel, loggedInContext);

            TestSuiteSectionSearchCriteriaInputModel testSuiteSectionSearchCriteriaInputModel = new TestSuiteSectionSearchCriteriaInputModel
            {
                TestSuiteId = testSuiteCasesOverviewInputModel.TestSuiteId,
                TestRunId = testSuiteCasesOverviewInputModel.TestRunId,
                IsArchived = false,
                IsSectionsRequired = testSuiteCasesOverviewInputModel.IsSectionsRequired,
                TestSuiteSectionId = testSuiteCasesOverviewInputModel.SectionId
            };

            var sectionsList = _testSuitePartialRepository.SearchTestSuiteSectionsWithParentSetionId(testSuiteSectionSearchCriteriaInputModel, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            var sectionHierarchy = new List<TestSuiteSectionOverviewModel>();
            var testSuiteName = string.Empty;
            var testSuiteDescription = string.Empty;
            var casesCount = 0;
            var sectionsCount = 0;

            if (sectionsList.Count > 1)
            {
                testSuiteName = sectionsList[0].TestSuiteName;
                testSuiteDescription = sectionsList[0].TestSuiteDescription;
                sectionsCount = sectionsList[0].TotalCount ?? 0;
                casesCount = sectionsList.Sum(p => p.CasesCount);
                sectionHierarchy = GenerateSectionHierarchy(sectionsList, null, 0);
            }
            else if (sectionsList.Count == 1)
            {
                testSuiteName = sectionsList[0].TestSuiteName;
                testSuiteDescription = sectionsList[0].TestSuiteDescription;
                sectionsCount = sectionsList[0].TotalCount ?? 0;
                casesCount = sectionsList.Sum(p => p.CasesCount);
                sectionHierarchy = new List<TestSuiteSectionOverviewModel>()
               {
                   new TestSuiteSectionOverviewModel()
                   {
                       SectionName = sectionsList[0].SectionName,
                       SectionId = sectionsList[0].TestSuiteSectionId,
                       CasesCount = sectionsList[0].CasesCount,
                       ParentSectionId = sectionsList[0].ParentSectionId,
                       Description = sectionsList[0].Description,
                       TimeStamp = sectionsList[0].TimeStamp,
                       SectionLevel = sectionsList[0].SectionLevel,
                       SectionEstimate = sectionsList[0].SectionEstimate

                   }
               };
            }

            if (!string.IsNullOrEmpty(testSuiteName))
            {
                TestSuiteCasesOverviewModel testSuiteCasesOverviewModel = new TestSuiteCasesOverviewModel
                {
                    TestSuiteName = testSuiteName,
                    TestSuiteId = testSuiteCasesOverviewInputModel.TestSuiteId,
                    Description = testSuiteDescription,
                    SectionsCount = sectionsCount,
                    CasesCount = casesCount,
                    Sections = sectionHierarchy.Count > 0 ? sectionHierarchy : null
                };

                if (testSuiteCasesOverviewInputModel.IncludeRunCases == true && testSuiteCasesOverviewInputModel.TestRunId != null && testSuiteCasesOverviewInputModel.TestRunId != Guid.Empty)
                {
                    var selectedCases = _testSuitePartialRepository.GetTestRunSelectedCases(testSuiteCasesOverviewInputModel.TestRunId, loggedInContext, validationMessages);

                    if (validationMessages.Count > 0)
                    {
                        return null;
                    }

                    if (selectedCases != null && selectedCases.Count > 0)
                    {
                        testSuiteCasesOverviewModel.TestRunSelectedCases = selectedCases;
                    }
                    var selectedSections = _testSuitePartialRepository.GetTestRunSelectedSections(testSuiteCasesOverviewInputModel.TestRunId, loggedInContext, validationMessages);

                    if (validationMessages.Count > 0)
                    {
                        return null;
                    }

                    if (selectedSections != null && selectedSections.Count > 0)
                    {
                        testSuiteCasesOverviewModel.TestRunSelectedSections = selectedSections;
                    }

                }
                return testSuiteCasesOverviewModel;
            }
            return null;
        }

        public TestCasesHierarchyApiReturnModel GetTestCasesHierarchy(SearchTestCaseInputModel searchTestCaseInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get TestCases Hierarchy", "SearchTestCaseInputModel", searchTestCaseInputModel, "Test Suite Service"));

            _auditService.SaveAudit(AppCommandConstants.GetTestSuiteCasesOverviewCommandId, searchTestCaseInputModel, loggedInContext);

            var testCases = SearchTestCases(searchTestCaseInputModel, loggedInContext, validationMessages);

            var testCasesHierarchyApiReturnModel = new TestCasesHierarchyApiReturnModel();


            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (testCases.Count > 0)
            {
                testCasesHierarchyApiReturnModel.TestCases = testCases;
            }

            var testSuiteSections = _testSuitePartialRepository.GetTestSuiteSections(searchTestCaseInputModel, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (testSuiteSections.Count > 0)
            {
                testCasesHierarchyApiReturnModel.TestSuiteSections = testSuiteSections;
            }
            return null;
        }


        private List<TestSuiteSectionOverviewModel> GenerateSectionHierarchy(List<TestSuiteSectionApiReturnModel> testSuiteSections, Guid? parentSectionId, int sectionLevel)
        {
            return testSuiteSections.Where(x => x.ParentSectionId.Equals(parentSectionId)).Select(sectionDetails => new TestSuiteSectionOverviewModel
            {
                SectionName = sectionDetails.SectionName,
                SectionId = sectionDetails.TestSuiteSectionId,
                SectionLevel = sectionLevel,
                CasesCount = sectionDetails.CasesCount,
                ParentSectionId = parentSectionId,
                Description = sectionDetails.Description,
                TimeStamp = sectionDetails.TimeStamp,
                SectionEstimate = sectionDetails.SectionEstimate,
                SubSections = GenerateSectionHierarchy(testSuiteSections, sectionDetails.TestSuiteSectionId, sectionLevel + 1)
            }).ToList();
        }

        public IList<TestSuiteSectionOverviewModel> BuildSectionTree(IEnumerable<TestSuiteSectionOverviewModel> testSuiteSectionOverviewModels, bool includeTestCases, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            List<IGrouping<Guid?, TestSuiteSectionOverviewModel>> groupOftestSuiteSections = testSuiteSectionOverviewModels.GroupBy(i => i.ParentSectionId).ToList();

            IGrouping<Guid?, TestSuiteSectionOverviewModel> groupFirstOrDefault = groupOftestSuiteSections.FirstOrDefault(g => g.Key.HasValue == false);

            if (groupFirstOrDefault != null)
            {
                List<TestSuiteSectionOverviewModel> apiReturnModels = groupFirstOrDefault.ToList();

                SearchTestCaseInputModel searchTestCaseInputModel = new SearchTestCaseInputModel
                {
                    IsArchived = false
                };

                if (apiReturnModels.Count > 0)
                {
                    Dictionary<Guid, List<TestSuiteSectionOverviewModel>> dictionary = groupOftestSuiteSections.Where(g => g.Key.HasValue).ToDictionary(g => g.Key.Value, g => g.ToList());

                    foreach (var apiReturnModel in apiReturnModels)
                    {
                        AddChildren(apiReturnModel, dictionary, loggedInContext, validationMessages);

                        if (validationMessages.Count > 0)
                        {
                            return null;
                        }

                        searchTestCaseInputModel.SectionId = apiReturnModel.SectionId;
                        if (includeTestCases)
                        {
                            apiReturnModel.TestCases = _testSuitePartialRepository.SearchTestCases(searchTestCaseInputModel, loggedInContext, validationMessages);
                        }
                        if (validationMessages.Count > 0)
                        {
                            return null;
                        }
                    }
                }

                return apiReturnModels;
            }
            return new List<TestSuiteSectionOverviewModel>();
        }

        private void AddChildren(TestSuiteSectionOverviewModel node, IDictionary<Guid, List<TestSuiteSectionOverviewModel>> source, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            SearchTestCaseInputModel searchTestCaseInputModel = new SearchTestCaseInputModel
            {
                IsArchived = false
            };

            if (node.SectionId != null && source.ContainsKey(node.SectionId.Value))
            {
                searchTestCaseInputModel.SectionId = node.SectionId;

                node.TestCases = _testSuitePartialRepository.SearchTestCases(searchTestCaseInputModel, loggedInContext, new List<ValidationMessage>());

                node.SubSections = source[node.SectionId.Value];

                foreach (var subsection in node.SubSections)
                {
                    searchTestCaseInputModel.SectionId = subsection.SectionId;

                    subsection.TestCases = _testSuitePartialRepository.SearchTestCases(searchTestCaseInputModel, loggedInContext, validationMessages);

                    AddChildren(subsection, source, loggedInContext, validationMessages);
                }
            }
            else
            {
                node.SubSections = new List<TestSuiteSectionOverviewModel>();
            }
        }

        private TestSuiteSectionOverviewModel ConvertToTestSuiteSectionOverviewModel(TestSuiteSectionApiReturnModel testSuiteSectionApiReturnModel)
        {
            TestSuiteSectionOverviewModel testSuiteSectionOverviewModel = new TestSuiteSectionOverviewModel
            {
                SectionName = testSuiteSectionApiReturnModel.SectionName,
                SectionId = testSuiteSectionApiReturnModel.TestSuiteSectionId,
                ParentSectionId = testSuiteSectionApiReturnModel.ParentSectionId,
                Description = testSuiteSectionApiReturnModel.Description,
                CasesCount = testSuiteSectionApiReturnModel.CasesCount,
                SectionLevel = testSuiteSectionApiReturnModel.SectionLevel,
                IsSelectedSection = testSuiteSectionApiReturnModel.IsSelectedSection,
                TimeStamp = testSuiteSectionApiReturnModel.TimeStamp
            };

            return testSuiteSectionOverviewModel;
        }

        public Guid? DeleteTestSuite(Guid? testSuiteId, byte[] timeStamp, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Delete Test Suite", "testSuiteId", testSuiteId, "Test Suite Service"));

            _testSuiteValidationHelper.TestSuiteIdValidation(testSuiteId, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.DeleteTestSuiteCommandId, testSuiteId, loggedInContext);

            TestSuiteInputModel testSuiteInputModel = new TestSuiteInputModel
            {
                TestSuiteId = testSuiteId,
                TimeStamp = timeStamp
            };

            var testsuiteId = _testSuitePartialRepository.DeleteTestSuite(testSuiteInputModel, loggedInContext, validationMessages);

            return validationMessages.Count > 0 ? null : testsuiteId;
        }

        public Guid? DeleteTestSuiteSection(Guid? sectionId, byte[] timeStamp, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Delete Test Suite Section", "sectionId", sectionId, "Test Suite Service"));

            _testSuiteValidationHelper.TestSuiteSectionIdValidation(sectionId, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.DeleteTestSuiteSectionCommandId, sectionId, loggedInContext);

            TestSuiteSectionInputModel testSuiteSectionInputModel = new TestSuiteSectionInputModel
            {
                TestSuiteSectionId = sectionId,
                TimeStamp = timeStamp
            };


            var archivedSectionId = _testSuitePartialRepository.DeleteTestSuiteSection(testSuiteSectionInputModel, loggedInContext, validationMessages);

            return validationMessages.Count > 0 ? null : archivedSectionId;
        }

        public string DeleteTestCase(TestCaseInputModel testCaseInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Delete Test Case", "testCaseId", testCaseInputModel, "Test Suite Service"));

            _auditService.SaveAudit(AppCommandConstants.DeleteTestCaseCommandId, testCaseInputModel, loggedInContext);

            var archivedTestCaseId = _testSuitePartialRepository.DeleteTestCase(testCaseInputModel, loggedInContext, validationMessages);

            return validationMessages.Count > 0 ? null : archivedTestCaseId;
        }

        private string GetSectionHierarchyText(string text, string name)
        {
            if (string.IsNullOrEmpty(text) || string.IsNullOrWhiteSpace(text))
            {
                return string.Empty;
            }
            var Tname = $"/{name}/";
            //var index = text.IndexOf(name);
            //if(index != null && index >= 0 )
            //{
            //    text = text.Remove(0, name.Length);
            //}
            text = text.Replace(Tname, "").Replace("/", ">");
            //text = text.Remove(0, 1);
            return text;
        }

        public bool UploadTestSuiteFromCsv(string projectName, HttpRequest httpRequest, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UploadTestSuiteFromCsv", "projectName", projectName, "Test Suite Service"));

            var fileExtension = Path.GetExtension(httpRequest.Files[0].FileName);
            List<TestSuiteCsvExtractModel> testCaseRecords = new List<TestSuiteCsvExtractModel>();

            if (fileExtension.Contains(".xlsx"))
            {
                using (var excelPackage = new ExcelPackage(httpRequest.InputStream))
                {
                    var worksheet = excelPackage.Workbook.Worksheets[1];

                    int rowsCount = worksheet.Dimension.End.Row;

                    for (int i = 2; i <= rowsCount; i++)
                    {
                        TestSuiteCsvExtractModel row;

                        if (httpRequest.Files[0].FileName.Contains("btrak_"))
                        {
                            row = new TestSuiteCsvExtractModel
                            {
                                SuiteName = i == 2 ? worksheet.Name ?? string.Empty : string.Empty,
                                SectionHierarchy = GetSectionHierarchyText(worksheet.Cells[i, 10]?.Text, worksheet.Name) ?? string.Empty,
                                SectionDescription = string.Empty,
                                Template = "Test Case (Steps)",
                                Type = "Performance",
                                Preconditions = worksheet.Cells[i, 7]?.Text ?? string.Empty,
                                Title = worksheet.Cells[i, 3]?.Text ?? string.Empty,
                                StepOrder = string.Empty,
                                StepDescription = worksheet.Cells[i, 4]?.Text ?? string.Empty,
                                StepsExpectedResult = worksheet.Cells[i, 6]?.Text ?? string.Empty,
                                EstimateInSeconds = string.Empty,
                                Priority = worksheet.Cells[i, 11]?.Text ?? string.Empty,
                                AutomationType = string.Empty,
                                References = string.Empty,
                                Mission = string.Empty,
                                Goals = string.Empty
                            };
                        }
                        else
                        {
                            row = new TestSuiteCsvExtractModel
                            {
                                SuiteName = worksheet.Cells[i, 1]?.Text ?? string.Empty,
                                SectionHierarchy = worksheet.Cells[i, 2]?.Text ?? string.Empty,
                                SectionDescription = worksheet.Cells[i, 3]?.Text ?? string.Empty,
                                Template = worksheet.Cells[i, 4]?.Text ?? string.Empty,
                                Type = worksheet.Cells[i, 5]?.Text ?? string.Empty,
                                Preconditions = worksheet.Cells[i, 6]?.Text ?? string.Empty,
                                Title = worksheet.Cells[i, 7]?.Text ?? string.Empty,
                                StepOrder = worksheet.Cells[i, 8]?.Text ?? string.Empty,
                                StepDescription = worksheet.Cells[i, 9]?.Text ?? string.Empty,
                                StepsExpectedResult = worksheet.Cells[i, 10]?.Text ?? string.Empty,
                                EstimateInSeconds = worksheet.Cells[i, 11]?.Text ?? string.Empty,
                                Priority = worksheet.Cells[i, 12]?.Text ?? string.Empty,
                                AutomationType = worksheet.Cells[i, 13]?.Text ?? string.Empty,
                                References = worksheet.Cells[i, 14]?.Text ?? string.Empty,
                                Mission = worksheet.Cells[i, 15]?.Text ?? string.Empty,
                                Goals = worksheet.Cells[i, 16]?.Text ?? string.Empty
                            };
                        }

                        testCaseRecords.Add(row);
                    }

                    var skipCount = 0;

                    if (skipCount != -1)
                    {
                        //skipCount = skipCount + 1;
                    }
                    else
                    {
                        throw new Exception("Invalid Excel file");
                    }
                    Guid? projectId;

                    List<ValidationMessage> validations = new List<ValidationMessage>();

                    TestRailMasterDataModel testRailMasterDataModel = new TestRailMasterDataModel()
                    { IsArchived = false };

                    var templates = GetAllTestCaseTemplates(testRailMasterDataModel, loggedInContext, validations);
                    if (validations.Count > 0)
                    {
                        validationMessages.AddRange(validations);
                        validations.Clear();
                        return false;
                    }

                    var automationTypes = GetAllTestCaseAutomationTypes(new TestCaseAutomationTypeSearchCriteriaInputModel()
                    { IsArchived = false }, loggedInContext, validations);
                    if (validations.Count > 0)
                    {
                        validationMessages.AddRange(validations);
                        validations.Clear();
                        return false;
                    }

                    var priorities = GetAllTestCasePriorities(testRailMasterDataModel, loggedInContext, validations);
                    if (validations.Count > 0)
                    {
                        validationMessages.AddRange(validations);
                        validations.Clear();
                        return false;
                    }

                    var testCaseTypes = GetAllTestCaseTypes(testRailMasterDataModel, loggedInContext, validations);
                    if (validations.Count > 0)
                    {
                        validationMessages.AddRange(validations);
                        validations.Clear();
                        return false;
                    }

                    var projectSearchCriteriaInputModel = new ProjectSearchCriteriaInputModel()
                    {
                        ProjectName = projectName.Trim(),
                        IsArchived = false
                    };
                    var projectSearchResults = _projectService.SearchProjects(projectSearchCriteriaInputModel, loggedInContext, validations);

                    if (projectSearchResults.Count > 0)
                    {
                        projectId = projectSearchResults.FirstOrDefault().ProjectId;
                    }
                    else
                    {
                        var projectInputModel = new ProjectUpsertInputModel()
                        {
                            ProjectName = projectName.Trim(),
                            ProjectResponsiblePersonId = loggedInContext.LoggedInUserId
                        };
                        projectId = _projectService.UpsertProject(projectInputModel, loggedInContext, validations);
                    }

                    if (validations.Count > 0)
                    {
                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadTestSuiteFromCsv", "TestSuite", "Unable to upsert project with the name " + projectName));
                        validationMessages.AddRange(validations);
                        return false;
                    }

                    var testSuiteName = testCaseRecords.Skip(skipCount).FirstOrDefault()?.SuiteName;
                    if (string.IsNullOrEmpty(testSuiteName))
                    {
                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadTestSuiteFromCsv", "TestSuite", "Unable to extract testsuite name"));
                        validationMessages.AddRange(validations);
                        return false;
                    }

                    TestSuiteInputModel testSuiteInputModel = new TestSuiteInputModel()
                    {
                        ProjectId = projectId,
                        TestSuiteName = testSuiteName
                    };

                    var testSuiteId = UpsertTestSuite(testSuiteInputModel, loggedInContext, validations);

                    if (validations.Count > 0)
                    {
                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadTestSuiteFromCsv", "TestSuite", "Unable to upsert testsuite with the name " + testSuiteName + " trying to update if available"));
                        validationMessages.AddRange(validations);
                        var staticValidation = new ValidationMessage
                        {
                            ValidationMessaage = string.Format(ValidationMessages.NotFoundTestSuiteWithTheName, testSuiteName),
                            ValidationMessageType = MessageTypeEnum.Error
                        };
                        validationMessages.Add(staticValidation);
                        validations.Clear();

                        var testSuiteSearchInputModel = new TestSuiteSearchCriteriaInputModel()
                        {
                            TestSuiteName = testSuiteName.Trim(),
                            ProjectId = projectId
                        };
                        var testSuites = SearchTestSuites(testSuiteSearchInputModel, loggedInContext, validations);

                        if (validations.Count > 0)
                        {
                            LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadTestSuiteFromCsv", "TestSuite", "Didnot found any testsuite with the name " + testSuiteName + " for updation"));
                            validationMessages.AddRange(validations);
                            validations.Clear();
                            return false;
                        }

                        if (testSuites.Count > 0)
                        {
                            testSuiteId = testSuites.FirstOrDefault().TestSuiteId;
                        }
                        else
                        {
                            LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadTestSuiteFromCsv", "TestSuite", "Didn't find any testsuite with name " + testSuiteName));
                            staticValidation = new ValidationMessage
                            {
                                ValidationMessaage = string.Format(ValidationMessages.NotFoundTestSuiteWithTheName, testSuiteName),
                                ValidationMessageType = MessageTypeEnum.Error
                            };
                            validationMessages.Add(staticValidation);
                            validations.Clear();
                            return false;
                        }
                    }

                    var finalRecords = testCaseRecords.Skip(skipCount).ToList();

                    List<SavedSectionsModel> availableSections = new List<SavedSectionsModel>();

                    for (int rowIndex = 0; rowIndex < finalRecords.Count; rowIndex++)
                    {
                        var testCase = finalRecords[rowIndex];

                        if (string.IsNullOrEmpty(testCase.SuiteName) && string.IsNullOrEmpty(testCase.Title) && string.IsNullOrEmpty(testCase.StepDescription))
                        {
                            break;
                        }

                        if (string.IsNullOrEmpty(testCase.SuiteName) && string.IsNullOrEmpty(testCase.Title) && !string.IsNullOrEmpty(testCase.StepDescription))
                        {
                            continue;
                        }

                        var sectionId = SaveSectionsFromCsv(testCase.SectionHierarchy, testSuiteId, testCase.SectionDescription, availableSections, loggedInContext, validations);

                        if (validations.Count > 0)
                        {
                            LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadTestSuiteFromCsv", "TestSuite", "Didnot found any testsuite with the name " + testSuiteName + " for updation"));
                            validationMessages.AddRange(validations);
                            validations.Clear();
                            continue;
                        }

                        var testCases = new List<TestSuiteCsvExtractModel>();
                        testCases.Add(finalRecords[rowIndex]);

                        for (int inRowIndex = rowIndex; rowIndex < finalRecords.Count; inRowIndex++)
                        {
                            if(inRowIndex == (finalRecords.Count-1))
                            {
                                break;
                                //testCases.Add(finalRecords[inRowIndex + 1]);
                            }
                            else if (string.IsNullOrEmpty(finalRecords[inRowIndex + 1].Title) && !string.IsNullOrEmpty(finalRecords[inRowIndex + 1].StepDescription))
                            {
                                testCases.Add(finalRecords[inRowIndex + 1]);
                            }
                            else
                            {
                                break;
                            }
                        }

                        var testCaseId = SaveCaseFromCsv(testCases, sectionId, testSuiteId, loggedInContext, validations, templates, automationTypes, priorities, testCaseTypes);


                        if (validations.Count > 0)
                        {
                            LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadTestSuiteFromCsv", "TestSuite", "Didnot found any testsuite with the name " + testSuiteName + " for updation"));
                            validationMessages.AddRange(validations);
                            validations.Clear();
                            continue;
                        }
                    }

                    if (validations.Count > 0)
                    {
                        validationMessages.AddRange(validations);
                    }

                    //fileReader.Close();

                    return true;
                }
            } else
            {
                using (TextReader fileReader = new StreamReader(httpRequest.InputStream))
                {
                    fileReader.ReadLine(); //to skip the first line

                    var csvReader = new CsvReader(fileReader);

                    csvReader.Configuration.MissingFieldFound = null;

                    csvReader.Configuration.BadDataFound = null;

                    csvReader.Configuration.HasHeaderRecord = false;

                    testCaseRecords = csvReader.GetRecords<TestSuiteCsvExtractModel>().ToList();

                    var skipCount = testCaseRecords.FindIndex(x => x.SuiteName.Contains("SuiteName"));

                    if (skipCount != -1)
                    {
                        skipCount = skipCount + 1;
                    }
                    else
                    {
                        throw new Exception("Invalid Csv file");
                    }

                    Guid? projectId;

                    List<ValidationMessage> validations = new List<ValidationMessage>();

                    TestRailMasterDataModel testRailMasterDataModel = new TestRailMasterDataModel()
                    { IsArchived = false };

                    var templates = GetAllTestCaseTemplates(testRailMasterDataModel, loggedInContext, validations);
                    if (validations.Count > 0)
                    {
                        validationMessages.AddRange(validations);
                        validations.Clear();
                        return false;
                    }

                    var automationTypes = GetAllTestCaseAutomationTypes(new TestCaseAutomationTypeSearchCriteriaInputModel()
                    { IsArchived = false }, loggedInContext, validations);
                    if (validations.Count > 0)
                    {
                        validationMessages.AddRange(validations);
                        validations.Clear();
                        return false;
                    }

                    var priorities = GetAllTestCasePriorities(testRailMasterDataModel, loggedInContext, validations);
                    if (validations.Count > 0)
                    {
                        validationMessages.AddRange(validations);
                        validations.Clear();
                        return false;
                    }

                    var testCaseTypes = GetAllTestCaseTypes(testRailMasterDataModel, loggedInContext, validations);
                    if (validations.Count > 0)
                    {
                        validationMessages.AddRange(validations);
                        validations.Clear();
                        return false;
                    }

                    var projectSearchCriteriaInputModel = new ProjectSearchCriteriaInputModel()
                    {
                        ProjectName = projectName.Trim(),
                        IsArchived = false
                    };
                    var projectSearchResults = _projectService.SearchProjects(projectSearchCriteriaInputModel, loggedInContext, validations);

                    if (projectSearchResults.Count > 0)
                    {
                        projectId = projectSearchResults.FirstOrDefault().ProjectId;
                    }
                    else
                    {
                        var projectInputModel = new ProjectUpsertInputModel()
                        {
                            ProjectName = projectName.Trim(),
                            ProjectResponsiblePersonId = loggedInContext.LoggedInUserId
                        };
                        projectId = _projectService.UpsertProject(projectInputModel, loggedInContext, validations);
                    }

                    if (validations.Count > 0)
                    {
                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadTestSuiteFromCsv", "TestSuite", "Unable to upsert project with the name " + projectName));
                        validationMessages.AddRange(validations);
                        return false;
                    }

                    var testSuiteName = testCaseRecords.Skip(skipCount).FirstOrDefault()?.SuiteName;
                    if (string.IsNullOrEmpty(testSuiteName))
                    {
                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadTestSuiteFromCsv", "TestSuite", "Unable to extract testsuite name"));
                        validationMessages.AddRange(validations);
                        return false;
                    }

                    TestSuiteInputModel testSuiteInputModel = new TestSuiteInputModel()
                    {
                        ProjectId = projectId,
                        TestSuiteName = testSuiteName
                    };

                    var testSuiteId = UpsertTestSuite(testSuiteInputModel, loggedInContext, validations);

                    if (validations.Count > 0)
                    {
                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadTestSuiteFromCsv", "TestSuite", "Unable to upsert testsuite with the name " + testSuiteName + " trying to update if available"));
                        validationMessages.AddRange(validations);
                        var staticValidation = new ValidationMessage
                        {
                            ValidationMessaage = string.Format(ValidationMessages.NotFoundTestSuiteWithTheName, testSuiteName),
                            ValidationMessageType = MessageTypeEnum.Error
                        };
                        validationMessages.Add(staticValidation);
                        validations.Clear();

                        var testSuiteSearchInputModel = new TestSuiteSearchCriteriaInputModel()
                        {
                            TestSuiteName = testSuiteName.Trim(),
                            ProjectId = projectId
                        };
                        var testSuites = SearchTestSuites(testSuiteSearchInputModel, loggedInContext, validations);

                        if (validations.Count > 0)
                        {
                            LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadTestSuiteFromCsv", "TestSuite", "Didnot found any testsuite with the name " + testSuiteName + " for updation"));
                            validationMessages.AddRange(validations);
                            validations.Clear();
                            return false;
                        }

                        if (testSuites.Count > 0)
                        {
                            testSuiteId = testSuites.FirstOrDefault().TestSuiteId;
                        }
                        else
                        {
                            LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadTestSuiteFromCsv", "TestSuite", "Didn't find any testsuite with name " + testSuiteName));
                            staticValidation = new ValidationMessage
                            {
                                ValidationMessaage = string.Format(ValidationMessages.NotFoundTestSuiteWithTheName, testSuiteName),
                                ValidationMessageType = MessageTypeEnum.Error
                            };
                            validationMessages.Add(staticValidation);
                            validations.Clear();
                            return false;
                        }
                    }

                    var finalRecords = testCaseRecords.Skip(skipCount).ToList();

                    List<SavedSectionsModel> availableSections = new List<SavedSectionsModel>();

                    for (int rowIndex = 0; rowIndex < finalRecords.Count; rowIndex++)
                    {
                        var testCase = finalRecords[rowIndex];

                        if (string.IsNullOrEmpty(testCase.SuiteName) && string.IsNullOrEmpty(testCase.Title) && string.IsNullOrEmpty(testCase.StepDescription))
                        {
                            break;
                        }

                        if (string.IsNullOrEmpty(testCase.SuiteName) && string.IsNullOrEmpty(testCase.Title) && !string.IsNullOrEmpty(testCase.StepDescription))
                        {
                            continue;
                        }

                        var sectionId = SaveSectionsFromCsv(testCase.SectionHierarchy, testSuiteId, testCase.SectionDescription, availableSections, loggedInContext, validations);

                        if (validations.Count > 0)
                        {
                            LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadTestSuiteFromCsv", "TestSuite", "Didnot found any testsuite with the name " + testSuiteName + " for updation"));
                            validationMessages.AddRange(validations);
                            validations.Clear();
                            continue;
                        }

                        var testCases = new List<TestSuiteCsvExtractModel>();
                        testCases.Add(finalRecords[rowIndex]);

                        for (int inRowIndex = rowIndex; rowIndex < finalRecords.Count; inRowIndex++)
                        {
                            if (string.IsNullOrEmpty(finalRecords[inRowIndex + 1].Title) && !string.IsNullOrEmpty(finalRecords[inRowIndex + 1].StepDescription))
                            {
                                testCases.Add(finalRecords[inRowIndex + 1]);
                            }
                            else
                            {
                                break;
                            }
                        }

                        var testCaseId = SaveCaseFromCsv(testCases, sectionId, testSuiteId, loggedInContext, validations, templates, automationTypes, priorities, testCaseTypes);


                        if (validations.Count > 0)
                        {
                            LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadTestSuiteFromCsv", "TestSuite", "Didnot found any testsuite with the name " + testSuiteName + " for updation"));
                            validationMessages.AddRange(validations);
                            validations.Clear();
                            continue;
                        }
                    }

                    if (validations.Count > 0)
                    {
                        validationMessages.AddRange(validations);
                    }

                    fileReader.Close();

                    return true;
                }
            }

        }

        private Guid? SaveSectionsFromCsv(string sectionHierarchy, Guid? testSuiteId, string sectionDescription, List<SavedSectionsModel> availableSections, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                var sectionTree = sectionHierarchy.Split('>').ToList();

                Guid? parentSectionId = availableSections.FirstOrDefault(p => p.SectionName == sectionTree[(sectionTree.Count - 1)] && p.Level == (sectionTree.Count - 1))?.SectionId;

                if (parentSectionId != null)
                {
                    return parentSectionId;
                }

                for (var level = 0; level < sectionTree.Count; level++)
                {
                    var currentSectionId = availableSections.FirstOrDefault(p => p.SectionName == sectionTree[level]?.Trim() && p.Level == level)?.SectionId;

                    if (currentSectionId == null)
                    {
                        List<ValidationMessage> validations = new List<ValidationMessage>();

                        var testSuiteSectionInputModel = new TestSuiteSectionInputModel()
                        {
                            TestSuiteId = testSuiteId,
                            ParentSectionId = parentSectionId,
                            SectionName = sectionTree[level]?.Trim(),
                            Description = level == sectionTree.Count - 1 ? sectionDescription : ""
                        };

                        currentSectionId = UpsertTestSuiteSection(testSuiteSectionInputModel, loggedInContext, validations);

                        availableSections.Add(new SavedSectionsModel
                        {
                            ParentName = level > 0 ? sectionTree[level - 1]?.Trim() : null,
                            SectionId = currentSectionId,
                            SectionName = sectionTree[level]?.Trim(),
                            Level = level
                        });
                    }

                    parentSectionId = currentSectionId;
                }

                return parentSectionId;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SaveSectionsFromCsv", "TestSuiteService ", exception.Message), exception);

                var staticValidation = new ValidationMessage
                {
                    ValidationMessaage = string.Format(exception.Message),
                    ValidationMessageType = MessageTypeEnum.Error
                };
                validationMessages.Add(staticValidation);
                return null;
            }

        }

        private Guid? SaveCaseFromCsv(List<TestSuiteCsvExtractModel> rows, Guid? sectionId, Guid? testSuiteId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, List<DropdownModel> templates, List<TestCaseAutomationTypeOutputModel> automationTypes, List<DropdownModel> priorities, List<DropdownModel> testCaseTypes)
        {
            try
            {
                var testCase = rows[0];

                var teplateId = templates.FirstOrDefault(p => p.Value.Trim().ToLower() == testCase.Template?.Trim().ToLower())?.Id;

                var automationId = automationTypes.FirstOrDefault(p => p.AutomationTypeName.Trim().ToLower() == testCase.AutomationType?.Trim().ToLower())?.Id;

                var priorityId = priorities.FirstOrDefault(p => p.Value.Trim().ToLower() == testCase.Priority?.Trim().ToLower())?.Id;

                var testCaseTypeId = testCaseTypes.FirstOrDefault(p => p.Value.Trim().ToLower() == testCase.Type?.Trim().ToLower())?.Id;

                var preCondition = testCase.Preconditions;

                var testCaseSteps = new List<TestCaseStepMiniModel>();

                if (rows.Count > 0 && testCase.Template?.Trim().ToLower() != "test case (text)")
                {
                    testCaseSteps.AddRange(rows.Select(p => new TestCaseStepMiniModel
                    {
                        StepOrder = GetStepOrder(p.StepOrder),
                        StepText = p.StepDescription,
                        StepExpectedResult = p.StepsExpectedResult
                    }));
                }

                var estimate = 0;

                int.TryParse((testCase.EstimateInSeconds), out estimate);

                var testCaseInputModel = new TestCaseInputModel()
                {
                    Title = testCase.Title,
                    SectionId = sectionId,
                    TemplateId = teplateId,
                    TypeId = testCaseTypeId,
                    Estimate = estimate,
                    References = testCase.References,
                    Steps = testCase.Template?.Trim()?.ToLower() == "test case (text)" ? testCase.StepDescription : null,
                    ExpectedResult = testCase.Template?.Trim()?.ToLower() == "test case (text)" ? testCase.StepsExpectedResult : null,
                    IsArchived = false,
                    Mission = testCase.Template?.Trim()?.ToLower() == "exploratory session" ? testCase.Mission : null,
                    Goals = testCase.Template?.Trim().ToLower() == "exploratory session" ? testCase.Goals : null,
                    PriorityId = priorityId,
                    AutomationTypeId = automationId,
                    TestSuiteId = testSuiteId,
                    Precondition = preCondition,
                    TestCaseSteps = testCase.Template?.Trim()?.ToLower() == "test case (steps)" ? testCaseSteps : null
                };

                return UpsertTestCase(testCaseInputModel, loggedInContext, validationMessages);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SaveCaseFromCsv", "TestSuiteService ", exception.Message), exception);

                var staticValidation = new ValidationMessage
                {
                    ValidationMessaage = string.Format(exception.Message),
                    ValidationMessageType = MessageTypeEnum.Error
                };
                validationMessages.Add(staticValidation);
                return null;
            }

        }

        private int GetStepOrder(string stepOrder)
        {
            int stepInt;

            int.TryParse(stepOrder, out stepInt);

            return stepInt;
        }

        public List<UploadTestCasesFromExcelModel> UploadTestCasesFromCsv(string projectName, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upload TestCases From Csv", "projectName", projectName, "Test Suite Service"));

            var excelResult = new List<UploadTestCasesFromExcelModel>();

            var httpRequest = HttpContext.Current.Request;

            using (TextReader fileReader = new StreamReader(httpRequest.InputStream))
            {
                fileReader.ReadLine(); //to skip the first line

                var csvReader = new CsvReader(fileReader);

                csvReader.Configuration.MissingFieldFound = null;

                csvReader.Configuration.BadDataFound = null;

                csvReader.Configuration.HasHeaderRecord = false;

                List<UploadTestCasesFromExcelModel> testCaseRecords = csvReader.GetRecords<UploadTestCasesFromExcelModel>().ToList();

                var skipCount = testCaseRecords.FindIndex(x => x.Suite.Contains("SuiteName"));

                if (skipCount != -1)
                {
                    skipCount = skipCount + 1;
                }
                else
                {
                    throw new Exception("Invalid Csv file");
                }

                List<ValidationMessage> validations = new List<ValidationMessage>();

                _testSuiteValidationHelper.UploadTestCasesCsvValidation(testCaseRecords[skipCount - 1], loggedInContext, validationMessages);

                if (validationMessages.Count > 0)
                {
                    return null;
                }

                foreach (var row in testCaseRecords.Skip(skipCount))
                {
                    LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "testCaseRecord", row));

                    var testCaseStepMiniModels = new List<TestCaseStepMiniModel>();
                    if (row.Template == "Test Case (Steps)")
                    {
                        testCaseStepMiniModels = SplitSteps(row.Steps);

                        if (testCaseStepMiniModels == null)
                        {
                            LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "TestCase Record Insertion Failed", "testCaseRecord", row, "Test Suite Service"));
                            excelResult.Add(row);
                            continue;
                        }

                        if (testCaseStepMiniModels.Count == 0)
                        {
                            row.TestCaseStepsXml = null;
                        }
                        else
                        {
                            row.TestCaseStepsXml = Utilities.GetXmlFromObject(testCaseStepMiniModels);
                        }
                    }
                    else
                    {
                        row.TestCaseStepsXml = null;
                    }

                    if (string.IsNullOrEmpty(row.Suite) && string.IsNullOrEmpty(row.Section) && string.IsNullOrEmpty(row.Title))
                    {
                        break;
                    }

                    var testCaseId = _testSuitePartialRepository.UploadTestCases(projectName, row, loggedInContext, validationMessages);

                    if (validationMessages.Count > 0 || testCaseId == null)
                    {
                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "TestCase Record Insertion Failed", "testCaseRecord", row, "Test Suite Service"));
                        validations.AddRange(validationMessages);
                        validationMessages.Clear();
                        excelResult.Add(row);
                        continue;
                    }

                    var testCase = GetTestCaseById(testCaseId, loggedInContext, validationMessages);

                    if (testCase != null && testCase.TestCaseSteps != null && row.Template == "Test Case (Steps)")
                    {
                        for (int step = 0; step < testCase.TestCaseSteps.Count; step++)
                        {
                            if (testCaseStepMiniModels[step].StepText.Contains("index.php?/attachments/get/"))
                            {
                                List<FileResult> stepAttachments = GetImagePaths(testCaseStepMiniModels[step].StepText);

                                TestRailFileModel testRailFileModel = new TestRailFileModel
                                {
                                    TestRailId = testCase.TestCaseSteps[step].StepId,
                                    IsTestCaseStep = true,
                                    FilePathList = stepAttachments.Select(x => x.FilePath).ToList(),
                                    FileName = stepAttachments[0].FileName
                                };

                                _testRailFileService.UpsertFile(testRailFileModel, loggedInContext, validationMessages);
                            }
                        }
                    }

                    if (row.InlineSteps.Contains("index.php?/attachments/get/"))
                    {
                        List<FileResult> inlineStepAttachments = GetImagePaths(row.InlineSteps);

                        TestRailFileModel testRailFileModel = new TestRailFileModel
                        {
                            TestRailId = testCaseId,
                            IsTestCase = true,
                            FilePathList = inlineStepAttachments.Select(x => x.FilePath).ToList(),
                            FileName = inlineStepAttachments[0].FileName
                        };

                        _testRailFileService.UpsertFile(testRailFileModel, loggedInContext, validationMessages);
                    }
                }

                if (validations.Count > 0)
                {
                    validationMessages.AddRange(validations);
                }

                fileReader.Close();

                return excelResult;
            }
        }


        public bool UploadTestSuitesFromCsv(string projectName, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upload TestCases From Csv", "projectName", projectName, "Test Suite Service"));

                var httpRequest = HttpContext.Current.Request;

                Task.Factory.StartNew(() =>
                {
                    UploadTestSuiteFromCsv(projectName, httpRequest, loggedInContext, validationMessages);
                });

                return true;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadTestSuitesFromCsv", "TestSuiteService ", exception.Message), exception);

                throw;
            }

        }

        public bool UploadTestSuiteFromXml(string projectName, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upload TestCases From Xml", "projectName", projectName, "Test Suite Service"));

                var xmlFile = HttpContext.Current.Request.Files[0];

                Task.Factory.StartNew(() =>
                {
                    ImportTestSuiteFromXml(projectName, xmlFile, loggedInContext, validationMessages);
                });

                return true;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadTestSuiteFromXml", "TestSuiteService ", exception.Message), exception);

                throw;
            }

        }

        private bool ImportTestSuiteFromXml(string projectName, HttpPostedFile xmlFile, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            XmlDocument doc = new XmlDocument();
            doc.Load(XmlReader.Create(xmlFile.InputStream));

            Guid? projectId;
            List<ValidationMessage> validations = new List<ValidationMessage>();

            TestRailMasterDataModel testRailMasterDataModel = new TestRailMasterDataModel()
            { IsArchived = false };
            var testCaseAutomationType = new TestCaseAutomationTypeSearchCriteriaInputModel()
            { IsArchived = false };

            var templates = GetAllTestCaseTemplates(testRailMasterDataModel, loggedInContext, validations);
            if (validations.Count > 0)
            {
                validationMessages.AddRange(validations);
                validations.Clear();
                return false;
            }

            var automationTypes = GetAllTestCaseAutomationTypes(testCaseAutomationType, loggedInContext, validations);
            if (validations.Count > 0)
            {
                validationMessages.AddRange(validations);
                validations.Clear();
                return false;
            }

            var priorities = GetAllTestCasePriorities(testRailMasterDataModel, loggedInContext, validations);
            if (validations.Count > 0)
            {
                validationMessages.AddRange(validations);
                validations.Clear();
                return false;
            }

            var testCaseTypes = GetAllTestCaseTypes(testRailMasterDataModel, loggedInContext, validations);
            if (validations.Count > 0)
            {
                validationMessages.AddRange(validations);
                validations.Clear();
                return false;
            }

            var projectSearchCriteriaInputModel = new ProjectSearchCriteriaInputModel()
            {
                ProjectName = projectName.Trim(),
                IsArchived = false
            };
            var projectSearchResults = _projectService.SearchProjects(projectSearchCriteriaInputModel, loggedInContext, validations);

            if (projectSearchResults.Count > 0)
            {
                projectId = projectSearchResults.FirstOrDefault().ProjectId;
            }
            else
            {
                var projectInputModel = new ProjectUpsertInputModel()
                {
                    ProjectName = projectName.Trim(),
                    ProjectResponsiblePersonId = loggedInContext.LoggedInUserId
                };
                projectId = _projectService.UpsertProject(projectInputModel, loggedInContext, validations);
            }

            if (validations.Count > 0)
            {
                LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadingTestSuiteXML", "TestSuite", "Unable to upsert project with the name " + projectName));
                validationMessages.AddRange(validations);
                return false;
            }

            var testSuiteName = string.IsNullOrEmpty((doc.SelectSingleNode("//suite/name") as XmlElement).InnerText) ? (doc.SelectSingleNode("//suite/name") as XmlElement).InnerText : (doc.SelectSingleNode("//suite/name") as XmlElement).InnerText.Trim();

            TestSuiteInputModel testSuiteInputModel = new TestSuiteInputModel()
            {
                ProjectId = projectId,
                TestSuiteName = testSuiteName
            };

            var testSuiteId = UpsertTestSuite(testSuiteInputModel, loggedInContext, validations);

            if (validations.Count > 0)
            {
                LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadingTestSuiteXML", "TestSuite", "Unable to upsert testsuite with the name " + testSuiteName + " trying to update if available"));
                validationMessages.AddRange(validations);
                var staticValidation = new ValidationMessage
                {
                    ValidationMessaage = string.Format(ValidationMessages.NotFoundTestSuiteWithTheName, testSuiteName),
                    ValidationMessageType = MessageTypeEnum.Error
                };
                validationMessages.Add(staticValidation);
                validations.Clear();

                var testSuiteSearchInputModel = new TestSuiteSearchCriteriaInputModel()
                {
                    TestSuiteName = testSuiteName.Trim(),
                    ProjectId = projectId
                };
                var testSuites = SearchTestSuites(testSuiteSearchInputModel, loggedInContext, validations);

                if (validations.Count > 0)
                {
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadingTestSuiteXML", "TestSuite", "Didnot found any testsuite with the name " + testSuiteName + " for updation"));
                    validationMessages.AddRange(validations);
                    validations.Clear();
                    return false;
                }

                if (testSuites.Count > 0)
                {
                    testSuiteId = testSuites.FirstOrDefault().TestSuiteId;
                }
                else
                {
                    LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadingTestSuiteXML", "TestSuite", "Didn't find any testsuite with name " + testSuiteName));
                    staticValidation = new ValidationMessage
                    {
                        ValidationMessaage = string.Format(ValidationMessages.NotFoundTestSuiteWithTheName, testSuiteName),
                        ValidationMessageType = MessageTypeEnum.Error
                    };
                    validationMessages.Add(staticValidation);
                    validations.Clear();
                    return false;
                }
            }

            XmlNodeList sections = doc.SelectNodes("//suite/sections/section");

            foreach (XmlElement section in sections.Cast<XmlElement>().Where(x => x != null).ToList())
            {
                var sectionName = string.IsNullOrEmpty((section.SelectSingleNode("name") as XmlElement).InnerText) ? (section.SelectSingleNode("name") as XmlElement).InnerText : (section.SelectSingleNode("name") as XmlElement).InnerText.Trim();
                var sectionDescription = (section.SelectSingleNode("description") as XmlElement)?.InnerText;

                XmlNodeList subSections = section.SelectNodes("sections/section");

                var testSuiteSectionInputModel = new TestSuiteSectionInputModel()
                {
                    TestSuiteId = testSuiteId,
                    SectionName = sectionName,
                    Description = sectionDescription
                };
                var sectionId = UpsertTestSuiteSection(testSuiteSectionInputModel, loggedInContext, validations);

                if (validations.Count > 0)
                {
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadingTestSuiteXML", "TestSuite", "Unable to upsert testsuiteSection with the name " + sectionName + " trying to update if available"));
                    var staticValidation = new ValidationMessage
                    {
                        ValidationMessaage = string.Format(ValidationMessages.TestSuiteUploadParentSectionName, sectionName),
                        ValidationMessageType = MessageTypeEnum.Error
                    };
                    validationMessages.Add(staticValidation);
                    validations.Clear();

                    var testSuiteSectionSearchCriteriaInput = new TestSuiteSectionSearchCriteriaInputModel()
                    {
                        ParentSectionId = null,
                        SectionName = sectionName,
                        IsFromTestRunUplaods = true,
                        TestSuiteId = testSuiteId
                    };

                    sectionId = SearchTestSuiteSections(testSuiteSectionSearchCriteriaInput, loggedInContext, validations).FirstOrDefault()?.TestSuiteSectionId;
                    if (validations.Count > 0)
                    {
                        validationMessages.AddRange(validations);
                        validations.Clear();
                        continue;
                    }
                    if (sectionId == null)
                    {
                        staticValidation = new ValidationMessage
                        {
                            ValidationMessaage = string.Format(ValidationMessages.TestSuiteUploadParentSectionNotFound, sectionName),
                            ValidationMessageType = MessageTypeEnum.Error
                        };
                        validationMessages.Add(staticValidation);
                        continue;
                    }
                }

                foreach (var subSection in subSections.OfType<XmlElement>().Where(x => x != null).ToList())
                {
                    LoadSection(subSection, (Guid)sectionId, (Guid)testSuiteId, loggedInContext, validationMessages, templates, automationTypes, priorities, testCaseTypes, sectionName);
                }

                XmlNodeList testCases = section.SelectNodes("cases/case");

                foreach (var testCase in testCases.OfType<XmlElement>().Where(x => x != null).ToList())
                {
                    LoadCase(testCase, (Guid)sectionId, (Guid)testSuiteId, loggedInContext, validationMessages, templates, automationTypes, priorities, testCaseTypes, sectionName);
                }
            }

            return true;
        }

        private void LoadCase(XmlElement testCase, Guid sectionId, Guid testSuiteId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, List<DropdownModel> templates, List<TestCaseAutomationTypeOutputModel> automationTypes, List<DropdownModel> priorities, List<DropdownModel> testCaseTypes, string sectionName)
        {
            try
            {
                var validations = new List<ValidationMessage>();

                int estimate = 0;

                var templateType = testCase.SelectSingleNode("template") as XmlElement;
                var teplateId = templates.FirstOrDefault(p => p.Value == templateType.InnerText).Id;

                var automationType = testCase.SelectSingleNode("custom/automation_type/value") as XmlElement;
                var automationId = automationTypes.FirstOrDefault(p => p.AutomationTypeName == automationType.InnerText.Trim()).Id;

                var priorityType = testCase.SelectSingleNode("priority") as XmlElement;
                var priorityId = priorities.FirstOrDefault(p => p.Value == priorityType.InnerText).Id;

                var testCaseType = testCase.SelectSingleNode("type") as XmlElement;
                var testCaseTypeId = testCaseTypes.FirstOrDefault(p => p.Value == testCaseType.InnerText).Id;

                var testCaseSteps = new List<TestCaseStepMiniModel>();
                var testCaseStepsWithoutUrls = new List<TestCaseStepMiniModel>();
                XmlNodeList steps = testCase.SelectNodes("custom/steps_separated/step");

                var preCondition = (testCase.SelectSingleNode("custom/preconds") as XmlElement)?.InnerText;
                if (preCondition != null && preCondition.Contains("![](index.php?/attachments/get/"))
                {
                    preCondition = ReplaceImageUrls(preCondition);
                }

                var caseExpectedResult = (testCase.SelectSingleNode("custom/expected") as XmlElement)?.InnerText;
                if (caseExpectedResult != null && caseExpectedResult.Contains("![](index.php?/attachments/get/"))
                {
                    caseExpectedResult = ReplaceImageUrls(caseExpectedResult);
                }

                var inlineStep = (testCase.SelectSingleNode("custom/steps") as XmlElement)?.InnerText;
                if (inlineStep != null && inlineStep.Contains("![](index.php?/attachments/get/"))
                {
                    inlineStep = ReplaceImageUrls(inlineStep);
                }

                foreach (XmlElement step in steps.Cast<XmlElement>().Where(x => x != null).ToList())
                {
                    var stepTitle = (step.SelectSingleNode("content") as XmlElement)?.InnerText;
                    if (stepTitle != null && stepTitle.Contains("![](index.php?/attachments/get/"))
                    {
                        stepTitle = ReplaceImageUrls(stepTitle);
                    }

                    var stepExpectedResult = (step.SelectSingleNode("expected") as XmlElement)?.InnerText;
                    if (stepExpectedResult != null && stepExpectedResult.Contains("![](index.php?/attachments/get/"))
                    {
                        stepExpectedResult = ReplaceImageUrls(stepExpectedResult);
                    }

                    var testCaseStepWithoutUrls = new TestCaseStepMiniModel()
                    {
                        StepOrder = int.Parse((step.SelectSingleNode("index") as XmlElement)?.InnerText),
                        StepText = string.IsNullOrEmpty(stepTitle) ? stepTitle : stepTitle.Trim(),
                        StepExpectedResult = stepExpectedResult,
                    };
                    testCaseStepsWithoutUrls.Add(testCaseStepWithoutUrls);

                    var testCaseStep = new TestCaseStepMiniModel()
                    {
                        StepOrder = int.Parse((step.SelectSingleNode("index") as XmlElement)?.InnerText),
                        StepText = string.IsNullOrEmpty((step.SelectSingleNode("content") as XmlElement)?.InnerText) ? (step.SelectSingleNode("content") as XmlElement)?.InnerText : (step.SelectSingleNode("content") as XmlElement)?.InnerText.Trim(),
                        StepExpectedResult = string.IsNullOrEmpty((step.SelectSingleNode("expected") as XmlElement)?.InnerText) ? (step.SelectSingleNode("expected") as XmlElement)?.InnerText : (step.SelectSingleNode("expected") as XmlElement)?.InnerText.Trim()
                    };
                    testCaseSteps.Add(testCaseStep);
                }

                var testCaseTitle = string.IsNullOrEmpty((testCase.SelectSingleNode("title") as XmlElement).InnerText) ? (testCase.SelectSingleNode("title") as XmlElement).InnerText : (testCase.SelectSingleNode("title") as XmlElement).InnerText.Trim();
                int.TryParse((testCase.SelectSingleNode("estimate") as XmlElement).InnerText, out estimate);
                var testCaseInputModel = new TestCaseInputModel()
                {
                    Title = testCaseTitle,
                    SectionId = sectionId,
                    TemplateId = teplateId,
                    TypeId = testCaseTypeId,
                    Estimate = estimate,
                    References = (testCase.SelectSingleNode("references") as XmlElement).InnerText,
                    Steps = inlineStep,
                    ExpectedResult = caseExpectedResult,
                    IsArchived = false,
                    Mission = (testCase.SelectSingleNode("custom/mission") as XmlElement)?.InnerText,
                    PriorityId = priorityId,
                    AutomationTypeId = automationId,
                    TestSuiteId = testSuiteId,
                    Precondition = preCondition,
                    TestCaseSteps = testCaseStepsWithoutUrls
                };
                var testCaseId = UpsertTestCase(testCaseInputModel, loggedInContext, validations);

                if (validations.Count > 0)
                {
                    validationMessages.AddRange(validations);
                    validations.Clear();

                    var searchTestCaseInputModel = new SearchTestCaseInputModel()
                    {
                        Title = testCaseTitle,
                        SectionId = sectionId
                    };
                    var testCaseDetails = SearchTestCases(searchTestCaseInputModel, loggedInContext, validations).FirstOrDefault();
                    if (validations.Count > 0)
                    {
                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadingTestRunXML", "TestRun", "Unable to search testcase with the title " + testCaseTitle));
                        validationMessages.AddRange(validations);
                        validations.Clear();
                        return;
                    }
                    if (testCaseDetails == null)
                    {
                        var StaticValidation = new ValidationMessage
                        {
                            ValidationMessaage = string.Format(ValidationMessages.TestSuiteUploadTestCaseNotFound, testCaseTitle, sectionName),
                            ValidationMessageType = MessageTypeEnum.Error
                        };
                        validationMessages.Add(StaticValidation);
                        return;
                    }

                    var stepstoBeUpdated = new List<TestCaseStepMiniModel>();

                    if (testCaseDetails.TestCaseSteps != null && testCaseStepsWithoutUrls.Count > 0)
                    {
                        foreach (var testCaseStepsFromXml in testCaseStepsWithoutUrls)
                        {
                            bool isUpdated = false;
                            foreach (var testCaseStep in testCaseDetails.TestCaseSteps)
                            {
                                if (testCaseStepsFromXml.StepText == testCaseStep.StepText)
                                {
                                    isUpdated = true;
                                    var testCaseStepMiniModel = new TestCaseStepMiniModel()
                                    {
                                        StepId = testCaseStep.StepId,
                                        StepOrder = testCaseStepsFromXml.StepOrder,
                                        StepText = testCaseStepsFromXml.StepText,
                                        StepExpectedResult = testCaseStepsFromXml.StepExpectedResult,
                                    };
                                    stepstoBeUpdated.Add(testCaseStepMiniModel);
                                }
                            }
                            if (!isUpdated)
                            {
                                var testCaseStepMiniModel = new TestCaseStepMiniModel()
                                {
                                    StepOrder = testCaseStepsFromXml.StepOrder,
                                    StepText = testCaseStepsFromXml.StepText,
                                    StepExpectedResult = testCaseStepsFromXml.StepExpectedResult,
                                };
                                stepstoBeUpdated.Add(testCaseStepMiniModel);
                            }
                        }
                    }

                    int.TryParse((testCase.SelectSingleNode("estimate") as XmlElement).InnerText, out estimate);

                    testCaseInputModel = new TestCaseInputModel()
                    {
                        TestCaseId = testCaseDetails.TestCaseId,
                        TimeStamp = testCaseDetails.TimeStamp,
                        Title = testCaseTitle,
                        SectionId = sectionId,
                        TemplateId = teplateId,
                        TypeId = testCaseTypeId,
                        Estimate = estimate,
                        References = (testCase.SelectSingleNode("references") as XmlElement).InnerText,
                        Steps = inlineStep,
                        ExpectedResult = caseExpectedResult,
                        IsArchived = false,
                        Mission = (testCase.SelectSingleNode("custom/mission") as XmlElement)?.InnerText,
                        PriorityId = priorityId,
                        AutomationTypeId = automationId,
                        TestSuiteId = testSuiteId,
                        Precondition = preCondition,
                        TestCaseSteps = stepstoBeUpdated
                    };
                    testCaseId = UpsertTestCase(testCaseInputModel, loggedInContext, validations);
                    if (validations.Count > 0)
                    {
                        validationMessages.AddRange(validations);
                        validations.Clear();
                        return;
                    }
                }

                preCondition = (testCase.SelectSingleNode("custom/preconds") as XmlElement)?.InnerText;
                if (preCondition != null && preCondition.Contains("![](index.php?/attachments/get/"))
                {
                    List<FileResult> preCondAttchments = GetImagePaths(preCondition);

                    TestRailFileModel testRailFileModel = new TestRailFileModel
                    {
                        TestRailId = testCaseId,
                        IsTestCasePreCondition = true,
                        FilePathList = preCondAttchments.Select(x => x.FilePath).ToList(),
                        FileName = preCondAttchments[0].FileName
                    };

                    _testRailFileService.UpsertFile(testRailFileModel, loggedInContext, validations);
                }

                inlineStep = (testCase.SelectSingleNode("custom/steps") as XmlElement)?.InnerText;
                if (inlineStep != null && inlineStep.Contains("![](index.php?/attachments/get/"))
                {
                    List<FileResult> inlineStepAttachments = GetImagePaths(inlineStep);

                    TestRailFileModel testRailFileModel = new TestRailFileModel
                    {
                        TestRailId = testCaseId,
                        IsTestCase = true,
                        IsExpectedResult = false,
                        FilePathList = inlineStepAttachments.Select(x => x.FilePath).ToList(),
                        FileName = inlineStepAttachments[0].FileName
                    };

                    _testRailFileService.UpsertFile(testRailFileModel, loggedInContext, validations);
                }

                caseExpectedResult = (testCase.SelectSingleNode("custom/expected") as XmlElement)?.InnerText;
                if (caseExpectedResult != null && caseExpectedResult.Contains("![](index.php?/attachments/get/"))
                {
                    List<FileResult> caseExpectedResultAttachments = GetImagePaths(caseExpectedResult);

                    TestRailFileModel testRailFileModel = new TestRailFileModel
                    {
                        TestRailId = testCaseId,
                        IsTestCase = true,
                        IsExpectedResult = true,
                        FilePathList = caseExpectedResultAttachments.Select(x => x.FilePath).ToList(),
                        FileName = caseExpectedResultAttachments[0].FileName
                    };

                    _testRailFileService.UpsertFile(testRailFileModel, loggedInContext, validations);
                }

                if (validations.Count > 0)
                {
                    validationMessages.AddRange(validations);
                    validations.Clear();
                    return;
                }

                var testSuiteSteps = GetTestCaseById(testCaseId, loggedInContext, validations);

                if (validations.Count > 0)
                {
                    validationMessages.AddRange(validations);
                    validations.Clear();
                    return;
                }
                if (testSuiteSteps != null && testSuiteSteps.TestCaseSteps != null && templateType.InnerText == "Test Case (Steps)")
                {
                    for (int step = 0; step < testSuiteSteps.TestCaseSteps.Count; step++)
                    {
                        if (testCaseSteps[step].StepText.Contains("index.php?/attachments/get/"))
                        {
                            List<FileResult> stepAttachments = GetImagePaths(testCaseSteps[step].StepText);

                            TestRailFileModel testRailFileModel = new TestRailFileModel
                            {
                                TestRailId = testSuiteSteps.TestCaseSteps[step].StepId,
                                IsTestCaseStep = true,
                                IsExpectedResult = false,
                                FilePathList = stepAttachments.Select(x => x.FilePath).ToList(),
                                FileName = stepAttachments[0].FileName
                            };

                            _testRailFileService.UpsertFile(testRailFileModel, loggedInContext, validations);

                            if (validations.Count > 0)
                            {
                                validationMessages.AddRange(validations);
                                validations.Clear();
                                break;
                            }
                        }
                        if (testCaseSteps[step].StepExpectedResult.Contains("index.php?/attachments/get/"))
                        {
                            List<FileResult> stepAttachments = GetImagePaths(testCaseSteps[step].StepExpectedResult);

                            TestRailFileModel testRailFileModel = new TestRailFileModel
                            {
                                TestRailId = testSuiteSteps.TestCaseSteps[step].StepId,
                                IsTestCaseStep = true,
                                IsExpectedResult = true,
                                FilePathList = stepAttachments.Select(x => x.FilePath).ToList(),
                                FileName = stepAttachments[0].FileName
                            };

                            _testRailFileService.UpsertFile(testRailFileModel, loggedInContext, validations);

                            if (validations.Count > 0)
                            {
                                validationMessages.AddRange(validations);
                                validations.Clear();
                                break;
                            }
                        }
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "LoadCase", "TestSuiteService ", exception.Message), exception);

            }
        }

        public byte[] GetTestRepoDataForExcel(List<TestSuitesForExportModel> testSuites, TestSuiteDownloadModel exportModel, string site, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            byte[] result = null;

            if (testSuites == null || !testSuites.Any())
            {
                return null;
            }

            try
            {
                using (var memoryStream = new MemoryStream())
                {
                    using (var spreadSheet = SpreadsheetDocument.Create(memoryStream, SpreadsheetDocumentType.Workbook))
                    {
                        InsertTestSuites(spreadSheet, testSuites);

                        spreadSheet.WorkbookPart.Workbook.Save();
                    }

                    SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, site);

                    SpreadsheetDocument.Open(memoryStream, false);

                    CompanyOutputModel companyModel = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);

                    var companySettingsSearchInputModel = new CompanySettingsSearchInputModel();
                    companySettingsSearchInputModel.CompanyId = companyModel?.CompanyId;
                    companySettingsSearchInputModel.IsSystemApp = null;

                    string storageAccountName = string.Empty;

                    List<CompanySettingsSearchOutputModel> companySettings = _masterDataManagementRepository.GetCompanySettings(companySettingsSearchInputModel, loggedInContext, validationMessages).ToList();
                    if (companySettings.Count > 0)
                    {
                        var storageAccountDetails = companySettings.Where(x => x.Key == "StorageAccountName").FirstOrDefault();
                        storageAccountName = storageAccountDetails?.Value;
                    }

                    var directory = SetupCompanyFileContainer(companyModel, 8, loggedInContext.LoggedInUserId, storageAccountName);

                    var fileName = exportModel.ProjectName;

                    LoggingManager.Debug("UploadCourseFile input fileName:" + fileName);

                    fileName = fileName.Replace(" ", "_");

                    var fileExtension = ".xlsx";

                    var convertedFileName = fileName + "-" + Guid.NewGuid() + fileExtension;

                    CloudBlockBlob blockBlob = directory.GetBlockBlobReference(convertedFileName);

                    blockBlob.Properties.CacheControl = "public, max-age=2592000";

                    blockBlob.Properties.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";

                    Byte[] bytes = memoryStream?.ToArray();

                    blockBlob.UploadFromByteArray(bytes, 0, bytes.Length);

                    var fileurl = blockBlob.Uri.AbsoluteUri;

                    var toEmails = (exportModel.ToMails == null || exportModel.ToMails.Trim() == "") ? null : exportModel.ToMails.Trim().Split('\n');

                    //var exportHtml = _goalRepository.GetHtmlTemplateByName("ScenarioExportMailTemplate", loggedInContext.CompanyGuid).Replace("##ToName##", exportModel.PersonName).Replace("##PdfUrl##", fileurl);
                    
                    var exportHtml = _goalRepository.GetHtmlTemplateByName("ScenarioExportMailTemplate", loggedInContext.CompanyGuid).Replace("##ToName##", "User").Replace("##PdfUrl##", fileurl);

                    TaskWrapper.ExecuteFunctionInNewThread(() =>
                    {
                        EmailGenericModel emailModel = new EmailGenericModel
                        {
                            SmtpServer = smtpDetails?.SmtpServer,
                            SmtpServerPort = smtpDetails?.SmtpServerPort,
                            SmtpMail = smtpDetails?.SmtpMail,
                            SmtpPassword = smtpDetails?.SmtpPassword,
                            ToAddresses = toEmails,
                            HtmlContent = exportHtml,
                            Subject = "Snovasys Business Suite: Export Mail Template",
                            CCMails = null,
                            BCCMails = null,
                            MailAttachments = null,
                            IsPdf = null
                        };
                        _emailService.SendMail(loggedInContext, emailModel);
                    });

                    result = memoryStream.ToArray();

                    return result;
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTestRepoDataForExcel", "TestSuiteService ", exception.Message), exception);

                throw;
            }
        }

        private CloudBlobDirectory SetupCompanyFileContainer(CompanyOutputModel companyModel, int moduleTypeId, Guid loggedInUserId, string storageAccountName)
        {
            LoggingManager.Info("SetupCompanyFileContainer");

            CloudStorageAccount storageAccount = StorageAccount(storageAccountName);

            CloudBlobClient blobClient = storageAccount.CreateCloudBlobClient();

            Regex re = new Regex(@"(^{[&\/\\#,+()$~%._\'"":*?<>{}@`;^=-]})$");

            companyModel.CompanyName = companyModel.CompanyName.Replace(" ", string.Empty);

            string companyName = re.Replace(companyModel.CompanyName, "");

            string company = (companyModel.CompanyId.ToString()).ToLower();

            CloudBlobContainer container = blobClient.GetContainerReference(company);

            try
            {
                bool isCreated = container.CreateIfNotExists();
                if (isCreated == true)
                {
                    Console.WriteLine("Created container {0}", container.Name);

                    container.SetPermissions(new BlobContainerPermissions
                    {
                        PublicAccess = BlobContainerPublicAccessType.Blob
                    });
                }
            }

            catch (StorageException e)
            {
                Console.WriteLine("HTTP error code {0}: {1}", e.RequestInformation.HttpStatusCode, e.RequestInformation.ErrorCode);

                Console.WriteLine(e.Message);

                throw;
            }

            string directoryReference = moduleTypeId == (int)ModuleTypeEnum.Hrm ? AppConstants.HrmBlobDirectoryReference :
                 moduleTypeId == (int)ModuleTypeEnum.Assets ? AppConstants.AssetsBlobDirectoryReference :
                 moduleTypeId == (int)ModuleTypeEnum.FoodOrder ? AppConstants.FoodOrderBlobDirectoryReference :
                 moduleTypeId == (int)ModuleTypeEnum.Projects ? AppConstants.ProjectsBlobDirectoryReference :
                 moduleTypeId == (int)ModuleTypeEnum.Invoices ? AppConstants.ProjectsBlobDirectoryReference :
                 moduleTypeId == (int)ModuleTypeEnum.TestRepo ? AppConstants.ProjectsBlobDirectoryReference : AppConstants.LocalBlobContainerReference;

            CloudBlobDirectory moduleDirectory = container.GetDirectoryReference(directoryReference);

            CloudBlobDirectory userLevelDirectory = moduleDirectory.GetDirectoryReference(loggedInUserId.ToString());

            return userLevelDirectory;
        }

        private CloudStorageAccount StorageAccount(string storageAccountName)
        {
            LoggingManager.Debug("Entering into GetStorageAccount method of blob service");
            string account;
            if (string.IsNullOrEmpty(storageAccountName))
            {
                account = CloudConfigurationManager.GetSetting("StorageAccountName");
            }
            else
            {
                account = storageAccountName;
            }
            string key = CloudConfigurationManager.GetSetting("StorageAccountAccessKey");
            string connectionString = $"DefaultEndpointsProtocol=https;AccountName={account};AccountKey={key}";
            CloudStorageAccount storageAccount = CloudStorageAccount.Parse(connectionString);

            LoggingManager.Debug("Exit from GetStorageAccount method of blob service");

            return storageAccount;
        }

        private void InsertTestSuites(SpreadsheetDocument spreadSheet, List<TestSuitesForExportModel> testSuites)
        {
            foreach (var testSuite in testSuites)
            {
                testSuite.TestSuiteName = testSuite.TestSuiteName?.EndsWith(".") == true ? testSuite.TestSuiteName.Remove(testSuite.TestSuiteName.Length - 1, 1) : testSuite.TestSuiteName;

                WorksheetPart worksheetPart = OpenXmlHelper.InsertWorksheet(spreadSheet, testSuite.TestSuiteName, 1);

                InsertTestSuite(spreadSheet, worksheetPart, testSuite);
            }
        }

        private void InsertTestSuite(SpreadsheetDocument spreadSheet, WorksheetPart worksheetPart, TestSuitesForExportModel testSuite)
        {
            var sectionList = new List<SectionForExport>();

            uint rowNo = 1;
            //OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "SNo", "A", rowNo, "no", "no", false, 10);
            //OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "TCID", "B", rowNo, "no", "no", false, 10);
            //OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "TITLE", "C", rowNo, "no", "no", false, 50);

            //OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "STEP", "D", rowNo, "no", "no", false, 50);
            //OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "DATA", "E", rowNo, "no", "no", false, 10);
            //OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "EXPECTED RESULT", "F", rowNo, "no", "no", false, 50);

            //OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "PRECONDITION", "G", rowNo, "no", "no", false, 50);
            //OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "STATUS", "H", rowNo, "no", "no", false, 10);

            //OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "SECTION", "I", rowNo, "no", "no", false, 30);
            //OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "SECTION PATH", "J", rowNo, "no", "no", false, 50);

            //OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "PRIORITY", "K", rowNo, "no", "no", false, 10);
            //SuiteName	SectionHierarchy	SectionDescription	Template	Type	Preconditions	Title	StepOrder	StepDescription	StepsExpectedResult	EstimateInSeconds	Priority	AutomationType	References	Mission	Goals
            OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "SuiteName", "A", rowNo, "no", "no", false, 50);
            OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "SectionHierarchy", "B", rowNo, "no", "no", false, 50);
            OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "SectionDescription", "C", rowNo, "no", "no", false, 50);
            OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "Template", "D", rowNo, "no", "no", false, 50);

            OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "Type", "E", rowNo, "no", "no", false, 50);
            OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "Preconditions", "F", rowNo, "no", "no", false, 50);
            OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "Title", "G", rowNo, "no", "no", false, 50);

            OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "StepOrder", "H", rowNo, "no", "no", false, 50);
            OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "StepDescription", "I", rowNo, "no", "no", false, 50);

            OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "StepsExpectedResult", "J", rowNo, "no", "no", false, 50);
            OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "EstimateInSeconds", "K", rowNo, "no", "no", false, 50);

            OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "Priority", "L", rowNo, "no", "no", false, 50);
            OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "AutomationType", "M", rowNo, "no", "no", false, 50);
            OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "References", "N", rowNo, "no", "no", false, 50);
            OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "Mission", "O", rowNo, "no", "no", false, 50);
            OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "Goals", "P", rowNo, "no", "no", false, 50);

            rowNo = 2;
            int sNo = 1;
            OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, testSuite.TestSuiteName ?? string.Empty, "A", rowNo);

            foreach (var section in testSuite.Sections)
            {
                section.SectionName = section.SectionName?.EndsWith(".") == true ? section.SectionName.Remove(section.SectionName.Length - 1, 1) : section.SectionName;
                var sectionObject = sectionList.FirstOrDefault(x => x.SectionName == section.SectionName && x.ParentSectionName == section.ParentSectionName);
                if (sectionObject == null)
                {
                    sectionObject = new SectionForExport { SectionName = section.SectionName, ParentSectionName = section.ParentSectionName};
                    sectionList.Add(sectionObject);
                }
            }

            foreach (var section in testSuite.Sections)
            {

                //var testRepositoryPath = "/" + testSuite.TestSuiteName + "/" + GetRepositoryPath(sectionList, section.ParentSectionName, section.SectionName);
                var testRepositoryPath = GetRepositoryPath(sectionList, section.ParentSectionName, section.SectionName);
                foreach (var testCase in section.TestCases)
                {
                    var testSteps = testCase.TestCaseSteps != null ? testCase.TestCaseSteps : new List<TestCaseStepsForExport>();

                    if (!string.IsNullOrEmpty(testCase.Steps))
                    {
                        testSteps.Add(new TestCaseStepsForExport { StepText = testCase.Steps, StepExpectedResult = testCase.ExpectedResult });
                    }

                    var sNoStr = sNo.ToString();
                    //OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, sNoStr ?? string.Empty, "A", rowNo);
                    //OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, testCase.TestCaseIdentity ?? string.Empty, "B", rowNo);
                    OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, testRepositoryPath ?? string.Empty, "B", rowNo);
                    OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, section.Description ?? string.Empty, "C", rowNo);
                    OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, testCase.TemplateName ?? string.Empty, "D", rowNo);
                    OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, testCase.TypeName ?? string.Empty, "E", rowNo);
                    OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, testCase.Precondition ?? string.Empty, "F", rowNo);

                    var testCaseTitle = testCase.Title?.EndsWith(".") == true ? testCase.Title.Remove(testCase.Title.Length - 1, 1) : testCase.Title;
                    OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, testCaseTitle ?? string.Empty, "G", rowNo);

                    OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, string.Empty, "H", rowNo);
                    OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, testCase.Estimate.ToString() ?? string.Empty, "K", rowNo);
                    OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, testCase.PriorityType ?? string.Empty, "L", rowNo);
                    OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, testCase.AutomationType ?? string.Empty, "M", rowNo);
                    OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, testCase.References ?? string.Empty, "N", rowNo);
                    OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, testCase.Mission ?? string.Empty, "O", rowNo);
                    OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, testCase.Goals ?? string.Empty, "P", rowNo);

                    //OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, string.Empty, "E", rowNo);

                    //OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, testCase.Precondition ?? string.Empty, "G", rowNo);
                    //OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "To Do", "H", rowNo);

                    //OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, section.SectionName ?? string.Empty, "I", rowNo);
                    //OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, testRepositoryPath ?? string.Empty, "J", rowNo);

                    //OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, testCase.PriorityType ?? string.Empty, "K", rowNo);

                    for (int i = 0; i < testSteps.Count(); i++)
                    {
                        var testStep = testSteps[i];

                        if (i > 0)
                        {
                            rowNo++;
                            //OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, sNoStr ?? string.Empty, "A", rowNo);
                            //OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, testCase.TestCaseIdentity ?? string.Empty, "B", rowNo);
                        }

                        OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, testStep.StepText ?? string.Empty, "I", rowNo);
                        OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, testStep.StepExpectedResult ?? string.Empty, "J", rowNo);
                    }

                    rowNo++;
                    sNo++;

                } // foreach (var testCase in section.TestCases)

            } // foreach(var section in testSuite.Sections)

            worksheetPart.Worksheet.Save();
        }

        private string GetRepositoryPath(List<SectionForExport> sectionList, string parentSectionName, string path)
        {
            var section = sectionList.FirstOrDefault(x => x.SectionName == parentSectionName && x.SectionName != x.ParentSectionName);
            if (section != null)
            {
                path = section.SectionName + ">" + path;
                return GetRepositoryPath(sectionList, section.ParentSectionName, path);
            }

            return path;
        }

        /* END OF CONVERT JSON TO EXCEL */

        public List<TestSuitesForExportModel> GetTestRepoDataForJson(string projectName, string testSuiteName, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            List<TestSuitesForExportModel> testSuitesForExport = new List<TestSuitesForExportModel>();

            try
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetTestRepoDataForJson", "projectName", projectName, "Test Suite Service"));

                List<ValidationMessage> validations = new List<ValidationMessage>();

                var projectSearchCriteriaInputModel = new ProjectSearchCriteriaInputModel()
                {
                    ProjectName = projectName.Trim(),
                    IsArchived = false
                };

                var projectSearchResults = _projectService.SearchProjects(projectSearchCriteriaInputModel, loggedInContext, validations).FirstOrDefault();

                TestSuiteSearchCriteriaInputModel testSuiteSearchInputCriteriaModel = new TestSuiteSearchCriteriaInputModel();

                testSuiteSearchInputCriteriaModel.ProjectId = projectSearchResults.ProjectId;
                testSuiteSearchInputCriteriaModel.TestSuiteName = testSuiteName;

                List<TestSuiteOverviewModel> testSuites = _testSuitePartialRepository.SearchTestSuites(testSuiteSearchInputCriteriaModel, loggedInContext, validationMessages);

                foreach (var testsuite in testSuites)
                {

                    TestSuiteSectionSearchCriteriaInputModel testSuiteSectionSearchCriteriaInputModel = new TestSuiteSectionSearchCriteriaInputModel();

                    testSuiteSectionSearchCriteriaInputModel.TestSuiteId = testsuite.TestSuiteId;

                    List<SectionForExport> SectionCasesList = new List<SectionForExport>();
                    var sections = SearchTestSuiteSections(testSuiteSectionSearchCriteriaInputModel, loggedInContext, validations);

                    foreach (var section in sections)
                    {
                        SearchTestCaseInputModel searchTestCaseInputModel = new SearchTestCaseInputModel();

                        searchTestCaseInputModel.SectionId = section.TestSuiteSectionId;
                        searchTestCaseInputModel.TestSuiteId = section.TestSuiteId;

                        try
                        {
                            var testCases = _testSuitePartialRepository.SearchTestCases(searchTestCaseInputModel, loggedInContext, validationMessages);

                            List<TestCasesForExport> testCaseList = new List<TestCasesForExport>();

                            foreach (var testcase in testCases)
                            {
                                SearchTestCaseDetailsInputModel searchTestCaseDetailsInputModel = new SearchTestCaseDetailsInputModel();
                                searchTestCaseDetailsInputModel.TestCaseId = testcase.TestCaseId;

                                try
                                {

                                    var testCaseDetails = _testSuitePartialRepository.SearchTestCaseDeatailsById(searchTestCaseDetailsInputModel, loggedInContext, validationMessages);

                                    List<TestCaseStepsForExport> testCaseStepsForExports;

                                    if (testCaseDetails != null && testCaseDetails.TestCaseStepsXml != null)
                                    {
                                        testCaseDetails.TestCaseSteps = Utilities.GetObjectFromXml<TestCaseStepMiniModel>(testCaseDetails.TestCaseStepsXml, "TestCaseStepMiniModel");

                                    }

                                    testCaseStepsForExports = testCaseDetails?.TestCaseSteps?.Select(p => new TestCaseStepsForExport()
                                    {
                                        StepExpectedResult = p.StepExpectedResult,
                                        StepText = p.StepText
                                    }).ToList();

                                    testCaseList.Add(new TestCasesForExport
                                    {
                                        TestCaseIdentity = testCaseDetails.TestCaseIdentity,
                                        Title = testCaseDetails.Title,
                                        Estimate = testCaseDetails.Estimate,
                                        TemplateName = testCaseDetails.TemplateName,
                                        TypeName = testCaseDetails.TypeName,
                                        References = testCaseDetails.References,
                                        Steps = testCaseDetails.Steps,
                                        ExpectedResult = testCaseDetails.ExpectedResult,
                                        Precondition = testCaseDetails.Precondition,
                                        AutomationType = testCaseDetails.AutomationType,
                                        PriorityType = testCaseDetails.PriorityType,
                                        Goals = testCaseDetails.Goals,
                                        Mission = testCaseDetails.Mission,
                                        Version = testCaseDetails.Version,
                                        Elapsed = testCaseDetails.Elapsed,
                                        CreatedDateTime = testCaseDetails.CreatedDateTime,
                                        AssignToProfileImage = testCaseDetails.AssignToProfileImage,
                                        AssignToName = testCaseDetails.AssignToName,
                                        TestCaseSteps = testCaseStepsForExports?.ToList()

                                    });
                                }
                                catch
                                {
                                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadingTestSuiteXML", "TestSuite", "Unable to upsert testsuiteSection with the name " + searchTestCaseInputModel.SectionId + " trying to update if available"));
                                    var StaticValidation = new ValidationMessage
                                    {
                                        ValidationMessaage = string.Format(ValidationMessages.TestSuiteUploadParentSectionName, searchTestCaseDetailsInputModel.TestCaseId),
                                        ValidationMessageType = MessageTypeEnum.Error
                                    };
                                    validationMessages.Add(StaticValidation);
                                    validations.Clear();
                                }
                            }

                            SectionCasesList.Add(new SectionForExport
                            {

                                SectionName = section.SectionName,
                                ParentSectionName = section.ParentSectionName,
                                Description = section.Description,
                                CreatedDateTime = section.CreatedDateTime,
                                TestCases = testCaseList?.OrderBy(p => p.CreatedDateTime).ToList()
                            });

                        }
                        catch
                        {
                            LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadingTestSuiteXML", "TestSuite", "Unable to upsert testsuiteSection with the name " + searchTestCaseInputModel.SectionId + " trying to update if available"));
                            var staticValidation = new ValidationMessage
                            {
                                ValidationMessaage = string.Format(ValidationMessages.TestSuiteUploadParentSectionName, searchTestCaseInputModel.SectionId),
                                ValidationMessageType = MessageTypeEnum.Error
                            };
                            validationMessages.Add(staticValidation);
                            validations.Clear();
                        }
                    }

                    testSuitesForExport.Add(new TestSuitesForExportModel
                    {
                        TestSuiteName = testsuite.TestSuiteName,
                        Description = testsuite.Description,
                        CreatedDateTime = testsuite.CreatedDateTime,
                        Sections = SectionCasesList?.OrderBy(p => p.CreatedDateTime).ToList()

                    });

                }
                return testSuitesForExport.OrderBy(p => p.CreatedDateTime).ToList();
            }

            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTestRepoDataForJson", "TestSuiteService ", exception.Message), exception);

                return testSuitesForExport;
            }

        }

        private void LoadSection(XmlElement section, Guid parentSectionId, Guid testSuiteId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, List<DropdownModel> templates, List<TestCaseAutomationTypeOutputModel> automationTypes, List<DropdownModel> priorities, List<DropdownModel> testCaseTypes, string parentSectionName)
        {
            var validations = new List<ValidationMessage>();
            var sectionName = string.IsNullOrEmpty((section.SelectSingleNode("name") as XmlElement).InnerText) ? (section.SelectSingleNode("name") as XmlElement).InnerText : (section.SelectSingleNode("name") as XmlElement).InnerText.Trim();
            var sectionDescription = (section.SelectSingleNode("description") as XmlElement)?.InnerText;

            XmlNodeList subSections = section.SelectNodes("sections/section");

            var testSuiteSectionInputModel = new TestSuiteSectionInputModel()
            {
                TestSuiteId = testSuiteId,
                SectionName = sectionName,
                ParentSectionId = parentSectionId,
                Description = sectionDescription
            };
            var subSectionId = UpsertTestSuiteSection(testSuiteSectionInputModel, loggedInContext, validations);

            if (validations.Count > 0)
            {
                LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadingTestSuiteXML", "TestSuite", "Unable to upsert testsuiteSection with the name " + sectionName + " trying to update if available"));
                var StaticValidation = new ValidationMessage
                {
                    ValidationMessaage = string.Format(ValidationMessages.TestSuiteUploadSectionNotPossible, sectionName, parentSectionName),
                    ValidationMessageType = MessageTypeEnum.Error
                };
                validationMessages.Add(StaticValidation);
                validations.Clear();

                var testSuiteSectionSearchCriteriaInput = new TestSuiteSectionSearchCriteriaInputModel()
                {
                    ParentSectionId = parentSectionId,
                    SectionName = sectionName,
                    IsFromTestRunUplaods = true,
                    TestSuiteId = testSuiteId
                };

                subSectionId = SearchTestSuiteSections(testSuiteSectionSearchCriteriaInput, loggedInContext, validations).FirstOrDefault()?.TestSuiteSectionId;
                if (validations.Count > 0)
                {
                    validationMessages.AddRange(validations);
                    validations.Clear();
                    return;
                }
                if (subSectionId == null)
                {
                    StaticValidation = new ValidationMessage
                    {
                        ValidationMessaage = string.Format(ValidationMessages.TestSuiteUploadSectionNotFound, sectionName, parentSectionName),
                        ValidationMessageType = MessageTypeEnum.Error
                    };
                    validationMessages.Add(StaticValidation);
                    return;
                }
            }

            foreach (var subSection in subSections.Cast<XmlElement>().Where(x => x != null).ToList())
            {
                LoadSection(subSection, (Guid)subSectionId, testSuiteId, loggedInContext, validationMessages, templates, automationTypes, priorities, testCaseTypes, sectionName);
            }

            XmlNodeList testCases = section.SelectNodes("cases/case");

            foreach (var testCase in testCases.Cast<XmlElement>().Where(x => x != null).ToList())
            {
                LoadCase(testCase, (Guid)subSectionId, testSuiteId, loggedInContext, validationMessages, templates, automationTypes, priorities, testCaseTypes, sectionName);
            }
        }

        public List<FileResult> GetImagePaths(string content)
        {
            try
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetImagePaths", "content", content, "Test suite Service"));

                var contentLength = content.Length;
                var pattern = "index.php?/attachments/get/";
                var patternlength = pattern.Length;
                List<FileResult> filePaths = new List<FileResult>();

                for (int i = 0; i < contentLength; i++)
                {
                    int startIndex = content.IndexOf(pattern, StringComparison.Ordinal);

                    if (startIndex > 0)
                    {
                        startIndex = startIndex + patternlength;
                        int endIndex = content.IndexOf(")", startIndex, StringComparison.Ordinal);
                        var id = content.Substring(startIndex, endIndex - startIndex);
                        filePaths.Add(GetImages(id));
                        content = content.Substring(endIndex);
                        i = i + endIndex;
                    }
                    else
                    {
                        break;
                    }
                }

                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetImagePaths", "Test suite Service"));

                return filePaths;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetImagePaths", "TestSuiteService ", exception.Message), exception);

                throw;
            }
        }

        public string ReplaceImageUrls(string content)
        {
            try
            {
                var modifiedContent = content;
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "ReplaceImageUrls", "content", content, "Test suite Service"));

                var contentLength = content.Length;
                var pattern = "index.php?/attachments/get/";
                var patternlength = pattern.Length;

                for (int i = 0; i < contentLength; i++)
                {
                    int startIndex = content.IndexOf(pattern, StringComparison.Ordinal);

                    if (startIndex > 0)
                    {
                        startIndex = startIndex + patternlength;
                        int endIndex = content.IndexOf(")", startIndex, StringComparison.Ordinal);
                        var imageUrl = content.Substring(startIndex, endIndex - startIndex);
                        var url = content.Substring(startIndex - (patternlength + 4), patternlength + 5 + imageUrl.Length);
                        modifiedContent = modifiedContent.Replace(url, "");
                        content = content.Substring(endIndex);
                        i = i + endIndex;
                    }
                    else
                    {
                        break;
                    }
                }

                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ReplaceImageUrls", "Test suite Service"));

                return modifiedContent;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ReplaceImageUrls", "TestSuiteService ", exception.Message), exception);

                throw;
            }
        }

        private List<TestCaseStepMiniModel> SplitSteps(string step)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SplitSteps", "step", step, "Test suite Service"));

            List<string> stepsResult = new List<string>();

            List<string> expectedResults = new List<string>();

            const string searchText = "\r\nExpected Result:\r\n";

            var steplength = step.Length;
            int number = 1;

            List<TestCaseStepMiniModel> testCaseStepMiniModels = new List<TestCaseStepMiniModel>();

            for (int i = 0; i < steplength; i++)
            {
                int stepStartIndex = step.IndexOf(number + ". ", StringComparison.Ordinal);

                int stepEndIndex = step.IndexOf(searchText, StringComparison.Ordinal);

                var nextStepIndex = step.IndexOf(number + 1 + ". ", StringComparison.Ordinal);

                if (nextStepIndex != -1 && nextStepIndex < stepEndIndex)
                {
                    stepEndIndex = -1;
                }

                if (stepEndIndex < 0)
                {
                    stepEndIndex = step.IndexOf(number + 1 + ". ", StringComparison.Ordinal);

                    if (stepEndIndex > 0)
                    {
                        stepsResult.Add(step.Substring(stepStartIndex + 3, stepEndIndex - (stepStartIndex + 3)));

                        step = step.Substring(stepEndIndex);
                        i = i + stepEndIndex;
                        number++;
                        expectedResults.Add(string.Empty);
                        continue;
                    }

                    stepsResult.Add(step.Substring(stepStartIndex));
                    expectedResults.Add(string.Empty);
                    break;
                }

                stepsResult.Add(step.Substring(stepStartIndex + 3, stepEndIndex - (stepStartIndex + 3)));

                int resultStartIndex = stepEndIndex + searchText.Length;

                int resultEndIndex = step.IndexOf(number + 1 + ". ", StringComparison.Ordinal);

                if (resultEndIndex > 0)
                {
                    expectedResults.Add(step.Substring(resultStartIndex, resultEndIndex - resultStartIndex));
                    step = step.Substring(resultEndIndex);
                }
                else
                {
                    expectedResults.Add(step.Substring(resultStartIndex));
                    break;
                }

                i = i + resultEndIndex;

                number++;
            }

            if (stepsResult.Count != expectedResults.Count)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SplitSteps Steps and expected results count mismatched", "Test suite Service"));
                return null;
            }

            for (int j = 0; j < stepsResult.Count; j++)
            {
                TestCaseStepMiniModel testCaseStepMiniModel = new TestCaseStepMiniModel
                {
                    StepOrder = j + 1,
                    StepText = stepsResult[j],
                    StepExpectedResult = expectedResults[j]
                };

                testCaseStepMiniModels.Add(testCaseStepMiniModel);
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SplitSteps", "Test suite Service"));

            return testCaseStepMiniModels;
        }

        private FileResult GetImages(string imageId)
        {
            try
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetImages", "imageId", imageId, "Test suite Service"));

                string tr_session = CloudConfigurationManager.GetSetting("TestRailSession");
                string tr_rememberme = CloudConfigurationManager.GetSetting("TestRailRememberMe");
                var baseAddress = new Uri("https://snovasys.testrail.io/"); // from web.config
                var cookieContainer = new CookieContainer();
                using (var handler = new HttpClientHandler { CookieContainer = cookieContainer })
                using (var client = new HttpClient(handler) { BaseAddress = baseAddress })
                {
                    cookieContainer.Add(baseAddress, new Cookie("tr_session", tr_session));
                    cookieContainer.Add(baseAddress, new Cookie("tr_rememberme", tr_rememberme));
                    var response = client.GetAsync("index.php?/attachments/get/" + imageId).Result;
                    if (response.IsSuccessStatusCode)
                    {
                        HttpContent content = response.Content;
                        var contentStream = content.ReadAsStreamAsync();
                        FilePostInputModel filePostInputModel = new FilePostInputModel
                        {
                            FileName = string.IsNullOrEmpty(content.Headers.ContentDisposition?.FileName?.Trim(new[] { ' ', '/', '"' })) ? Guid.NewGuid().ToString() + ".png" : content.Headers.ContentDisposition?.FileName.Trim(new[] { ' ', '/', '"' }),
                            ContentType = content.Headers.ContentType.ToString(),
                            MemoryStream = ((MemoryStream)contentStream.Result).ToArray()
                        };
                        var filePath = _fileStoreService.PostFile(filePostInputModel);
                        FileResult fileResult = new FileResult
                        {
                            FileName = filePostInputModel.FileName,
                            FilePath = filePath
                        };

                        LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetImages", "Test suite Service"));

                        return fileResult;
                    }
                    LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetImages", "Test suite Service"));

                    throw new FileNotFoundException();
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetImages", "TestSuiteService ", exception.Message), exception);

                throw;
            }
        }

        public Guid? UpsertTestCaseAutomationType(TestCaseAutomationTypeInputModel testCaseAutomationTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertTestCaseAutomationType", "Test Suite Service"));
            LoggingManager.Debug(testCaseAutomationTypeInputModel.ToString());

            if (!TestSuiteValidationHelper.UpsertTestCaseAutomationTypeValidation(testCaseAutomationTypeInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                testCaseAutomationTypeInputModel.TimeZone = userTimeDetails?.TimeZone;
            }
            if (testCaseAutomationTypeInputModel.TimeZone == null)
            {
                var indianTimeDetails = TimeZoneHelper.GetIstTime();
                testCaseAutomationTypeInputModel.TimeZone = indianTimeDetails?.TimeZone;
            }


            testCaseAutomationTypeInputModel.TestCaseAutomationTypeId = _testSuitePartialRepository.UpsertTestCaseAutomationType(testCaseAutomationTypeInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertTestCaseAutomationTypeCommandId, testCaseAutomationTypeInputModel, loggedInContext);

            LoggingManager.Debug(testCaseAutomationTypeInputModel.TestCaseAutomationTypeId?.ToString());

            return testCaseAutomationTypeInputModel.TestCaseAutomationTypeId;
        }

        public List<TestCaseAutomationTypeOutputModel> GetAllTestCaseAutomationTypes(TestCaseAutomationTypeSearchCriteriaInputModel testCaseAutomationTypeSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get All Test Case Automation Types", "testCaseAutomationTypeSearchCriteriaInputModel", testCaseAutomationTypeSearchCriteriaInputModel, "TestSuite Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.GetAllTestCaseAutomationTypesCommandId, testCaseAutomationTypeSearchCriteriaInputModel, loggedInContext);

            List<TestCaseAutomationTypeOutputModel> automationTypesDetailedList = _testSuitePartialRepository.GetAllTestCaseAutomationTypes(testCaseAutomationTypeSearchCriteriaInputModel, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }
            return automationTypesDetailedList;
        }

        public void UpdateFolderAndStoreSizeByFolderId(Guid? folderId, LoggedInContext loggedInContext)
        {
            List<ValidationMessage> validationMessages = new List<ValidationMessage>();

            _fileRepository.UpdateFolderAndStoreSizeByFolderId(folderId, loggedInContext, validationMessages);
        }
    }
}