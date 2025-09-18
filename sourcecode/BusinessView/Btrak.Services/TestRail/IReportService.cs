using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Btrak.Models;
using Btrak.Models.TestRail;
using BTrak.Common;

namespace Btrak.Services.TestRail
{
    public interface IReportService
    {
        Guid? UpsertTestRailReport(ReportInputModel reportInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<ReportsApiReturnModel> GetTestRailReports(ReportSearchCriteriaInputModel reportSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        ReportsApiReturnModel GetTestRailReportById(ReportSearchCriteriaInputModel reportSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        Task<bool?> SendReportAsPdf(ReportsEmailInputModel reportsEmailInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
