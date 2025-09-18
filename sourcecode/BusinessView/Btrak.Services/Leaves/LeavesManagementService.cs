using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.Branch;
using Btrak.Models.CompanyStructure;
using Btrak.Models.LeaveManagement;
using Btrak.Models.MasterData;
using Btrak.Models.Notification;
using Btrak.Models.Role;
using Btrak.Models.SystemManagement;
using Btrak.Services.Audit;
using Btrak.Services.Chromium;
using Btrak.Services.CompanyStructure;
using Btrak.Services.Email;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.EmployeeAbsenceValidations;
using Btrak.Services.Helpers.LeaveManagementValidationHelpers;
using Btrak.Services.Notification;
using BTrak.Common;
using BTrak.Common.Constants;
using BTrak.Common.Texts;
using Hangfire;
using Postal;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.Hosting;
using System.Web.Mvc;

namespace Btrak.Services.Leaves
{
    public class LeavesManagementService : ILeavesManagementService
    {
        private readonly LeaveApplicationRepository _leaveApplicationRepository;
        private readonly GoalRepository _goalRepository = new GoalRepository();
        private readonly UserRepository _userRepository = new UserRepository();
        private readonly IAuditService _auditService;
        private readonly IChromiumService _chromiumService;
        private readonly ICompanyStructureService _companyStructureService;
        private readonly Email.IEmailService _emailService;
        private readonly INotificationService _notificationService;
        public LeavesManagementService(LeaveApplicationRepository leaveApplicationRepository
            , IAuditService auditService
            , IChromiumService chromiumService
            , ICompanyStructureService companyStructureService
            , Email.IEmailService emailService
            , INotificationService notificationService)
        {
            _leaveApplicationRepository = leaveApplicationRepository;
            _auditService = auditService;
            _chromiumService = chromiumService;
            _companyStructureService = companyStructureService;
            _emailService = emailService;
            _notificationService = notificationService;
        }

        public Guid? UpsertLeaves(LeaveManagementInputModel leaveManagementInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertLeaves", "leaveManagementInputModel", leaveManagementInputModel, "LeavesManagementService"));
            LoggingManager.Debug(leaveManagementInputModel.ToString());
            LeaveManagementValidationHelper.CheckValidationForUpsertLeaves(leaveManagementInputModel, loggedInContext, validationMessages);
            if (validationMessages.Count > 0)
            {
                return null;
            }

            List<LeaveApplicationOutputModel> leaveApplicationOutputModels = _leaveApplicationRepository.UpsertLeave(leaveManagementInputModel, loggedInContext, validationMessages);
            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (leaveApplicationOutputModels != null && leaveApplicationOutputModels.Count > 0)
            {
                foreach (var leaveApplication in leaveApplicationOutputModels)
                {
                    if(leaveApplication.ReportToUserId != loggedInContext.LoggedInUserId && leaveApplication.ReportToUserId != null)
                    {
                        _notificationService.SendNotification((new NotificationModelForLeaveApplication(
                                                             string.Format(NotificationSummaryConstants.LeaveApplicationNotification,
                                                                 leaveApplication.AppliedUsername))), loggedInContext, leaveApplication.ReportToUserId);
                    }
                }
                BackgroundJob.Enqueue(() => SendLeaveRequestMail(leaveApplicationOutputModels, validationMessages, loggedInContext));
            }

            if (leaveApplicationOutputModels == null || leaveApplicationOutputModels.Count() == 0)
            {
                return null;
            }

            return leaveApplicationOutputModels[0].LeaveApplicationId;
        }

