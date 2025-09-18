using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.TestRail;
using BTrak.Common;

namespace Btrak.Services.Helpers.TestRailValidationHelpers
{
    public class TestSuiteValidationHelper
    {
        public void UpsertTestSuiteCheckValidation(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, TestSuiteInputModel testSuiteInputModel)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Test Suite validating LoggedInUser", "Test suite Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (testSuiteInputModel.ProjectId == null || testSuiteInputModel.ProjectId == Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Test Suite validating Project", "ProjectId", testSuiteInputModel.ProjectId, "Test suite Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyProjectId
                });
            }

            if (string.IsNullOrEmpty(testSuiteInputModel.TestSuiteName))
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Test Suite validating TestSuite Name", "TestSuite Name", testSuiteInputModel.TestSuiteName, "Test suite Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyTestSuiteName)
                });
            }

            else if (testSuiteInputModel.TestSuiteName.Length > AppConstants.InputWithMaxSize250)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Test Suite validating TestSuiteName Length","Test Suite Name", testSuiteInputModel.TestSuiteName, "Test suite Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.MaximumLengthForTestSuiteName)
                });
            }
        }

        public void UpsertTestSuiteSectionCheckValidation(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, TestSuiteSectionInputModel testSuiteSectionInputModel)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Test Suite Section validating LoggedInUser", "Test suite Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (testSuiteSectionInputModel.TestSuiteId == null || testSuiteSectionInputModel.TestSuiteId == Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Test Suite Section validating TestSuiteId", "Test Suite Id", testSuiteSectionInputModel.TestSuiteId, "Test suite Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyTestSuiteId
                });
            }

            if (string.IsNullOrEmpty(testSuiteSectionInputModel.SectionName))
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Test Suite Section validating SectionName", "Section Name" , testSuiteSectionInputModel.SectionName, "Test suite Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyTestSuiteSectionName
                });
            }

            else if (testSuiteSectionInputModel.SectionName.Length > AppConstants.InputWithMaxSize250)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Test Suite Section validating SectionName", "Section Name", testSuiteSectionInputModel.SectionName, "Test suite Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForTestSuiteSectionName
                });
            }
        }

        public void TestRunIdValidation(Guid? testRunId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Test Run Id validating LoggedInUser", "Test suite Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (testRunId == null || testRunId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyTestRunId
                });
            }
        }

        public void UpsertTestCaseCheckValidation(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, TestCaseInputModel testCaseInputModel)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Test Case validating LoggedInUser", "Test suite Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (testCaseInputModel.TestSuiteId == null || testCaseInputModel.TestSuiteId == Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Test Case validating TestSuiteId", "testSuiteId", testCaseInputModel.TestSuiteId, "Test suite Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyTestSuiteId
                });
            }

            if (string.IsNullOrEmpty(testCaseInputModel.Title))
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Test Case validating TestCase Title", "Title", testCaseInputModel.Title, "Test suite Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyTestCaseTitle)
                });
            }
            else if (testCaseInputModel.Title.Length > AppConstants.InputWithMaxSize500)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Test Case validating Test Case title Length", "Title", testCaseInputModel.Title, "Test suite Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForTestCaseTitle
                });
            }

            if (testCaseInputModel.SectionId == null || testCaseInputModel.SectionId == Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Test Case validating SectionId", "SectionId", testCaseInputModel.SectionId, "Test suite Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyTestCaseSectionId
                });
            }

            if (testCaseInputModel.TemplateId == null || testCaseInputModel.TemplateId == Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Test Case validating TemplateId", "TemplateId", testCaseInputModel.TemplateId, "Test suite Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyTestCaseTemplateId
                });
            }

            if (testCaseInputModel.TypeId == null || testCaseInputModel.TypeId == Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Test Case validating TypeId", "TypeId", testCaseInputModel.TypeId, "Test suite Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyTestCaseTypeId
                });
            }

            if (testCaseInputModel.PriorityId == null || testCaseInputModel.PriorityId == Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Test Case validating PriorityId", "PriorityId", testCaseInputModel.PriorityId, "Test suite Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyTestCasePriorityId
                });
            }
        }

        public void UpsertMultipleTestCaseCheckValidation(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, TestCaseInputModel testCaseInputModel)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Multiple Test Case validating LoggedInUser", "Test suite Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (testCaseInputModel.TestSuiteId == null || testCaseInputModel.TestSuiteId == Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Multiple Test Case validating TestSuiteId", "testSuiteId", testCaseInputModel.TestSuiteId, "Test suite Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyTestSuiteId
                });
            }

            if (testCaseInputModel.SectionId == null || testCaseInputModel.SectionId == Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Multiple Test Case validating SectionId", "SectionId", testCaseInputModel.SectionId, "Test suite Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyTestCaseSectionId
                });
            }

            if (string.IsNullOrEmpty(testCaseInputModel.Title))
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Multiple Test Case validating TestCase Title", "Title", testCaseInputModel.Title, "Test suite Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyTestCaseTitle)
                });
            }

            if (testCaseInputModel.MultipleTestCasesTitles != null)
                foreach (var multipleTestCasesTitles in testCaseInputModel.MultipleTestCasesTitles)
                {
                    if (multipleTestCasesTitles.Length > AppConstants.InputWithMaxSize500)
                    {
                        validationMessages.Add(new ValidationMessage
                        {
                            ValidationMessageType = MessageTypeEnum.Error,
                            ValidationMessaage = ValidationMessages.MaximumLengthForTestCaseTitle
                        });
                    }
                }
        }

        public void UpsertTestCaseTitleCheckValidation(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, TestCaseTitleInputModel testCaseTitleInputModel)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Test Case Title validating LoggedInUser", "Test suite Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (testCaseTitleInputModel.TestSuiteId == null || testCaseTitleInputModel.TestSuiteId == Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Test Case Title validating Test Suite Id", "TestSuiteId", testCaseTitleInputModel.TestSuiteId, "Test suite Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyTestSuiteId
                });
            }
            
            if (testCaseTitleInputModel.Title == string.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Test Case Title validating Title", "title", testCaseTitleInputModel.Title, "Test suite Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyTestCaseTitle
                });
            }
            else if (testCaseTitleInputModel.Title.Length > AppConstants.InputWithMaxSize500)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Test Case validating Test Case title Length", "Title", testCaseTitleInputModel.Title, "Test suite Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForTestCaseTitle
                });
            }
        }

        public void UpdateMultipleTestCasesCheckValidation(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, TestCaseInputModel testCaseInputModel)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Multiple Test Cases validating LoggedInUser", "Test suite Service"));

            UpsertTestCaseCheckValidation(loggedInContext, validationMessages, testCaseInputModel);

            foreach (var testCaseId in testCaseInputModel.TestCaseIds)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Update multiple Test Case validating TestCaseId", "TestCaseId", testCaseId, "Test Suite Service"));

                if (testCaseId == null || testCaseId == Guid.Empty)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.NotEmptyTestCaseId
                    });
                }
            }
        }

        public void GetSectionsAndSubSectionsCheckValidation(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, Guid? testSuiteId)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Sections And SubSections CheckValidation validating LoggedInUser", "Test suite Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (testSuiteId == null || testSuiteId == Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Sections And Subsections validating TestSuite Id", "Test suite Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyTestSuiteId
                });
            }
        }

        public void ProjectIdValidation(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, Guid? projectId)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "validating LoggedInUser", "Test suite Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (projectId == null || projectId == Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "validating ProjectId", "projectId", null,  "Test Suite Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyProjectId
                });
            }
        }

        public void UpsertTestCaseStatusMasterValueValidation(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, TestCaseStatusMasterDataInputModel testCaseStatusMasterDataInputModel)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert TestCase Status Master Value validating LoggedInUser", "Test suite Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(testCaseStatusMasterDataInputModel.Status))
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert TestCase Status Master Value validating status", "Status", testCaseStatusMasterDataInputModel.Status, "Test suite Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyTestCaseStatusValue
                });
            }
        }

        public void UpsertTestCaseTypeMasterValueValidation(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, TestRailMasterDataModel testRailMasterDataInputModel)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Test Case Type Master Value validating LoggedInUser", "Test suite Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(testRailMasterDataInputModel.Value))
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert TestCase Type Master Value validating value", "Master Value", testRailMasterDataInputModel.Value, "Test suite Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyTestCaseTypeValue
                });
            }
        }

        public void UpsertTestCasePriorityMasterValueValidation(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, TestRailMasterDataModel testRailMasterDataInputModel)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert TestCase Priority Master Value validating LoggedInUser", "Test suite Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(testRailMasterDataInputModel.Value))
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert TestCase Priority Master Value validating value", "Master Value", testRailMasterDataInputModel.Value, "Test suite Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyTestCaseTypeValue
                });
            }
        }

        public void TestCaseStatusIdValidation(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, Guid? statusId)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Test Case Status Master Data By Id validating LoggedInUser", "Test suite Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (statusId == null || statusId == Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Test Case Status Master Data By Id validating StatusId", "StatusId", null, "Test suite Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyTestCaseStatusId
                });
            }
        }

        public void TestCaseTypeIdValidation(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, Guid? typeId)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Test Case Type Master Data By Id validating LoggedInUser", "Test suite Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (typeId == null || typeId == Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Test Case Type Master Data By Id validating TypeId", "TypeId", null, "Test suite Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyTestCaseTypeId
                });
            }
        }

        public void TestCasePriorityIdValidation(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, Guid? priorityId)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Test Case Priority Master Data By Id validating LoggedInUser", "Test suite Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (priorityId == null || priorityId == Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Test Case Priority Master Data By Id validating PriorityId", "priorityId", null, "Test suite Service"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyTestCasePriorityId
                });
            }
        }

        public void TestSuiteIdValidation(Guid? testSuiteId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Test Suite Id validating LoggedInUser", "Test suite Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (testSuiteId == null || testSuiteId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyTestSuiteId
                });
            }
        }

        public void TestSuiteSectionIdValidation(Guid? sectionId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Test Suite section Id validating LoggedInUser", "Test suite Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (sectionId == null || sectionId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyTestSuiteSectionId
                });
            }
        }

        public void TestCaseIdValidation(Guid? testCaseId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Test Case Id validating LoggedInUser", "Test suite Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (testCaseId == null || testCaseId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyTestCaseId
                });
            }
        }

        public void UploadTestCasesCsvValidation(UploadTestCasesFromExcelModel uploadTestCasesFromExcelMode, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Test Case Id validating LoggedInUser", "Test suite Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (uploadTestCasesFromExcelMode.ID != "ID" && uploadTestCasesFromExcelMode.Title != "Title" && uploadTestCasesFromExcelMode.UpdatedOn != "UpdatedOn")
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.HeaderColumnsNotMatched
                });
            }
        }

        public static bool UpsertTestCaseAutomationTypeValidation(TestCaseAutomationTypeInputModel testCaseAutomationTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertTestCaseAutomationTypeValidation", "testCaseAutomationTypeInputModel", testCaseAutomationTypeInputModel, "Master Data Management Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(testCaseAutomationTypeInputModel.AutomationTypeName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyAutomationTypeName
                });
            }

            if (testCaseAutomationTypeInputModel.AutomationTypeName?.Length > AppConstants.InputWithMaxSize50)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForAutomationTypeName
                });
            }

            return validationMessages.Count <= 0;
        }


        public void MilestoneIdValidation(Guid? milestoneId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "MilestoneId validating LoggedInUser", "Test suite Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (milestoneId  == null || milestoneId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyMilestoneId
                });
            }
        }
    }
}
