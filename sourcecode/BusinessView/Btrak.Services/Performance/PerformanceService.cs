using Btrak.Dapper.Dal.Partial;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.Employee;
using Btrak.Models.Notification;
using Btrak.Models.Performance;
using Btrak.Models.Probation;
using Btrak.Models.SystemManagement;
using Btrak.Services.Audit;
using Btrak.Services.Chromium;
using Btrak.Services.Email;
using Btrak.Services.Notification;
using Btrak.Services.User;
using BTrak.Common;
using BTrak.Common.Constants;
using Hangfire;
using Nest;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Threading.Tasks;

namespace Btrak.Services.Performance
{
    public class PerformanceService : IPerformanceService
    {
        private readonly PerformanceRepository _performanceRepository;
        private readonly GoalRepository _goalRepository;
        private readonly UserRepository _userRepository;
        private readonly IAuditService _auditService;
        private readonly INotificationService _notificationService;
        private readonly IUserService _userService;
        private readonly IChromiumService _chromiumService;
        private readonly IEmailService _emailService;
        private readonly EmployeeReportToRepository _employeeReportToRepository;
        public PerformanceService(EmployeeReportToRepository employeeReportToRepository,PerformanceRepository performanceRepository, IChromiumService chromiumService, GoalRepository goalRepository, UserRepository userRepository, IAuditService auditService, INotificationService notificationService, IUserService userService, IEmailService emailService)
        {
            _performanceRepository = performanceRepository;
            _auditService = auditService;
            _notificationService = notificationService;
            _userService = userService;
            _userRepository = userRepository;
            _goalRepository = goalRepository;
            _chromiumService = chromiumService;
            _emailService = emailService;
            _employeeReportToRepository = employeeReportToRepository;
        }

        public Guid? UpsertPerformanceConfiguration(PerformanceConfigurationModel performanceConfiguration, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertPerformanceConfiguration", "performanceConfiguration", performanceConfiguration, "Performance Service"));

            if (performanceConfiguration.SelectedRoleIds.Count > 0)
            {
                performanceConfiguration.SelectedRoles = String.Join(",", performanceConfiguration.SelectedRoleIds);
            }

            Guid? PerformanceId = _performanceRepository.UpsertPerformanceConfiguration(performanceConfiguration, loggedInContext, validationMessages);
            if (validationMessages.Count == 0)
            {
                _auditService.SaveAudit(AppConstants.Performance, performanceConfiguration, loggedInContext);
                return PerformanceId;
            }

            return null;
        }

        public List<PerformanceConfigurationOutputModel> GetPerformanceConfigurations(PerformanceConfigurationModel performanceConfiguration, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetPerformanceConfigurations", "PerformanceConfigurationModel", performanceConfiguration, "Performance Service"));

            List<PerformanceConfigurationOutputModel> PerformanceConfigurations = _performanceRepository.GetPerformanceConfigurations(performanceConfiguration, loggedInContext, validationMessages);

            Parallel.ForEach(PerformanceConfigurations, performance =>
            {
                if (!string.IsNullOrEmpty(performance.SelectedRoles))
                {
                    performance.SelectedRoleIds = performance.SelectedRoles.Split(',').ToList().ConvertAll(Guid.Parse);
                }
            });

            if (validationMessages.Count == 0)
            {
                _auditService.SaveAudit(AppConstants.Performance, performanceConfiguration, loggedInContext);
                return PerformanceConfigurations;
            }

            return null;
        }

