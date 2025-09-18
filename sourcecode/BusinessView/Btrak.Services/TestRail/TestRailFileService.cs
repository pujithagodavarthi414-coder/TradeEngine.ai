using System;
using System.Collections.Generic;
using System.Linq;
using Btrak.Dapper.Dal.Partial;
using Btrak.Models;
using Btrak.Models.TestRail;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.TestRailValidationHelpers;
using BTrak.Common;

namespace Btrak.Services.TestRail
{
    public class TestRailFileService : ITestRailFileService
    {
        private readonly IAuditService _auditService;
        private readonly TestRailFileRepository _testRailFileRepository;
        private readonly TestRailValidationHelper _testRailValidationHelper;

        public TestRailFileService(IAuditService auditService, TestRailFileRepository testRailFileRepository, TestRailValidationHelper testRailValidationHelper)
        {
            _auditService = auditService;
            _testRailFileRepository = testRailFileRepository;
            _testRailValidationHelper = testRailValidationHelper;
        }

        public List<Guid?> UpsertFile(TestRailFileModel testRailFileModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert File", "Test Rail File Service"));

            _testRailValidationHelper.UpsertFileValidation(testRailFileModel, loggedInContext, validationMessages);

            if (validationMessages.Any())
            {
                return null;
            }

            if (testRailFileModel.FilePathList.Count > 0)
            {
                testRailFileModel.FilePathXml = Utilities.GetXmlFromObject(testRailFileModel.FilePathList);
            }

            List<Guid?> fileIds = _testRailFileRepository.UpsertFile(testRailFileModel, loggedInContext);

            if (fileIds != null && fileIds.Count > 0)
            {
                LoggingManager.Debug("File with the id " + fileIds + " has been created / updated.");

                return fileIds;
            }

            _auditService.SaveAudit(AppCommandConstants.UpsertFileCommandId, testRailFileModel, loggedInContext);

            return null;
        }

        public TestRailFileModel GetTestRailFileById(Guid? testRailFileId, LoggedInContext loggedInContext,List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get TestRail File By Id", "Test Rail File Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            TestRailFileModel testRailFileModel = new TestRailFileModel
            {
                FileId = testRailFileId,
            };

            var files = _testRailFileRepository.SearchTestRailFiles(testRailFileModel, loggedInContext);

            if (files.Count > 0)
            {
                return files[0];
            }

            validationMessages.Add(new ValidationMessage
            {
                ValidationMessageType = MessageTypeEnum.Error,
                ValidationMessaage = string.Format(ValidationMessages.NotFoundFileWithTheId, testRailFileId)
            });

            return null;
        }

        public List<TestRailFileModel> SearchTestRailFiles(TestRailFileModel testRailFileModel,LoggedInContext loggedInContext)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Search TestRail Files", "TestRail File Service"));

            var files = _testRailFileRepository.SearchTestRailFiles(testRailFileModel, loggedInContext);

            return files;
        }
    }
}