        public List<LeaveManagementOutputModel> SearchLeaves(LeavesSearchCriteriaInputModel leavesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchLeaves", "leavesSearchCriteriaInputModel", leavesSearchCriteriaInputModel, "LeavesManagementService"));
            LoggingManager.Debug(leavesSearchCriteriaInputModel?.ToString());
            _auditService.SaveAudit(AppCommandConstants.SearchLeavesCommandId, "SearchLeaves", loggedInContext);
            CommonValidationHelper.CheckValidationForSearchCriteria(loggedInContext, leavesSearchCriteriaInputModel, validationMessages);
            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (!string.IsNullOrEmpty(leavesSearchCriteriaInputModel.LeaveApplicationIds))
            {
                string[] userStoryIds = leavesSearchCriteriaInputModel.LeaveApplicationIds.Split(new[] { ',' });

                List<Guid> alluserStoryIds = userStoryIds.Select(Guid.Parse).ToList();

                leavesSearchCriteriaInputModel.LeaveApplicationIdsXml = Utilities.ConvertIntoListXml(alluserStoryIds.ToList());
            }

            List<LeaveManagementOutputModel> leavesList = _leaveApplicationRepository.SearchLeaves(leavesSearchCriteriaInputModel, loggedInContext, validationMessages);

            if (leavesList != null && leavesList.Count() > 0)
            {
                if (leavesSearchCriteriaInputModel.IsCalendarView == true)
                {
                    foreach (var leave in leavesList)
                    {
                        leave.Start = leave.Start == null ? leave.StartFrom : leave.Start?.ToLocalTime();
                        leave.End = leave.End == null ? leave.EndTo : leave.End?.ToLocalTime();
                        leave.Title = string.Format(LangText.LeaveFromForScheduler, '[' + leave.Start?.ToString("dd-MM-yyyy HH:mm:ss"), leave.End?.ToString("dd-MM-yyyy HH:mm:ss") + ']', leave.LeaveStatusName);
                        var subModel = new LeaveManagementOutputModel.LeaveManagementDataItem();
                        subModel.LeaveStatusColour = leave.LeaveStatusColour;
                        subModel.Description = leave.Title;
                        subModel.ProfileImage = leave.ProfileImage;
                        subModel.EmployeeName = leave.EmployeeName;
                        leave.DataItem = subModel;
                    }
                }
            }
            return leavesList;
        }

        public List<LeaveStatusSetHistorySearchReturnModel> GetLeaveStatusSetHistory(LeavesSearchCriteriaInputModel leavesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchLeaves", "leavesSearchCriteriaInputModel", leavesSearchCriteriaInputModel, "LeavesManagementService"));
            LoggingManager.Debug(leavesSearchCriteriaInputModel?.ToString());
            _auditService.SaveAudit(AppCommandConstants.SearchLeavesCommandId, "SearchLeaves", loggedInContext);

            List<LeaveStatusSetHistorySearchReturnModel> leavesList = _leaveApplicationRepository.GetLeaveStatusSetHistory(leavesSearchCriteriaInputModel, loggedInContext, validationMessages);

            foreach (var leavehistory in leavesList)
            {
                if (leavehistory.Description == "Applied" && !(bool)leavehistory.OnBehalf)
                {
                    leavehistory.Description = string.Format(LangText.LeaveAppliedhistory, leavehistory.StatusSetUser, leavehistory.CreatedDate, leavehistory.Reason, leavehistory.ApproveList, leavehistory.LeaveDateFromFormat, leavehistory.LeaveDateToFormat);
                }
                else if (leavehistory.Description == "Applied" && (bool)leavehistory.OnBehalf)
                {
                    leavehistory.Description = string.Format(LangText.LeaveAppliedBehalfHistory, leavehistory.StatusSetUser, leavehistory.CreatedDate, leavehistory.Reason, leavehistory.ApproveList, leavehistory.LeaveAppliedUser, leavehistory.LeaveDateFromFormat, leavehistory.LeaveDateToFormat);
                }
                else if (leavehistory.Description == "Approved")
                {
                    leavehistory.Description = string.Format(LangText.LeaveApprovedHistory, leavehistory.StatusSetUser, leavehistory.CreatedDate, leavehistory.LeaveDateFromFormat, leavehistory.LeaveDateToFormat);
                }
                else if (leavehistory.Description == "Rejected")
                {
                    leavehistory.Description = string.Format(LangText.LeaveRejectedHistory, leavehistory.StatusSetUser, leavehistory.CreatedDate, leavehistory.Reason, leavehistory.LeaveDateFromFormat, leavehistory.LeaveDateToFormat);
                }
                else if (leavehistory.Description == "Reapplied")
                {
                    leavehistory.Description = string.Format(LangText.LeaveReAppledHistory, leavehistory.StatusSetUser, leavehistory.CreatedDate, leavehistory.Reason, leavehistory.ApproveList, leavehistory.LeaveDateFromFormat, leavehistory.LeaveDateToFormat);
                }
                else if (leavehistory.Description == "LeaveFrom")
                {
                    leavehistory.Description = string.Format(LangText.LeaveFromForScheduler, leavehistory.LeaveDateFromFormat, leavehistory.LeaveDateToFormat, leavehistory.LeaveStatusName);
                }
                else if (leavehistory.Description == "WeekOff")
                {
                    leavehistory.Description = string.Format(LangText.WeekOffForScheduler, leavehistory.LeaveDateFromFormat);
                }
                else if (leavehistory.Description == "Holiday")
                {
                    leavehistory.Description = string.Format(LangText.HolidayForScheduler, leavehistory.LeaveDateFromFormat, leavehistory.Reason);
                }
                else
                {
                    leavehistory.Description = string.Format(LangText.EditedLeave, leavehistory.StatusSetUser, leavehistory.Description, leavehistory.OldValue, leavehistory.NewValue, leavehistory.CreatedDate, leavehistory.LeaveDateFrom, leavehistory.LeaveDateTo);
                }

            }

            return leavesList;
        }