        public Guid? UpsertPerformance(PerformanceModel performanceModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertPerformance", "PerformanceModel", performanceModel, "Performance Service"));

            Guid? PerformanceId = _performanceRepository.UpsertPerformance(performanceModel, loggedInContext, validationMessages);
            if (validationMessages.Count == 0)
            {
                _auditService.SaveAudit(AppConstants.Performance, performanceModel, loggedInContext);

                if (performanceModel.IsApproved == true)
                {
                    PerformanceModel inputModel = new PerformanceModel()
                    {
                        PerformanceId = performanceModel.PerformanceId,
                        IncludeApproved = true,
                        WaitingForApproval = true,
                        PageNumber = 1,
                        PageSize = 10
                    };
                    var selectedPerformance = GetPerformances(inputModel, loggedInContext, validationMessages).FirstOrDefault((p) => p.PerformanceId == performanceModel.PerformanceId);
                    TaskWrapper.ExecuteFunctionInNewThread(() =>
                    {
                        _notificationService.SendNotification(new PerformanceNotificationModel(
                                      string.Format(NotificationSummaryConstants.PerformanceApproved, selectedPerformance.ConfigurationName, selectedPerformance.ApprovedByUser),
                                      loggedInContext.LoggedInUserId,
                                      selectedPerformance.SubmittedBy.Value,
                                      performanceModel.PerformanceId,
                                      selectedPerformance.ApprovedByUser,
                                      selectedPerformance.ApprovedBy
                                          ), loggedInContext, selectedPerformance.SubmittedBy);
                    });
                }
                else if (performanceModel.IsSubmitted == true)
                {
                    PerformanceModel inputModel = new PerformanceModel()
                    {
                        PerformanceId = performanceModel.PerformanceId,
                        IncludeApproved = true,
                        WaitingForApproval = true,
                        PageNumber = 1,
                        PageSize = 10
                    };
                    var selectedPerformance = GetPerformances(inputModel, loggedInContext, validationMessages).FirstOrDefault();

                    var usersToBeNotified = _performanceRepository.GetUsersBasedOnFeaturePermissions(AppConstants.CanApprovePerformanceFeatureId, loggedInContext, validationMessages);
                    TaskWrapper.ExecuteFunctionInNewThread(() =>
                    {
                        foreach (var user in usersToBeNotified)
                        {
                            _notificationService.SendNotification(new PerformanceNotificationModel(
                                          string.Format(NotificationSummaryConstants.PerformanceWaitingForApproval, selectedPerformance.ConfigurationName, selectedPerformance.SubmittedByUser),
                                          loggedInContext.LoggedInUserId,
                                          user.UserId,
                                          performanceModel.PerformanceId,
                                          selectedPerformance.ApprovedByUser,
                                          selectedPerformance.ApprovedBy
                                              ), loggedInContext, user.UserId);
                        }
                    });
                }

                return PerformanceId;
            }

            return null;
        }

        public List<PerformanceOutputModel> GetPerformances(PerformanceModel performanceModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetPerformances", "PerformanceModel", performanceModel, "Performance Service"));

            List<PerformanceOutputModel> Performances = _performanceRepository.GetPerformances(performanceModel, loggedInContext, validationMessages);
            if (validationMessages.Count == 0)
            {
                _auditService.SaveAudit(AppConstants.Performance, performanceModel, loggedInContext);
                return Performances;
            }

            return null;
        }

        public List<PerformanceSubmissionOutputModel> GetPerformanceSubmissions(PerformanceSubmissionModel performanceModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetPerformanceSubmissions", "PerformanceSubmissionModel", performanceModel, "Performance Service"));

            List<PerformanceSubmissionOutputModel> Performances = _performanceRepository.GetPerformanceSubmissions(performanceModel, loggedInContext, validationMessages);
            if (validationMessages.Count == 0)
            {
                _auditService.SaveAudit(AppConstants.Performance, performanceModel, loggedInContext);
                return Performances;
            }

            return null;
        }

        public List<PerformanceSubmissionOutputModel> GetPerformanceSubmissionDetails(PerformanceSubmissionModel performanceModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetPerformanceSubmissionDetails", "PerformanceSubmissionModel", performanceModel, "Performance Service"));

            List<PerformanceSubmissionOutputModel> Performances = _performanceRepository.GetPerformanceSubmissionDetails(performanceModel, loggedInContext, validationMessages);
            if (validationMessages.Count == 0)
            {
                _auditService.SaveAudit(AppConstants.Performance, performanceModel, loggedInContext);
                return Performances;
            }

            return null;
        }

