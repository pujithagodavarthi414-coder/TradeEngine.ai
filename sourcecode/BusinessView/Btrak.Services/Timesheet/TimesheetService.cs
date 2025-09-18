using Btrak.Dapper.Dal.Partial;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Dapper.Dal.SpModels;
using Btrak.Models;
using Btrak.Models.ActivityTracker;
using Btrak.Models.Chat;
using Btrak.Models.MasterData;
using Btrak.Models.MyWork;
using Btrak.Models.Notification;
using Btrak.Models.SlackMessages;
using Btrak.Models.TestRail;
using Btrak.Models.TimeSheet;
using Btrak.Models.User;
using Btrak.Models.Widgets;
using Btrak.Services.Audit;
using Btrak.Services.FileUploadDownload;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.MasterDataValidationHelper;
using Btrak.Services.Helpers.TimeSheetValidationHelpers;
using Btrak.Services.Notification;
using Btrak.Services.Roster;
using Btrak.Services.User;
using BTrak.Common;
using BTrak.Common.Constants;
using DocumentFormat.OpenXml;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Spreadsheet;
using Hangfire;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Web.Hosting;
using System.Web.Script.Serialization;

namespace Btrak.Services.TimeSheet
{
    public class TimeSheetService : ITimeSheetService
    {
        private readonly TimeSheetRepository _timeSheetRepository = new TimeSheetRepository();
        private readonly MasterTableRepository _masterTableRepository = new MasterTableRepository();
        private readonly UserRepository _userRepository = new UserRepository();
        private readonly AuditRepository _auditRepository = new AuditRepository();
        private readonly TimeSheetUploadRepository _timeSheetUploadRepository = new TimeSheetUploadRepository();
        private readonly IUserService _userService;
        private readonly INotificationService _notificationService;
        private readonly IRosterService _rosterService;
        private readonly IFileStoreService _fileStoreService;
        private readonly WidgetRepository _widgetRepository = new WidgetRepository();
        static HexBinaryValue border = "2a84c8";
        static HexBinaryValue insideBorder = "2a84c8";



        public TimeSheetService(IUserService userService, INotificationService notificationService, IRosterService rosterService,
            TimeSheetRepository timeSheetRepository, MasterTableRepository masterTableRepository, UserRepository userRepository, AuditRepository auditRepository,
            TimeSheetUploadRepository timeSheetUploadRepository, IFileStoreService fileStoreService)
        {
            _userService = userService;
            _notificationService = notificationService;
            _rosterService = rosterService;
            _timeSheetRepository = timeSheetRepository;
            _masterTableRepository = masterTableRepository;
            _userRepository = userRepository;
            _auditRepository = auditRepository;
            _timeSheetUploadRepository = timeSheetUploadRepository;
            _fileStoreService = fileStoreService;
        }

        public Guid? UpsertTimeSheet(TimeSheetManagementInputModel timeSheetModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertTimeSheet", "timeSheetModel", timeSheetModel, "TimeSheet Service"));
            TimeSheetValidationsHelper.CheckUpsertTimeSheetValidationMessages(timeSheetModel, loggedInContext,
                validationMessages);
            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (timeSheetModel.InTime != null)
            {
                timeSheetModel.InTimeOffset = DateTimeOffset.ParseExact(timeSheetModel.InTime.Value.ToString("yyyy-MM-dd'T'HH:mm:ss") + timeSheetModel.TimeZoneOffset.Substring(0, 3) + ":" + timeSheetModel.TimeZoneOffset.Substring(3, 2),
                                               "yyyy-MM-dd'T'HH:mm:sszzz",
                                               CultureInfo.InvariantCulture);
            }
            if (timeSheetModel.OutTime != null)
            {
                timeSheetModel.OutTimeOffset = DateTimeOffset.ParseExact(timeSheetModel.OutTime.Value.ToString("yyyy-MM-dd'T'HH:mm:ss") + timeSheetModel.TimeZoneOffset.Substring(0, 3) + ":" + timeSheetModel.TimeZoneOffset.Substring(3, 2),
                                               "yyyy-MM-dd'T'HH:mm:sszzz",
                                               CultureInfo.InvariantCulture);
            }
            if (timeSheetModel.LunchBreakStartTime != null)
            {
                timeSheetModel.LunchBreakStartTimeOffset = DateTimeOffset.ParseExact(timeSheetModel.LunchBreakStartTime.Value.ToString("yyyy-MM-dd'T'HH:mm:ss") + timeSheetModel.TimeZoneOffset.Substring(0, 3) + ":" + timeSheetModel.TimeZoneOffset.Substring(3, 2),
                                               "yyyy-MM-dd'T'HH:mm:sszzz",
                                               CultureInfo.InvariantCulture);
            }
            if (timeSheetModel.LunchBreakEndTime != null)
            {
                timeSheetModel.LunchBreakEndTimeOffset = DateTimeOffset.ParseExact(timeSheetModel.LunchBreakEndTime.Value.ToString("yyyy-MM-dd'T'HH:mm:ss") + timeSheetModel.TimeZoneOffset.Substring(0, 3) + ":" + timeSheetModel.TimeZoneOffset.Substring(3, 2),
                                               "yyyy-MM-dd'T'HH:mm:sszzz",
                                               CultureInfo.InvariantCulture);

            }
            if (timeSheetModel.BreakInTime != null)
            {

                timeSheetModel.BreakInTimeOffset = DateTimeOffset.ParseExact(timeSheetModel.BreakInTime.Value.ToString("yyyy-MM-dd'T'HH:mm:ss") + timeSheetModel.TimeZoneOffset.Substring(0, 3) + ":" + timeSheetModel.TimeZoneOffset.Substring(3, 2),
                                               "yyyy-MM-dd'T'HH:mm:sszzz",
                                               CultureInfo.InvariantCulture);
            }
            if (timeSheetModel.BreakOutTime != null)
            {

                timeSheetModel.BreakOutTimeOffset = DateTimeOffset.ParseExact(timeSheetModel.BreakOutTime.Value.ToString("yyyy-MM-dd'T'HH:mm:ss") + timeSheetModel.TimeZoneOffset.Substring(0, 3) + ":" + timeSheetModel.TimeZoneOffset.Substring(3, 2),
                                               "yyyy-MM-dd'T'HH:mm:sszzz",
                                               CultureInfo.InvariantCulture);
            }

            timeSheetModel.TimeSheetId = _timeSheetRepository.UpsertTimeSheet(timeSheetModel, loggedInContext, validationMessages);

            if (timeSheetModel.OutTime.HasValue)
            {
                TaskWrapper.ExecuteFunctionInNewThread(() =>
                {
                    _rosterService.SendFinishMailToEmployee(timeSheetModel, loggedInContext, validationMessages);
                });
            }
            LoggingManager.Debug("Updated timeSheet with the id " + timeSheetModel.TimeSheetId);
            return timeSheetModel.TimeSheetId;
        }

        public TimeSheetManagementButtonDetails GetEnableOrDisableTimeSheetButtonDetails(Guid? userId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetEnableOrDisableTimeSheetButtonDetails", "userId", userId, "TimeSheet Service"));
            TimeSheetValidationsHelper.CheckGetEnableOrDisableTimeSheetButtonDetailsValidationMessages(userId, loggedInContext, validationMessages);
            if (validationMessages.Count > 0)
            {
                return null;
            }
            var indianTimeDetails = TimeZoneHelper.GetIstTime();
            DateTimeOffset? buttonClickedDate = indianTimeDetails?.UserTimeOffset;

            if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                buttonClickedDate = userTimeDetails?.UserTimeOffset;
            }

            TimeSheetManagementButtonDetails timeSheetButtonDetails = _timeSheetRepository.GetEnableOrDisableTimeSheetButtonDetails(userId, buttonClickedDate, loggedInContext, validationMessages);

            if (timeSheetButtonDetails != null)
            {
                TimeSheetManagementButtonDetails timeSheetButtonDetailsModel = new TimeSheetManagementButtonDetails
                {
                    StartTime = timeSheetButtonDetails.StartTime,
                    LunchStartTime = timeSheetButtonDetails.LunchStartTime,
                    LunchEndTime = timeSheetButtonDetails.LunchEndTime,
                    BreakInTime = timeSheetButtonDetails.BreakInTime,
                    BreakOutTime = timeSheetButtonDetails.BreakOutTime,
                    FinishTime = timeSheetButtonDetails.FinishTime,
                    IsStart = timeSheetButtonDetails.IsStart,
                    IsLunchStart = timeSheetButtonDetails.IsLunchStart,
                    IsLunchEnd = timeSheetButtonDetails.IsLunchEnd,
                    IsBreakIn = timeSheetButtonDetails.IsBreakIn,
                    IsBreakOut = timeSheetButtonDetails.IsBreakOut,
                    IsFinish = timeSheetButtonDetails.IsFinish,
                    SpentTime = timeSheetButtonDetails.SpentTime
                };
                return timeSheetButtonDetailsModel;
            }

            validationMessages.Add(new ValidationMessage
            {
                ValidationMessageType = MessageTypeEnum.Error,
                ValidationMessaage = string.Format(ValidationMessages.NotFoundTimeSheetDetailsWithTheId, userId)
            });
            return null;
        }

        public List<TimeSheetManagementApiOutputModel> GetTimeSheetDetails(TimeSheetManagementSearchInputModel timeSheetManagementSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetTimeSheetDetails", "timeSheetManagementSearchInputModel", timeSheetManagementSearchInputModel, "TimeSheet Api"));
            AuditService auditService = new AuditService();
            auditService.SaveAudit(AppCommandConstants.GetTimeSheetDetailsCommandId, timeSheetManagementSearchInputModel, loggedInContext);
            CommonValidationHelper.CheckValidationForSearchCriteria(loggedInContext, timeSheetManagementSearchInputModel, validationMessages);
            if (validationMessages.Count > 0)
            {
                return null;
            }

            List<TimeSheetManagementApiOutputModel> timeSheetDetailsList = _timeSheetRepository.GetTimeSheetDetails(timeSheetManagementSearchInputModel, loggedInContext, validationMessages).ToList();

            var name = TimeZoneInfo.Local.DisplayName;

            return timeSheetDetailsList;

        }

        //public PdfGenerationOutputModel GetTimeSheetDetailsUploadTemplate(TimeSheetManagementSearchInputModel getTimeSheetDetails, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        //{
        //    var details = _timeSheetRepository.GetTimeSheetDetails(getTimeSheetDetails, loggedInContext, validationMessages);
        //    var path = "";
        //    var path1 = HostingEnvironment.MapPath(@"~/Resources/ExcelTemplates");
        //    var guid = Guid.NewGuid();
        //    if (path1 != null && getTimeSheetDetails.UserId == null)
        //    {
        //        var pdfOutputModel = new PdfGenerationOutputModel();
        //        DataTable dt = new DataTable();
        //        dt.Columns.Add("Employee name", typeof(string));
        //        dt.Columns.Add("Date", typeof(string));
        //        dt.Columns.Add("Start time", typeof(string));
        //        dt.Columns.Add("Finish time", typeof(string));
        //        dt.Columns.Add("Punch card lunch", typeof(string));
        //        dt.Columns.Add("Punch card breaks", typeof(string));
        //        dt.Columns.Add("Total time", typeof(string));
        //        dt.Columns.Add("System usage time", typeof(string));
        //        dt.Columns.Add("System idle time", typeof(string));
        //        dt.Columns.Add("System productive time", typeof(string));
        //        dt.Columns.Add("No of screenshots", typeof(string));
        //        dt.Columns.Add("Time spent on work items", typeof(string));
        //        // dt.Columns.Add("Is on leave", typeof(string));
        //        dt.Columns.Add("Leave type", typeof(string));
        //        dt.Columns.Add("Leave session", typeof(string));

        //        foreach (var detail in details)
        //        {
        //            var date = detail.Date.ToString() != null ? ConvertNumbertoMonth(detail.Date.Value.Month) + "-" + ConvertDate(detail.Date.Value.Day) + "-" + detail.Date.Value.Year : null;
        //            var inTime = detail.InTime != null ? ConvertDateTimeToTime(detail.InTime.Value.DateTime, getTimeSheetDetails.TimeZone) + " " + detail.InTimeAbbreviation : null;
        //            var outTime = detail.OutTime != null ? ConvertDateTimeToTime(detail.OutTime.Value.DateTime, getTimeSheetDetails.TimeZone) + " " + detail.OutTimeAbbreviation : null;
        //            var lunchTime = (detail.LunchBreakStartTime != null && detail.LunchBreakEndTime != null) ?
        //                     ConvertDateTimeToTime(detail.LunchBreakStartTime.Value.DateTime, getTimeSheetDetails.TimeZone) + " " + detail.LunchStartAbbreviation + " - "
        //                     + ConvertDateTimeToTime(detail.LunchBreakEndTime.Value.DateTime, getTimeSheetDetails.TimeZone) + " " + detail.LunchEndAbbreviation + " (" + detail.LunchBreakDiff + ")" :
        //                     (detail.LunchBreakStartTime != null) ? ConvertDateTimeToTime(detail.LunchBreakStartTime.Value.DateTime, getTimeSheetDetails.TimeZone) + " " + detail.LunchStartAbbreviation + " - " : null;
        //            var userBreak = detail.UsersBreakTime != null ? detail.UsersBreakTime + " (" + detail.UserBreaksCount + ")" : null;
        //            var leave = (detail.LeaveTypeName != null || detail.LeaveReason != null || detail.LeaveSessionName != null) ? "Yes" : null;
        //            var leaveType = (detail.LeaveTypeName != null || detail.LeaveReason != null || detail.LeaveSessionName != null) ? detail.LeaveTypeName== null? detail.LeaveTypeName : detail.LeaveReason : null;
        //            var leaveSession = ( detail.LeaveSessionName != null) ? detail.LeaveSessionName : null;
        //            var spentTime = detail.SpentTimeDiff != null ? detail.SpentTimeDiff : null;
        //            dt.Rows.Add(detail.EmployeeName, date.ToString(), inTime, outTime, lunchTime, userBreak, spentTime, ConvertedTime(detail.ActiveTimeInMin),
        //                ConvertedTime(detail.TotalIdleTime), ConvertedTime(detail.ProductiveTimeInMin), detail.Screenshots, ConvertedTime(detail.LoggedTime),
        //                leaveType, leaveSession );
        //        }

        //        var CSVFileData = DataTableToCSV(dt);
        //        var convertedCSV = Encoding.GetEncoding("iso-8859-1").GetBytes(CSVFileData);

        //        var blobUrl = _fileStoreService.PostFile(new FilePostInputModel
        //        {
        //            MemoryStream = Encoding.GetEncoding("iso-8859-1").GetBytes(CSVFileData),
        //            FileName = "TimeSheet" + DateTime.Now.ToString("yyyy-MM-dd") + ".csv",
        //            ContentType = "text/csv"
        //        });

        //        pdfOutputModel = new PdfGenerationOutputModel()
        //        {
        //            ByteStream = convertedCSV,
        //            BlobUrl = blobUrl,
        //            FileName = "TimeSheet" + DateTime.Now.ToString("yyyy-MM-dd") + ".csv",
        //        };
        //        return pdfOutputModel;
        //    }
        //    else if (path1 != null && getTimeSheetDetails.UserId != null)
        //    {
        //        var pdfOutputModel = new PdfGenerationOutputModel();
        //        DataTable dt = new DataTable();
        //        dt.Columns.Add("Date", typeof(string));
        //        dt.Columns.Add("Start time", typeof(string));
        //        dt.Columns.Add("Finish time", typeof(string));
        //        dt.Columns.Add("Punch card lunch", typeof(string));
        //        dt.Columns.Add("Punch card breaks", typeof(string));
        //        dt.Columns.Add("Total time", typeof(string));
        //        dt.Columns.Add("System usage time", typeof(string));
        //        dt.Columns.Add("System idle time", typeof(string));
        //        dt.Columns.Add("System productive time", typeof(string));
        //        dt.Columns.Add("No of screenshots", typeof(string));
        //        dt.Columns.Add("Time spent on work items", typeof(string));
        //        dt.Columns.Add("Is on leave", typeof(string));

