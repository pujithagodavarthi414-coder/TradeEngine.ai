using Btrak.Dapper.Dal.Partial;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.SystemManagement;
using Btrak.Models.TestRail;
using Btrak.Services.Audit;
using Btrak.Services.Chromium;
using Btrak.Services.Email;
using Btrak.Services.Helpers.TestRailValidationHelpers;
using BTrak.Common;
using Hangfire;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Threading.Tasks;
using System.Web;

namespace Btrak.Services.TestRail
{
    public class ReportService : IReportService
    {
        private readonly TestRailPartialRepository _testRailPartialRepository;
        private readonly IAuditService _auditService;
        private readonly IChromiumService _chromiumService;
        private readonly TestRailValidationHelper _testRailValidationHelper;
        private readonly GoalRepository _goalRepository = new GoalRepository();
        private readonly UserRepository _userRepository = new UserRepository();
        private readonly IEmailService _emailService;

        public ReportService(IAuditService auditService, IChromiumService chromiumService, TestRailPartialRepository testRailPartialRepository, TestRailValidationHelper testRailValidationHelper, IEmailService emailService)
        {
            _auditService = auditService;
            _chromiumService = chromiumService;
            _testRailPartialRepository = testRailPartialRepository;
            _testRailValidationHelper = testRailValidationHelper;
            _emailService = emailService;
        }

        public Guid? UpsertTestRailReport(ReportInputModel reportInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Report", "reportInputModel", reportInputModel, "Report Service"));
            _testRailValidationHelper.UpsertReportValidation(loggedInContext, validationMessages, reportInputModel);
            if (validationMessages.Count > 0)
            {
                return null;
            }
            Guid? reportId = _testRailPartialRepository.UpsertTestRailReport(reportInputModel, loggedInContext, validationMessages);
            if (validationMessages.Count > 0)
            {
                return null;
            }
            if (reportId != null)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Report audit saving", "reportId", reportId, "Report Service"));
                _auditService.SaveAudit(AppCommandConstants.UpsertReportCommandId, reportInputModel, loggedInContext);
                if (!reportInputModel.IsFromGeneratedPdf)
                {
                    BackgroundJob.Enqueue(() => GenrerateReportPdf(reportId, reportInputModel.ReportName, loggedInContext));
                }
                return reportId;
            }
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Report Failed", "Report Service"));
            return null;
        }

        public List<ReportsApiReturnModel> GetTestRailReports(ReportSearchCriteriaInputModel reportSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get TestRail Report", "ReportSearchCriteriaInputModel", reportSearchCriteriaInputModel, "Report Service"));
            var reports = _testRailPartialRepository.GetTestRailReports(reportSearchCriteriaInputModel, loggedInContext, validationMessages);
            _auditService.SaveAudit(AppCommandConstants.GetTestRailReportsCommandId, reportSearchCriteriaInputModel, loggedInContext);
            return validationMessages.Count > 0 ? null : reports;
        }

        public ReportsApiReturnModel GetTestRailReportById(ReportSearchCriteriaInputModel reportSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get TestRail Report By Id", "ReportSearchCriteriaInputModel", reportSearchCriteriaInputModel, "Report Service"));
            var report = _testRailPartialRepository.GetTestRailReportById(reportSearchCriteriaInputModel, loggedInContext, validationMessages);
            if (validationMessages.Count > 0)
            {
                return null;
            }
            if (report != null)
            {
                if (!string.IsNullOrEmpty(report.TestCasesXml))
                {
                    report.TestCases = Utilities.GetObjectFromXml<TestRailReportsMiniModel>(report.TestCasesXml, "TestCaseModel");
                }
                else
                {
                    report.TestCases = null;
                }
                if (!string.IsNullOrEmpty(report.TestRunsXml))
                {
                    report.TestRuns = Utilities.GetObjectFromXml<TestRunReportMiniModel>(report.TestRunsXml, "TestRunModel");
                }
                else
                {
                    report.TestRuns = null;
                }
                var hierarchy = _testRailPartialRepository.GetReportHierarchicalCases(reportSearchCriteriaInputModel, loggedInContext, validationMessages);
                if (hierarchy != null && hierarchy.Count > 0)
                {
                    var hierarchyTreeStructure = GenerateSectionHierarchy(hierarchy, null);
                    if (hierarchyTreeStructure.Count > 0)
                    {
                        report.HierarchyTree = hierarchyTreeStructure;
                    }
                }
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Reports By Id audit saving", "report", report, "Report Service"));
                _auditService.SaveAudit(AppCommandConstants.GetTestRailReportByIdCommandId, reportSearchCriteriaInputModel, loggedInContext);
                return report;
            }
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Reports By Id Failed", "Report Service"));
            return null;
        }