        public LeaveManagementOutputModel GetLeaveDetailById(Guid? leaveApplicationId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetLeavesById", "Leave Service"));
            LoggingManager.Debug(leaveApplicationId?.ToString());
            LeaveManagementValidationHelper.CheckGetLeaveDetailByIdValidationMessages(leaveApplicationId, loggedInContext, validationMessages);
            if (validationMessages.Count > 0)
            {
                return null;
            }

            LeavesSearchCriteriaInputModel leavesSearchCriteriaInputModel = new LeavesSearchCriteriaInputModel
            {
                LeaveApplicationId = leaveApplicationId
            };
            LeaveManagementOutputModel leavesDetails = _leaveApplicationRepository.SearchLeaves(leavesSearchCriteriaInputModel, loggedInContext, validationMessages).FirstOrDefault();
            if (leavesDetails != null)
            {
                _auditService.SaveAudit(AppCommandConstants.GetLeavesByIdCommandId, "GetLeaveDetailById", loggedInContext);
                return leavesDetails;
            }
            validationMessages.Add(new ValidationMessage
            {
                ValidationMessageType = MessageTypeEnum.Error,
                ValidationMessaage = string.Format(ValidationMessages.NotFoundLeaveApplicationWithTheId, leaveApplicationId)
            });
            return null;
        }

        public Guid? UpsertEmployeeAbsence(LeaveManagementInputModel leaveManagementInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertEmployeeAbsence", "leaveManagementInputModel", leaveManagementInputModel, "LeavesManagementService"));

            LoggingManager.Debug(leaveManagementInputModel.ToString());

            EmployeeAbsenceValidationHelper.CheckValidationForEmployeeAbsence(leaveManagementInputModel, loggedInContext,
                validationMessages);
            if (validationMessages.Count > 0)
            {
                return null;
            }

            leaveManagementInputModel.LeaveApplicationId = _leaveApplicationRepository.UpsertEmployeeAbsence(leaveManagementInputModel, loggedInContext, validationMessages);
            if (leaveManagementInputModel.LeaveApplicationId != Guid.Empty)
            {
                LoggingManager.Debug("New Employee Absence with the id " + leaveManagementInputModel.LeaveApplicationId + " has been created.");
                _auditService.SaveAudit(AppCommandConstants.UpsertEmployeeAbsenceCommandId, leaveManagementInputModel, loggedInContext);
            }
            return leaveManagementInputModel.LeaveApplicationId;
        }

        public Guid? DeleteLeave(DeleteLeaveModel deleteLeaveModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "DeleteLeave", "deleteLeaveModel", deleteLeaveModel, "Leaves Management Service"));
            if (!LeaveManagementValidationHelper.DeleteLeave(deleteLeaveModel, loggedInContext,
                validationMessages))
            {
                return null;
            }