        public List<PerformanceReportModel> GetPerformanceReports(PerformanceReportModel performanceModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetPerformanceReports", "PerformanceSubmissionModel", performanceModel, "Performance Service"));

            List<PerformanceReportModel> Performances = _performanceRepository.GetPerformanceReports(performanceModel, loggedInContext, validationMessages);
            if (validationMessages.Count == 0)
            {
                _auditService.SaveAudit(AppConstants.Performance, performanceModel, loggedInContext);
                return Performances;
            }

            return null;
        }

        public Guid? UpsertPerformanceSubmission(PerformanceSubmissionModel performanceModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, bool isFormPdfGeneration)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertPerformanceSubmission", "PerformanceSubmissionModel", performanceModel, "Performance Service"));

            Guid? PerformanceId = _performanceRepository.UpsertPerformanceSubmission(performanceModel, loggedInContext, validationMessages);
            if (validationMessages.Count == 0)
            {
                _auditService.SaveAudit(AppConstants.Performance, performanceModel, loggedInContext);

                if (performanceModel.IsOpen == false && isFormPdfGeneration == false)
                {
                    BackgroundJob.Enqueue(() => GeneratePerformancePdf(performanceModel, loggedInContext));
                }

                if (performanceModel.PerformanceId == null)
                {
                    _notificationService.SendNotification((new PerformanceReviewAssignToEmployeeNotification(
                                                             string.Format(NotificationSummaryConstants.ReviewAssignNotification,
                                                                 "Performance"))), loggedInContext, performanceModel.OfUserId);
                }

                return PerformanceId;
            }

            return null;
        }

        public Guid? UpsertPerformanceSubmissionDetails(PerformanceSubmissionModel performanceModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertPerformanceSubmissionDetails", "PerformanceSubmissionModel", performanceModel, "Performance Service"));

            var isInvited = false;
            if (performanceModel.PerformanceDetailsId == null && performanceModel.SubmissionFrom == 2 && performanceModel.SubmittedBy.ToString().ToLower() != loggedInContext.LoggedInUserId.ToString().ToLower())
            {
                isInvited = true;
            }

            Guid? PerformanceDetailsId = _performanceRepository.UpsertPerformanceSubmissionDetails(performanceModel, loggedInContext, validationMessages);
            if (validationMessages.Count == 0)
            {
                _auditService.SaveAudit(AppConstants.Performance, performanceModel, loggedInContext);
                if (isInvited == true)
                {
                    BackgroundJob.Enqueue(() => sendInviteeMail(performanceModel, loggedInContext, validationMessages));
                }

                if (performanceModel.IsCompleted == true && performanceModel.SubmissionFrom == 0)
                {

                    EmployeeDetailSearchCriteriaInputModel employeeDetailSearchCriteriaInputModel = new EmployeeDetailSearchCriteriaInputModel();
                    employeeDetailSearchCriteriaInputModel.EmployeeId = performanceModel.EmployeeId;
                    employeeDetailSearchCriteriaInputModel.IsArchived = false;
                    employeeDetailSearchCriteriaInputModel.PageNumber = 1;
                    employeeDetailSearchCriteriaInputModel.PageSize = 1000;

                    EmployeeDetailsApiReturnModel employeeDetailsApiReturnModel = new EmployeeDetailsApiReturnModel();
                    employeeDetailsApiReturnModel.employeeReportToDetails = _employeeReportToRepository.GetEmployeeReportToDetails(employeeDetailSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

                    foreach (var ReportMember in employeeDetailsApiReturnModel.employeeReportToDetails)
                    {
                        _notificationService.SendNotification((new PerformanceReviewSubmittedByEmployeeNotification(
                                                             string.Format(NotificationSummaryConstants.ReviewSubmittedByEmployeeNotification,
                                                                 "Performace", ReportMember.UserName), ReportMember.UserId)), loggedInContext, ReportMember.ReportToUserId);
                    }
                }

                if (performanceModel.FormData == null && performanceModel.SubmissionFrom == 2)
                {
                    _notificationService.SendNotification((new PerformanceReviewInvitationNotificationModel(
                                                            string.Format(NotificationSummaryConstants.PerformanceReviewInvitationNotification,
                                                                performanceModel.OfUserName), performanceModel.OfUserId)), loggedInContext, performanceModel.SubmittedBy);
                }

                return PerformanceDetailsId;
            }

            return null;
        }

        public bool sendInviteeMail(PerformanceSubmissionModel performanceModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            var invitedUser = _userService.GetUserById(performanceModel.SubmittedBy, true, loggedInContext, validationMessages);
            var invitedByUser = _userService.GetUserById(loggedInContext.LoggedInUserId, true, loggedInContext, validationMessages);
            var ofUser = _userService.GetUserById(performanceModel.OfUserId, true, loggedInContext, validationMessages);

            SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, null);

            var html = _goalRepository.GetHtmlTemplateByName("UserPerformanceReviewInvitationTemplate", loggedInContext.CompanyGuid);
            html = html.Replace("##InviteeName##", invitedUser.FullName).
                    Replace("##CompanyName##", smtpDetails.CompanyName).
                    Replace("##InvitedByName##", invitedByUser.FullName).
                    Replace("##ofUserName##", ofUser.FullName);

            var toMails = new string[1];
            toMails[0] = invitedUser.Email;
            EmailGenericModel emailModel = new EmailGenericModel
            {
                SmtpServer = smtpDetails?.SmtpServer,
                SmtpServerPort = smtpDetails?.SmtpServerPort,
                SmtpMail = smtpDetails?.SmtpMail,
                SmtpPassword = smtpDetails?.SmtpPassword,
                ToAddresses = toMails,
                HtmlContent = html,
                Subject = "Snovasys Business Suite: Performance review invitation",
                CCMails = null,
                BCCMails = null,
                MailAttachments = null,
                IsPdf = null
            };
            _emailService.SendMail(loggedInContext, emailModel);
            return true;
        }