        private List<ReportsHierarchyReturnModel> GenerateSectionHierarchy(List<ReportsHierarchyReturnModel> testSuiteSections, Guid? parentSectionId)
        {
            return testSuiteSections.Where(x => x.ParentSectionId.Equals(parentSectionId)).Select(sectionDetails => new ReportsHierarchyReturnModel
            {
                SectionName = sectionDetails.SectionName,
                SectionId = sectionDetails.SectionId,
                CasesCount = sectionDetails.CasesCount,
                ParentSectionId = parentSectionId,
                SubSections = GenerateSectionHierarchy(testSuiteSections, sectionDetails.SectionId),
                TestCases = sectionDetails.TestCasesXml != null ? Utilities.GetObjectFromXml<TestRailReportsMiniModel>(sectionDetails.TestCasesXml, "TestCaseModel") : null
            }).ToList();
        }

        public async Task<bool?> SendReportAsPdf(ReportsEmailInputModel reportsEmailInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Send Report As Pdf", "reportsEmailInputModel", reportsEmailInputModel, "Report Service"));
            try
            {
                _testRailValidationHelper.SendReportEmailValidator(loggedInContext, validationMessages, reportsEmailInputModel);
                if (validationMessages.Count > 0)
                {
                    return null;
                }
                var reportSearchCriteriaInputModel = new ReportSearchCriteriaInputModel()
                {
                    ReportId = reportsEmailInputModel.ReportId
                };
                var reports = GetTestRailReportById(reportSearchCriteriaInputModel, loggedInContext, validationMessages);
                if (validationMessages.Count > 0)
                {
                    return null;
                }
                if (reports != null && reports.PdfUrl != null)
                {
                    await SendReportEmail(reportsEmailInputModel, reports.PdfUrl, loggedInContext, validationMessages);
                }
                return true;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SendReportAsPdf", "ReportService ", exception.Message), exception);

                return false;
            }
        }

        public async Task SendReportEmail(ReportsEmailInputModel reportsEmailInputModel, string PdfUrl, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entering into SendReportEmail Method in Reports service");

            SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, HttpContext.Current.Request.Url.Authority);

            var toEmails = reportsEmailInputModel.ToUsers.Trim().Split('\n');

