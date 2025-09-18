using Btrak.Models;
using Btrak.Models.HrDashboard;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.HrDashboard
{
    public interface IHrDashboardService
    {
        EmployeeAttendanceOutputModel GetEmployeeAttendanceByDay(EmployeeAttendanceSearchInputModel employeeAttendanceSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EmployeeWorkingDaysOutputModel> GetEmployeeWorkingDays(EmployeeWorkingDaysSearchCriteriaInputModel employeeWorkingDaysSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EmployeeSpentTimeOutputModel> GetEmployeeSpentTime(Guid? userId, string fromDate, string toDate, Guid? entityId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<LateEmployeeOutputModel> GetLateEmployee(HrDashboardSearchCriteriaInputModel hrDashboardSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EmployeePresenceApiOutputModel> GetEmployeePresence(HrDashboardSearchCriteriaInputModel hrDashboardSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<LeavesReportOutputModel> GetLeavesReport(LeavesReportSearchCriteriaInputModel leavesReportSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<LateEmployeeCountSpOutputModel> GetLateEmployeeCount(LateEmployeeCountSearchInputModel lateEmployeeCountSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<LineManagersOutputModel> GetLineManagers(string searchText, bool? isReportToOnly, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<DailyLogTimeReportOutputModel> GetDailyLogTimeReport(LogTimeReportSearchInputModel logTimeReportSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        MonthlyLogTimeReportModel GetMonthlyLogTimeReport(LogTimeReportSearchInputModel logTimeReportSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<OrganizationchartOutputModel> GetOrganizationChartDetails(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertSignature(SignatureModel signature, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<SignatureModel> GetSignature(SignatureModel signature, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
