using Btrak.Dapper.Dal.Partial;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.HrDashboard;
using Btrak.Models.SystemManagement;
using Btrak.Services.Email;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.HrDashboardValidationHelpers;
using BTrak.Common;
using Hangfire;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Services.HrDashboard
{
    public class HrDashboardService : IHrDashboardService
    {
        private readonly HrDashboardRepository _hrDashboardRepository;

        private readonly UserRepository _userRepository;

        private readonly GoalRepository _goalRepository;

        private readonly IEmailService _emailService;

        public HrDashboardService(HrDashboardRepository hrDashboardRepository, UserRepository userRepository, GoalRepository goalRepository, IEmailService emailService)
        {
            _hrDashboardRepository = hrDashboardRepository;
            _userRepository = userRepository;
            _goalRepository = goalRepository;
            _emailService = _emailService;
        }

        public EmployeeAttendanceOutputModel GetEmployeeAttendanceByDay(EmployeeAttendanceSearchInputModel employeeAttendanceSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeeAttendanceByDay", "HrDashboard Service"));
            LoggingManager.Debug("Entered GetEmployeeAttendanceByDay with " + employeeAttendanceSearchInputModel);
            if (!HrDashboardValidationHelper.EmployeeAttendanceByDayValidation(employeeAttendanceSearchInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            List<EmployeeAttendanceSpOutputModel> employeeAttendance = _hrDashboardRepository.GetEmployeeAttendanceByDay(employeeAttendanceSearchInputModel, loggedInContext, validationMessages).OrderBy(x => x.Date).ToList();
            EmployeeAttendanceOutputModel employeeAttendanceValues = new EmployeeAttendanceOutputModel();
            if (employeeAttendance.Count > 0)
            {
                employeeAttendanceValues = ConvertToApiReturnModel(employeeAttendance);
            }
            LoggingManager.Debug(employeeAttendanceValues.ToString());

            return employeeAttendanceValues;
        }

        public List<EmployeeWorkingDaysOutputModel> GetEmployeeWorkingDays(EmployeeWorkingDaysSearchCriteriaInputModel employeeWorkingDaysSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeeWorkingDays", "HrDashboard Service"));
            LoggingManager.Debug("Entered GetEmployeeAttendanceByDay with date " + employeeWorkingDaysSearchCriteriaInputModel.Date);
            if (!HrDashboardValidationHelper.GetEmployeeWorkingDaysValidation(employeeWorkingDaysSearchCriteriaInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            List<EmployeeWorkingDaysOutputModel> employeeWorkingDaysForMonth = _hrDashboardRepository.GetEmployeeWorkingDays(employeeWorkingDaysSearchCriteriaInputModel, loggedInContext, validationMessages)
                .ToList();
            return employeeWorkingDaysForMonth;
        }

        public List<EmployeeSpentTimeOutputModel> GetEmployeeSpentTime(Guid? userId, string fromDate, string toDate, Guid? entityId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeeSpentTime", "HrDashboard Service"));

            if (!HrDashboardValidationHelper.GetEmployeeSpentTimeValidation(userId, fromDate, toDate, loggedInContext, validationMessages))
            {
                return null;
            }

            List<EmployeeSpentTimeOutputModel> employeeSpentTimes = _hrDashboardRepository
                .GetEmployeeSpentTime(userId, fromDate, toDate, entityId, loggedInContext, validationMessages).OrderBy(x => x.Date).ToList();

            LoggingManager.Debug(employeeSpentTimes.ToString());

            return employeeSpentTimes;
        }

        public List<LateEmployeeOutputModel> GetLateEmployee(HrDashboardSearchCriteriaInputModel hrDashboardSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetLateEmployee", "HrDashboard Service"));

            if (!HrDashboardValidationHelper.GetEmployeeSpentTimeValidation(hrDashboardSearchCriteriaInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            List<LateEmployeeOutputModel> lateEmployee = _hrDashboardRepository.GetLateEmployee(hrDashboardSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
            return lateEmployee;
        }

        public List<EmployeePresenceApiOutputModel> GetEmployeePresence(HrDashboardSearchCriteriaInputModel hrDashboardSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeePresence", "HrDashboard Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<EmployeePresenceApiOutputModel> employeePresence = _hrDashboardRepository.GetEmployeePresence(hrDashboardSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
            return employeePresence;
        }

        public List<LeavesReportOutputModel> GetLeavesReport(LeavesReportSearchCriteriaInputModel leavesReportSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetLeavesReport", "HrDashboard Service"));

            if (leavesReportSearchCriteriaInputModel.Year == null)
            {
                leavesReportSearchCriteriaInputModel.Year = DateTime.Now.Year;
            }

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<LeavesReportOutputModel> leavesReport = _hrDashboardRepository.GetLeavesReport(leavesReportSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
            return leavesReport;
        }

        public List<LateEmployeeCountSpOutputModel> GetLateEmployeeCount(LateEmployeeCountSearchInputModel lateEmployeeCountSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetLateEmployeeCount", "HrDashboard Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            if (lateEmployeeCountSearchInputModel.DateFrom == null && lateEmployeeCountSearchInputModel.DateTo == null)
            {
                var currentDate = DateTime.Now.Date;

                lateEmployeeCountSearchInputModel.DateFrom = currentDate.AddMonths(-6);
                lateEmployeeCountSearchInputModel.DateTo = currentDate;
            }


            List<LateEmployeeCountSpOutputModel> lateEmployeeCountSpOutputModels = _hrDashboardRepository.GetLateEmployeeCount(lateEmployeeCountSearchInputModel, loggedInContext, validationMessages).ToList();
            //List<LateEmployeeCountOutputModel> lateEmployeeCountOutputLists = new List<LateEmployeeCountOutputModel>();

            //foreach(LateEmployeeCountSpOutputModel lateEmployeeCountModel in lateEmployeeCountSpOutputModels)
            //{
            //    lateEmployeeCountOutputLists.Add(ConvertToApiReturnModel(lateEmployeeCountModel));
            //}
            return lateEmployeeCountSpOutputModels;
        }

        public List<LineManagersOutputModel> GetLineManagers(string searchText, bool? isReportToOnly, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetLineManagers", "HrDashboard Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<LineManagersOutputModel> lineManagers = _hrDashboardRepository.GetLineManagers(searchText, isReportToOnly, loggedInContext, validationMessages).ToList();
            return lineManagers;
        }

        public List<DailyLogTimeReportOutputModel> GetDailyLogTimeReport(LogTimeReportSearchInputModel logTimeReportSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDailyLogTimeReport", "HrDashboard Service"));

            LoggingManager.Debug(logTimeReportSearchInputModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<DailyLogTimeReportOutputModel> dailyLogTimeReport = _hrDashboardRepository.GetDailyLogTimeReport(logTimeReportSearchInputModel, loggedInContext, validationMessages).ToList();
            return dailyLogTimeReport;
        }

        public MonthlyLogTimeReportModel GetMonthlyLogTimeReport(LogTimeReportSearchInputModel logTimeReportSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetMonthlyLogTimeReport", "HrDashboard Service"));

            LoggingManager.Debug(logTimeReportSearchInputModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<MonthlyLogTimeReportSpOutputModel> monthlyLogTimeReportSpOutputModels = _hrDashboardRepository.GetMonthlyLogTimeReport(logTimeReportSearchInputModel, loggedInContext, validationMessages).OrderBy(x => x.Date).ToList();

            MonthlyLogTimeReportModel monthlyLogTimeReportModel = ConvertToApiReturnModel(monthlyLogTimeReportSpOutputModels);

            return monthlyLogTimeReportModel;
        }

        public List<OrganizationchartOutputModel> GetOrganizationChartDetails(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetOrganizationChartDetails", "HrDashboard Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<OrganizationchartModel> employeesList = _hrDashboardRepository.GetOrganizationChartDetails(loggedInContext, validationMessages);

            List<OrganizationchartModel> employeelist = FilteredEmployeeList(employeesList);

            List<OrganizationchartOutputModel> orgChart = GenerateOrgChartHierarchy(employeelist, null, null);

            return orgChart;
        }

        public Guid? UpsertSignature(SignatureModel signatureModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertSignature", "HrDashboard Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            var signatureId = _hrDashboardRepository.UpsertSignature(signatureModel, loggedInContext, validationMessages);

            if (validationMessages.Count == 0 && signatureModel.IsArchived == false && signatureModel.SignatureId == null && signatureModel.InviteeId != null)
            {
                BackgroundJob.Enqueue(() => SendSignatureInvitationMail(signatureModel.ReferenceId, signatureModel.InviteeId, loggedInContext, validationMessages));
            }

            return signatureId;
        }

        public bool SendSignatureInvitationMail(Guid? referenceId, Guid? inviteeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            SignatureModel signatureModel = new SignatureModel()
            {
                ReferenceId = referenceId,
                InviteeId = inviteeId
            };

            var signature = _hrDashboardRepository.GetSignature(signatureModel, loggedInContext, validationMessages);

            if (signature.Count > 0)
            {
                var currentSignature = signature.FirstOrDefault();
                SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, null);

                var html = _goalRepository.GetHtmlTemplateByName("UserSignatureInvitationTemplate", loggedInContext.CompanyGuid);
                var siteAddress = ConfigurationManager.AppSettings["SiteUrl"] + "/sessions/signin";
                html = html.Replace("##InviteeName##", currentSignature.InviteeName).
                        Replace("##InvitedByName##", currentSignature.InvitedByName).
                        Replace("##CompanyName##", smtpDetails.CompanyName);

                var toMails = new string[1];
                toMails[0] = currentSignature.InviteeMail;
                EmailGenericModel emailModel = new EmailGenericModel
                {
                    SmtpServer = smtpDetails?.SmtpServer,
                    SmtpServerPort = smtpDetails?.SmtpServerPort,
                    SmtpMail = smtpDetails?.SmtpMail,
                    SmtpPassword = smtpDetails?.SmtpPassword,
                    ToAddresses = toMails,
                    HtmlContent = html,
                    Subject = "Snovasys Business Suite: Signature invitation notification",
                    CCMails = null,
                    BCCMails = null,
                    MailAttachments = null,
                    IsPdf = null
                };
                _emailService.SendMail(loggedInContext, emailModel);
            }
            return true;
        }

        public List<SignatureModel> GetSignature(SignatureModel signatureModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetSignature", "HrDashboard Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            return _hrDashboardRepository.GetSignature(signatureModel, loggedInContext, validationMessages);
        }

        private static List<OrganizationchartOutputModel> GenerateOrgChartHierarchy(List<OrganizationchartModel> employeesList, Guid? parentId, string color)
        {
            return employeesList.Where(x => x.ParentId.Equals(parentId)).Select(employeeDetails => new OrganizationchartOutputModel
            {
                Name = employeeDetails.Name,
                Designation = employeeDetails.Designation,
                EmployeeId = employeeDetails.EmployeeId,
                Color = !string.IsNullOrEmpty(employeeDetails.Color) ? employeeDetails.Color : color,
                Img = string.IsNullOrEmpty(employeeDetails.Img) ? "https://bviewstorage.blob.core.windows.net/4afeb444-e826-4f95-ac41-2175e36a0c16/projects/d1272dde-5e0f-44d0-abca-17e97ec5ac9d/userprofile-da43d8b5-5647-46c5-982a-89f299727da4.png" : employeeDetails.Img,
                Items = GenerateOrgChartHierarchy(employeesList, employeeDetails.EmployeeId, employeeDetails.Color ?? color),
            }).ToList();
        }

        private static LateEmployeeCountOutputModel ConvertToApiReturnModel(LateEmployeeCountSpOutputModel lateEmployeeCountSpOutputModel)
        {
            LateEmployeeCountOutputModel employeeSpentTimeOutputModel = new LateEmployeeCountOutputModel
            {
                Date = lateEmployeeCountSpOutputModel.Date,
                LunchbreakLateCount = lateEmployeeCountSpOutputModel.LunchbreakLateCount,
                MorningLateCount = lateEmployeeCountSpOutputModel.MorningLateCount,
                MorningLateExcludingPermissionCount = lateEmployeeCountSpOutputModel.MorningLateExcludingPermissionCount,
                MorningLatePermissionCount = lateEmployeeCountSpOutputModel.MorningLatePermissionCount,
                TotalCount = lateEmployeeCountSpOutputModel.TotalCount

            };
            return employeeSpentTimeOutputModel;
        }


        public EmployeeAttendanceOutputModel ConvertToApiReturnModel(List<EmployeeAttendanceSpOutputModel> employeeAttendance)
        {
            var employeeAttendanceModel = new EmployeeAttendanceOutputModel
            {
                Names = new List<object>(),
                Dates = new List<object>(),
                SummaryValue = new List<List<object>>(),
                UserIds = new List<object>()

            };

            var employeeAttendanceApiOutputModel = new EmployeeAttendanceApiOutputModel
            {
                Names = new List<object>(),
                SubDates = new List<object>(),
                SubSummary = new List<object>(),
                SubSummaryList = new List<object>(),
                SummaryValue = new List<List<object>>(),
                Dates = new List<List<object>>(),
                UserIds = new List<object>(),
                Summary = new List<List<object>>()
            };

            var employeeAttendanceValues = employeeAttendance.OrderByDescending(x => x.UserId);

            Guid? userId = Guid.Empty;
            foreach (var employeeAttendanceValue in employeeAttendanceValues)
            {


                if (userId == employeeAttendanceValue.UserId)
                {

                }
                else if (userId == Guid.Empty)
                {
                    employeeAttendanceApiOutputModel.Names.Add(employeeAttendanceValue.FullName);
                    employeeAttendanceApiOutputModel.UserIds.Add(employeeAttendanceValue.UserId);
                }

                else
                {
                    employeeAttendanceApiOutputModel.Names.Add(employeeAttendanceValue.FullName);
                    employeeAttendanceApiOutputModel.UserIds.Add(employeeAttendanceValue.UserId);
                    employeeAttendanceApiOutputModel.SummaryValue.Add(employeeAttendanceApiOutputModel.SubSummaryList);
                    employeeAttendanceApiOutputModel.Dates.Add(employeeAttendanceApiOutputModel.SubDates);
                    employeeAttendanceApiOutputModel.Summary.Add(employeeAttendanceApiOutputModel.SubSummary);
                    employeeAttendanceApiOutputModel.SubSummaryList = new List<object>();
                    employeeAttendanceApiOutputModel.SubDates = new List<object>();

                }
                employeeAttendanceApiOutputModel.SubDates.Add(employeeAttendanceValue.Date);
                employeeAttendanceApiOutputModel.SubSummaryList.Add(employeeAttendanceValue.SummaryValue);
                employeeAttendanceApiOutputModel.SubSummary.Add(employeeAttendanceValue.Summary);

                userId = employeeAttendanceValue.UserId;
            }
            employeeAttendanceApiOutputModel.SummaryValue.Add(employeeAttendanceApiOutputModel.SubSummaryList);
            employeeAttendanceApiOutputModel.Dates.Add(employeeAttendanceApiOutputModel.SubDates);
            employeeAttendanceApiOutputModel.Summary.Add(employeeAttendanceApiOutputModel.SubSummary);

            employeeAttendanceModel.Names = employeeAttendanceApiOutputModel.Names;
            employeeAttendanceModel.UserIds = employeeAttendanceApiOutputModel.UserIds;
            employeeAttendanceModel.SummaryValue = employeeAttendanceApiOutputModel.SummaryValue;
            employeeAttendanceModel.Dates = employeeAttendanceApiOutputModel.SubDates;
            employeeAttendanceModel.Summary = employeeAttendanceApiOutputModel.Summary;

            return employeeAttendanceModel;
        }

        public MonthlyLogTimeReportModel ConvertToApiReturnModel(List<MonthlyLogTimeReportSpOutputModel> monthlyLogTime)
        {
            var monthlyLogTimeReportOutputModel = new MonthlyLogTimeReportOutputModel
            {
                EmployeeName = new List<object>(),
                Dates = new List<List<object>>(),
                SubSummary = new List<object>(),
                SummaryValue = new List<List<object>>(),
                SubDates = new List<object>(),
                UserId = new List<object>()
            };

            var monthlyLogTimeReportModel = new MonthlyLogTimeReportModel
            {
                EmployeeName = new List<object>(),
                Dates = new List<object>(),
                SummaryValue = new List<List<object>>(),
                UserId = new List<object>()
            };
            var monthlyLogTimeList = monthlyLogTime.OrderByDescending(x => x.EmployeeName);

            Guid? userId = Guid.Empty;

            foreach (var monthlyLogTimeReportSpOutputModel in monthlyLogTimeList)
            {
                if (userId == monthlyLogTimeReportSpOutputModel.UserId)
                {

                }
                else if (userId == Guid.Empty)
                {
                    monthlyLogTimeReportOutputModel.EmployeeName.Add(monthlyLogTimeReportSpOutputModel.EmployeeName);
                }
                else
                {
                    monthlyLogTimeReportOutputModel.EmployeeName.Add(monthlyLogTimeReportSpOutputModel.EmployeeName);
                    monthlyLogTimeReportOutputModel.Dates.Add(monthlyLogTimeReportOutputModel.SubDates);
                    monthlyLogTimeReportOutputModel.SummaryValue.Add(monthlyLogTimeReportOutputModel.SubSummary);
                    monthlyLogTimeReportOutputModel.SubSummary = new List<object>();
                    monthlyLogTimeReportOutputModel.SubDates = new List<object>();
                }
                monthlyLogTimeReportOutputModel.SubSummary.Add(monthlyLogTimeReportSpOutputModel.SummaryValue);
                monthlyLogTimeReportOutputModel.SubDates.Add(monthlyLogTimeReportSpOutputModel.Date);
                userId = monthlyLogTimeReportSpOutputModel.UserId;
            }
            monthlyLogTimeReportOutputModel.SummaryValue.Add(monthlyLogTimeReportOutputModel.SubSummary);

            monthlyLogTimeReportModel.EmployeeName = monthlyLogTimeReportOutputModel.EmployeeName;
            monthlyLogTimeReportModel.SummaryValue = monthlyLogTimeReportOutputModel.SummaryValue;
            monthlyLogTimeReportModel.Dates = monthlyLogTimeReportOutputModel.SubDates;
            return monthlyLogTimeReportModel;
        }

        private static List<OrganizationchartModel> FilteredEmployeeList(List<OrganizationchartModel> employeesList)
        {
            List<OrganizationchartModel> employeelist = new List<OrganizationchartModel>();

            var emplist = from e in employeesList group e by e.EmployeeId;

            foreach (var emp in emplist)
            {
                var empLength = emp.Count();
                var nullCount = 0;
                var nullObj = new OrganizationchartModel();
                foreach (var e in emp)
                {
                    //if(e.Img == null)
                    //{
                    //    e.Img = string.IsNullOrEmpty(e.Img) ? "https://bviewstorage.blob.core.windows.net/4afeb444-e826-4f95-ac41-2175e36a0c16/projects/d1272dde-5e0f-44d0-abca-17e97ec5ac9d/userprofile-da43d8b5-5647-46c5-982a-89f299727da4.png" : e.Img;
                    //}

                    if (e.ParentId != null)
                    {
                        employeelist.Add(e);
                    }
                    else
                    {
                        nullCount++;
                        nullObj = e;
                    }
                }
                if (nullCount == empLength)
                {
                    employeelist.Add(nullObj);
                }
            }

            var duplicateList = from e in employeesList group e by e.ParentId;
            var random = new Random();
            StringBuilder existingColor = new StringBuilder();
            foreach (var dup in duplicateList)
            {
                foreach (var d in dup)
                {
                    if (d.ParentId != null)
                    {
                        var color = String.Format("#{0:X6}", random.Next(0x1000000));
                        if (color == "#000000" || color == "#FFFFFF" || color == "#FF0000" || color == "#00FF00" || color == "#0000FF" || color == "#FFFF00" || color == "#3da8b5" || color == "#3c7e86"
                            || (string.IsNullOrEmpty(existingColor.ToString()) && existingColor.ToString().ToLower().Contains(color.ToLower())))
                        {
                            color = RandomColorGenetaror(existingColor.ToString());
                        }
                        existingColor.Append(color);
                        employeelist.FirstOrDefault(x => x.EmployeeId.Equals(d.ParentId)).Color = color;
                    }
                }
            }

            return employeelist;
        }   

        private static string RandomColorGenetaror(string existingColor)
        {
            var random = new Random();
            var color = String.Format("#{0:X6}", random.Next(0x1000000));
            if (color == "#000000" || color == "#FFFFFF" || color == "#FF0000" || color == "#00FF00" || color == "#0000FF" || color == "#FFFF00" || color == "#3da8b5" || color == "#3c7e86" 
                || (string.IsNullOrEmpty(existingColor) && existingColor.ToLower().Contains(color.ToLower())))
            {
                return RandomColorGenetaror(existingColor);
            }
            else
            {
                return color;
            }
        }
    }
}