        public async Task GeneratePerformancePdf(PerformanceSubmissionModel performanceModel, LoggedInContext loggedInContext)
        {
            try
            {

                LoggingManager.Info("Entering into GeneratePerformancePdf Method in Performance service");
                var validationMessages = new List<ValidationMessage>();

                var performanceSearchModel = new PerformanceSubmissionModel()
                {
                    OfUserId = performanceModel.OfUserId,
                    IsOpen = false
                };

                LoggingManager.Info("Getting performanceDetails in GeneratePerformancePdf Method in Performance service");
                var performanceDetails = _performanceRepository.GetPerformanceSubmissions(performanceSearchModel, loggedInContext, validationMessages).FirstOrDefault(p => p.PerformanceId == performanceModel.PerformanceId);
                if (performanceDetails != null)
                {
                    LoggingManager.Info("Getting formheaders in GeneratePerformancePdf Method in Performance service");
                    var formHeaders = JsonConvert.DeserializeObject<JsonFormDetailsModel>(performanceDetails.FormJson);
                    LoggingManager.Info("formheaders generated in GeneratePerformancePdf Method in Performance service");

                    LoggingManager.Info("Getting employeeperformanceDetails in GeneratePerformancePdf Method in Performance service");
                    var employeePerformanceSearchModel = new PerformanceSubmissionModel()
                    {
                        PerformanceId = performanceModel.PerformanceId,
                        SubmissionFrom = 0
                    };
                    PerformanceSubmissionOutputModel employeePerformance = _performanceRepository.GetPerformanceSubmissionDetails(employeePerformanceSearchModel, loggedInContext, validationMessages).FirstOrDefault();

                    LoggingManager.Info("Getting form data of employee in GeneratePerformancePdf Method in Performance service");
                    PerformanceDataValues employeeFormData = new PerformanceDataValues();
                    if (employeePerformance != null && !string.IsNullOrEmpty(employeePerformance.FormData))
                    {
                        employeeFormData = GetValuesFromJson(employeePerformance.FormData);
                    }
                    LoggingManager.Info("Got form data of employee in GeneratePerformancePdf Method in Performance service");

                    LoggingManager.Info("Getting managerperformanceDetails in GeneratePerformancePdf Method in Performance service");
                    var managerPerformanceSearchModel = new PerformanceSubmissionModel()
                    {
                        PerformanceId = performanceModel.PerformanceId,
                        SubmissionFrom = 1
                    };
                    PerformanceSubmissionOutputModel managerPerformance = _performanceRepository.GetPerformanceSubmissionDetails(managerPerformanceSearchModel, loggedInContext, validationMessages).FirstOrDefault();

                    LoggingManager.Info("Getting formData of manager in GeneratePerformancePdf Method in Performance service");
                    PerformanceDataValues managerFormData = new PerformanceDataValues();
                    if (managerPerformance != null && !string.IsNullOrEmpty(managerPerformance.FormData))
                    {
                        managerFormData = GetValuesFromJson(managerPerformance.FormData);
                    }
                    LoggingManager.Info("Got formData of manager in GeneratePerformancePdf Method in Performance service");

                    LoggingManager.Info("Getting inviteesperformanceDetails in GeneratePerformancePdf Method in Performance service");
                    var inviteePerformanceSearchModel = new PerformanceSubmissionModel()
                    {
                        PerformanceId = performanceModel.PerformanceId,
                        SubmissionFrom = 2
                    };
                    List<PerformanceSubmissionOutputModel> inviteePerformances = _performanceRepository.GetPerformanceSubmissionDetails(inviteePerformanceSearchModel, loggedInContext, validationMessages);

                    List<PerformanceDataValues> inviteeFormData = new List<PerformanceDataValues>();

                    LoggingManager.Info("Getting formdatas of invitees in GeneratePerformancePdf Method in Performance service");

                    List<PerformanceSubmissionOutputModel> finalizedInviteePerformances = new List<PerformanceSubmissionOutputModel>();

                    foreach (var inviteePerformance in inviteePerformances)
                    {
                        if (!string.IsNullOrEmpty(inviteePerformance.FormData))
                        {
                            var formResult = GetValuesFromJson(inviteePerformance.FormData);
                            inviteeFormData.Add(formResult);
                            finalizedInviteePerformances.Add(inviteePerformance);
                        }
                    }

                    inviteePerformances = finalizedInviteePerformances;

                    LoggingManager.Info("Got formdata of invitees in GeneratePerformancePdf Method in Performance service");

                    LoggingManager.Info("Getting of user details in GeneratePerformancePdf Method in Performance service");
                    var ofUser = _userService.GetUserById(performanceModel.OfUserId, true, loggedInContext, validationMessages);

                    LoggingManager.Info("Generating pdf headers in GeneratePerformancePdf Method in Performance service");
                    var PdfData = "<html><body>"
                                 + "<h2 style=\"margin: 10px; text-align: center;\"> Performance review report </h2>";
                    PdfData = PdfData + "<div style=\"margin: 10px;\">Review Closed on <b>" + performanceDetails.LatestModificationOn.ToString("dddd, dd MMMM yyyy", new CultureInfo("en-US")) + "</b></div>"
                                 + "<div style=\"margin: 10px;\">Review Closed by <b>" + performanceDetails.ClosedByUserName + "</b></div><hr>"
                                 + "<div style=\"margin: 10px;\">Employee(E) - <b>" + ofUser.FullName + "</b></div>"
                                 + "<div style=\"margin: 10px;\">Manager(M) - <b>" + performanceDetails.ClosedByUserName + "</b></div>";
                    int inviteeNumber = 1;
                    foreach (var invitee in inviteePerformances)
                    {
                        PdfData = PdfData + "<div style=\"margin: 10px;\">Invitee(I" + inviteeNumber + ") - <b>" + invitee.SubmittedByName + "</b></div>";
                        inviteeNumber = inviteeNumber + 1;
                    }

                    PdfData = PdfData + "<hr>";

                    int questionNumber = 1;

                    LoggingManager.Info("Generating Pdf body in GeneratePerformancePdf Method in Performance service");
                    foreach (var header in formHeaders.Components)
                    {
                        if (header.Key != "submit")
                        {
                            var htmlBody = "<div style=\"clear: both;\">"
                                          + "<div style=\"float: left;text-align: center;margin-right: 10px;margin: 8px;padding: 8px 2px !important;line-height: 5px !important;vertical-align: middle;\"><b>Q" + questionNumber + ":</b></div>"
                                          + "<div style=\"float: left;width: 90%;font-size: 16px;font-weight: bold;margin-top: 4px;\">"
                                          + "<p style=\"margin: 8px;font-size: 16px;font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;\" >" + header.Label + "</p>"
                                          + "</div>"
                                          + "</div>";

                            var employeeData = "<div style=\"clear: both;\">"
                                             + "<div style=\"float: left;text-align: center;margin-right: 10px;margin: 8px;padding: 8px 2px !important;line-height: 5px !important;vertical-align: middle;\"><b>E:</b></div>"
                                             + "<div style=\"float: left;width: 90%;font-size: 16px;margin-top: 4px;\">"
                                             + "<p style=\"margin: 8px;font-size: 14px;font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;\" >" + employeeFormData.DataPairs?.FirstOrDefault(p => p.Key == header.Key)?.Value + "</p>"
                                             + "</div>"
                                             + "</div>";

                            var managerData = "<div style=\"clear: both;\">"
                                             + "<div style=\"float: left;text-align: center;margin-right: 10px;margin: 8px;padding: 8px 2px !important;line-height: 5px !important;vertical-align: middle;\"><b>M:</b></div>"
                                             + "<div style=\"float: left;width: 90%;font-size: 16px;margin-top: 4px;\">"
                                             + "<p style=\"margin: 8px;font-size: 14px;font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;\" >" + managerFormData.DataPairs?.FirstOrDefault(p => p.Key == header.Key)?.Value + "</p>"
                                             + "</div>"
                                             + "</div>";

                            inviteeNumber = 1;
                            var inviteeData = "";
                            foreach (var invitee in inviteeFormData)
                            {
                                inviteeData = inviteeData + "<div style=\"clear: both;\">"
                                             + "<div style=\"float: left;text-align: center;margin-right: 10px;margin: 8px;padding: 8px 2px !important;line-height: 5px !important;vertical-align: middle;\"><b>I" + inviteeNumber + ":</b></div>"
                                             + "<div style=\"float: left;width: 95%;font-size: 16px;margin-top: 4px;\">"
                                             + "<p style=\"margin: 8px;font-size: 14px;font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;\" >" + invitee.DataPairs?.FirstOrDefault(p => p.Key == header.Key)?.Value + "</p>"
                                             + "</div>"
                                             + "</div>";
                                inviteeNumber = inviteeNumber + 1;
                            }

                            PdfData = PdfData + htmlBody + employeeData + managerData + inviteeData;
                            PdfData = PdfData + "<br><hr>";
                            questionNumber = questionNumber + 1;
                        }
                    }
                    PdfData = PdfData + "</body>"
                                      + "</html>";
                    LoggingManager.Info("pdf file generated in GeneratePerformancePdf Method in Performance service");

                    LoggingManager.Info("Generated html realted to Pdf File in Reports service");

                    var fileName = ofUser.FullName + "-Performance-Review-" + DateTime.Now.Day + "-" + DateTime.Now.Month + DateTime.Now.Year +
                                   "-Report.pdf";

                    var pdfOutput = await _chromiumService.GeneratePdf(PdfData, fileName, null);

                    LoggingManager.Info("pdf file generated in GeneratePerformancePdf Method in Performance service");

                    performanceModel.PdfUrl = pdfOutput.BlobUrl;

                    UpsertPerformanceSubmission(performanceModel, loggedInContext, validationMessages, true);
                }
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GeneratePerformancePdf", "PerformanceService ", ex.Message), ex);

            }
        }