        //        foreach (var detail in details)
        //        {
        //            var date = detail.Date.ToString() != null ? ConvertNumbertoMonth(detail.Date.Value.Month) + "-" + ConvertDate(detail.Date.Value.Day) + "-" + detail.Date.Value.Year : null;
        //            var inTime = detail.InTime != null ? ConvertDateTimeToTime(detail.InTime.Value.DateTime, getTimeSheetDetails.TimeZone) + " " + detail.InTimeAbbreviation : null;
        //            var outTime = detail.OutTime != null ? ConvertDateTimeToTime(detail.OutTime.Value.DateTime, getTimeSheetDetails.TimeZone) + " " + detail.OutTimeAbbreviation : null;
        //            var lunchTime = (detail.LunchBreakStartTime != null && detail.LunchBreakEndTime != null) ?
        //                     ConvertDateTimeToTime(detail.LunchBreakStartTime.Value.DateTime, getTimeSheetDetails.TimeZone) + " " + detail.LunchStartAbbreviation + " - "
        //                     + ConvertDateTimeToTime(detail.LunchBreakEndTime.Value.DateTime, getTimeSheetDetails.TimeZone) + " " + detail.LunchEndAbbreviation + " (" + detail.LunchBreakDiff + ")" :
        //                     (detail.LunchBreakStartTime != null) ? ConvertDateTimeToTime(detail.LunchBreakStartTime.Value.DateTime, getTimeSheetDetails.TimeZone) + " " + detail.LunchStartAbbreviation + " - " : null;
        //            var userBreak = detail.UsersBreakTime != null ? detail.UsersBreakTime + " (" + detail.UserBreaksCount + ")" : null;
        //            var leave = (detail.LeaveTypeName != null || detail.LeaveReason != null || detail.LeaveSessionName != null) ? "Yes" : null;
        //            var spentTime = detail.SpentTimeDiff != null ? detail.SpentTimeDiff : null;
        //            dt.Rows.Add(date.ToString(), inTime, outTime, lunchTime, userBreak, spentTime, ConvertedTime(detail.ActiveTimeInMin),
        //                ConvertedTime(detail.TotalIdleTime), ConvertedTime(detail.ProductiveTimeInMin), detail.Screenshots, ConvertedTime(detail.LoggedTime),
        //                leave);
        //        }

        //        var CSVFileData = DataTableToCSV(dt);
        //        var convertedCSV = Encoding.GetEncoding("iso-8859-1").GetBytes(CSVFileData);

        //        var UserDetails = _userService.GetUserById(getTimeSheetDetails.UserId, true, loggedInContext, validationMessages);

        //        var blobUrl = _fileStoreService.PostFile(new FilePostInputModel
        //        {
        //            MemoryStream = Encoding.GetEncoding("iso-8859-1").GetBytes(CSVFileData),
        //            FileName = UserDetails.FullName + "'s monthly timesheet" + DateTime.Now.ToString("yyyy-MM-dd") + ".csv",
        //            ContentType = "text/csv"
        //        });

        //        pdfOutputModel = new PdfGenerationOutputModel()
        //        {
        //            ByteStream = convertedCSV,
        //            BlobUrl = blobUrl,
        //            FileName = UserDetails.FullName + "'s monthly timesheet" + DateTime.Now.ToString("yyyy-MM-dd") + ".csv",
        //        };
        //        return pdfOutputModel;
        //    }
        //    return null;
        //}
        public PdfGenerationOutputModel GetTimeSheetDetailsUploadTemplate(TimeSheetManagementSearchInputModel getTimeSheetDetails, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            var details = _timeSheetRepository.GetTimeSheetDetails(getTimeSheetDetails, loggedInContext, validationMessages);
            var path = HostingEnvironment.MapPath(@"~/Resources/ExcelTemplates/TimesheetDownload.xlsx");

            var path1 = HostingEnvironment.MapPath(@"~/Resources/ExcelTemplates");
            List<string> excelColumns = new List<string>();
            List<string> excelFields = new List<string>();

            var guid = Guid.NewGuid();
            if (path1 != null && getTimeSheetDetails.UserId == null)
            {
                getTimeSheetDetails.ExcelColumnList = new List<WorkReportExcelInputModel>
{
    new WorkReportExcelInputModel { ExcelColumn = "Employee name", ExcelField = "Employee name" },
    new WorkReportExcelInputModel { ExcelColumn = "Date", ExcelField = "Date" },
    new WorkReportExcelInputModel { ExcelColumn = "Start time", ExcelField = "Start time" },
    new WorkReportExcelInputModel { ExcelColumn = "Finish time", ExcelField = "Finish time" },
    new WorkReportExcelInputModel { ExcelColumn = "Punch card lunch", ExcelField = "Punch card lunch" },
    new WorkReportExcelInputModel { ExcelColumn = "Punch card breaks", ExcelField = "Punch card breaks" },
    new WorkReportExcelInputModel { ExcelColumn = "Total time", ExcelField = "Total time" },
    new WorkReportExcelInputModel { ExcelColumn = " System usage time", ExcelField = " System usage time" },
    new WorkReportExcelInputModel { ExcelColumn = "System idle time", ExcelField = "System idle time" },
    new WorkReportExcelInputModel { ExcelColumn = "System productive time", ExcelField = "System productive time" },
    new WorkReportExcelInputModel { ExcelColumn = "No of screenshots", ExcelField = "No of screenshots" },
    new WorkReportExcelInputModel { ExcelColumn = "Time spent on work items", ExcelField = "Time spent on work items" },
    new WorkReportExcelInputModel { ExcelColumn = "Leave type", ExcelField = "Leave type" },
    new WorkReportExcelInputModel { ExcelColumn = "Leave session", ExcelField = "Leave session" },
    new WorkReportExcelInputModel { ExcelColumn = "Submission status", ExcelField = "Submission status" }
};

                foreach (var value in getTimeSheetDetails.ExcelColumnList)
                {
                    excelColumns.Add(value.ExcelColumn);
                    excelFields.Add(value.ExcelField);
                }
                var columLength = excelColumns.Count();

                var pdfOutputModel = new PdfGenerationOutputModel();
                var destinationPath = Path.Combine(path1, guid.ToString());
                string docName = Path.Combine(destinationPath, "TimesheetDownload.xlsx");
                if (!Directory.Exists(destinationPath))
                {
                    Directory.CreateDirectory(destinationPath);

                    if (path != null)
                    {
                        System.IO.File.Copy(path, docName, true);
                    }

                    LoggingManager.Info("Created a directory to save temp file");
                }

                string[] columnIndex = new string[] { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" };

                using (SpreadsheetDocument spreadSheet = SpreadsheetDocument.Open(docName, true))
                {

                    for (int i = 0; i < columLength; i++)
                    {
                        AddUpdateCellValue(spreadSheet, "Leaves", 0, columnIndex[i], excelColumns[i], "", details.Count());
                    }

                    uint rowIndex = 1;

                    foreach (var detail in details)
                    {
                        var date = detail.Date.ToString() != null ? ConvertNumbertoMonth(detail.Date.Value.Month) + "-" + ConvertDate(detail.Date.Value.Day) + "-" + detail.Date.Value.Year : null;
                        var inTime = detail.InTime != null ? ConvertDateTimeToTime(detail.InTime.Value.DateTime, getTimeSheetDetails.TimeZone) + " " + detail.InTimeAbbreviation : null;
                        var outTime = detail.OutTime != null ? ConvertDateTimeToTime(detail.OutTime.Value.DateTime, getTimeSheetDetails.TimeZone) + " " + detail.OutTimeAbbreviation : null;
                        var lunchTime = (detail.LunchBreakStartTime != null && detail.LunchBreakEndTime != null) ?
                                 ConvertDateTimeToTime(detail.LunchBreakStartTime.Value.DateTime, getTimeSheetDetails.TimeZone) + " " + detail.LunchStartAbbreviation + " - "
                                 + ConvertDateTimeToTime(detail.LunchBreakEndTime.Value.DateTime, getTimeSheetDetails.TimeZone) + " " + detail.LunchEndAbbreviation + " (" + detail.LunchBreakDiff + ")" :
                                 (detail.LunchBreakStartTime != null) ? ConvertDateTimeToTime(detail.LunchBreakStartTime.Value.DateTime, getTimeSheetDetails.TimeZone) + " " + detail.LunchStartAbbreviation + " - " : null;
                        var userBreak = detail.UsersBreakTime != null ? detail.UsersBreakTime + " (" + detail.UserBreaksCount + ")" : null;
                        var leave = (detail.LeaveTypeName != null || detail.LeaveReason != null || detail.LeaveSessionName != null) ? "Yes" : null;
                        var leaveType = detail.LeaveTypeName;
                        var leaveSession = (detail.LeaveSessionName != null) ? detail.LeaveSessionName : null;
                        var spentTime = detail.SpentTimeDiff != null ? detail.SpentTimeDiff : null;
                        AddUpdateCellValue(spreadSheet, "Leaves", rowIndex, "A", detail.EmployeeName, detail.LeaveStatusColor, details.Count());
                        AddUpdateCellValue(spreadSheet, "Leaves", rowIndex, "B", date.ToString(), detail.LeaveStatusColor, details.Count());
                        AddUpdateCellValue(spreadSheet, "Leaves", rowIndex, "C", inTime, detail.LeaveStatusColor, details.Count());
                        AddUpdateCellValue(spreadSheet, "Leaves", rowIndex, "D", outTime, detail.LeaveStatusColor, details.Count());
                        AddUpdateCellValue(spreadSheet, "Leaves", rowIndex, "E", lunchTime, detail.LeaveStatusColor, details.Count());
                        AddUpdateCellValue(spreadSheet, "Leaves", rowIndex, "F", userBreak, detail.LeaveStatusColor, details.Count());
                        AddUpdateCellValue(spreadSheet, "Leaves", rowIndex, "G", spentTime, detail.LeaveStatusColor, details.Count());
                        AddUpdateCellValue(spreadSheet, "Leaves", rowIndex, "H", ConvertedTime(detail.ActiveTimeInMin), detail.LeaveStatusColor, details.Count());
                        AddUpdateCellValue(spreadSheet, "Leaves", rowIndex, "I", ConvertedTime(detail.TotalIdleTime), detail.LeaveStatusColor, details.Count());
                        AddUpdateCellValue(spreadSheet, "Leaves", rowIndex, "J", ConvertedTime(detail.ProductiveTimeInMin), detail.LeaveStatusColor, details.Count());
                        AddUpdateCellValue(spreadSheet, "Leaves", rowIndex, "K", detail.Screenshots, detail.LeaveStatusColor, details.Count());
                        AddUpdateCellValue(spreadSheet, "Leaves", rowIndex, "L", ConvertedTime(detail.LoggedTime), detail.LeaveStatusColor, details.Count());
                        AddUpdateCellValue(spreadSheet, "Leaves", rowIndex, "M", leaveType, detail.LeaveStatusColor, details.Count());
                        AddUpdateCellValue(spreadSheet, "Leaves", rowIndex, "N", leaveSession, detail.LeaveStatusColor, details.Count());
                        AddUpdateCellValue(spreadSheet, "Leaves", rowIndex, "O", detail.StatusName, detail.StatusColour, details.Count());
                        rowIndex++;
                    }

                    spreadSheet.Close();

                    var inputBytes = System.IO.File.ReadAllBytes(docName);

                    var blobUrl = _fileStoreService.PostFile(new FilePostInputModel
                    {
                        MemoryStream = System.IO.File.ReadAllBytes(docName),
                        FileName = "Timesheet-" + DateTime.Now.ToString("yyyy-MM-dd") + ".xlsx",
                        ContentType = "application/xlsx",
                        LoggedInUserId = loggedInContext.LoggedInUserId
                    });

                    pdfOutputModel = new PdfGenerationOutputModel()
                    {
                        ByteStream = System.IO.File.ReadAllBytes(docName),
                        BlobUrl = blobUrl,
                        FileName = "Timesheet-" + DateTime.Now.ToString("yyyy-MM-dd") + ".xlsx",
                    };

                }

                if (Directory.Exists(destinationPath))
                {
                    System.IO.File.Delete(docName);
                    Directory.Delete(destinationPath);

                    LoggingManager.Info("Deleting the temp folder");
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "DownloadUserstories", "UserStoryApiController"));
                return pdfOutputModel;
            }
            else if (path1 != null && getTimeSheetDetails.UserId != null)
            {
                getTimeSheetDetails.ExcelColumnList = new List<WorkReportExcelInputModel>
{
     new WorkReportExcelInputModel { ExcelColumn = "Employee name", ExcelField = "Employee name" },
    new WorkReportExcelInputModel { ExcelColumn = "Date", ExcelField = "Date" },
    new WorkReportExcelInputModel { ExcelColumn = "Start time", ExcelField = "Start time" },
    new WorkReportExcelInputModel { ExcelColumn = "Finish time", ExcelField = "Finish time" },
    new WorkReportExcelInputModel { ExcelColumn = "Punch card lunch", ExcelField = "Punch card lunch" },
    new WorkReportExcelInputModel { ExcelColumn = "Punch card breaks", ExcelField = "Punch card breaks" },
    new WorkReportExcelInputModel { ExcelColumn = "Total time", ExcelField = "Total time" },
    new WorkReportExcelInputModel { ExcelColumn = " System usage time", ExcelField = " System usage time" },
    new WorkReportExcelInputModel { ExcelColumn = "System idle time", ExcelField = "System idle time" },
    new WorkReportExcelInputModel { ExcelColumn = "System productive time", ExcelField = "System productive time" },
    new WorkReportExcelInputModel { ExcelColumn = "No of screenshots", ExcelField = "No of screenshots" },
    new WorkReportExcelInputModel { ExcelColumn = "Time spent on work items", ExcelField = "Time spent on work items" },
    new WorkReportExcelInputModel { ExcelColumn = "Leave type", ExcelField = "Leave type" },
    new WorkReportExcelInputModel { ExcelColumn = "Leave session", ExcelField = "Leave session" },
    new WorkReportExcelInputModel { ExcelColumn = "Submission status", ExcelField = "Submission status" }

};

                foreach (var value in getTimeSheetDetails.ExcelColumnList)
                {
                    excelColumns.Add(value.ExcelColumn);
                    excelFields.Add(value.ExcelField);
                }
                var columLength = excelColumns.Count();
                var pdfOutputModel = new PdfGenerationOutputModel();
                var destinationPath = Path.Combine(path1, guid.ToString());
                string docName = Path.Combine(destinationPath, "TimesheetDownload.xlsx");
                if (!Directory.Exists(destinationPath))
                {
                    Directory.CreateDirectory(destinationPath);

                    if (path != null)
                    {
                        System.IO.File.Copy(path, docName, true);
                    }

                    LoggingManager.Info("Created a directory to save temp file");
                }

                string[] columnIndex = new string[] { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" };

                using (SpreadsheetDocument spreadSheet = SpreadsheetDocument.Open(docName, true))
                {

                    for (int i = 0; i < columLength; i++)
                    {
                        AddUpdateCellValue(spreadSheet, "Leaves", 0, columnIndex[i], excelColumns[i], "", details.Count);
                    }

                    uint rowIndex = 1;

                    foreach (var detail in details)
                    {
                        var date = detail.Date.ToString() != null ? ConvertNumbertoMonth(detail.Date.Value.Month) + "-" + ConvertDate(detail.Date.Value.Day) + "-" + detail.Date.Value.Year : null;
                        var inTime = detail.InTime != null ? ConvertDateTimeToTime(detail.InTime.Value.DateTime, getTimeSheetDetails.TimeZone) + " " + detail.InTimeAbbreviation : null;
                        var outTime = detail.OutTime != null ? ConvertDateTimeToTime(detail.OutTime.Value.DateTime, getTimeSheetDetails.TimeZone) + " " + detail.OutTimeAbbreviation : null;
                        var lunchTime = (detail.LunchBreakStartTime != null && detail.LunchBreakEndTime != null) ?
                                 ConvertDateTimeToTime(detail.LunchBreakStartTime.Value.DateTime, getTimeSheetDetails.TimeZone) + " " + detail.LunchStartAbbreviation + " - "
                                 + ConvertDateTimeToTime(detail.LunchBreakEndTime.Value.DateTime, getTimeSheetDetails.TimeZone) + " " + detail.LunchEndAbbreviation + " (" + detail.LunchBreakDiff + ")" :
                                 (detail.LunchBreakStartTime != null) ? ConvertDateTimeToTime(detail.LunchBreakStartTime.Value.DateTime, getTimeSheetDetails.TimeZone) + " " + detail.LunchStartAbbreviation + " - " : null;
                        var userBreak = detail.UsersBreakTime != null ? detail.UsersBreakTime + " (" + detail.UserBreaksCount + ")" : null;
                        var leave = (detail.LeaveTypeName != null || detail.LeaveReason != null || detail.LeaveSessionName != null) ? "Yes" : null;
                        var leaveType = (detail.LeaveTypeName != null || detail.LeaveReason != null || detail.LeaveSessionName != null) ? detail.LeaveTypeName == null ? detail.LeaveTypeName : detail.LeaveReason : null;
                        var leaveSession = (detail.LeaveSessionName != null) ? detail.LeaveSessionName : null;
                        var spentTime = detail.SpentTimeDiff != null ? detail.SpentTimeDiff : null;
                        AddUpdateCellValue(spreadSheet, "Leaves", rowIndex, "A", detail.EmployeeName, detail.LeaveStatusColor, details.Count);
                        AddUpdateCellValue(spreadSheet, "Leaves", rowIndex, "B", date.ToString(), detail.LeaveStatusColor, details.Count);
                        AddUpdateCellValue(spreadSheet, "Leaves", rowIndex, "C", inTime, detail.LeaveStatusColor, details.Count);
                        AddUpdateCellValue(spreadSheet, "Leaves", rowIndex, "D", outTime, detail.LeaveStatusColor, details.Count);
                        AddUpdateCellValue(spreadSheet, "Leaves", rowIndex, "E", lunchTime, detail.LeaveStatusColor, details.Count);
                        AddUpdateCellValue(spreadSheet, "Leaves", rowIndex, "F", userBreak, detail.LeaveStatusColor, details.Count);
                        AddUpdateCellValue(spreadSheet, "Leaves", rowIndex, "G", spentTime, detail.LeaveStatusColor, details.Count);
                        AddUpdateCellValue(spreadSheet, "Leaves", rowIndex, "H", ConvertedTime(detail.ActiveTimeInMin), detail.LeaveStatusColor, details.Count);
                        AddUpdateCellValue(spreadSheet, "Leaves", rowIndex, "I", ConvertedTime(detail.TotalIdleTime), detail.LeaveStatusColor, details.Count);
                        AddUpdateCellValue(spreadSheet, "Leaves", rowIndex, "J", ConvertedTime(detail.ProductiveTimeInMin), detail.LeaveStatusColor, details.Count);
                        AddUpdateCellValue(spreadSheet, "Leaves", rowIndex, "K", detail.Screenshots, detail.LeaveStatusColor, details.Count);
                        AddUpdateCellValue(spreadSheet, "Leaves", rowIndex, "L", ConvertedTime(detail.LoggedTime), detail.LeaveStatusColor, details.Count);
                        AddUpdateCellValue(spreadSheet, "Leaves", rowIndex, "M", leaveType, detail.LeaveStatusColor, details.Count);
                        AddUpdateCellValue(spreadSheet, "Leaves", rowIndex, "N", leaveSession, detail.LeaveStatusColor, details.Count);
                        AddUpdateCellValue(spreadSheet, "Leaves", rowIndex, "O", detail.StatusName, detail.StatusColour, details.Count());
                        rowIndex++;
                    }

                    spreadSheet.Close();

                    var inputBytes = System.IO.File.ReadAllBytes(docName);
                    var UserDetails = _userService.GetUserById(getTimeSheetDetails.UserId, true, loggedInContext, validationMessages);

                    var blobUrl = _fileStoreService.PostFile(new FilePostInputModel
                    {
                        MemoryStream = System.IO.File.ReadAllBytes(docName),
                        FileName = UserDetails.FullName + "'s Monthly Timesheet-" + DateTime.Now.ToString("yyyy-MM-dd") + ".xlsx",
                        ContentType = "application/xlsx",
                        LoggedInUserId = loggedInContext.LoggedInUserId
                    });

                    pdfOutputModel = new PdfGenerationOutputModel()
                    {
                        ByteStream = System.IO.File.ReadAllBytes(docName),
                        BlobUrl = blobUrl,
                        FileName = UserDetails.FullName + "'s Monthly Timesheet-" + DateTime.Now.ToString("yyyy-MM-dd") + ".xlsx",
                    };

                }

                if (Directory.Exists(destinationPath))
                {
                    System.IO.File.Delete(docName);
                    Directory.Delete(destinationPath);

                    LoggingManager.Info("Deleting the temp folder");
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "DownloadUserstories", "UserStoryApiController"));
                return pdfOutputModel;
            }
            return null;
        }