            deleteLeaveModel.LeaveId = _leaveApplicationRepository.DeleteLeave(deleteLeaveModel, loggedInContext, validationMessages);
            LoggingManager.Debug("Delete Leave with the id " + deleteLeaveModel.LeaveId);
            _auditService.SaveAudit(AppCommandConstants.DeleteLeaveCommandId, deleteLeaveModel, loggedInContext);
            return deleteLeaveModel.LeaveId;
        }

        public Guid? ApproveOrRejectLeave(ApproveOrRejectLeaveInputModel approveOrRejectLeaveInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Approve or Reject Leave", "Approve or Reject Leave Model", approveOrRejectLeaveInputModel, "Leaves Management Service"));

            if (approveOrRejectLeaveInputModel.IsAdminApprove == true)
            {
                ApproveOrRejectLeaveDetails LeaveDetails = _leaveApplicationRepository.ApproveLeaveByAdmin(approveOrRejectLeaveInputModel, loggedInContext, validationMessages);
                
                _auditService.SaveAudit(AppCommandConstants.ApproveOrRejectLeaveCommandId, approveOrRejectLeaveInputModel, loggedInContext);
                if(approveOrRejectLeaveInputModel.IsApproved == true)
                {
                    _notificationService.SendNotification((new ApproveLeaveNotification(
                                         string.Format(NotificationSummaryConstants.LeaveApproveNotification, Convert.ToDateTime(LeaveDetails.DateFrom.ToString()).ToString("dd-MMM-yyyy").ToString(), 
                                         Convert.ToDateTime(LeaveDetails.DateTo.ToString()).ToString("dd-MMM-yyyy").ToString(),
                                             LeaveDetails.ApproveOrRejectedBy))), loggedInContext, LeaveDetails.AppliedUserId);
                }
                else if (approveOrRejectLeaveInputModel.IsApproved == false)
                {
                    _notificationService.SendNotification((new RejectLeaveNotification(
                                         string.Format(NotificationSummaryConstants.LeaveRejectNotification, Convert.ToDateTime(LeaveDetails.DateFrom.ToString()).ToString("dd-MMM-yyyy").ToString()
                                         , Convert.ToDateTime(LeaveDetails.DateTo.ToString()).ToString("dd-MMM-yyyy").ToString(),
                                             LeaveDetails.ApproveOrRejectedBy, LeaveDetails.Reason))), loggedInContext, LeaveDetails.AppliedUserId);
                }
                return LeaveDetails.LeaveStatusId;
            }
            else
            {
                ApproveOrRejectLeaveDetails LeaveDetails = _leaveApplicationRepository.ApproveOrRejectLeave(approveOrRejectLeaveInputModel, loggedInContext, validationMessages);
                _auditService.SaveAudit(AppCommandConstants.ApproveOrRejectLeaveCommandId, approveOrRejectLeaveInputModel, loggedInContext);
                if (approveOrRejectLeaveInputModel.IsApproved == true)
                {
                    _notificationService.SendNotification((new ApproveLeaveNotification(
                                         string.Format(NotificationSummaryConstants.LeaveApproveNotification, LeaveDetails.DateFrom, LeaveDetails.DateTo,
                                             LeaveDetails.ApproveOrRejectedBy))), loggedInContext, LeaveDetails.AppliedUserId);
                }
                else if (approveOrRejectLeaveInputModel.IsApproved == false)
                {
                    _notificationService.SendNotification((new RejectLeaveNotification(
                                         string.Format(NotificationSummaryConstants.LeaveRejectNotification, LeaveDetails.DateFrom, LeaveDetails.DateTo,
                                             LeaveDetails.ApproveOrRejectedBy, LeaveDetails.Reason))), loggedInContext, LeaveDetails.AppliedUserId);
                }
                return LeaveDetails.LeaveStatusId;
            }

        }

        public MontlyLeaveOutputModel GetMonthlyLeavesReport(LeavesSearchCriteriaInputModel leavesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Monthly Leaves Report", "Get Monthly Leaves Report", leavesSearchCriteriaInputModel, "Leaves Management Service"));

            MontlyLeaveOutputModel montlyLeaveOutputModel = new MontlyLeaveOutputModel();

            montlyLeaveOutputModel.MonthlyReports = _leaveApplicationRepository.GetMonthlyLeavesReport(leavesSearchCriteriaInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.GetMonthlyLeavesReport, leavesSearchCriteriaInputModel, loggedInContext);

            return montlyLeaveOutputModel;
        }

        public List<LeaveDetails> GetLeaveDetails(LeavesSearchCriteriaInputModel leavesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Monthly Leaves Report", "Get Monthly Leaves Report", leavesSearchCriteriaInputModel, "Leaves Management Service"));

            List<LeaveDetails> leaveDetails = _leaveApplicationRepository.GetLeaveDetails(leavesSearchCriteriaInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.GetMonthlyLeavesReport, leavesSearchCriteriaInputModel, loggedInContext);

            return leaveDetails;
        }

        public async Task<MontlyLeaveOutputModel> DownloadMonthlyLeavesReport(LeavesSearchCriteriaInputModel leavesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Approve or Reject Leave", "Get monthly leave report input model", leavesSearchCriteriaInputModel, "Leaves Management Service"));

            var montlyLeaveOutput = new MontlyLeaveOutputModel()
            {
                MonthlyReports = _leaveApplicationRepository.GetMonthlyLeavesReport(leavesSearchCriteriaInputModel, loggedInContext, validationMessages)
            };

            if (montlyLeaveOutput.MonthlyReports != null)
            {
                LoggingManager.Info("DownloadMonthlyReport");

                var PdfData = "<html><body>"
                      + "<h2 style=\"margin: 10px;\">" + "Monthly Leave Statistics" + "</h2>";

                foreach (var report in montlyLeaveOutput.MonthlyReports)
                {
                    var htmlBody = "<div style=\"clear: both;\">"
                                  + "<div style=\"float: left;width: 10%;color: white;text-align: center;margin-right: 10px;margin: 8px;padding: 8px 2px !important;border-radius: 4px !important;line-height: 5px !important;max-height: 25px;-webkit-print-color-adjust: exact;vertical-align: middle;</div>"
                                  + "<div style=\"float: left;width: 70%;font-size: 16px;font-weight: bold;margin-top: 4px;\">"
                                  + "<p style=\"margin: 8px;font-size: 10px;font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;\" >" + report.Month + "</p>"
                                  + "</div>"
                                  + "<div style=\"width: 12 %; font - size: 16px; margin - top: 4px; float: right;\">"
                                           + "<p style=\"margin: 8px;font-size: 10px;font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;\" >" + report.NumberOfLeaves + "</p>"
                                  + "</div>"
                                  + "<div style=\"float: right;width: 10%;font-size: 16px;color: #a7a3a3;font-weight: bold;\">"
                                  + "</div>"
                                  + "</div>";
                    PdfData = PdfData + htmlBody;
                }

                PdfData = PdfData + "</body></html>";

                var fileName = "MonthlyLeavesReport" + DateTime.Now.Day + "-" + DateTime.Now.Month + DateTime.Now.Year +
                               "-Reports.pdf";

                var pdfOutput = await _chromiumService.GeneratePdf(PdfData, "MonthlyLeavesReport", null);

                montlyLeaveOutput.DownloadLink = pdfOutput.BlobUrl;
                montlyLeaveOutput.Pdf = pdfOutput.ByteStream;
            }
            _auditService.SaveAudit(AppCommandConstants.GetMonthlyLeavesReport, leavesSearchCriteriaInputModel, loggedInContext);

            return montlyLeaveOutput;
        }

        public Guid? UpsertLeaveApplicability(LeaveApplicabilityUpsertInputModel leaveApplicabilityUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertLeaveApplicability", "UpsertLeaveApplicability", leaveApplicabilityUpsertInputModel, "Leaves Management Service"));

            if (leaveApplicabilityUpsertInputModel.RoleId != null && leaveApplicabilityUpsertInputModel.RoleId.Count > 0)
            {
                leaveApplicabilityUpsertInputModel.RoleIdXml = Utilities.ConvertIntoListXml(leaveApplicabilityUpsertInputModel.RoleId);
            }

            if (leaveApplicabilityUpsertInputModel.BranchId != null && leaveApplicabilityUpsertInputModel.BranchId.Count > 0)
            {
                leaveApplicabilityUpsertInputModel.BranchIdXml = Utilities.ConvertIntoListXml(leaveApplicabilityUpsertInputModel.BranchId);
            }

            if (leaveApplicabilityUpsertInputModel.GenderId != null && leaveApplicabilityUpsertInputModel.GenderId.Count > 0)
            {
                leaveApplicabilityUpsertInputModel.GenderIdXml = Utilities.ConvertIntoListXml(leaveApplicabilityUpsertInputModel.GenderId);
            }

            if (leaveApplicabilityUpsertInputModel.MaritalStatusId != null && leaveApplicabilityUpsertInputModel.MaritalStatusId.Count > 0)
            {
                leaveApplicabilityUpsertInputModel.MaritalStatusIdXml = Utilities.ConvertIntoListXml(leaveApplicabilityUpsertInputModel.MaritalStatusId);
            }

            if (leaveApplicabilityUpsertInputModel.EmployeeId != null && leaveApplicabilityUpsertInputModel.EmployeeId.Count > 0)
            {
                leaveApplicabilityUpsertInputModel.EmployeeIdXml = Utilities.ConvertIntoListXml(leaveApplicabilityUpsertInputModel.EmployeeId);
            }

            leaveApplicabilityUpsertInputModel.LeaveApplicabilityId = _leaveApplicationRepository.UpsertLeaveApplicability(leaveApplicabilityUpsertInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertLeaveApplicabilityCommandId, leaveApplicabilityUpsertInputModel, loggedInContext);
            return leaveApplicabilityUpsertInputModel.LeaveApplicabilityId;
        }

        public Guid? UpsertTotalOffLeave(TotalOffLeaveUpsertInputModel totalOffLeaveUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertTotalOffLeave", "UpsertTotalOffLeave", totalOffLeaveUpsertInputModel, "Leaves Management Service"));

            totalOffLeaveUpsertInputModel.TotalOffLeaveId = _leaveApplicationRepository.UpsertTotalOffLeave(totalOffLeaveUpsertInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertTotalOffLeaveCommandId, totalOffLeaveUpsertInputModel, loggedInContext);
            return totalOffLeaveUpsertInputModel.TotalOffLeaveId;
        }

        public Guid? DeleteLeavePermission(DeleteLeavePermissionModel deleteLeavePermissionModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "DeleteLeavePermission", "deleteLeavePermissionModel", deleteLeavePermissionModel, "Leaves Management Service"));
            if (!LeaveManagementValidationHelper.DeleteLeavePermission(deleteLeavePermissionModel, loggedInContext,
                validationMessages))
            {
                return null;
            }

            deleteLeavePermissionModel.PermissionId = _leaveApplicationRepository.DeleteLeavePermission(deleteLeavePermissionModel, loggedInContext, validationMessages);
            LoggingManager.Debug("Delete Leave Permission with the id " + deleteLeavePermissionModel.PermissionId);
            _auditService.SaveAudit(AppCommandConstants.DeletePermissionCommandId, deleteLeavePermissionModel, loggedInContext);
            return deleteLeavePermissionModel.PermissionId;
        }

        public List<LeaveApplicabilitySearchOutputModel> GetLeaveApplicability(Guid? leaveTypeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetLeaveApplicability", "leaveTypeId", leaveTypeId, "LeavesManagementService"));
            LoggingManager.Debug(leaveTypeId?.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetLeaveApplicability, "GetLeaveApplicability", loggedInContext);

            List<LeaveApplicabilitySearchOutputModel> leaveApplicabilitySearchOutputModels = _leaveApplicationRepository.GetLeaveApplicability(leaveTypeId, loggedInContext, validationMessages);

            if (leaveApplicabilitySearchOutputModels != null)
            {
                leaveApplicabilitySearchOutputModels = leaveApplicabilitySearchOutputModels.Select(ConvertLeaveApplicabilityModel).ToList();
            }
            return leaveApplicabilitySearchOutputModels;
        }

        public List<LeaveOverViewReportGetOutputModel> GetLeaveOverViewRepport(LeaveOverViewReportGetInputModel leaveOverViewReportGetInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetLeaveOverViewRepport", "leaveTypeId", leaveOverViewReportGetInputModel, "LeavesManagementService"));
            LoggingManager.Debug(leaveOverViewReportGetInputModel?.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetLeaveApplicability, "GetLeaveOverViewRepport", loggedInContext);

            List<LeaveOverViewReportGetOutputModel> leaveOverViewReportGetOutputModel = _leaveApplicationRepository.GetLeaveOverViewRepport(leaveOverViewReportGetInputModel, loggedInContext, validationMessages);

            return leaveOverViewReportGetOutputModel;
        }

        public async Task<LeaveOverViewReportGetOutputModel> DownloadLeaveOverViewRepport(LeaveOverViewReportGetInputModel leaveOverViewReportGetInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "DownloadLeaveOverViewRepport", "leaveTypeId", leaveOverViewReportGetInputModel, "LeavesManagementService"));
            LoggingManager.Debug(leaveOverViewReportGetInputModel?.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetLeaveApplicability, "DownloadLeaveOverViewRepport", loggedInContext);
            var pdfList = new LeaveOverViewReportGetOutputModel();

            List<LeaveOverViewReportGetOutputModel> leaveOverViewReportGetOutputModels = _leaveApplicationRepository.GetLeaveOverViewRepport(leaveOverViewReportGetInputModel, loggedInContext, validationMessages);
            var PdfData = "<html><body>"
                         + "<h2 style=\"margin: 10px;\">" + "Leave Over View Report" + "</h2>";

            foreach (LeaveOverViewReportGetOutputModel leaveOverViewReportGetOutputModel in leaveOverViewReportGetOutputModels)
            {


                PdfData = PdfData + "<div style=\"margin: 10px;\"> User Name - <b>" + leaveOverViewReportGetOutputModel.UserName + "</b></div>"
                            + "<div style=\"margin: 10px;\">Period - <b>" + leaveOverViewReportGetInputModel.DateFrom + "</b>" + "TO" + "<b> " + leaveOverViewReportGetInputModel.DateTo + " </b></div>"
                            + "<div style=\"margin: 10px;\">Approved Leaves - <b>" + leaveOverViewReportGetOutputModel.Approved + "</b></div>"
                            + "<div style=\"margin: 10px;\">Waiting For Approval - <b>" + leaveOverViewReportGetOutputModel.WaitingForApproval + "</b></div>"
                            + "<div style=\"margin: 10px;\">Rejected - <b> " + leaveOverViewReportGetOutputModel.Rejected + " </b></div>"
                            + "<div style=\"margin: 10px;\">Balance Leaves - <b> " + leaveOverViewReportGetOutputModel.Balance + " </b></div>";
            }
            PdfData = PdfData + "</body></html>";

            var fileName = "MonthlyLeavesReport" + DateTime.Now.Day + "-" + DateTime.Now.Month + DateTime.Now.Year +
                           "-Reports.pdf";

            var Pdfoutput = await _chromiumService.GeneratePdf(PdfData, "MonthlyLeavesReport", null);

            pdfList.DownloadLink = Pdfoutput.BlobUrl;
            pdfList.Pdf = Pdfoutput.ByteStream;

            return pdfList;
        }

        public CompanyOverViewLeaveReportOutputModel GetCompanyOverViewLeaveReport(CompanyOverViewLeaveReportInputModel companyOverViewLeaveReportInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {


            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetCompanyOverViewLeaveRepport", "leaveTypeId", companyOverViewLeaveReportInputModel, "LeavesManagementService"));
            LoggingManager.Debug(companyOverViewLeaveReportInputModel?.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetLeaveApplicability, "GetCompanyOverViewLeaveRepport", loggedInContext);

            CompanyOverViewLeaveReportOutputModel companyOverViewLeaveReportOutputModels = _leaveApplicationRepository.GetCompanyOverViewLeaveReport(companyOverViewLeaveReportInputModel, loggedInContext, validationMessages);

            return companyOverViewLeaveReportOutputModels;
        }

        public async Task<CompanyOverViewLeaveReportOutputModel> DownloadCompanyOverViewLeaveReport(CompanyOverViewLeaveReportInputModel companyOverViewLeaveReportInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {


            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "DownloadCompanyOverViewLeaveRepport", "leaveTypeId", companyOverViewLeaveReportInputModel, "LeavesManagementService"));
            LoggingManager.Debug(companyOverViewLeaveReportInputModel?.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetLeaveApplicability, "DownloadCompanyOverViewLeaveRepport", loggedInContext);

            CompanyOverViewLeaveReportOutputModel companyOverViewLeaveReportOutputModels = _leaveApplicationRepository.GetCompanyOverViewLeaveReport(companyOverViewLeaveReportInputModel, loggedInContext, validationMessages);

            var PdfData = "<html><body>"
                        + "<h2 style=\"margin: 10px;\">" + "Leaves Overview Report Of" + companyOverViewLeaveReportOutputModels.CompanyName + "</h2>";

            PdfData = PdfData + "<div style=\"margin: 10px;\">No of Employees - <b>" + companyOverViewLeaveReportOutputModels.NumberOfMembers + "</b></div>"
                        + "<div style=\"margin: 10px;\">No of Working Days - <b>" + companyOverViewLeaveReportOutputModels.NumberOfWorkingDays + "</b></div>"
                        + "<div style=\"margin: 10px;\">No of Absents - <b> " + companyOverViewLeaveReportOutputModels.NumberOfAbsenceDays + " </b></div>"
                        + "<div style=\"margin: 10px;\">Absence percentage - <b> " + companyOverViewLeaveReportOutputModels.AbsencePercentage + " </b></div>";

            PdfData = PdfData + "</body></html>";

            var fileName = "MonthlyLeavesReport" + DateTime.Now.Day + "-" + DateTime.Now.Month + DateTime.Now.Year +
                           "-Reports.pdf";

            var Pdfoutput = await _chromiumService.GeneratePdf(PdfData, "MonthlyLeavesReport", null);


            companyOverViewLeaveReportOutputModels.DownloadLink = Pdfoutput.BlobUrl;
            companyOverViewLeaveReportOutputModels.ReportInPdf = Pdfoutput.ByteStream;

            return companyOverViewLeaveReportOutputModels;
        }

        public LeaveApplicabilitySearchOutputModel ConvertLeaveApplicabilityModel(LeaveApplicabilitySearchOutputModel leaveApplicabilitySearchOutputModels)
        {
            if (leaveApplicabilitySearchOutputModels.RoleXml != null)
            {
                leaveApplicabilitySearchOutputModels.RoleIdModels = Utilities.GetObjectFromXml<RolesInputModel>(leaveApplicabilitySearchOutputModels.RoleXml, "LeaveApplicabilityRoleModel").ToList();
            }
            if (leaveApplicabilitySearchOutputModels.BranchXml != null)
            {
                leaveApplicabilitySearchOutputModels.BranchModels = Utilities.GetObjectFromXml<BranchApiReturnModel>(leaveApplicabilitySearchOutputModels.BranchXml, "LeaveApplicabilityBranchModel").ToList();
            }
            if (leaveApplicabilitySearchOutputModels.GenderXml != null)
            {
                leaveApplicabilitySearchOutputModels.GenderModels = Utilities.GetObjectFromXml<GendersOutputModel>(leaveApplicabilitySearchOutputModels.GenderXml, "LeaveApplicabilityGenderModel").ToList();
            }
            if (leaveApplicabilitySearchOutputModels.MariatalStatusXml != null)
            {
                leaveApplicabilitySearchOutputModels.MaritalStatusModels = Utilities.GetObjectFromXml<MaritalStatusesOutputModel>(leaveApplicabilitySearchOutputModels.MariatalStatusXml, "LeaveApplicabilityMariatalStatusModel").ToList();
            }
            if (leaveApplicabilitySearchOutputModels.EmployeeXml != null)
            {
                leaveApplicabilitySearchOutputModels.EmployeesModels = Utilities.GetObjectFromXml<EmployeesOutputModel>(leaveApplicabilitySearchOutputModels.EmployeeXml, "LeaveApplicabilityEmployeeModel").ToList();
            }

            leaveApplicabilitySearchOutputModels.RoleIds = leaveApplicabilitySearchOutputModels.RoleIdModels.Select(x => x.RoleId).ToList();

            leaveApplicabilitySearchOutputModels.BranchIds = leaveApplicabilitySearchOutputModels.BranchModels.Select(x => x.BranchId).ToList();

            leaveApplicabilitySearchOutputModels.GenderIds = leaveApplicabilitySearchOutputModels.GenderModels.Select(x => x.GenderId).ToList();

            leaveApplicabilitySearchOutputModels.MaritalStatusIds = leaveApplicabilitySearchOutputModels.MaritalStatusModels.Select(x => x.MaritalStatusId).ToList();

            leaveApplicabilitySearchOutputModels.EmployeeIds = leaveApplicabilitySearchOutputModels.EmployeesModels.Select(x => x.EmployeeId).ToList();

            return leaveApplicabilitySearchOutputModels;
        }

        public bool SendLeaveRequestMail(List<LeaveApplicationOutputModel> leaveApplicationOutputModels, List<ValidationMessage> validationMessages, LoggedInContext loggedInContext)
        {
            CompanyOutputModel companyDetails = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);
            var siteDomain = ConfigurationManager.AppSettings["SiteUrl"];
            var siteAddress = siteDomain + "/leavemanagement/waitingforapproval";
            SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, companyDetails.SiteAddress);
            var html = _goalRepository.GetHtmlTemplateByName("LeaveApplicationTemplate", loggedInContext.CompanyGuid);
            foreach (var leaveApplicationModel in leaveApplicationOutputModels)
            {
                var formattedHtml = html.Replace("##ToName##", leaveApplicationModel.AppliedUsername).
                    Replace("##leaveFromDate##", leaveApplicationModel.LeaveDateFrom?.ToString("dd-MM-yyyy HH:mm:ss")).
                    Replace("##NoofDays##", leaveApplicationModel.NumberOfDays.ToString()).
                    Replace("##leaveDateTo##", leaveApplicationModel.LeaveDateTo?.ToString("dd-MM-yyyy HH:mm:ss")).
                    Replace("##siteAddress##", siteAddress);
                if (leaveApplicationModel.ReportToUserMail != null)
                {
                    var toMails = leaveApplicationModel.ReportToUserMail.Split('\n');
                    EmailGenericModel emailModel = new EmailGenericModel
                    {
                        SmtpServer = smtpDetails?.SmtpServer,
                        SmtpServerPort = smtpDetails?.SmtpServerPort,
                        SmtpMail = smtpDetails?.SmtpMail,
                        SmtpPassword = smtpDetails?.SmtpPassword,
                        ToAddresses = toMails,
                        HtmlContent = formattedHtml,
                        Subject = "Snovasys Business Suite: Leave Application Request",
                        CCMails = null,
                        BCCMails = null,
                        MailAttachments = null,
                        IsPdf = null
                    };
                    _emailService.SendMail(loggedInContext, emailModel);
                }
            }
            return true;
        }
    }
}