        public Guid? UpsertProbationConfiguration(ProbationConfigurationModel probationConfiguration, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertProbationConfiguration", "UpsertProbationConfiguration", probationConfiguration, "Performance Service"));

            if (probationConfiguration.SelectedRoleIds.Count > 0)
            {
                probationConfiguration.SelectedRoles = String.Join(",", probationConfiguration.SelectedRoleIds);
            }

            Guid? PerformanceId = _performanceRepository.UpsertProbationConfiguration(probationConfiguration, loggedInContext, validationMessages);
            if (validationMessages.Count == 0)
            {
                _auditService.SaveAudit(AppConstants.Performance, probationConfiguration, loggedInContext);
                return PerformanceId;
            }

            return null;
        }

        public Guid? UpsertProbationSubmissionDetails(ProbationSubmissionModel probationModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertProbationSubmissionDetails", "ProbationSubmissionModel", probationModel, "Performance Service"));

            var isInvited = false;
            if (probationModel.ProbationDetailsId == null && probationModel.SubmissionFrom == 2 && probationModel.SubmittedBy.ToString().ToLower() != loggedInContext.LoggedInUserId.ToString().ToLower())
            {
                isInvited = true;
            }

            Guid? PerformanceDetailsId = _performanceRepository.UpsertProbationSubmissionDetails(probationModel, loggedInContext, validationMessages);
            if (validationMessages.Count == 0)
            {


                if (probationModel.IsCompleted == true && probationModel.SubmissionFrom == 0)
                {

                    EmployeeDetailSearchCriteriaInputModel employeeDetailSearchCriteriaInputModel = new EmployeeDetailSearchCriteriaInputModel();
                    employeeDetailSearchCriteriaInputModel.EmployeeId = probationModel.EmployeeId;
                    employeeDetailSearchCriteriaInputModel.IsArchived = false;
                    employeeDetailSearchCriteriaInputModel.PageNumber = 1;
                    employeeDetailSearchCriteriaInputModel.PageSize = 1000;

                    EmployeeDetailsApiReturnModel employeeDetailsApiReturnModel = new EmployeeDetailsApiReturnModel();
                    employeeDetailsApiReturnModel.employeeReportToDetails = _employeeReportToRepository.GetEmployeeReportToDetails(employeeDetailSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

                    foreach (var ReportMember in employeeDetailsApiReturnModel.employeeReportToDetails)
                    {
                        _notificationService.SendNotification((new ReviewSubmittedByEmployeeNotification(
                                                             string.Format(NotificationSummaryConstants.ReviewSubmittedByEmployeeNotification,
                                                                 "Probation", ReportMember.UserName), ReportMember.UserId)), loggedInContext, ReportMember.ReportToUserId);
                    }
                }

                if (probationModel.FormData == null && probationModel.SubmissionFrom == 2)
                {
                    _notificationService.SendNotification((new ReviewInvitationNotificationModel(
                                                            string.Format(NotificationSummaryConstants.ReviewInvitationNotification,
                                                                probationModel.OfUserName), probationModel.OfUserId)), loggedInContext, probationModel.SubmittedBy);
                }

                return PerformanceDetailsId;
            }

            return null;
        }

        public List<ProbationSubmissionOutputModel> GetProbationSubmissionDetails(ProbationSubmissionModel probationModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetProbationSubmissionDetails", "ProbationSubmissionModel", probationModel, "Performance Service"));

            List<ProbationSubmissionOutputModel> Performances = _performanceRepository.GetProbationSubmissionDetails(probationModel, loggedInContext, validationMessages);
            if (validationMessages.Count == 0)
            {
                _auditService.SaveAudit(AppConstants.Performance, probationModel, loggedInContext);
                return Performances;
            }

            return null;
        }

        public Guid? UpsertProbationSubmission(ProbationSubmissionModel probationModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, bool isFormPdfGeneration)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertPerformanceSubmission", "PerformanceSubmissionModel", probationModel, "Performance Service"));

            Guid? ProbationId = _performanceRepository.UpsertProbationSubmission(probationModel, loggedInContext, validationMessages);
            if (validationMessages.Count == 0)
            {
                _auditService.SaveAudit(AppConstants.Performance, probationModel, loggedInContext);

                //if (probationModel.IsOpen == false && isFormPdfGeneration == false)
                //{
                //    BackgroundJob.Enqueue(() => GeneratePerformancePdf(probationModel, loggedInContext));
                //}

                if(probationModel.ProbationId == null)
                {
                    _notificationService.SendNotification((new ReviewAssignToEmployeeNotification(
                                                             string.Format(NotificationSummaryConstants.ReviewAssignNotification,
                                                                 "Probation"))), loggedInContext, probationModel.OfUserId);
                }

                return ProbationId;
            }

            return null;
        }