        private static CellFormat GetCellFormat(WorkbookPart workbookPart, uint styleIndex)
        {
            return workbookPart.WorkbookStylesPart.Stylesheet.Elements<CellFormats>().First().Elements<CellFormat>().ElementAt((int)styleIndex);
        }

        private static uint InsertFont(WorkbookPart workbookPart, Font font)
        {
            Fonts fonts = workbookPart.WorkbookStylesPart.Stylesheet.Elements<Fonts>().First();
            // ReSharper disable once PossiblyMistakenUseOfParamsMethod
            if (font != null) fonts.Append(font);
            return fonts.Count++;
        }

        private static Font GenerateFont(int fontSize = 11, Color color = null)
        {
            var font = new Font(new FontSize { Val = fontSize }, new Bold(), color);
            if (color != null)
                font.Color = color;
            return font;
        }

        private static uint InsertFill(WorkbookPart workbookPart, string ColorIndex)
        {
            Fill fill3 = new Fill();
            PatternFill patternFill3 = new PatternFill() { PatternType = PatternValues.Solid };
            ForegroundColor foregroundColor1 = new ForegroundColor() { Rgb = ColorIndex };
            BackgroundColor backgroundColor1 = new BackgroundColor() { Indexed = (UInt32Value)64U };
            patternFill3.Append(foregroundColor1);
            patternFill3.Append(backgroundColor1);
            fill3.Append(patternFill3);
            Fills fills = workbookPart.WorkbookStylesPart.Stylesheet.Elements<Fills>().First();
            fills.Append(fill3);
            return fills.Count++;
        }

        private static uint SetBorderStyle(WorkbookPart workbookPart, BorderStyleValues leftBorder, HexBinaryValue leftBorderColor, BorderStyleValues rightBorder, HexBinaryValue RightBorderColor,
              BorderStyleValues topBorder, HexBinaryValue topBorderColor, BorderStyleValues bottomBorder, HexBinaryValue bottomBorderColor)
        {
            Border border2 = new Border();
            HexBinaryValue borderColor = border;

            LeftBorder leftBorder2 = new LeftBorder() { Style = leftBorder };
            Color color1 = new Color() { Rgb = leftBorderColor };
            leftBorder2.Append(color1);

            RightBorder rightBorder2 = new RightBorder() { Style = rightBorder };
            Color color2 = new Color() { Rgb = RightBorderColor };
            rightBorder2.Append(color2);

            TopBorder topBorder2 = new TopBorder() { Style = topBorder };
            Color color3 = new Color() { Rgb = topBorderColor };
            topBorder2.Append(color3);

            BottomBorder bottomBorder2 = new BottomBorder() { Style = bottomBorder };
            Color color4 = new Color() { Rgb = bottomBorderColor };
            bottomBorder2.Append(color4);

            border2.Append(leftBorder2);
            border2.Append(rightBorder2);
            border2.Append(topBorder2);
            border2.Append(bottomBorder2);


            Borders boarders = workbookPart.WorkbookStylesPart.Stylesheet.Elements<Borders>().First();
            boarders.Append(border2);

            return boarders.Count++;
        }

        private static uint InsertCellFormat(WorkbookPart workbookPart, CellFormat cellFormat)
        {
            CellFormats cellFormats = workbookPart.WorkbookStylesPart.Stylesheet.Elements<CellFormats>().First();
            // ReSharper disable once PossiblyMistakenUseOfParamsMethod
            if (cellFormat != null) cellFormats.Append(cellFormat);
            return cellFormats.Count++;
        }

        //retrieve sheetpart            
        private WorksheetPart RetrieveSheetPartByName(SpreadsheetDocument document, string sheetName)
        {
            IEnumerable<Sheet> sheets =
             document.WorkbookPart.Workbook.GetFirstChild<Sheets>().
            Elements<Sheet>().Where(s => s.Name == sheetName);
            if (sheets.Count() == 0)
            {
                return null;
            }

            string relationshipId = sheets.First().Id.Value;
            WorksheetPart worksheetPart = (WorksheetPart)
            document.WorkbookPart.GetPartById(relationshipId);
            return worksheetPart;
        }

        //insert cell in sheet based on column and row index            
        private Cell InsertCellInSheet(string columnName, uint rowIndex, WorksheetPart worksheetPart)
        {
            Worksheet worksheet = worksheetPart.Worksheet;
            SheetData sheetData = worksheet.GetFirstChild<SheetData>();
            string cellReference = columnName + rowIndex;
            Row row;
            //check whether row exist or not            
            //if row exist            
            if (sheetData.Elements<Row>().Where(r => r.RowIndex == rowIndex).Count() != 0)
            {
                row = sheetData.Elements<Row>().Where(r => r.RowIndex == rowIndex).First();
            }
            //if row does not exist then it will create new row            
            else
            {
                row = new Row()
                {
                    RowIndex = rowIndex
                };
                sheetData.Append(row);
            }
            //check whether cell exist or not            
            //if cell exist            
            if (row.Elements<Cell>().Where(c => c.CellReference.Value == columnName + rowIndex).Count() > 0)
            {
                return row.Elements<Cell>().Where(c => c.CellReference.Value == cellReference).First();
            }
            //if cell does not exist            
            else
            {
                Cell refCell = null;
                foreach (Cell cell in row.Elements<Cell>())
                {
                    if (string.Compare(cell.CellReference.Value, cellReference, true) > 0)
                    {
                        refCell = cell;
                        break;
                    }
                }
                Cell newCell = new Cell()
                {
                    CellReference = cellReference
                };
                row.InsertBefore(newCell, refCell);
                worksheet.Save();
                return newCell;
            }
        }

        private void AddUpdateCellValue(SpreadsheetDocument spreadSheet, string sheetname, uint rowIndex, string columnName, string text, string ColorIndex, int count)
        {
            // Opening document for editing
            WorksheetPart worksheetPart =
             RetrieveSheetPartByName(spreadSheet, sheetname);
            if (worksheetPart != null)
            {
                Cell cell = InsertCellInSheet(columnName, (rowIndex + 1), worksheetPart);
                cell.CellValue = new CellValue(text);

                if (rowIndex == 0)
                {
                    CellFormat cellFormat = cell.StyleIndex != null ? GetCellFormat(spreadSheet.WorkbookPart, cell.StyleIndex).CloneNode(true) as CellFormat : new CellFormat();
                    cellFormat.FontId = InsertFont(spreadSheet.WorkbookPart, GenerateFont(11));

                    if (columnName == "A")
                    {
                        cellFormat.BorderId = SetBorderStyle(spreadSheet.WorkbookPart, BorderStyleValues.Thin, insideBorder, BorderStyleValues.Thin, insideBorder, BorderStyleValues.Thick, border, BorderStyleValues.Thin, insideBorder);
                        cellFormat.ApplyBorder = true;
                    }
                    else if (columnName == "O")
                    {
                        cellFormat.BorderId = SetBorderStyle(spreadSheet.WorkbookPart, BorderStyleValues.Thin, insideBorder, BorderStyleValues.Thick, border, BorderStyleValues.Thick, border, BorderStyleValues.Thin, insideBorder);
                        cellFormat.ApplyBorder = true;
                    }
                    else
                    {
                        cellFormat.BorderId = SetBorderStyle(spreadSheet.WorkbookPart, BorderStyleValues.Thin, insideBorder, BorderStyleValues.Thin, insideBorder, BorderStyleValues.Thick, border, BorderStyleValues.Thin, insideBorder);
                        cellFormat.ApplyBorder = true;
                    }
                    cell.StyleIndex = InsertCellFormat(spreadSheet.WorkbookPart, cellFormat);
                }
                //last row
                else if (rowIndex == count)
                {
                    CellFormat cellFormat = cell.StyleIndex != null ? GetCellFormat(spreadSheet.WorkbookPart, cell.StyleIndex).CloneNode(true) as CellFormat : new CellFormat();

                    if (ColorIndex != null)
                    {
                        cellFormat.FillId = InsertFill(spreadSheet.WorkbookPart, ColorIndex.Replace('#', ' '));
                        cellFormat.ApplyFill = true;
                    }
                    if (columnName == "A")
                    {
                        cellFormat.BorderId = SetBorderStyle(spreadSheet.WorkbookPart, BorderStyleValues.Thick, border, BorderStyleValues.Thin, insideBorder, BorderStyleValues.Thin, insideBorder, BorderStyleValues.Thick, border);
                        cellFormat.ApplyBorder = true;
                    }
                    else if (columnName == "O")
                    {
                        cellFormat.BorderId = SetBorderStyle(spreadSheet.WorkbookPart, BorderStyleValues.Thin, insideBorder, BorderStyleValues.Thick, border, BorderStyleValues.Thin, insideBorder, BorderStyleValues.Thick, border);
                        cellFormat.ApplyBorder = true;
                    }
                    else
                    {
                        cellFormat.BorderId = SetBorderStyle(spreadSheet.WorkbookPart, BorderStyleValues.Thin, insideBorder, BorderStyleValues.Thin, insideBorder, BorderStyleValues.Thin, insideBorder, BorderStyleValues.Thick, border);
                        cellFormat.ApplyBorder = true;
                    }

                    cell.StyleIndex = InsertCellFormat(spreadSheet.WorkbookPart, cellFormat);
                }
                else if (rowIndex > 0)
                {
                    CellFormat cellFormat = cell.StyleIndex != null ? GetCellFormat(spreadSheet.WorkbookPart, cell.StyleIndex).CloneNode(true) as CellFormat : new CellFormat();

                    if (ColorIndex != null)
                    {
                        cellFormat.FillId = InsertFill(spreadSheet.WorkbookPart, ColorIndex.Replace('#', ' '));
                        cellFormat.ApplyFill = true;
                    }

                    if (columnName == "A")
                    {
                        cellFormat.BorderId = SetBorderStyle(spreadSheet.WorkbookPart, BorderStyleValues.Thick, border, BorderStyleValues.Thin, insideBorder, BorderStyleValues.Thin, insideBorder, BorderStyleValues.Thin, insideBorder);
                        cellFormat.ApplyBorder = true;
                    }
                    else if (columnName == "O")
                    {
                        cellFormat.BorderId = SetBorderStyle(spreadSheet.WorkbookPart, BorderStyleValues.Thin, insideBorder, BorderStyleValues.Thick, border, BorderStyleValues.Thin, insideBorder, BorderStyleValues.Thin, insideBorder);
                        cellFormat.ApplyBorder = true;
                    }
                    else
                    {
                        cellFormat.BorderId = SetBorderStyle(spreadSheet.WorkbookPart, BorderStyleValues.Thin, insideBorder, BorderStyleValues.Thin, insideBorder, BorderStyleValues.Thin, insideBorder, BorderStyleValues.Thin, insideBorder);
                        cellFormat.ApplyBorder = true;
                    }
                    cell.StyleIndex = InsertCellFormat(spreadSheet.WorkbookPart, cellFormat);
                }

                //cell datatype     
                cell.DataType = new EnumValue<CellValues>(CellValues.String);

                // Save the worksheet.            
                worksheetPart.Worksheet.Save();
            }
        }
        private string DataTableToCSV(DataTable dt)
        {
            StringBuilder sb = new StringBuilder();

            // Create the header row
            for (int i = 0; i <= dt.Columns.Count - 1; i++)
            {
                // Append column name in quotes
                sb.Append("\"" + dt.Columns[i].ColumnName + "\"");
                // Add carriage return and linefeed if last column, else add comma
                sb.Append(i == dt.Columns.Count - 1 ? "\n" : ",");
            }
            foreach (DataRow row in dt.Rows)
            {
                for (int i = 0; i <= dt.Columns.Count - 1; i++)
                {
                    // Append value in quotes
                    //sb.Append("""" & row.Item(i) & """")

                    // OR only quote items that that are equivilant to strings
                    sb.Append(object.ReferenceEquals(dt.Columns[i].DataType, typeof(string)) || object.ReferenceEquals(dt.Columns[i].DataType, typeof(char)) ? "\"" + row[i] + "\"" : row[i]);

                    // Append CR+LF if last field, else add Comma
                    sb.Append(i == dt.Columns.Count - 1 ? "\n" : ",");
                }
            }
            return sb.ToString();
        }

