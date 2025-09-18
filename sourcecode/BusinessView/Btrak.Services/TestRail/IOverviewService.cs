using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.TestRail;
using BTrak.Common;

namespace Btrak.Services.TestRail
{
    public interface IOverviewService
    {
        ReportModel GetProjectOverviewReport(Guid projectId,int timeFrame, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        void SaveTestRailAudit(TestRailAuditJsonModel testRailAuditJsonModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<TestRailAuditJsonModel> GetTestRailActivity(TestRailAuditSearchModel testRailAuditSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