        public List<ProbationSubmissionOutputModel> GetProbationSubmissions(ProbationSubmissionModel probationModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetProbationSubmissions", "ProbationSubmissionModel", probationModel, "Performance Service"));

            List<ProbationSubmissionOutputModel> probations = _performanceRepository.GetProbationSubmissions(probationModel, loggedInContext, validationMessages);
            if (validationMessages.Count == 0)
            {
                _auditService.SaveAudit(AppConstants.Performance, probationModel, loggedInContext);
                return probations;
            }

            return null;
        }

        public List<ProbationConfigurationOutputModel> GetProbationConfigurations(ProbationConfigurationModel probationConfiguration, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetPerformanceConfigurations", "PerformanceConfigurationModel", probationConfiguration, "Performance Service"));

            List<ProbationConfigurationOutputModel> ProbationConfigurations = _performanceRepository.GetProbationConfigurations(probationConfiguration, loggedInContext, validationMessages);

            Parallel.ForEach(ProbationConfigurations, performance =>
            {
                if (!string.IsNullOrEmpty(performance.SelectedRoles))
                {
                    performance.SelectedRoleIds = performance.SelectedRoles.Split(',').ToList().ConvertAll(Guid.Parse);
                }
            });

            if (validationMessages.Count == 0)
            {
                _auditService.SaveAudit(AppConstants.Performance, probationConfiguration, loggedInContext);
                return ProbationConfigurations;
            }

            return null;
        }