        private string ConvertDateTimeToTime(DateTime? dateTime, int timeZone)
        {
            var date = dateTime; //- TimeSpan.FromMinutes(timeZone);
            string hour = date?.Hour > 9 ? date?.Hour + "" : 0 + "" + date?.Hour;
            var minute = date?.Minute > 9 ? date?.Minute + "" : 0 + "" + date?.Minute;
            string time = hour + ":" + minute;
            return time;
        }

        private string ConvertNumbertoMonth(int n)
        {
            if (n == 1)
                return "Jan";
            if (n == 2)
                return "Feb";
            if (n == 3)
                return "Mar";
            if (n == 4)
                return "Apr";
            if (n == 5)
                return "May";
            if (n == 6)
                return "Jun";
            if (n == 7)
                return "Jul";
            if (n == 8)
                return "Aug";
            if (n == 9)
                return "Sep";
            if (n == 10)
                return "Oct";
            if (n == 11)
                return "Nov";
            if (n == 12)
                return "Dec";
            return String.Empty;
        }

        private string ConvertedTime(string time)
        {
            int value = Int16.Parse(time);
            if (value == 0)
            {
                return "";
            }
            else
            {
                Decimal hrs = value / 60;
                var totalTimeHours = Math.Floor(hrs);

                var totalTimeMinutes = (value % 60);
                if (totalTimeHours == 0)
                {
                    return totalTimeMinutes + "m";
                }
                return totalTimeHours + "h " + totalTimeMinutes + "m";
            }
        }

        private string ConvertDate(int day)
        {
            var day1 = day > 9 ? day + "" : 0 + "" + day;
            return day1;
        }

        private void AddUpdateCellValue(SpreadsheetDocument spreadSheet, string sheetname, uint rowIndex, string columnName, string text)
        {
            // Opening document for editing            
            WorksheetPart worksheetPart =
             RetrieveSheetPartByName(spreadSheet, sheetname);
            if (worksheetPart != null)
            {
                Cell cell = InsertCellInSheet(columnName, (rowIndex + 1), worksheetPart);
                cell.CellValue = new CellValue(text);
                //cell datatype     
                cell.DataType = new EnumValue<CellValues>(CellValues.String);
                // Save the worksheet.            
                worksheetPart.Worksheet.Save();
            }
        }

        public Guid? UpsertUserBreakDetails(UserBreakDetailsInputModel userBreakModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertTimeSheet", "timeSheetModel", userBreakModel, "TimeSheet Service"));
            AuditService auditService = new AuditService();

            if (userBreakModel.DateFrom != null)
            {
                userBreakModel.DateFromOffset = DateTimeOffset.ParseExact(userBreakModel.DateFrom.Value.ToString("yyyy-MM-dd'T'HH:mm:ss") + userBreakModel.TimeZoneOffset.Substring(0, 3) + ":" + userBreakModel.TimeZoneOffset.Substring(3, 2),
                                               "yyyy-MM-dd'T'HH:mm:sszzz",
                                               CultureInfo.InvariantCulture);
            }
            if (userBreakModel.DateTo != null)
            {
                userBreakModel.DateToOffset = DateTimeOffset.ParseExact(userBreakModel.DateTo.Value.ToString("yyyy-MM-dd'T'HH:mm:ss") + userBreakModel.TimeZoneOffset.Substring(0, 3) + ":" + userBreakModel.TimeZoneOffset.Substring(3, 2),
                                               "yyyy-MM-dd'T'HH:mm:sszzz",
                                               CultureInfo.InvariantCulture);
            }

            userBreakModel.BreakId = _timeSheetRepository.UpsertUserBreakDetails(userBreakModel, loggedInContext, validationMessages);
            LoggingManager.Debug("Updated timeSheet with the id " + userBreakModel.BreakId);
            auditService.SaveAudit(AppCommandConstants.UpsertTimeSheetCommandId, userBreakModel, loggedInContext);
            return userBreakModel.BreakId;
        }

        public List<UserBreakDetailsOutputModel> GetUserBreakDetails(GetUserBreakDetailsInputModel getUserBreakDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetUserBreakDeatils", "getUserBreakDetailsInputModel", getUserBreakDetailsInputModel, "TimeSheet Api"));
            AuditService auditService = new AuditService();
            auditService.SaveAudit(AppCommandConstants.GetTimeSheetDetailsCommandId, getUserBreakDetailsInputModel, loggedInContext);
            //CommonValidationHelper.CheckValidationForSearchCriteria(loggedInContext, getUserBreakDetailsInputModel, validationMessages);
            if (validationMessages.Count > 0)
            {
                return null;
            }
            List<UserBreakDetailsOutputModel> breakDetailsList = _timeSheetRepository.GetUserBreakDetails(getUserBreakDetailsInputModel, loggedInContext, validationMessages).ToList();

            return breakDetailsList;

        }

        public List<TimeSheetManagementApiOutputModel> GetTimeSheetHistoryDetails(TimeSheetManagementSearchInputModel timeSheetManagementSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetTimeSheetHistoryDetails", "timeSheetManagementSearchInputModel", timeSheetManagementSearchInputModel, "TimeSheet Api"));
            AuditService auditService = new AuditService();
            auditService.SaveAudit(AppCommandConstants.GetTimeSheetHistoryDetailsCommandId, timeSheetManagementSearchInputModel, loggedInContext);
            CommonValidationHelper.CheckValidationForSearchCriteria(loggedInContext, timeSheetManagementSearchInputModel, validationMessages);
            if (validationMessages.Count > 0)
            {
                return null;
            }

            List<TimeSheetManagementApiOutputModel> timeSheetDetailsList = _timeSheetRepository.GetTimeSheetHistoryDetails(timeSheetManagementSearchInputModel, loggedInContext, validationMessages).ToList();

            return timeSheetDetailsList;
        }

        public List<TimeSheetManagementPermissionOutputModel> GetTimeSheetPermissions(TimeSheetManagementPermissionInputModel timeSheetPermissionsModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetTimeSheetPermissions", "timeSheetPermissionsModel", timeSheetPermissionsModel, "TimeSheet Api"));
            AuditService auditService = new AuditService();
            auditService.SaveAudit(AppCommandConstants.GetTimeSheetPermissionsCommandId, timeSheetPermissionsModel, loggedInContext);
            CommonValidationHelper.CheckValidationForSearchCriteria(loggedInContext, timeSheetPermissionsModel, validationMessages);
            if (validationMessages.Count > 0)
            {
                return null;
            }

            List<TimeSheetManagementPermissionOutputModel> timeSheetPermissionsList = _timeSheetRepository.GetTimeSheetPermissions(timeSheetPermissionsModel, loggedInContext, validationMessages);

            return timeSheetPermissionsList;
        }

        public Guid? UpsertTimeSheetPermissions(TimeSheetManagementPermissionInputModel timeSheetPermissionsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetTimeSheetPermissions", "timeSheetPermissionsInputModel", timeSheetPermissionsInputModel, "TimeSheet Api"));
            TimeSheetValidationsHelper.CheckTimeSheetManagementPermissionModelValidationMessages(timeSheetPermissionsInputModel, loggedInContext, validationMessages);
            if (validationMessages.Count > 0)
            {
                return null;
            }

            timeSheetPermissionsInputModel.PermissionId =
                _timeSheetRepository.UpsertTimeSheetPermissions(timeSheetPermissionsInputModel,
                    loggedInContext, validationMessages);
            if (timeSheetPermissionsInputModel.PermissionId == Guid.Empty)
            {
                return null;
            }

            LoggingManager.Debug("New permission time sheet with the id " +
                                timeSheetPermissionsInputModel.PermissionId + " has been created.");
            AuditService auditService = new AuditService();
            auditService.SaveAudit(AppCommandConstants.UpsertTimeSheetPermissionsCommandId, timeSheetPermissionsInputModel, loggedInContext);
            return timeSheetPermissionsInputModel.PermissionId;
        }

        public List<TimeSheetPermissionReasonOutputModel> GetAllPermissionReasons(GetPermissionReasonModel getPermissionReasonModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug("Entered to GetAllPermissionReasons." + "Logged in User Id=" + loggedInContext);
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (validationMessages.Count > 0)
            {
                return null;
            }

            List<TimeSheetPermissionReasonOutputModel> permissionReasonList = _timeSheetRepository.GetAllPermissionReasons(getPermissionReasonModel, loggedInContext, validationMessages);
            return permissionReasonList;
        }

        public Guid? UpsertTimeSheetPermissionReasons(TimeSheetPermissionReasonInputModel timeSheetPermissionReasonInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertTimeSheetPermissionReasons", "timeSheetPermissionReasonInputModel", timeSheetPermissionReasonInputModel, "TimeSheet Api"));
            AuditService auditService = new AuditService();
            TimeSheetPermissionValidationHelpers.CheckPermissionReasonsValidationMessages(timeSheetPermissionReasonInputModel, loggedInContext, validationMessages);
            if (validationMessages.Count > 0)
            {
                return null;
            }

            timeSheetPermissionReasonInputModel.PermissionReasonId = _timeSheetRepository.UpsertTimeSheetPermissionReasons(timeSheetPermissionReasonInputModel, loggedInContext, validationMessages);
            if (timeSheetPermissionReasonInputModel.PermissionReasonId != Guid.Empty)
            {
                LoggingManager.Debug("New permission time sheet with the id " + timeSheetPermissionReasonInputModel.PermissionReasonId + " has been created.");
                auditService.SaveAudit(AppCommandConstants.UpsertTimeSheetPermissionReasonsCommandId, timeSheetPermissionReasonInputModel, loggedInContext);
                return timeSheetPermissionReasonInputModel.PermissionReasonId;
            }

            return null;
        }

        public bool? UpsertUserPunchCard(UpsertUserPunchCardInputModel upsertUserPunchCardInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertUserPunchCard", "upsertUserPunchCardInputModel", upsertUserPunchCardInputModel, "TimeSheet Service"));

            if (!TimeSheetValidationsHelper.CheckUpsertUserPunchCardValidationMessages(upsertUserPunchCardInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            if (upsertUserPunchCardInputModel.IsMobilePunchCard != true)
            {
                if (!CheckIpAddressExists(loggedInContext))
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.ExceptionValidateUserLocation
                    });
                    return null;
                }
            }

