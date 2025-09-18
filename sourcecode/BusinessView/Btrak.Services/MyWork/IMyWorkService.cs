using Btrak.Models;
using Btrak.Models.GenericForm;
using Btrak.Models.MyWork;
using Btrak.Models.TestRail;
using BTrak.Common;

using System.Collections.Generic;

namespace Btrak.Services.MyWork
{
    public interface IMyWorkService
    {
        List<GetMyProjectWorkOutputModel> GetMyProjectsWork(MyProjectWorkModel myProjectWorkModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        PdfGenerationOutputModel GetWorkReportDetailsUploadTemplate(UserHistoricalWorkReportSearchInputModel getTimeSheetDetails, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        PdfGenerationOutputModel GetCompletedWorkReportDetailsUploadTemplate(UserHistoricalWorkReportSearchInputModel getTimeSheetDetails, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        MyWorkOverViewOutputModel GetMyWorkOverViewDetails(MyWorkOverViewInputModel myWorkOverViewInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<UserHistoricalWorkReportSearchSpOutputModel> GetUserHistoricalWorkReport(UserHistoricalWorkReportSearchInputModel userHistoricalSearchInputModel, LoggedInContext loggedInContext,List<ValidationMessage> validationMessages);
        List<UserHistoricalWorkReportSearchSpOutputModel> GetUserHistoricalCompletedWorkReport(UserHistoricalWorkReportSearchInputModel userHistoricalSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EmployeeWorkLogReportOutputmodel> GetEmployeeWorkLogReports(EmployeeWorkLogReportInputModel employeeWorkLogReportInputModel, LoggedInContext loggedInContext,List<ValidationMessage> validationMessages);
        List<EmployeeYearlyProductivityReportOutputModel> GetEmployeeYearlyProductivityReport(GetEmployeeYearlyProductivityReportInputModel getEmployeeYearlyProductivityReportInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        GeneralOutput GetGoalBurnDownChart(GetGoalBurnDownChartInputModel getGoalBurnDownChartInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GetMyWorkOutputModel> GetMyWork(MyWorkInputModel myWorkInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        IEnumerable<dynamic> GetEmployeeLogTimeDetailsReport(EmployeeLogTimeDetailSearchInputModel employeeLogTimeDetailSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        IEnumerable<dynamic> GetUsersSpentTimeDetailsReport(EmployeeLogTimeDetailSearchInputModel employeeLogTimeDetailSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<WorkItemsDetailsSearchOutPutModel> GetWorkItemsDetailsReport(UserHistoricalWorkReportSearchInputModel userHistoricalSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
