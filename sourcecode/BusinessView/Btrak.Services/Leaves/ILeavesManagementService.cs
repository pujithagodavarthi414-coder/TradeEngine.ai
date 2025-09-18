using System;
using System.Collections.Generic;
using Btrak.Models;
using BTrak.Common;
using Btrak.Models.LeaveManagement;
using System.Threading.Tasks;

namespace Btrak.Services.Leaves
{
    public interface ILeavesManagementService
    {
       Guid? UpsertLeaves(LeaveManagementInputModel leaveManagementInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<LeaveManagementOutputModel> SearchLeaves(LeavesSearchCriteriaInputModel leavesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        LeaveManagementOutputModel GetLeaveDetailById(Guid? leaveApplicationId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertEmployeeAbsence(LeaveManagementInputModel leaveManagementInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? DeleteLeavePermission(DeleteLeavePermissionModel deleteLeavePermissionModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? DeleteLeave(DeleteLeaveModel deleteLeaveModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertLeaveApplicability(LeaveApplicabilityUpsertInputModel leaveApplicabilityUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertTotalOffLeave(TotalOffLeaveUpsertInputModel totalOffLeaveUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? ApproveOrRejectLeave(ApproveOrRejectLeaveInputModel approveOrRejectLeaveInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<LeaveApplicabilitySearchOutputModel> GetLeaveApplicability(Guid? leaveTypeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        MontlyLeaveOutputModel GetMonthlyLeavesReport(LeavesSearchCriteriaInputModel leavesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<LeaveOverViewReportGetOutputModel> GetLeaveOverViewRepport(LeaveOverViewReportGetInputModel leaveOverViewReportGetInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        CompanyOverViewLeaveReportOutputModel GetCompanyOverViewLeaveReport(CompanyOverViewLeaveReportInputModel companyOverViewLeaveReportInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<MontlyLeaveOutputModel> DownloadMonthlyLeavesReport(LeavesSearchCriteriaInputModel leavesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<LeaveOverViewReportGetOutputModel> DownloadLeaveOverViewRepport(LeaveOverViewReportGetInputModel leaveOverViewReportGetInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<CompanyOverViewLeaveReportOutputModel> DownloadCompanyOverViewLeaveReport(CompanyOverViewLeaveReportInputModel companyOverViewLeaveReportInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<LeaveStatusSetHistorySearchReturnModel> GetLeaveStatusSetHistory(LeavesSearchCriteriaInputModel leavesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<LeaveDetails> GetLeaveDetails(LeavesSearchCriteriaInputModel leavesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}