            if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                upsertUserPunchCardInputModel.ButtonClickedDate = userTimeDetails?.UserTimeOffset;
                upsertUserPunchCardInputModel.TimeZoneName = userTimeDetails?.TimeZone;
            }

            if (upsertUserPunchCardInputModel.ButtonClickedDate == null)
            {
                var indianTimeDetails = TimeZoneHelper.GetIstTime();
                upsertUserPunchCardInputModel.ButtonClickedDate = indianTimeDetails?.UserTimeOffset;
                upsertUserPunchCardInputModel.TimeZoneName = indianTimeDetails?.TimeZone;
            }

            bool? userPunchCard = _timeSheetRepository.UpsertUserPunchCard(upsertUserPunchCardInputModel, loggedInContext, validationMessages);
            AuditService auditService = new AuditService();

            auditService.SaveAudit(AppCommandConstants.UpsertUserPunchCardCommandId, upsertUserPunchCardInputModel, loggedInContext);

            return userPunchCard;
        }

        public bool? ValidateUserLocation(UserLocationInputModel userLocationInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "ValidateUserLocation", "userLocationInputModel", userLocationInputModel, "TimeSheet Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            bool? userLocation = _timeSheetRepository.ValidateUserLocation(userLocationInputModel, loggedInContext, validationMessages);
            AuditService auditService = new AuditService();
            auditService.SaveAudit(AppCommandConstants.ValidateUserLocationCommandId, userLocationInputModel,
                loggedInContext);

            LoggingManager.Debug(userLocation?.ToString());

            return userLocation;
        }

        public List<TimeFeedHistoryApiReturnModel> GetFeedTimeHistory(GetFeedTimeHistoryInputModel getFeedTimeHistoryInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetFeedTimeHistoryInputModel", "getFeedTimeHistoryInputModel", getFeedTimeHistoryInputModel, "Hr Management Service"));
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<TimeFeedHistoryApiReturnModel> feedTimeHistory = _timeSheetRepository.GetFeedTimeHistory(getFeedTimeHistoryInputModel, loggedInContext, validationMessages);

            LoggingManager.Debug("Feed Time History with the id " + getFeedTimeHistoryInputModel.OperationsPerformedBy);
            AuditService auditService = new AuditService();
            auditService.SaveAudit(AppCommandConstants.GetFeedTimeHistoryCommandId, getFeedTimeHistoryInputModel, loggedInContext);
            return feedTimeHistory;
        }

        public TimesheetDisableorEnableApiModel GetEnableorDisableTimesheetButtons(LoggedInContext loggedInContext)
        {
            if (!CheckIpAddressExists(loggedInContext))
            {
                LoggingManager.Warn($"Some one with IP address {loggedInContext.RequestedHostAddress} tried to access the BTrak.");

                return new TimesheetDisableorEnableApiModel { TimeSheetRestricted = true };
            }

            var indianTimeDetails = TimeZoneHelper.GetIstTime();
            DateTimeOffset? buttonClickedDate = indianTimeDetails?.UserTimeOffset;

            if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                buttonClickedDate = userTimeDetails?.UserTimeOffset;
            }

            TimesheetDisableorEnableEntity enableorDisableTimesheetButtons = _timeSheetRepository.GetEnableorDisableTimesheetButtons(loggedInContext.LoggedInUserId, buttonClickedDate);

            if (enableorDisableTimesheetButtons != null)
            {
                TimesheetDisableorEnableApiModel timesheetDetails = new TimesheetDisableorEnableApiModel
                {
                    //StartTime = enableorDisableTimesheetButtons.StartTime != null ? GetTimeInHoursandMinutes(enableorDisableTimesheetButtons.StartTime.Value.UtcDateTime, loggedInContext.LoggedInUserId) : null,
                    //LunchStartTime = enableorDisableTimesheetButtons.LunchStartTime != null ? GetTimeInHoursandMinutes(enableorDisableTimesheetButtons.LunchStartTime.Value.UtcDateTime, loggedInContext.LoggedInUserId) : null,
                    //LunchEndTime = enableorDisableTimesheetButtons.LunchEndTime != null ? GetTimeInHoursandMinutes(enableorDisableTimesheetButtons.LunchEndTime.Value.UtcDateTime, loggedInContext.LoggedInUserId) : null,
                    //FinishTime = enableorDisableTimesheetButtons.FinishTime != null ? GetTimeInHoursandMinutes(enableorDisableTimesheetButtons.FinishTime.Value.UtcDateTime, loggedInContext.LoggedInUserId) : null,
                    //BreakInTime = enableorDisableTimesheetButtons.BreakInTime != null ? GetTimeInHoursandMinutes(enableorDisableTimesheetButtons.BreakInTime.Value.UtcDateTime, loggedInContext.LoggedInUserId) : null,
                    //BreakOutTime = enableorDisableTimesheetButtons.BreakOutTime != null ? GetTimeInHoursandMinutes(enableorDisableTimesheetButtons.BreakOutTime.Value.UtcDateTime, loggedInContext.LoggedInUserId) : null,
                    StartTime = enableorDisableTimesheetButtons.StartTime,
                    LunchStartTime = enableorDisableTimesheetButtons.LunchStartTime,
                    LunchEndTime = enableorDisableTimesheetButtons.LunchEndTime,
                    FinishTime = enableorDisableTimesheetButtons.FinishTime,
                    BreakInTime = enableorDisableTimesheetButtons.BreakInTime,
                    BreakOutTime = enableorDisableTimesheetButtons.BreakOutTime,
                    BreakIn = enableorDisableTimesheetButtons.IsBreakIn,
                    BreakOut = enableorDisableTimesheetButtons.IsBreakOut,
                    Start = enableorDisableTimesheetButtons.IsStart,
                    Finish = enableorDisableTimesheetButtons.IsFinish,
                    LunchStart = enableorDisableTimesheetButtons.IsLunchStart,
                    LunchEnd = enableorDisableTimesheetButtons.IsLunchEnd,
                    SpentTime = enableorDisableTimesheetButtons.SpentTime,
                    StartTimeAbbr = enableorDisableTimesheetButtons.StartTimeAbbr,
                    StartTimeZoneName = enableorDisableTimesheetButtons.StartTimeZoneName,
                    LunchStartTimeAbbr = enableorDisableTimesheetButtons.LunchStartTimeAbbr,
                    LunchStartTimeZoneName = enableorDisableTimesheetButtons.LunchStartTimeZoneName,
                    LunchEndTimeAbbr = enableorDisableTimesheetButtons.LunchEndTimeAbbr,
                    LunchEndTimeZoneName = enableorDisableTimesheetButtons.LunchEndTimeZoneName,
                    BreakInTimeAbbr = enableorDisableTimesheetButtons.BreakInTimeAbbr,
                    BreakInTimeZoneName = enableorDisableTimesheetButtons.BreakInTimeZoneName,
                    BreakOutTimeAbbr = enableorDisableTimesheetButtons.BreakOutTimeAbbr,
                    BreakOutTimeZoneName = enableorDisableTimesheetButtons.BreakOutTimeZoneName,
                    FinishTimeAbbr = enableorDisableTimesheetButtons.FinishTimeAbbr,
                    FinishTimeZoneName = enableorDisableTimesheetButtons.FinishTimeZoneName
                };

                return timesheetDetails;
            }

            return null;
        }

        public DateTime? ConvertFromUtCtoLocal(DateTime? time, Guid? timeZoneId, string defaultTimeZone = null)
        {
            if (time != null)
            {
                string localTimeZone = _masterTableRepository.GetTimeZone(Guid.Parse(MasterDataTypeConstants.TimeZoneId), Guid.Parse(timeZoneId.ToString()));
                if (localTimeZone == null)
                {
                    return time;
                }

                var timeZoneList = TimeZoneInfo.GetSystemTimeZones();

                if (timeZoneList.Select(tz => tz.StandardName).Contains(localTimeZone))
                {
                    TimeZoneInfo timeZone = TimeZoneInfo.FindSystemTimeZoneById(defaultTimeZone == null ? localTimeZone : defaultTimeZone);
                    DateTime localTime = TimeZoneInfo.ConvertTimeFromUtc(Convert.ToDateTime(time), timeZone);
                    return localTime;
                }
            }
            return time;
        }

        public string GetTimeInHoursandMinutes(DateTime? time, Guid loggedUserId)
        {
            if (time != null)
            {
                Guid? timeZoneId;
                string defaultTimeZoneString;
                var userDetails = _userRepository.UserDetails(loggedUserId);
                if (userDetails?.TimeZoneId == null)
                {
                    timeZoneId = AppConstants.DefaultTimeZoneId;
                    defaultTimeZoneString = AppConstants.DefaultTimeZone;
                }
                else
                {
                    timeZoneId = userDetails.TimeZoneId;
                    defaultTimeZoneString = null;
                }

                DateTime? indianTime = ConvertFromUtCtoLocal(time, timeZoneId, defaultTimeZoneString);
                int? hours = indianTime?.TimeOfDay.Hours;
                int? minutes = indianTime?.TimeOfDay.Minutes;
                if (hours < 10 && minutes < 10)
                {
                    return "0" + hours + ":" + "0" + minutes;
                }
                if (hours < 10)
                {
                    return "0" + hours + ":" + minutes;
                }
                if (minutes < 10)
                {
                    return hours + ":" + "0" + minutes;
                }
                return hours + ":" + minutes;
            }
            return null;
        }

        public IList<AuditJsonModel> GetTimesheetHistoryDetails(Guid userId, DateTime dateFrom, DateTime dateTo)
        {
            IList<AuditJsonModel> timesheetHistory = new List<AuditJsonModel>();

            IList<TimesheetAuditModel> historyDetails = _auditRepository.GetAudit(userId, AppCommandConstants.GetTimeSheetHistoryDetailsCommandId, Guid.Empty, dateFrom, dateTo).Take(15).OrderByDescending(x => x.CreatedDateTime).ToList();

            foreach (TimesheetAuditModel historyDetail in historyDetails)
            {
                AuditJsonModel detail = new AuditJsonModel
                {
                    UserId = historyDetail.UserId,
                    FeatureId = historyDetail.FeatureId,
                    UserName = historyDetail.UserName,
                    Description = "<b>" + historyDetail.UserName + "</b>" + historyDetail.AuditDescription,
                    CreatedDateTime = historyDetail.CreatedDateTime.ToString("dd - MMM - yyyy HH:mm:ss")
                };
                timesheetHistory.Add(detail);
            }
            return timesheetHistory;
        }

        public bool CheckIpAddressExists(LoggedInContext loggedInContext)
        {
            string ipAddressVal = _timeSheetRepository.IsIpExisting(loggedInContext);
            if (!string.IsNullOrEmpty(ipAddressVal))
            {
                return true;
            }
            return false;
        }

        public string TimespantoString(TimeSpan? value)
        {
            if (value == null)
            {
                return null;
            }
            else
            {
                if (value.Value.Hours == 0)
                {
                    return value.Value.Minutes.ToString() + "min";
                }
                else if (value.Value.Minutes == 0)
                {
                    return value.Value.Hours.ToString() + "hr";

                }
                else
                {
                    return value.Value.Hours.ToString() + "hr : " + value.Value.Minutes.ToString() + "min";

                }
            }
        }

        public string GetProcessedMessage(LoggedInContext loggedInContext, DateTime? dateFrom, DateTime? dateTo)
        {
            var statuses = _timeSheetRepository.GetStatusReportOfAnEmployee(loggedInContext, dateFrom, dateTo);

            statuses = statuses.OrderByDescending(d => d.TodaySpentTimeInHours).Take(5).ToList();

            List<MessageAttachmentsModel> messageAttachmentsModels = new List<MessageAttachmentsModel>();

            var employeeDetail = statuses.FirstOrDefault();

            foreach (var status in statuses)
            {
                if (!string.IsNullOrEmpty(status.TaskName))
                {
                    List<FieldsToBeDisplayed> fieldsToBeDisplayedList = new List<FieldsToBeDisplayed>();
                    FieldsToBeDisplayed fieldsToBeDisplayed = new FieldsToBeDisplayed
                    {
                        title = status.StatusText,
                        value = status.Transition + "\nWork description : " + Regex.Replace(status.WorkDescription, "<.*?>", String.Empty) + "\nOriginal Estimate : " + status.OrginalEstimate + " | Spent so far : " + status.SpentSoFar + " | Spent today : " + status.SpentToday + " | Remaining : " + status.Remaining
                    };
                    fieldsToBeDisplayedList.Add(fieldsToBeDisplayed);

                    MessageAttachmentsModel messageAttachmentsModel = new MessageAttachmentsModel
                    {
                        color = string.IsNullOrEmpty(status.StatusColor) ? status.OverAllStatus : status.StatusColor,
                        title = status.GoalName + " - " + status.TaskType + " :- " + status.TaskName,
                        fields = fieldsToBeDisplayedList
                    };
                    messageAttachmentsModels.Add(messageAttachmentsModel);
                }
            }

            string processedText;

            if (employeeDetail?.RemainingHoursToBeLogged == "0.00h" || employeeDetail?.RemainingHoursToBeLogged.Trim() == "0h")
            {
                processedText = "Here is " + employeeDetail.EmployeeName +
                                "'s status report for the day. \n_Total of hours spent in office : " +
                                employeeDetail.TotalSpentHoursInOffice;
            }
            else
            {
                processedText = "Here is " + employeeDetail?.EmployeeName +
                                "'s status report for the day. \n_Total of hours spent in office : " +
                                employeeDetail?.TotalSpentHoursInOffice + ", `Remaining hours to be logged : " +
                                employeeDetail?.RemainingHoursToBeLogged + "`_";
            }

            PushMessageInputModel pushMessageInputModel = new PushMessageInputModel
            {
                text = processedText,
                attachments = messageAttachmentsModels
            };

            string message = new JavaScriptSerializer().Serialize(pushMessageInputModel);
            return message;
        }

        public List<PermissionRegisterReturnOutputModel> SearchPermissionRegister(PermissionRegisterSearchInputModel permissionRegisterSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "permissionRegisterSearchInputModel", "EmployeeId", permissionRegisterSearchInputModel.EmployeeId, "Time sheet Service"));
            List<PermissionRegisterReturnOutputModel> permissionRegisterReturnOutputModel = _timeSheetUploadRepository.SearchPermissionRegister(permissionRegisterSearchInputModel, loggedInContext, validationMessages).ToList();
            return permissionRegisterReturnOutputModel;
        }

        public LoggingComplainceOutputModel GetLoggingCompliance(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetProcessDashboardStatusById", "Time sheet Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            LoggingComplainceOutputModel loggingCompliance = _timeSheetRepository.GetLoggingCompliance(loggedInContext, validationMessages);
            LoggingManager.Debug("Get Logging Compliance" + loggedInContext.LoggedInUserId);

            return loggingCompliance;
        }

        public async Task PushMessageToSlack(LoggedInContext loggedInContext, string url)
        {
            var message = GetProcessedMessage(loggedInContext, DateTime.Today, DateTime.Now);

            HttpClient client = new HttpClient();
            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

            HttpRequestMessage request = new HttpRequestMessage(HttpMethod.Post, url)
            {
                Content = new StringContent(message, Encoding.UTF8, "application/json")
            };

            await client.SendAsync(request).ContinueWith(responseTask => { });
        }
        public async Task PushMessageToUserWebHook(LoggedInContext loggedInContext, string url)
        {
            try
            {
                LoggingManager.Debug("Entered into PushMessageToUserWebHook");

                var message = GetProcessedMessage(loggedInContext, DateTime.Today, DateTime.Now);

                if (url.Contains("Webhook?webhook"))
                {
                    WebHookInputModel webHookInputModel = new WebHookInputModel
                    {
                        WebUrl = url,
                        ReportMessage = message,
                        SenderId = loggedInContext.LoggedInUserId
                    };

                    using (var client = new HttpClient())
                    {
                        client.BaseAddress = new Uri(url.Substring(0, url.LastIndexOf('/') + 1));
                        client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                        var Content = new StringContent(JsonConvert.SerializeObject(webHookInputModel), Encoding.UTF8, "application/json");
                        var result = await client.PostAsync(RouteConstants.ChannelWebHook, Content);
                        string resultContent = await result.Content.ReadAsStringAsync();
                        Console.WriteLine(resultContent);
                    }
                }
                else
                {
                    HttpClient client = new HttpClient();
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

                    HttpRequestMessage request = new HttpRequestMessage(HttpMethod.Post, url)
                    {
                        Content = new StringContent(message, Encoding.UTF8, "application/json")
                    };

                    await client.SendAsync(request).ContinueWith(responseTask => { });
                }

                LoggingManager.Debug("Exit from PushMessageToUserWebHook");
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "PushMessageToUserWebHook", "TimeSheetService ", ex.Message), ex);

            }
        }

        public List<TimeSheetSubmissionFrequencyOutputModel> GetTimeSheetSubmissionTypes(string searchText, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetTimeSheetSubmissionTypes", "MasterDataManagement Service"));


            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<TimeSheetSubmissionFrequencyOutputModel> timeSheetSubmissionFrequencies = _timeSheetRepository.GetTimeSheetSubmissionTypes(searchText, loggedInContext, validationMessages).ToList();
            return timeSheetSubmissionFrequencies;
        }

        public Guid? UpsertTimeSheetSubmission(TimeSheetSubmissionUpsertInputModel timeSheetSubmissionUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertTimeSheetSubmission", "Master Data Management Service"));

            if (!MasterDataValidationHelper.UpsertTimeSheetSubmissionValidation(timeSheetSubmissionUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            timeSheetSubmissionUpsertInputModel.TimeSheetSubmissionId = _timeSheetRepository.UpsertTimeSheetSubmission(timeSheetSubmissionUpsertInputModel, loggedInContext, validationMessages);

            if (timeSheetSubmissionUpsertInputModel.TimeSheetSubmissionId != null)
            {
                JobInputModel GetJobModel = new JobInputModel();
                GetJobModel.IsForProbation = false;
                List<TimeSheetJobDetails> timeSheetJobDetails = _timeSheetRepository.GetTimeSheetJobDetails(GetJobModel, loggedInContext, validationMessages);

                if (timeSheetJobDetails.Count > 0)
                {
                    foreach (var timeSheetJob in timeSheetJobDetails)
                    {
                        RecurringJob.RemoveIfExists("Main-TimeSheet-Job" + timeSheetJob.JobId.ToString());
                        RecurringJob.RemoveIfExists(timeSheetJob.JobId.ToString());

                        JobInputModel jobInputModel = new JobInputModel();
                        jobInputModel.JobId = timeSheetJob.JobId.ToString();
                        jobInputModel.IsArchived = true;
                        jobInputModel.IsForProbation = false;

                        var archivedId = _timeSheetRepository.UpsertTimeSheetJobDetails(jobInputModel, loggedInContext, validationMessages);
                    }
                }

                var JobId = Guid.NewGuid();
                RecurringJob.AddOrUpdate("Main-TimeSheet-Job" + JobId.ToString(),
                () => RunMainTimeSheetJob(timeSheetSubmissionUpsertInputModel, loggedInContext, validationMessages),
                    "0 0 1/1 * *");

                JobInputModel jobModel = new JobInputModel();
                jobModel.JobId = "Main-TimeSheet-Job" + JobId.ToString();
                jobModel.IsArchived = false;
                jobModel.IsForProbation = false;
                var id = _timeSheetRepository.UpsertTimeSheetJobDetails(jobModel, loggedInContext, validationMessages);
            }

            return timeSheetSubmissionUpsertInputModel.TimeSheetSubmissionId;
        }

        public Guid? UpsertTimeSheetInterval(TimeSheetSubmissionUpsertInputModel timeSheetIntervalInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertTimeSheetInterval", "Master Data Management Service"));

            timeSheetIntervalInputModel.TimeSheetIntervalId = _timeSheetRepository.UpsertTimeSheetInterval(timeSheetIntervalInputModel, loggedInContext, validationMessages);

            return timeSheetIntervalInputModel.TimeSheetIntervalId;
        }

        public void RunMainTimeSheetJob(TimeSheetSubmissionUpsertInputModel timeSheetSubmissionUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            List<LineManagerOutputModel> lineManagerOutputModel = _timeSheetRepository.GetLineManagersWithTimeZones(loggedInContext, validationMessages);

            var DistinctItems = lineManagerOutputModel.GroupBy(x => x.TimeZoneId).Select(y => y.ToList()).ToList();

            var TodayDate = DateTime.Today;

            foreach (var distinctItem in DistinctItems)
            {
                DateTime exeDate = Convert.ToDateTime(TodayDate);
                TimeSpan ts = new TimeSpan(00, 00, 0);
                exeDate = exeDate + ts;
                int ustTime = -270;

                Guid? employeeId = Guid.Empty;
                foreach (var Employee in distinctItem)
                {
                    if (Employee.ReportingMembers != null)
                    {
                        employeeId = Employee.EmployeeId;
                    }
                }

                if (employeeId != Guid.Empty)
                {
                    int offSetMin = _userRepository.GetOffsetMinutes(employeeId);
                    if (offSetMin != 0)
                        exeDate = exeDate.AddMinutes(ustTime).AddMinutes(offSetMin);

                    var hour = exeDate.Hour;
                    var min = exeDate.Minute;

                    CronExpressionInputModel cronExpressionInputModel = new CronExpressionInputModel();
                    UpsertCronExpressionApiReturnModel upsertCronExpressionApiReturnModel = new UpsertCronExpressionApiReturnModel();
                    cronExpressionInputModel.IsForTimeSheet = true;
                    if (timeSheetSubmissionUpsertInputModel.TimeSheetFrequencyId.ToString().ToLower() == "5ba47e73-8fc7-43f3-8a6d-39628e93f847") //Daily
                    {
                        //"0 0 1/1 * ?"
                        //cronExpressionInputModel.CronExpression = min.ToString() + ' ' + hour.ToString() + ' ' + "1/1 * ?";
                        //upsertCronExpressionApiReturnModel = _widgetRepository.UpsertCronExpression(cronExpressionInputModel, loggedInContext, validationMessages);

                        //cronExpressionInputModel.CronExpression = cronExpressionInputModel.CronExpression.Replace('?', '*');

                        var jobId = BackgroundJob.Schedule(() => AutoSubmitTimeSheet(distinctItem, loggedInContext, validationMessages), exeDate);

                        JobInputModel jobInputModel = new JobInputModel();
                        jobInputModel.JobId = jobId;
                        jobInputModel.IsArchived = false;
                        jobInputModel.IsForProbation = false;

                        var id = _timeSheetRepository.UpsertTimeSheetJobDetails(jobInputModel, loggedInContext, validationMessages);

                        //RecurringJob.AddOrUpdate("Sub-timesheet-jobs" + upsertCronExpressionApiReturnModel.CronExpressionId.ToString(),
                        //() => AutoSubmitTimeSheet(distinctItem, loggedInContext, validationMessages),
                        //    cronExpressionInputModel.CronExpression);
                    }
                    else if (timeSheetSubmissionUpsertInputModel.TimeSheetFrequencyId.ToString() == "A5DFB2E2-5C92-4C36-871A-5AFF6DFDD736") //Weekly
                    {
                        //0 0 ? * SAT
                        //cronExpressionInputModel.CronExpression = min.ToString() + ' ' + hour.ToString() + ' ' + "? * SAT";
                        //upsertCronExpressionApiReturnModel = _widgetRepository.UpsertCronExpression(cronExpressionInputModel, loggedInContext, validationMessages);

                        //cronExpressionInputModel.CronExpression = cronExpressionInputModel.CronExpression.Replace('?', '*');

                        var jobId = BackgroundJob.Schedule(() => AutoSubmitWeekTimeSheet(timeSheetSubmissionUpsertInputModel, distinctItem, loggedInContext, validationMessages), exeDate);

                        JobInputModel jobInputModel = new JobInputModel();
                        jobInputModel.JobId = jobId;
                        jobInputModel.IsArchived = false;
                        jobInputModel.IsForProbation = false;

                        var id = _timeSheetRepository.UpsertTimeSheetJobDetails(jobInputModel, loggedInContext, validationMessages);

                        //RecurringJob.AddOrUpdate("Sub-timesheet-jobs" + upsertCronExpressionApiReturnModel.CronExpressionId.ToString(),
                        //() => AutoSubmitWeekTimeSheet(distinctItem, loggedInContext, validationMessages),
                        //    cronExpressionInputModel.CronExpression);
                    }
                }

            }
        }

        public void AutoSubmitWeekTimeSheet(TimeSheetSubmissionUpsertInputModel timeSheetSubmissionUpsertInputModel, List<LineManagerOutputModel> linemangers, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            var TodayDate = DateTime.Today;

            DateTime WeekStartDate = DateTime.Now.StartOfWeek(DayOfWeek.Monday);

            int[] weeks = { 0, 1, 2, 3, 4 };

            List<StatusOutputModel> statuses = _timeSheetRepository.GetStatus(loggedInContext, validationMessages).ToList();

            var StatusId = statuses.Find(x => x.StatusName == "Waiting for approval").StatusId;

            EmlpoyeeShiftWeekModel emlpoyeeShiftWeekModel = new EmlpoyeeShiftWeekModel
            {
                DateFrom = null,
                DateTo = null,
                StatusId = null
            };

            if (DateTime.Today.ToString("dddd") == "Saturday")
            {
                var now = DateTime.Now.AddDays(-1);
                List<EmlpoyeeShiftWeekOutputModel> weekDays = _timeSheetRepository.GetEmployeeShiftWeekDays(emlpoyeeShiftWeekModel, loggedInContext, validationMessages);

                List<EmlpoyeeShiftWeekOutputModel> timeSheets = new List<EmlpoyeeShiftWeekOutputModel>();

                timeSheets = (from x in weekDays where (TodayDate.AddDays(-1) <= x.Day?.Date && x.Day?.Date <= TodayDate.AddDays(-1)) select x).ToList();

                timeSheets.Reverse();

                TimeSheetSubmissionSearchInputModel timeSheetSubmissionSearchInputModel = new TimeSheetSubmissionSearchInputModel();
                timeSheetSubmissionSearchInputModel.IsIncludedPastData = true;

                List<TimeSheetSubmissionSearchOutputModel> timeSheetSubmissionFrequencies = _timeSheetRepository.GetTimeSheetSubmissions(timeSheetSubmissionSearchInputModel, loggedInContext, validationMessages).ToList();
                var TImeSheetSubmissionId = timeSheetSubmissionFrequencies.Find(x => x.Name == "Weekly").TimeSheetSubmissionId;

                foreach (var lineManager in linemangers)
                {
                    List<ReportingMembersDetailsModel> reportingMembers = new List<ReportingMembersDetailsModel>();
                    if (lineManager.ReportingMembers != null)
                    {
                        reportingMembers = JsonConvert.DeserializeObject<List<ReportingMembersDetailsModel>>(lineManager.ReportingMembers);
                    }

                    if (reportingMembers.Count > 0)
                    {
                        foreach (var reportingMemberId in reportingMembers)
                        {
                            foreach (var week in weeks)
                            {
                                TimeSheetManagementSearchInputModel timeSheetManagementSearchInputModel = new TimeSheetManagementSearchInputModel();
                                timeSheetManagementSearchInputModel.UserId = reportingMemberId.ChildId;
                                timeSheetManagementSearchInputModel.DateFrom = WeekStartDate.AddDays(week);
                                timeSheetManagementSearchInputModel.DateTo = WeekStartDate.AddDays(week);
                                timeSheetManagementSearchInputModel.IncludeEmptyRecords = true;
                                List<TimeSheetManagementApiOutputModel> timeSheetDetailsList = _timeSheetRepository.GetTimeSheetDetails(timeSheetManagementSearchInputModel, loggedInContext, validationMessages).ToList();

                                if (timeSheetDetailsList.Count > 0 && timeSheetDetailsList[0].InTime != null && timeSheetDetailsList[0].OutTime != null)
                                {
                                    EmployeeTimeSheetPunchCardUpsertInputModel employeeTimeSheetPunchCardUpsertInputModel = new EmployeeTimeSheetPunchCardUpsertInputModel();
                                    employeeTimeSheetPunchCardUpsertInputModel.StartTime = timeSheetDetailsList[0].InTime.Value.DateTime;
                                    employeeTimeSheetPunchCardUpsertInputModel.EndTime = timeSheetDetailsList[0].OutTime.Value.DateTime;
                                    employeeTimeSheetPunchCardUpsertInputModel.Breakmins = timeSheetDetailsList[0].BreakInMin;
                                    employeeTimeSheetPunchCardUpsertInputModel.Date = WeekStartDate.AddDays(week);
                                    employeeTimeSheetPunchCardUpsertInputModel.StatusId = statuses.Find(x => x.StatusName == "Pending for submission").StatusId;
                                    employeeTimeSheetPunchCardUpsertInputModel.UserId = reportingMemberId.ChildId;
                                    employeeTimeSheetPunchCardUpsertInputModel.TimeSheetSubmissionId = TImeSheetSubmissionId;
                                    var TimeSheetPunchCardId = _timeSheetRepository.UpsertEmployeeTimeSheetPunchCard(employeeTimeSheetPunchCardUpsertInputModel, loggedInContext, validationMessages);

                                }
                            }
                            TimeSheetPunchCardUpDateInputModel timeSheetPunchCardUpDateInputModel = new TimeSheetPunchCardUpDateInputModel();
                            timeSheetPunchCardUpDateInputModel.StatusId = StatusId;
                            timeSheetPunchCardUpDateInputModel.FromDate = WeekStartDate;
                            timeSheetPunchCardUpDateInputModel.ToDate = TodayDate.AddDays(-1);
                            timeSheetPunchCardUpDateInputModel.IsRejected = false;
                            timeSheetPunchCardUpDateInputModel.ApproverId = lineManager.UserId;
                            timeSheetPunchCardUpDateInputModel.ReportingUserId = reportingMemberId.ChildId;
                            bool? value = _timeSheetRepository.UpdateEmployeeTimeSheetPunchCard(timeSheetPunchCardUpDateInputModel, loggedInContext, validationMessages);
                        }
                        _notificationService.SendNotification((new NotificationModelForAutoTimeSheetSubmission(
                                                        string.Format(NotificationSummaryConstants.AutoTimeSheetSubmissionNotification,
                                                            "Weekly"))), loggedInContext, lineManager.UserId);
                    }
                }
            }

        }

        public void AutoSubmitTimeSheet(List<LineManagerOutputModel> linemangers, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            var TodayDate = DateTime.Today;

            List<StatusOutputModel> statuses = _timeSheetRepository.GetStatus(loggedInContext, validationMessages).ToList();

            var StatusId = statuses.Find(x => x.StatusName == "Waiting for approval").StatusId;

            EmlpoyeeShiftWeekModel emlpoyeeShiftWeekModel = new EmlpoyeeShiftWeekModel
            {
                DateFrom = null,
                DateTo = null,
                StatusId = null
            };

            List<EmlpoyeeShiftWeekOutputModel> weekDays = _timeSheetRepository.GetEmployeeShiftWeekDays(emlpoyeeShiftWeekModel, loggedInContext, validationMessages);

            TimeSheetSubmissionSearchInputModel timeSheetSubmissionSearchInputModel = new TimeSheetSubmissionSearchInputModel();
            timeSheetSubmissionSearchInputModel.IsIncludedPastData = true;

            List<TimeSheetSubmissionSearchOutputModel> timeSheetSubmissionFrequencies = _timeSheetRepository.GetTimeSheetSubmissions(timeSheetSubmissionSearchInputModel, loggedInContext, validationMessages).ToList();
            var TImeSheetSubmissionId = timeSheetSubmissionFrequencies.Find(x => x.Name == "Daily").TimeSheetSubmissionId;
            List<EmlpoyeeShiftWeekOutputModel> timeSheets = new List<EmlpoyeeShiftWeekOutputModel>();

            timeSheets = (from x in weekDays where (TodayDate.AddDays(-1) <= x.Day?.Date && x.Day?.Date <= TodayDate.AddDays(-1)) select x).ToList();

            timeSheets.Reverse();
            var now = DateTime.Now.AddDays(-1);
            foreach (var lineManager in linemangers)
            {
                List<ReportingMembersDetailsModel> reportingMembers = new List<ReportingMembersDetailsModel>();
                if (lineManager.ReportingMembers != null)
                {
                    reportingMembers = JsonConvert.DeserializeObject<List<ReportingMembersDetailsModel>>(lineManager.ReportingMembers);
                }

                if (reportingMembers.Count > 0)
                {
                    foreach (var reportingMemberId in reportingMembers)
                    {
                        TimeSheetManagementSearchInputModel timeSheetManagementSearchInputModel = new TimeSheetManagementSearchInputModel();
                        timeSheetManagementSearchInputModel.UserId = reportingMemberId.ChildId;
                        timeSheetManagementSearchInputModel.DateFrom = TodayDate.AddDays(-1);
                        timeSheetManagementSearchInputModel.DateTo = TodayDate.AddDays(-1);
                        timeSheetManagementSearchInputModel.IncludeEmptyRecords = true;
                        List<TimeSheetManagementApiOutputModel> timeSheetDetailsList = _timeSheetRepository.GetTimeSheetDetails(timeSheetManagementSearchInputModel, loggedInContext, validationMessages).ToList();

                        if (timeSheetDetailsList.Count > 0 && timeSheetDetailsList[0].InTime != null && timeSheetDetailsList[0].OutTime != null)
                        {
                            EmployeeTimeSheetPunchCardUpsertInputModel employeeTimeSheetPunchCardUpsertInputModel = new EmployeeTimeSheetPunchCardUpsertInputModel();
                            employeeTimeSheetPunchCardUpsertInputModel.StartTime = timeSheetDetailsList[0].InTime.Value.DateTime;
                            employeeTimeSheetPunchCardUpsertInputModel.EndTime = timeSheetDetailsList[0].OutTime.Value.DateTime;
                            employeeTimeSheetPunchCardUpsertInputModel.Breakmins = timeSheetDetailsList[0].BreakInMin;
                            employeeTimeSheetPunchCardUpsertInputModel.Date = TodayDate.AddDays(-1);
                            employeeTimeSheetPunchCardUpsertInputModel.StatusId = statuses.Find(x => x.StatusName == "Pending for submission").StatusId;
                            employeeTimeSheetPunchCardUpsertInputModel.UserId = reportingMemberId.ChildId;
                            employeeTimeSheetPunchCardUpsertInputModel.TimeSheetSubmissionId = TImeSheetSubmissionId;
                            var TimeSheetPunchCardId = _timeSheetRepository.UpsertEmployeeTimeSheetPunchCard(employeeTimeSheetPunchCardUpsertInputModel, loggedInContext, validationMessages);
                            if (TimeSheetPunchCardId != null)
                            {
                                TimeSheetPunchCardUpDateInputModel timeSheetPunchCardUpDateInputModel = new TimeSheetPunchCardUpDateInputModel();
                                timeSheetPunchCardUpDateInputModel.StatusId = StatusId;
                                timeSheetPunchCardUpDateInputModel.AutoFromDate = new DateTime(now.Year, now.Month, now.Day, 12, 0, 0).ToString("MM/dd/yyyy") + " 12:00:00 AM";
                                timeSheetPunchCardUpDateInputModel.AutoToDate = new DateTime(now.Year, now.Month, now.Day, 12, 0, 0).ToString("MM/dd/yyyy") + " 12:00:00 AM";
                                timeSheetPunchCardUpDateInputModel.IsRejected = false;
                                timeSheetPunchCardUpDateInputModel.ApproverId = lineManager.UserId;
                                timeSheetPunchCardUpDateInputModel.ReportingUserId = reportingMemberId.ChildId;
                                bool? value = _timeSheetRepository.UpdateEmployeeTimeSheetPunchCard(timeSheetPunchCardUpDateInputModel, loggedInContext, validationMessages);
                            }
                        }
                    }
                    _notificationService.SendNotification((new NotificationModelForAutoTimeSheetSubmission(
                                                           string.Format(NotificationSummaryConstants.AutoTimeSheetSubmissionNotification,
                                                               "Daily"))), loggedInContext, lineManager.UserId);
                }
            }
        }

        public List<TimeSheetSubmissionSearchOutputModel> GetTimeSheetSubmissions(TimeSheetSubmissionSearchInputModel timeSheetSubmissionSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetTimeSheetSubmissions", "MasterDataManagement Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<TimeSheetSubmissionSearchOutputModel> timeSheetSubmissionFrequencies = _timeSheetRepository.GetTimeSheetSubmissions(timeSheetSubmissionSearchInputModel, loggedInContext, validationMessages).ToList();

            if (timeSheetSubmissionFrequencies.Count > 0)
            {
                return timeSheetSubmissionFrequencies;
            }

            return null;
        }

        public List<TimeSheetSubmissionSearchOutputModel> GetTimeSheetInterval(TimeSheetSubmissionSearchInputModel timeSheetIntervalSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetTimeSheetInterval", "MasterDataManagement Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<TimeSheetSubmissionSearchOutputModel> timeSheetIntervalFrequencies = _timeSheetRepository.GetTimeSheetInterval(timeSheetIntervalSearchInputModel, loggedInContext, validationMessages).ToList();

            if (timeSheetIntervalFrequencies.Count > 0)
            {
                return timeSheetIntervalFrequencies;
            }

            return null;
        }

        public List<TimeSheetSubmissionModel> GetEmployeeShiftWeekTimeSheets(TimeSheetSubmissionSearchInputModel timeSheetSubmissionSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetTimeSheetSubmissions", "MasterDataManagement Service"));


            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<TimeSheetSubmissionSearchOutputModel> timeSheetSubmissionFrequencies = _timeSheetRepository.GetTimeSheetSubmissions(timeSheetSubmissionSearchInputModel, loggedInContext, validationMessages).ToList();

            if (timeSheetSubmissionFrequencies.Count > 0)
            {
                EmlpoyeeShiftWeekModel emlpoyeeShiftWeekModel = new EmlpoyeeShiftWeekModel
                {
                    DateFrom = timeSheetSubmissionSearchInputModel.DateFrom,
                    DateTo = timeSheetSubmissionSearchInputModel.DateTo,
                    StatusId = timeSheetSubmissionSearchInputModel.StatusId
                };
                List<EmlpoyeeShiftWeekOutputModel> weekDays = _timeSheetRepository.GetEmployeeShiftWeekDays(emlpoyeeShiftWeekModel, loggedInContext, validationMessages);
                if (weekDays.Count > 0)
                {
                    return new List<TimeSheetSubmissionModel>(ConvertIntoTimeSheetList(weekDays, timeSheetSubmissionFrequencies));
                }
            }

            return null;
        }
        private List<TimeSheetSubmissionModel> ConvertIntoTimeSheetList(List<EmlpoyeeShiftWeekOutputModel> weekDays, List<TimeSheetSubmissionSearchOutputModel> timeSheetSubmissionFrequencies)
        {
            List<TimeSheetSubmissionModel> timeSheetSubmissions = new List<TimeSheetSubmissionModel>();

            foreach (var timeSheetSubmissionModel in timeSheetSubmissionFrequencies)
            {
                List<TimeSheetSubmissionModel> timeSheetSubmissionsList = new List<TimeSheetSubmissionModel>();

                DateTime? dateTo = new DateTime?();

                string status = string.Empty;

                List<EmlpoyeeShiftWeekOutputModel> timeSheets = new List<EmlpoyeeShiftWeekOutputModel>();

                dateTo = timeSheetSubmissionModel.ActiveTo ?? weekDays.OrderByDescending(t => t.Day).First().Day;

                timeSheets = (from x in weekDays where (timeSheetSubmissionModel.ActiveFrom?.Date <= x.Day?.Date && x.Day?.Date <= dateTo?.Date) select x).ToList();

                timeSheets.Reverse();

                if (timeSheets.Count > 0)
                {
                    if (timeSheetSubmissionModel.Name == "Monthly")
                    {
                        var groupedTimeSheetList = (from s in timeSheets group s by s.Day?.ToString("MMM yyyy")).ToList();

                        foreach (var timeSheetList in groupedTimeSheetList)
                        {
                            int rejectedStatusCount = timeSheetList.Count(x => x.StatusName.Contains("Rejected"));
                            int count = timeSheetList.Count(x => x.StatusName.Contains("Draft"));
                            TimeSheetSubmissionModel model = new TimeSheetSubmissionModel
                            {
                                TimeSheetTitle = timeSheetList.LastOrDefault().Day?.ToString("dd MMM yyyy") + " - " + timeSheetList.FirstOrDefault().Day?.ToString("dd MMM yyyy") + " time sheet",
                                Date = (from x in timeSheetList
                                        select new DateTimeValues
                                        {
                                            Date = x.Day,
                                            SpentTime = x.SpentTime,
                                            InTime = x.InTime,
                                            OutTime = x.OutTime,
                                            TimeSheetSubmissionId = timeSheetSubmissionModel.TimeSheetSubmissionId,
                                            Summary = x.Summary,
                                            Breakmins = x.Breakmins,
                                            IsOnLeave = x.IsOnLeave,
                                            Status = x.StatusName
        ,
                                            AdditionInformation = x.HolidayReason != null ? "Holiday(" + x.HolidayReason + ")" : (x.LeaveReason != null ? "Leave(" + x.LeaveReason + ")" : (x.TimesheetInTime != null ? "Punch card" : (x.RosterInTime != null ? "Roster: " + x.RosterName : (x.ShiftInTime != null ? "Shift: " + x.ShiftName : null))))
        ,
                                            AdditionalIntTime = x.TimesheetInTime != null ? x.TimesheetInTime : (x.RosterInTime != null ? DateTime.Today.Add((TimeSpan)x.RosterInTime) : (x.ShiftInTime != null ? DateTime.Today.Add((TimeSpan)x.ShiftInTime) : (DateTime?)null))
        ,
                                            AdditionalOuttTime = x.TimesheetInTime != null ? x.TimeSheetOutTime : (x.RosterInTime != null ? (x.RosterOutTime != null ? DateTime.Today.Add((TimeSpan)x.RosterOutTime) : (DateTime?)null) : (x.ShiftInTime != null ? (x.ShiftOutTime != null ? DateTime.Today.Add((TimeSpan)x.ShiftOutTime) : (DateTime?)null) : (DateTime?)null))
        ,
                                            HolidayReason = x.HolidayReason,
                                            LeaveReason = x.LeaveReason
                                        }).ToList(),
                                IsHeaderVisible = true,
                                IsEnableBuuton = rejectedStatusCount == timeSheetList.Count() ? true : (count == timeSheetList.Count() ? true : false),
                                Status = (rejectedStatusCount > 0) ? timeSheetList.FirstOrDefault().StatusName : ((count <= timeSheetList.Count() && count > 0) ? "Draft" : timeSheetList.FirstOrDefault().StatusName),
                                IsRejected = timeSheetList.FirstOrDefault().IsRejected,
                                RejectedReason = timeSheetList.FirstOrDefault().RejectedReason,
                                StatusColour = timeSheetList.FirstOrDefault().StatusColour
                            };
                            model.StatusColour = (from s in timeSheetList where s.StatusName == model.Status select s.StatusColour).FirstOrDefault();
                            timeSheetSubmissionsList.Add(model);
                        }
                    }
                    else if (timeSheetSubmissionModel.Name == "Weekly")
                    {
                        var groupedTimeSheetList = timeSheets.GroupBy(x => CultureInfo.CurrentCulture.Calendar.GetWeekOfYear((DateTime)x.Day, CalendarWeekRule.FirstDay, DayOfWeek.Monday));
                        foreach (var timeSheetList in groupedTimeSheetList)
                        {
                            int rejectedStatusCount = timeSheetList.Count(x => x.StatusName.Contains("Rejected"));
                            int count = timeSheetList.Count(x => x.StatusName.Contains("Draft"));
                            TimeSheetSubmissionModel model = new TimeSheetSubmissionModel
                            {
                                TimeSheetTitle = timeSheetList.LastOrDefault().Day?.ToString("dd MMM yyyy") + " - " + timeSheetList.FirstOrDefault().Day?.ToString("dd MMM yyyy") + " time sheet",
                                Date = (from x in timeSheetList
                                        select new DateTimeValues
                                        {
                                            Date = x.Day,
                                            SpentTime = x.SpentTime,
                                            InTime = x.InTime,
                                            OutTime = x.OutTime,
                                            TimeSheetSubmissionId = timeSheetSubmissionModel.TimeSheetSubmissionId,
                                            Summary = x.Summary,
                                            Breakmins = x.Breakmins,
                                            IsOnLeave = x.IsOnLeave,
                                            Status = x.StatusName
        ,
                                            AdditionInformation = x.HolidayReason != null ? "Holiday(" + x.HolidayReason + ")" : (x.LeaveReason != null ? "Leave(" + x.LeaveReason + ")" : (x.TimesheetInTime != null ? "Punch card" : (x.RosterInTime != null ? "Roster: " + x.RosterName : (x.ShiftInTime != null ? "Shift:" + x.ShiftName : null))))
        ,
                                            AdditionalIntTime = x.TimesheetInTime != null ? x.TimesheetInTime : (x.RosterInTime != null ? DateTime.Today.Add((TimeSpan)x.RosterInTime) : (x.ShiftInTime != null ? DateTime.Today.Add((TimeSpan)x.ShiftInTime) : (DateTime?)null))
        ,
                                            AdditionalOuttTime = x.TimesheetInTime != null ? x.TimeSheetOutTime : (x.RosterInTime != null ? (x.RosterOutTime != null ? DateTime.Today.Add((TimeSpan)x.RosterOutTime) : (DateTime?)null) : (x.ShiftInTime != null ? (x.ShiftOutTime != null ? DateTime.Today.Add((TimeSpan)x.ShiftOutTime) : (DateTime?)null) : (DateTime?)null))
        ,
                                            HolidayReason = x.HolidayReason,
                                            LeaveReason = x.LeaveReason
                                        }).ToList(),
                                IsHeaderVisible = true,
                                IsEnableBuuton = rejectedStatusCount == timeSheetList.Count() ? true : (count == timeSheetList.Count() ? true : false),
                                Status = (rejectedStatusCount > 0) ? timeSheetList.FirstOrDefault().StatusName : ((count <= timeSheetList.Count() && count > 0) ? "Draft" : timeSheetList.FirstOrDefault().StatusName),
                                IsRejected = timeSheetList.FirstOrDefault().IsRejected,
                                RejectedReason = timeSheetList.FirstOrDefault().RejectedReason,
                                StatusColour = timeSheetList.FirstOrDefault().StatusColour
                            };
                            model.StatusColour = (from s in timeSheetList where s.StatusName == model.Status select s.StatusColour).FirstOrDefault();
                            timeSheetSubmissionsList.Add(model);
                        }
                    }
                    else
                    {
                        var groupedTimeSheetList = timeSheets.GroupBy(x => x.Day?.Date);
                        foreach (var timeSheetList in groupedTimeSheetList)
                        {
                            int rejectedStatusCount = timeSheetList.Count(x => x.StatusName.Contains("Rejected"));
                            int count = timeSheetList.Count(x => x.StatusName.Contains("Draft"));
                            timeSheetSubmissionsList.Add(new TimeSheetSubmissionModel
                            {
                                TimeSheetTitle = timeSheetList.FirstOrDefault().Day?.ToString("dd MMM yyyy") + " time sheet",
                                Date = (from x in timeSheetList
                                        select new DateTimeValues
                                        {
                                            Date = x.Day,
                                            SpentTime = x.SpentTime,
                                            InTime = x.InTime,
                                            OutTime = x.OutTime,
                                            TimeSheetSubmissionId = timeSheetSubmissionModel.TimeSheetSubmissionId,
                                            Summary = x.Summary,
                                            Breakmins = x.Breakmins,
                                            IsOnLeave = x.IsOnLeave,
                                            Status = x.StatusName,
                                            AdditionInformation = x.HolidayReason != null ? "Holiday(" + x.HolidayReason + ")" : (x.LeaveReason != null ? "Leave(" + x.LeaveReason + ")" : (x.TimesheetInTime != null ? "Punch card" : (x.RosterInTime != null ? "Roster: " + x.RosterName : (x.ShiftInTime != null ? "Shift:" + x.ShiftName : null))))
        ,
                                            AdditionalIntTime = x.TimesheetInTime != null ? x.TimesheetInTime : (x.RosterInTime != null ? DateTime.Today.Add((TimeSpan)x.RosterInTime) : (x.ShiftInTime != null ? DateTime.Today.Add((TimeSpan)x.ShiftInTime) : (DateTime?)null))
        ,
                                            AdditionalOuttTime = x.TimesheetInTime != null ? x.TimeSheetOutTime : (x.RosterInTime != null ? (x.RosterOutTime != null ? DateTime.Today.Add((TimeSpan)x.RosterOutTime) : (DateTime?)null) : (x.ShiftInTime != null ? (x.ShiftOutTime != null ? DateTime.Today.Add((TimeSpan)x.ShiftOutTime) : (DateTime?)null) : (DateTime?)null))
         ,
                                            HolidayReason = x.HolidayReason,
                                            LeaveReason = x.LeaveReason
                                        }).ToList(),
                                IsHeaderVisible = false,
                                IsEnableBuuton = rejectedStatusCount == timeSheetList.Count() ? true : (count == timeSheetList.Count() ? true : false),
                                Status = (rejectedStatusCount > 0) ? timeSheetList.FirstOrDefault().StatusName : ((count <= timeSheetList.Count() && count > 0) ? "Draft" : timeSheetList.FirstOrDefault().StatusName),
                                IsRejected = timeSheetList.FirstOrDefault().IsRejected,
                                RejectedReason = timeSheetList.FirstOrDefault().RejectedReason,
                                StatusColour = timeSheetList.FirstOrDefault().StatusColour
                            });
                        }
                    }

                    timeSheetSubmissions.AddRange(timeSheetSubmissionsList);
                }
            }
            return timeSheetSubmissions;
        }

        public List<StatusOutputModel> GetStatus(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetStatus", "MasterDataManagement Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<StatusOutputModel> statuses = _timeSheetRepository.GetStatus(loggedInContext, validationMessages).ToList();

            if (statuses.Count > 0)
            {
                return statuses;
            }
            return null;
        }

        public List<TimeSheetApproveLineManagersOutputModel> GetTimeSheetApproveLineManagers(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetTimeSheetApproveLineManagers", "MasterDataManagement Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<TimeSheetApproveLineManagersOutputModel> lineManagers = _timeSheetRepository.GetTimeSheetApproveLineManagers(loggedInContext, validationMessages).ToList();

            if (lineManagers.Count > 0)
            {
                return lineManagers;
            }
            return null;
        }

        public List<TimeSheetApproveLineManagersOutputModel> GetApproverUsers(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetApproverUsers", "MasterDataManagement Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<TimeSheetApproveLineManagersOutputModel> lineManagers = _timeSheetRepository.GetApproverUsers(loggedInContext, validationMessages).ToList();

            if (lineManagers.Count > 0)
            {
                return lineManagers;
            }
            return null;
        }

        public EmployeeTimeSheetPunchCardDetailsOutputModel GetEmployeeTimeSheetPunchCardDetails(string date, Guid? UserId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetStatus", "MasterDataManagement Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            if (date != null)
            {
                var dateTime = new DateTime();
                if (date.Contains(' '))
                {
                    var spaces = date.Split(' ');
                    var arg = spaces[0].Split('/');
                    dateTime = DateTime.Parse(arg[2] + "/" + arg[1] + "/" + arg[0]);
                    EmployeeTimeSheetPunchCardDetailsOutputModel punchCardDetails = _timeSheetRepository.GetEmployeeTimeSheetPunchCardDetails(dateTime, UserId, loggedInContext, validationMessages).FirstOrDefault();
                    return punchCardDetails;
                }
                else
                {
                    EmployeeTimeSheetPunchCardDetailsOutputModel punchCardDetails = _timeSheetRepository.GetEmployeeTimeSheetPunchCardDetails(date, UserId, loggedInContext, validationMessages).FirstOrDefault();
                    return punchCardDetails;
                }
            }
            return null;
        }
        public Guid? UpsertApproverEditTimeSheet(EmployeeTimeSheetPunchCardUpsertInputModel employeeTimeSheetPunchCardUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertEmployeeTimeSheetPunchCard", "Master Data Management Service"));

            if (!MasterDataValidationHelper.UpsertEmployeeTimeSheetPunchCardValidation(employeeTimeSheetPunchCardUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            employeeTimeSheetPunchCardUpsertInputModel.TimeSheetPunchCardId = _timeSheetRepository.UpsertApproverEditTimeSheet(employeeTimeSheetPunchCardUpsertInputModel, loggedInContext, validationMessages);

            return employeeTimeSheetPunchCardUpsertInputModel.TimeSheetPunchCardId;
        }

        public Guid? UpsertEmployeeTimeSheetPunchCard(EmployeeTimeSheetPunchCardUpsertInputModel employeeTimeSheetPunchCardUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertEmployeeTimeSheetPunchCard", "Master Data Management Service"));

            if (!MasterDataValidationHelper.UpsertEmployeeTimeSheetPunchCardValidation(employeeTimeSheetPunchCardUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            employeeTimeSheetPunchCardUpsertInputModel.TimeSheetPunchCardId = _timeSheetRepository.UpsertEmployeeTimeSheetPunchCard(employeeTimeSheetPunchCardUpsertInputModel, loggedInContext, validationMessages);

            return employeeTimeSheetPunchCardUpsertInputModel.TimeSheetPunchCardId;
        }

        public bool? UpdateEmployeeTimeSheetPunchCard(TimeSheetPunchCardUpDateInputModel timeSheetPunchCardUpDateInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateEmployeeTimeSheetPunchCard", "Master Data Management Service"));

            if (!MasterDataValidationHelper.UpdateTimeSheetPunchCardValidation(timeSheetPunchCardUpDateInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            bool? value = _timeSheetRepository.UpdateEmployeeTimeSheetPunchCard(timeSheetPunchCardUpDateInputModel, loggedInContext, validationMessages);

            if (Convert.ToBoolean(value))
            {
                Task.Run(() =>
                {
                    try
                    {
                        validationMessages = new List<ValidationMessage>();

                        Models.User.UserSearchCriteriaInputModel userSearchModel = new Models.User.UserSearchCriteriaInputModel();
                        userSearchModel.CompanyId = loggedInContext.CompanyGuid;
                        userSearchModel.UserId = loggedInContext.LoggedInUserId;

                        List<UserOutputModel> userDetails = _userService.GetAllUsers(userSearchModel, loggedInContext, validationMessages);

                        List<StatusOutputModel> statuses = _timeSheetRepository.GetStatus(loggedInContext, validationMessages).ToList();

                        if (timeSheetPunchCardUpDateInputModel.StatusId != null && timeSheetPunchCardUpDateInputModel.StatusId != Guid.Empty && statuses?.FirstOrDefault(x => x.StatusName == "Approved").StatusId == timeSheetPunchCardUpDateInputModel.StatusId)
                        {
                            _rosterService.SendTimesheetEmployeeManagerMails("Approved", timeSheetPunchCardUpDateInputModel, userDetails, loggedInContext, validationMessages);
                            _notificationService.SendNotification(new SubmitTimesheetApproveNotification(
                                   string.Format(NotificationSummaryConstants.TimesheetApprovedOrRejected, timeSheetPunchCardUpDateInputModel.TimesheetTitle, "approved", userDetails?[0].FullName),
                                   loggedInContext.LoggedInUserId,
                                   timeSheetPunchCardUpDateInputModel.UserId,
                                   "Time sheet",
                                    NotificationSummaryConstants.NotificationHeader
                                   ), loggedInContext, timeSheetPunchCardUpDateInputModel.UserId);
                        }

                        if (timeSheetPunchCardUpDateInputModel.StatusId != null && timeSheetPunchCardUpDateInputModel.StatusId != Guid.Empty && statuses?.FirstOrDefault(x => x.StatusName == "Rejected").StatusId == timeSheetPunchCardUpDateInputModel.StatusId)
                        {
                            _rosterService.SendTimesheetEmployeeManagerMails("Rejected", timeSheetPunchCardUpDateInputModel, userDetails, loggedInContext, validationMessages);
                            _notificationService.SendNotification(new SubmitTimesheetRejecteNotification(
                                   string.Format(NotificationSummaryConstants.TimesheetApprovedOrRejected, timeSheetPunchCardUpDateInputModel.TimesheetTitle, "rejected", userDetails?[0].FullName),
                                   loggedInContext.LoggedInUserId,
                                   timeSheetPunchCardUpDateInputModel.UserId,
                                   "Time sheet",
                                    NotificationSummaryConstants.NotificationHeader
                                   ), loggedInContext, timeSheetPunchCardUpDateInputModel.UserId);
                        }

                        if (userDetails?.Count > 0 && timeSheetPunchCardUpDateInputModel.ApproverId != null && timeSheetPunchCardUpDateInputModel.ApproverId != Guid.Empty && statuses?.FirstOrDefault(x => x.StatusName == "Waiting for approval").StatusId == timeSheetPunchCardUpDateInputModel.StatusId)
                        {
                            _rosterService.SendTimesheetEmployeeManagerMails("Submitted", timeSheetPunchCardUpDateInputModel, userDetails, loggedInContext, validationMessages);
                            _notificationService.SendNotification(new SubmitTimeSheetNotification(
                                     string.Format(NotificationSummaryConstants.TimeSheetSubmitted, timeSheetPunchCardUpDateInputModel.TimesheetTitle, userDetails?[0].FullName),
                                     loggedInContext.LoggedInUserId,
                                     timeSheetPunchCardUpDateInputModel.ApproverId,
                                     "Time sheet",
                                      NotificationSummaryConstants.NotificationHeader
                                     ), loggedInContext, timeSheetPunchCardUpDateInputModel.ApproverId);
                        }
                    }
                    catch (Exception exception)
                    {
                        LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateEmployeeTimeSheetPunchCard", "TimeSheetService ", exception.Message), exception);

                    }
                });
            }


            return value;
        }


        public List<TimeSheetSubmissionModel> GetApproverTimeSheetSubmissions(ApproverTimeSheetSubmissionsGetInputModel approverTimeSheetSubmissionsGetInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetApproverTimeSheetSubmissions", "MasterDataManagement Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<ApproverTimeSheetSubmissionsGetOutputModel> timeSheetSubmissions = _timeSheetRepository.GetApproverTimeSheetSubmissions(approverTimeSheetSubmissionsGetInputModel, loggedInContext, validationMessages).ToList();

            if (timeSheetSubmissions.Count > 0)
            {
                return new List<TimeSheetSubmissionModel>(ConvertToModel(timeSheetSubmissions));
            }
            return new List<TimeSheetSubmissionModel>();
        }

        public List<TimeSheetSubmissionModel> ConvertToModel(List<ApproverTimeSheetSubmissionsGetOutputModel> timeSheetSubmissionModels)
        {
            List<TimeSheetSubmissionModel> timeSheetSubmissionsList = new List<TimeSheetSubmissionModel>();
            var groupedList = from s in timeSheetSubmissionModels group s by s.UserId;

            foreach (var TimeSheetList in groupedList)
            {

                var frequencyGroupedList = from s in TimeSheetList group s by s.Name;

                foreach (var frequencyList in frequencyGroupedList)
                {
                    List<TimeSheetSubmissionModel> timeSheetSubmissions = new List<TimeSheetSubmissionModel>();

                    if (frequencyList.Key == "Weekly")
                    {
                        var groupedTimeSheetList = frequencyList.GroupBy(x => CultureInfo.CurrentCulture.Calendar.GetWeekOfYear((DateTime)x.Date, CalendarWeekRule.FirstDay, DayOfWeek.Monday));
                        timeSheetSubmissions = new List<TimeSheetSubmissionModel>();
                        foreach (var timeSheetList in groupedTimeSheetList)
                        {
                            timeSheetSubmissions.Add(new TimeSheetSubmissionModel
                            {
                                TimeSheetTitle = timeSheetList.LastOrDefault().Date?.ToString("dd MMM yyyy") + " - " + timeSheetList.FirstOrDefault().Date?.ToString("dd MMM yyyy") + " time sheet",
                                Date = (from x in timeSheetList select new DateTimeValues { Date = x.Date, SpentTime = x.SpentTime, InTime = x.StartTime, OutTime = x.EndTime, UserId = x.UserId, UserName = x.UserName, TimeSheetSubmissionId = x.TimeSheetSubmissionId, Summary = x.Summary, Breakmins = x.Breakmins, IsOnLeave = x.IsOnLeave }).ToList(),
                                IsHeaderVisible = true,
                                UserId = timeSheetList.FirstOrDefault().UserId,
                                UserName = timeSheetList.FirstOrDefault().UserName,
                                ProfileImage = timeSheetList.FirstOrDefault().ProfileImage
                            });
                        }
                    }
                    else if (frequencyList.Key == "Monthly")
                    {
                        var groupedTimeSheetList = (from s in frequencyList group s by s.Date?.ToString("MMM yyyy")).ToList();
                        timeSheetSubmissions = new List<TimeSheetSubmissionModel>();
                        foreach (var timeSheetList in groupedTimeSheetList)
                        {
                            timeSheetSubmissions.Add(new TimeSheetSubmissionModel
                            {
                                TimeSheetTitle = timeSheetList.LastOrDefault().Date?.ToString("dd MMM yyyy") + " - " + timeSheetList.FirstOrDefault().Date?.ToString("dd MMM yyyy") + " time sheet",
                                Date = (from x in timeSheetList select new DateTimeValues { Date = x.Date, SpentTime = x.SpentTime, InTime = x.StartTime, OutTime = x.EndTime, UserId = x.UserId, UserName = x.UserName, TimeSheetSubmissionId = x.TimeSheetSubmissionId, Summary = x.Summary, Breakmins = x.Breakmins, IsOnLeave = x.IsOnLeave }).ToList(),
                                IsHeaderVisible = true,
                                UserId = timeSheetList.FirstOrDefault().UserId,
                                UserName = timeSheetList.FirstOrDefault().UserName,
                                ProfileImage = timeSheetList.FirstOrDefault().ProfileImage
                            });
                        }
                    }
                    else
                    {
                        var groupedTimeSheetList = frequencyList.GroupBy(x => x.Date?.Date);
                        timeSheetSubmissions = new List<TimeSheetSubmissionModel>();
                        foreach (var timeSheetList in groupedTimeSheetList)
                        {
                            timeSheetSubmissions.Add(new TimeSheetSubmissionModel
                            {
                                TimeSheetTitle = timeSheetList.FirstOrDefault().Date?.ToString("dd MMM yyyy") + " time sheet",
                                Date = (from x in timeSheetList select new DateTimeValues { Date = x.Date, SpentTime = x.SpentTime, InTime = x.StartTime, OutTime = x.EndTime, UserId = x.UserId, UserName = x.UserName, TimeSheetSubmissionId = x.TimeSheetSubmissionId, Summary = x.Summary, Breakmins = x.Breakmins, IsOnLeave = x.IsOnLeave }).ToList(),
                                IsHeaderVisible = false,
                                UserId = timeSheetList.FirstOrDefault().UserId,
                                UserName = timeSheetList.FirstOrDefault().UserName,
                                ProfileImage = timeSheetList.FirstOrDefault().ProfileImage
                            });
                        }
                    }
                    timeSheetSubmissionsList.AddRange(timeSheetSubmissions);
                }
            }
            return timeSheetSubmissionsList;
        }

        public List<TimeSheetModel> GetAllLateUsers(ActivityKpiSearchModel activityKpiSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetAllLateUsers", "", " ", "TimeSheetService"));
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            return _timeSheetRepository.GetAllLateUsers(activityKpiSearchModel, loggedInContext, validationMessages);
        }
        public List<TimeSheetModel> GetAllAbsenceUsers(ActivityKpiSearchModel activityKpiSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetAllAbsenceUsers", "", " ", "TimeSheetService"));
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            return _timeSheetRepository.GetAllAbsenceUsers(activityKpiSearchModel, loggedInContext, validationMessages);
        }

        public Guid? UpsertTimeSheetStatus(TimesheetStatusModel timesheetStatusModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertTimeSheetInterval", "Master Data Management Service"));

            var StatusId = _timeSheetRepository.UpsertTimeSheetStatus(timesheetStatusModel, loggedInContext, validationMessages);

            return StatusId;
        }
    }
}

public static class DateTimeExtensions
{
    public static DateTime StartOfWeek(this DateTime dt, DayOfWeek startOfWeek)
    {
        int diff = (7 + (dt.DayOfWeek - startOfWeek)) % 7;
        return dt.AddDays(-1 * diff).Date;
    }
}