            var html = _goalRepository.GetHtmlTemplateByName("TestRailReportTemplate", loggedInContext.CompanyGuid).Replace("##ReportName##", reportsEmailInputModel.ReportName).Replace("##PdfUrl##", PdfUrl);
            EmailGenericModel emailModel = new EmailGenericModel
            {
                SmtpServer = smtpDetails?.SmtpServer,
                SmtpServerPort = smtpDetails?.SmtpServerPort,
                SmtpMail = smtpDetails?.SmtpMail,
                SmtpPassword = smtpDetails?.SmtpPassword,
                ToAddresses = toEmails,
                HtmlContent = html,
                Subject = "Snovasys Business Suite: TestRail Report",
                CCMails = null,
                BCCMails = null,
                MailAttachments = null,
                IsPdf = null
            };
            _emailService.SendMail(loggedInContext, emailModel);
            LoggingManager.Info("sent reports Pdf to " + toEmails + " in SendReportEmail in Reports Service");
        }

        public async Task GenrerateReportPdf(Guid? reportId, string reportName, LoggedInContext loggedInContext)
        {
            LoggingManager.Info("Entering into GenrerateReportPdf Method in Reports service");
            var reportSearchCriteriaInputModel = new ReportSearchCriteriaInputModel()
            {
                ReportId = reportId,
                IsForPdf = true
            };
            var validationMessages = new List<ValidationMessage>();
            LoggingManager.Info("Fetching Reports using reportId " + reportId + " in Reports service");
            var reportSearchModel = new ReportSearchCriteriaInputModel()
            {
                ReportId = reportId
            };
            var reportDetails = GetTestRailReports(reportSearchModel, loggedInContext, validationMessages);
            var reports = reportDetails.FirstOrDefault();
            if (reports != null)
            {
                var reportsCases = GetTestRailReportById(reportSearchCriteriaInputModel, loggedInContext, validationMessages);
                var PdfData = "<html><body>"
                             + "<h2 style=\"margin: 10px;\">" + reportName + "</h2>";
                if (!string.IsNullOrEmpty(reports.Description))
                {
                    PdfData = PdfData + "<div style=\"margin: 10px;\"> ( " + reports.Description + " ) </div>";
                }
                PdfData = PdfData + "<div style=\"margin: 10px;\"> Project name - <b>" + reportsCases?.ProjectName + "</b></div>"
                             + "<div style=\"margin: 10px;\">by <b>" + reports.CreatedBy + "</b> - " + reports.CreatedDateTime.Value.ToString("dddd, dd MMMM yyyy", new CultureInfo("en-US")) + "</div><hr>"
                             + "<div style=\"margin: 10px;\">Total cases - <b>" + reportsCases?.CasesCount + "</b></div>"
                             + "<div style=\"margin: 10px;\">Untested cases count - <b>" + reports.UntestedCount + "</b> ( <b>" + reports.UntestedPercent + " </b>% ) </div>"
                             + "<div style=\"margin: 10px;\">Passed cases count - <b>" + reports.PassedCount + "</b> ( <b> " + reports.PassedPercent + " </b>% ) </div>"
                             + "<div style=\"margin: 10px;\">Blocked cases count - <b> " + reports.BlockedCount + " </b> ( <b>" + reports.BlockedPercent + " </b>% ) </div>"
                             + "<div style=\"margin: 10px;\">Reset cases count - <b> " + reports.RetestCount + " </b> ( <b>" + reports.RetestPercent + " </b>% ) </div>"
                             + "<div style=\"margin: 10px;\">Failed cases count - <b>" + reports.FailedCount + " </b> ( <b>" + reports.FailedPercent + " </b>% ) </div><hr>";
                if(reportsCases != null)
                {
                    foreach (var report in reportsCases?.TestCases)
                    {
                        string name = " Untested ";
                        if (!string.IsNullOrEmpty(report.TestedByUserName))
                        {
                            name = " Tested by " + report.TestedByUserName;
                        }
                        var htmlBody = "<div style=\"clear: both;\">"
                                      + "<div style=\"float: left;width: 10%;color: white;text-align: center;margin-right: 10px;margin: 8px;padding: 8px 2px !important;border-radius: 4px !important;line-height: 5px !important;max-height: 25px;-webkit-print-color-adjust: exact;vertical-align: middle;background: " + report.StatusColor + "\"" + "><span>" + report.StatusName + "</span></div>"
                                      + "<div style=\"float: left;width: 70%;font-size: 16px;font-weight: bold;margin-top: 4px;\">"
                                      + "<p style=\"margin: 8px;font-size: 10px;font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;\" >" + report.Title + "</p>"
                                      + "</div>"
                                      + "<div style=\"width: 12 %; font - size: 16px; margin - top: 4px; float: right;\">"
                                               + "<p style=\"margin: 8px;font-size: 10px;font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;\" >" + name + "</p>"
                                      + "</div>"
                                      + "<div style=\"float: right;width: 10%;font-size: 16px;color: #a7a3a3;font-weight: bold;\">"
                                      + "</div>"
                                      + "</div>";
                        PdfData = PdfData + htmlBody;
                    }
                }
                
                PdfData = PdfData + "</body>"
                                  + "</html>";
                LoggingManager.Info("Generated html realted to Pdf File in Reports service");

                var fileName = reportName + DateTime.Now.Day + "-" + DateTime.Now.Month + DateTime.Now.Year +
                               "-Reports.pdf";

                var pdfOutput = await _chromiumService.GeneratePdf(PdfData, reportName, null);
                var reportModel = new ReportInputModel()
                {
                    TestRailReportId = reportId,
                    ReportName = reports.TestRailReportName,
                    PdfUrl = pdfOutput.BlobUrl,
                    TimeStamp = reports.TimeStamp,
                    ProjectId = reports.ProjectId,
                    TestRunId = reports.TestRunId,
                    MilestoneId = reports.MilestoneId,
                    IsFromGeneratedPdf = true
                };

                validationMessages = new List<ValidationMessage>();
                UpsertTestRailReport(reportModel, loggedInContext, validationMessages);
            }
            
        }
    }
}