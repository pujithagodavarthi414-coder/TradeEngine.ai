using System;
using System.Collections.Generic;
using Btrak.Dapper.Dal.Partial;
using Btrak.Models;
using Btrak.Models.TestRail;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using BTrak.Common;
using Newtonsoft.Json;

namespace Btrak.Services.TestRail
{
    public class OverviewService : IOverviewService
    {
        private readonly TestRailPartialRepository _testRailPartialRepository;
        private readonly IAuditService _auditService;

        public OverviewService(IAuditService auditService, TestRailPartialRepository testRailPartialRepository)
        {
            _auditService = auditService;
            _testRailPartialRepository = testRailPartialRepository;
        }

        public ReportModel GetProjectOverviewReport(Guid projectId, int timeFrame, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Project Overview Report", "ProjectId and timeFrame", projectId + "and" + timeFrame, "Overview Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetProjectOverviewReportCommandId, projectId, loggedInContext);

            var projectReport = _testRailPartialRepository.GetProjectOverviewReport(projectId, timeFrame, loggedInContext, validationMessages);

            return validationMessages.Count > 0 ? null : projectReport;

        }

        public void SaveTestRailAudit(TestRailAuditJsonModel testRailAuditJsonModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Save TestRail Audit", "testRailAuditJsonModel", testRailAuditJsonModel, "Overview Service"));

            testRailAuditJsonModel.OperationPerformedDateTime = DateTime.Now;
            testRailAuditJsonModel.OperationsPerformedBy = loggedInContext.LoggedInUserId;

            var auditJson = JsonConvert.SerializeObject(testRailAuditJsonModel);

            TestRailAuditModel testRailAuditModel = new TestRailAuditModel
            {
                AuditJson = auditJson,
                CompanyId = loggedInContext.CompanyGuid,
                CreatedByUserId = loggedInContext.LoggedInUserId
            };

            _testRailPartialRepository.UpsertTestRailAudit(testRailAuditModel, validationMessages);
        }

        public List<TestRailAuditJsonModel> GetTestRailActivity(TestRailAuditSearchModel testRailAuditSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get TestRail Activity", "Overview Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            var audits = _testRailPartialRepository.GetTestRailAudits(testRailAuditSearchModel, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            return audits;
        }
    }
}