        public PerformanceDataValues GetValuesFromJson(string formData)
        {
            List<JsonDataPairs> datapairs = new List<JsonDataPairs>();
            var overaallData = formData.Trim();
            var overaallDataLength = overaallData.Length;
            overaallData = overaallData.Substring(1, overaallDataLength - 2);
            var rawDatasplits = overaallData.Split('{');
            var mainData = rawDatasplits[1].Split('}');
            var rawkeyValuePairs = mainData[0].Split(',');
            foreach (var rawKeyValue in rawkeyValuePairs)
            {
                var rawKeyValueSplits = rawKeyValue.Split(':');
                if (rawKeyValueSplits.Length > 1)
                {
                    var rawKeyValueSplitsLenght = rawKeyValueSplits[0].Length;
                    var key = rawKeyValueSplits[0].Substring(1, rawKeyValueSplitsLenght - 2);
                    if (key != "submit")
                    {
                        var value = rawKeyValueSplits[1];
                        var properData = new JsonDataPairs
                        {
                            Key = key,
                            Value = value
                        };
                        datapairs.Add(properData);
                    }
                }
            }
            return new PerformanceDataValues { DataPairs = datapairs };
        }
    }

    public partial class JsonFormDetailsModel
    {
        [JsonProperty("components")]
        public Component[] Components { get; set; }
    }

    public partial class Component
    {
        [JsonProperty("label")]
        public string Label { get; set; }

        [JsonProperty("key")]
        public string Key { get; set; }
    }

    public partial class JsonDataPairs
    {
        public string Key { get; set; }
        public string Value { get; set; }
    }

    public class PerformanceDataValues
    {
        public List<JsonDataPairs> DataPairs { get; set; }
    }
}
