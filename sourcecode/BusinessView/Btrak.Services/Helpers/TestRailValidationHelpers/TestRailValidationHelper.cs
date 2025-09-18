using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.TestRail;
using BTrak.Common;

namespace Btrak.Services.Helpers.TestRailValidationHelpers
{
    public class TestRailValidationHelper
    {
        public void UpsertMilestoneValidation(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, MilestoneInputModel milestoneInputModel)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Milestone validating LoggedInUser", "Milestone Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (milestoneInputModel.ProjectId == null || milestoneInputModel.ProjectId == Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Milestone validating Project Id", "ProjectId",milestoneInputModel.ProjectId, "Milestone Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyProjectId
                });
            }

            if (string.IsNullOrEmpty(milestoneInputModel.MilestoneTitle))
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Project not found with the provided project identifier", "Title", milestoneInputModel.MilestoneTitle, "Milestone Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyMilestoneTitle
                });
            }
            else if (milestoneInputModel.MilestoneTitle.Length > AppConstants.InputWithMaxSize250)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Milestone Validating title length", "Title", milestoneInputModel.MilestoneTitle, "Milestone Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForMilestoneTitle
                });
            }
        }

        public void ValidateMilestoneId(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, Guid? milestoneId)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "validating LoggedInUser", "Milestone Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (milestoneId == Guid.Empty || milestoneId == null)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "validating milestone Id", "milestoneId", milestoneId, "Milestone Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyMilestoneId
                });
            }
        }

        public void ValidateUserstoryId(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, Guid? userstoryId)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "validating userstoryId", "TestRun Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (userstoryId == Guid.Empty || userstoryId == null)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "validating userstory Id", "userstoryId", userstoryId, "Testrun Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyUserStoryId
                });
            }
        }

        public void UpsertTestRunValidation(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, TestRunInputModel testRunInputModel)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Test Run validating LoggedInUser", "Test Run Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (testRunInputModel.ProjectId == null || testRunInputModel.ProjectId == Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Test Run validating Project", "ProjectId", testRunInputModel.ProjectId, "Test Run Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyProjectId
                });
            }

            if (testRunInputModel.TestSuiteId == null || testRunInputModel.TestSuiteId == Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Test Run validating Test Suite", "TestSuiteId", testRunInputModel.TestSuiteId, "Test Run Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyTestSuiteId
                });
            }

            if (string.IsNullOrEmpty(testRunInputModel.TestRunName))
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Test Run validating TestRun Name", "TestRun Name", testRunInputModel.TestRunName, "Test Run Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyTestRunName)
                });
            }

            else if (testRunInputModel.TestRunName.Length > AppConstants.InputWithMaxSize250)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Test Run validating TestRunName Length", "TestRun Name", testRunInputModel.TestRunName, "Test Run Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.MaximumLengthForTestRunName)
                });
            }
        }

        public void UpsertTestPlanValidation(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, TestPlanInputModel testPlanInputModel)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Test Plan validating LoggedInUser", "Test Run Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (testPlanInputModel.ProjectId == null || testPlanInputModel.ProjectId == Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Test Plan validating Project", "ProjectId", testPlanInputModel.ProjectId, "Test Run Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyProjectId
                });
            }

            if (string.IsNullOrEmpty(testPlanInputModel.TestPlanName))
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Test Plan validating TestPlan Name", "TestPlanName", testPlanInputModel.TestPlanName, "Test Run Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyTestPlanName)
                });
            }

            else if (testPlanInputModel.TestPlanName.Length > AppConstants.InputWithMaxSize250)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Test Run validating TestPlanName Length", "TestPlanName", testPlanInputModel.TestPlanName, "Test Run Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.MaximumLengthForTestRunName)
                });
            }
        }

        public void UpdateTestCaseStatusValidation(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, TestCaseStatusInputModel testCaseStatusInputModel)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Update Test Case Status validating loggedInUser", "Test Run Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (testCaseStatusInputModel.TestCaseId == Guid.Empty || testCaseStatusInputModel.TestCaseId == null)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Update Test Case Status validating TestCaseId", "TestCaseId", testCaseStatusInputModel.TestCaseId, "Test Run Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyTestCaseId
                });
            }
        }

        public void UpsertUserStoryScenarioValidation(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, TestCaseStatusInputModel testCaseStatusInputModel)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert UserStory Scenario validating loggedInUser", "Test Run Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (testCaseStatusInputModel?.TestCaseId == Guid.Empty || testCaseStatusInputModel?.TestCaseId == null)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert UserStory Scenario TestCaseId", "TestCaseId", testCaseStatusInputModel.TestCaseId, "Test Run Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyTestCaseId
                });
            }
        }

        public void UpdateAssignForMultipleTestCases(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, TestCaseAssignInputModel testCaseAssignInputModel)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Update Multiple TestCase Assign validating loggedInUser", "Test Run Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (testCaseAssignInputModel.TestCaseIds == null || testCaseAssignInputModel.TestCaseIds.Contains(Guid.Empty))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyTestCaseId
                });
            }

            if (testCaseAssignInputModel.TestRunId == null || testCaseAssignInputModel.TestRunId == Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Update Multiple TestCase Assign validating TestRunId", "TestRunId", testCaseAssignInputModel.TestRunId, "Test Run Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyTestRunId
                });
            }
        }

        public void UpsertFileValidation(TestRailFileModel testRailFileModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert File Validation validating loggedInUser", "Test Run Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (testRailFileModel.FilePathList.Count < 1)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyFilePath
                });
            }

            if (testRailFileModel.TestRailId == null || testRailFileModel.TestRailId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyTestRailId
                });
            }
        }

        public void UploadTestRunsCsvValidation(UploadTestRunsFromExcelModel uploadTestRunsFromExcelMode, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Test Case Id validating LoggedInUser", "Test suite Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (uploadTestRunsFromExcelMode.ID != "ID" && uploadTestRunsFromExcelMode.Title != "Title")
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.HeaderColumnsNotMatched
                });
            }
        }

        public void UpsertReportValidation(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, ReportInputModel reportInputModel)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Report validating LoggedInUser", "Report Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (reportInputModel.ProjectId == null || reportInputModel.ProjectId == Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Report validating Project", "ProjectId", reportInputModel.ProjectId, "Report Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyProjectId
                });
            }

            //if (reportInputModel.MilestoneId == null || reportInputModel.MilestoneId == Guid.Empty)
            //{
            //    LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Report validating Project", "MilestoneId", reportInputModel.MilestoneId, "Report Service"));

            //    validationMessages.Add(new ValidationMessage
            //    {
            //        ValidationMessageType = MessageTypeEnum.Error,
            //        ValidationMessaage = ValidationMessages.NotEmptyMilestoneId
            //    });
            //}

            if (string.IsNullOrEmpty(reportInputModel.ReportName))
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Report validating TestPlan Name", "ReportName", reportInputModel.ReportName, "Report Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyReportName)
                });
            }

            else if (reportInputModel.ReportName.Length > AppConstants.InputWithMaxSize250)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Report validating ReportName Length", "ReportName", reportInputModel.ReportName, "Report Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.MaximumLengthForReportName)
                });
            }
        }

        public void SendReportEmailValidator(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, ReportsEmailInputModel reportsEmailInputModel)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Send Report Email Validator", "Report Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            //if (string.IsNullOrEmpty(reportsEmailInputModel.EmailString))
            //{
            //    LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Send Report Email Validator", "EmailString", reportsEmailInputModel.EmailString, "Report Service"));

            //    validationMessages.Add(new ValidationMessage
            //    {
            //        ValidationMessageType = MessageTypeEnum.Error,
            //        ValidationMessaage = ValidationMessages.NoEmptyEmailString
            //    });
            //}

            if (string.IsNullOrEmpty(reportsEmailInputModel.ReportName))
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Send Report Email Validator", "ReportName", reportsEmailInputModel.ReportName, "Report Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyReportName
                });
            }

            if (reportsEmailInputModel.ReportId == null || reportsEmailInputModel.ReportId == Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Send Report Email Validator", "ReportId", reportsEmailInputModel.ReportId, "Report Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyReportId
                });
            }

            if (reportsEmailInputModel.ToUsers == null)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Send Report Email Validator", "ToUsers", reportsEmailInputModel.ToUsers, "Report Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyEmailReceiverList)
                });
            }
        }
    }
}
