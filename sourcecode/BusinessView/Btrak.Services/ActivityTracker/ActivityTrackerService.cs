using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.ActivityTracker;
using Btrak.Models.ActTracker;
using Btrak.Models.Chat;
using Btrak.Models.ScheduledConfigurations;
using Btrak.Models.SystemManagement;
using Btrak.Models.User;
using Btrak.Services.ActTracker;
using Btrak.Services.Email;
using Btrak.Services.FileUpload;
using Btrak.Services.Helpers.ActivityTracker;
using BTrak.Common;
using Hangfire;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Btrak.Services.ActivityTracker
{
    public class ActivityTrackerService : IActivityTrackerService
    {
        private readonly ActivityTrackerRepository _activityTrackerRepository;
        private readonly ActivityTrackerValidationHelpers _activityTrackerValidationHelpers;
        private readonly IFileService _fileService;
        private readonly UserRepository _userRepository;
        private readonly GoalRepository _goalRepository;
        private readonly IEmailService _emailService;
        private readonly IActTrackerService _actTrackerService;

        public ActivityTrackerService(
            ActivityTrackerRepository activityTrackerRepository,
            ActivityTrackerValidationHelpers activityTrackerValidationHelpers,
            IFileService fileService,
            UserRepository userRepository,
            GoalRepository goalRepository,
            IEmailService emailService,
            IActTrackerService actTrackerService)
        {
            _fileService = fileService;
            _activityTrackerRepository = activityTrackerRepository;
            _activityTrackerValidationHelpers = activityTrackerValidationHelpers;
            _userRepository = userRepository;
            _goalRepository = goalRepository;
            _emailService = emailService;
            _actTrackerService = actTrackerService;
        }

        public void ActivityTrackerProduceData(string sqlquery)
        {
            LoggingManager.Info("Entering into ActivityTrackerProduceData webjob to execute proc with name " + sqlquery + " on utc date " + DateTime.UtcNow);

            BackgroundJob.Enqueue(() => _activityTrackerRepository.ActivityTrackerData(sqlquery));
        }

        public void UpdateUserActivityInIdleTime(Guid? userId, DateTime trackedDate, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Update User Activity In Idle Time", "Update User Activity In Idle Time", trackedDate, "ActivityTracker Service"));
                _activityTrackerRepository.UpdateUserActivityInIdleTime(userId, trackedDate, validationMessages);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateUserActivityInIdleTime", "ActivityTrackerService ", exception.Message), exception);

            }
        }

        public void UpdateUserTrackerData(Guid? userId, DateTime trackedDate, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Update User TrackerData", "ActivityTrackerService", trackedDate, "ActivityTracker Service"));
                _activityTrackerRepository.UpdateUserTrackerData(userId, trackedDate.ToString("yyyy-MM-dd"), validationMessages);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Update User TrackerData", "ActivityTrackerService ", exception.Message), exception);
            }
        }

        public string UpsertActivityTrackerStatus(string deviceId, List<ValidationMessage> validationMessages, Guid? loggedInUser, string userIpAddress, string timeZone)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Activity Tracker Status", "", "", "ActivityTracker Service"));

            string status = _activityTrackerRepository.UpsertActivityTrackerStatus(deviceId, validationMessages, loggedInUser, userIpAddress, timeZone);
            if (status != null)
            {
                LoggingManager.Debug("Upsert Activity Tracker Status has been " + status);

                return status;
            }
            return null;
        }

        public List<TimeUsageOfApplicationApiOutputModel> GetTotalTimeUsageOfApplicationsByUsers(TimeUsageOfApplicationSearchInputModel timeUsageOfApplicationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Total Time Usage Of Applications By Users", "timeUsageOfApplicationSearchInputModel", timeUsageOfApplicationSearchInputModel, "ActivityTracker Service"));
            
            if (timeUsageOfApplicationSearchInputModel.UserId != null && timeUsageOfApplicationSearchInputModel.UserId.Count > 0)
            {
                timeUsageOfApplicationSearchInputModel.UserIdXml = Utilities.ConvertIntoListXml(timeUsageOfApplicationSearchInputModel.UserId.ToArray());
            }
            if (timeUsageOfApplicationSearchInputModel.RoleId != null && timeUsageOfApplicationSearchInputModel.RoleId.Count > 0)
            {
                timeUsageOfApplicationSearchInputModel.RoleIdXml = Utilities.ConvertIntoListXml(timeUsageOfApplicationSearchInputModel.RoleId.ToArray());
            }
            if (timeUsageOfApplicationSearchInputModel.BranchId != null && timeUsageOfApplicationSearchInputModel.BranchId.Count > 0)
            {
                timeUsageOfApplicationSearchInputModel.BranchIdXml = Utilities.ConvertIntoListXml(timeUsageOfApplicationSearchInputModel.BranchId.ToArray());
            }
            timeUsageOfApplicationSearchInputModel.DateFrom = timeUsageOfApplicationSearchInputModel.DateFrom.Date;
            timeUsageOfApplicationSearchInputModel.DateTo = timeUsageOfApplicationSearchInputModel.DateTo.Date;
            var result = _activityTrackerRepository.GetTotalTimeUsageOfApplicationsByUsers(timeUsageOfApplicationSearchInputModel, loggedInContext, validationMessages);

            if (result.Count > 0)
            {
                return ConvertToApiReturnModel(result, timeUsageOfApplicationSearchInputModel);
            }

            return null;
        }

        public List<TimeUsageOfApplicationApiOutputModel> ConvertToApiReturnModel(List<TimeUsageOfApplicationApiOutputModel> timeUsageOfApplicationSearchOutputModel, TimeUsageOfApplicationSearchInputModel timeUsageOfApplicationSearchInputModel)
        {
            var dates = new List<DateTime>();
            for (var dt = timeUsageOfApplicationSearchInputModel.DateFrom; dt <= timeUsageOfApplicationSearchInputModel.DateTo; dt = dt.AddDays(1))
            {
                dates.Add(dt);
            }

            var maxTotalTime = timeUsageOfApplicationSearchOutputModel.Max(p => p.Productive + p.UnProductive + p.Neutral + p.Idle);

            var maxNeutralTime = timeUsageOfApplicationSearchOutputModel.Max(p => p.Productive + p.UnProductive + p.Neutral);

            List<TimeUsageOfApplicationApiOutputModel> timeUsageOfApplicationSearchOutput = new List<TimeUsageOfApplicationApiOutputModel>();

            timeUsageOfApplicationSearchOutput = timeUsageOfApplicationSearchOutputModel.GroupBy(g => g.UserId).Select(x => new TimeUsageOfApplicationApiOutputModel { Name = x.FirstOrDefault()?.Name, ProfileImage = x.FirstOrDefault()?.ProfileImage, UserId = x.Key, TotalCount = x.FirstOrDefault().TotalCount }).Distinct().ToList();

            foreach (var item in timeUsageOfApplicationSearchOutput)
            {
                item.timeUsageSearchOutputModel = (from tib in timeUsageOfApplicationSearchOutputModel
                                                   where tib.UserId == item.UserId
                                                   select new TimeUsageSearchOutputModel
                                                   {
                                                       OperationDate = tib.OperationDate,
                                                       TotalTime = tib.TotalTime,
                                                       Productive = maxTotalTime == 0 ? 0 : (tib.Productive/ maxTotalTime) * 100,
                                                       UnProductive = maxTotalTime == 0 ? 0 : (tib.UnProductive / maxTotalTime) * 100,
                                                       Neutral = maxTotalTime == 0 ? 0 : (tib.Neutral / maxTotalTime) * 100,
                                                       Idle = maxTotalTime == 0 ? 0 : (tib.Idle / maxTotalTime) * 100,
                                                       ProductiveTime = tib.Productive,
                                                       UnProductiveTime = tib.UnProductive,
                                                       NeutralTime = tib.Neutral,
                                                       IdleTime = tib.Idle,
                                                       TotalCount = tib.TotalCount
                                                   }).ToList();
            }
            timeUsageOfApplicationSearchOutput = timeUsageOfApplicationSearchOutput.Select(x => x).Distinct().ToList();
            timeUsageOfApplicationSearchOutput[0].Dates = dates;
            timeUsageOfApplicationSearchOutput[0].TotalTime = maxTotalTime;
            timeUsageOfApplicationSearchOutput[0].Neutral = maxNeutralTime;
            timeUsageOfApplicationSearchOutput[0].TotalCount = timeUsageOfApplicationSearchOutputModel.Select(x => x.TotalCount ).FirstOrDefault();
            return timeUsageOfApplicationSearchOutput;
        }

        public string GetProductiveTime(ActivityKpiSearchModel activityKpiSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Productive Time", "activityKpiSearchModel", activityKpiSearchModel, "ActivityTracker Service"));
            return _activityTrackerRepository.GetProductiveTime(activityKpiSearchModel, loggedInContext, validationMessages);
        }

        public string GetUnproductiveTime(ActivityKpiSearchModel activityKpiSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Unproductive Time", "activityKpiSearchModel", activityKpiSearchModel, "ActivityTracker Service"));
            return _activityTrackerRepository.GetUnproductiveTime(activityKpiSearchModel, loggedInContext, validationMessages);
        }

        public string GetIdleTime(ActivityKpiSearchModel activityKpiSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Idle Time", "activityKpiSearchModel", activityKpiSearchModel, "ActivityTracker Service"));
            return _activityTrackerRepository.GetIdleTime(activityKpiSearchModel, loggedInContext, validationMessages);
        }

        public string GetNeutralTime(ActivityKpiSearchModel activityKpiSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Neutral Time", "activityKpiSearchModel", activityKpiSearchModel, "ActivityTracker Service"));
            return _activityTrackerRepository.GetNeutralTime(activityKpiSearchModel, loggedInContext, validationMessages);
        }

        public string GetDeskTime(ActivityKpiSearchModel activityKpiSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Desk Time", "activityKpiSearchModel", activityKpiSearchModel, "ActivityTracker Service"));
            return _activityTrackerRepository.GetDeskTime(activityKpiSearchModel, loggedInContext, validationMessages);
        }


        public List<GetTimeUsageDrillDownOutputModel> GetTimeUsageDrillDown(TimeUsageDrillDownSearchInputModel timeUsageDrillDownSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Time Usage Drill Down", "timeUsageDrillDownSearchInputModel", timeUsageDrillDownSearchInputModel, "ActivityTracker Service"));
            return _activityTrackerRepository.GetTimeUsageDrillDown(timeUsageDrillDownSearchInputModel, loggedInContext, validationMessages);
        }

        public int GetTotalTeamMembers(TimeUsageDrillDownSearchInputModel timeUsageDrillDownSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Time Usage Drill Down", "timeUsageDrillDownSearchInputModel", timeUsageDrillDownSearchInputModel, "ActivityTracker Service"));
            return _activityTrackerRepository.GetTotalTeamMembers(timeUsageDrillDownSearchInputModel, loggedInContext, validationMessages);
        }

        public List<EmployeeSearchOutputModel> GetEmployees(EmployeeSearchInputModel employeeSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Total Time Usage Of Applications By Users", "employeeSearchInputModel", employeeSearchInputModel, "ActivityTracker Service"));
            
            if (employeeSearchInputModel.RoleId != null && employeeSearchInputModel.RoleId.Count > 0)
            {
                employeeSearchInputModel.RoleIdXml = Utilities.ConvertIntoListXml(employeeSearchInputModel.RoleId.ToArray());
            }
            if (employeeSearchInputModel.BranchId != null && employeeSearchInputModel.BranchId.Count > 0)
            {
                employeeSearchInputModel.BranchIdXml = Utilities.ConvertIntoListXml(employeeSearchInputModel.BranchId.ToArray());
            }

            List<EmployeeSearchOutputModel> result = _activityTrackerRepository.GetEmployees(employeeSearchInputModel, loggedInContext, validationMessages);

            if (result.Count > 0)
            {
                var returnValue = from r in result group r by r.UserId;

                List<EmployeeSearchOutputModel> returnResult = new List<EmployeeSearchOutputModel>();
                var i = 0;
                foreach (var res in returnValue)
                {
                    EmployeeSearchOutputModel employe = new EmployeeSearchOutputModel()
                    {
                        Name = string.Empty,
                        RoleId = new Guid?(),
                        UserId = new Guid?(),
                        Role = string.Empty
                    };
                    foreach (var ren in res)
                    {
                        if (!employe.UserId.ToString().Equals(ren.UserId.ToString()))
                        {
                            employe.UserId = ren.UserId;
                            employe.RoleId = ren.RoleId;
                            employe.Name = ren.Name;
                            employe.Role = ren.RoleId.ToString();
                        }
                        else
                        {
                            employe.Role = employe.Role + "," + ren.RoleId.ToString();
                        }
                    }
                    returnResult.Add(employe);
                }
                return returnResult;
            }
            return null;
        }

        public List<EmployeeWebAppUsageTimeOutputModel> GetWebAppUsageTime(EmployeeWebAppUsageTimeSearchInputModel employeeWebAppUsageTimeSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Web App Usage Time", "employeeWebAppUsageTimeSearchInputModel", employeeWebAppUsageTimeSearchInputModel, "ActivityTracker Service"));
            
            if (employeeWebAppUsageTimeSearchInputModel.UserId != null && employeeWebAppUsageTimeSearchInputModel.UserId.Count > 0)
            {
                employeeWebAppUsageTimeSearchInputModel.UserIdXml = Utilities.ConvertIntoListXml(employeeWebAppUsageTimeSearchInputModel.UserId.ToArray());
            }
            if (employeeWebAppUsageTimeSearchInputModel.RoleId != null && employeeWebAppUsageTimeSearchInputModel.RoleId.Count > 0)
            {
                employeeWebAppUsageTimeSearchInputModel.RoleIdXml = Utilities.ConvertIntoListXml(employeeWebAppUsageTimeSearchInputModel.RoleId.ToArray());
            }
            if (employeeWebAppUsageTimeSearchInputModel.BranchId != null && employeeWebAppUsageTimeSearchInputModel.BranchId.Count > 0)
            {
                employeeWebAppUsageTimeSearchInputModel.BranchIdXml = Utilities.ConvertIntoListXml(employeeWebAppUsageTimeSearchInputModel.BranchId.ToArray());
            }

            return _activityTrackerRepository.GetWebAppUsageTime(employeeWebAppUsageTimeSearchInputModel, loggedInContext, validationMessages);
        }

        public ActivityTrackerInformationOutputModel GetActivityTrackerInformation(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Activity Tracker Information", "", "", "ActivityTracker Service"));
           
            GetChatActivityTrackerRecorder(loggedInContext, validationMessages);

            return _activityTrackerRepository.GetActivityTrackerInformation(loggedInContext, validationMessages);
        }

        public TrackedInformationOfUserStoryOutputModel GetTrackedInformationOfUserStory(TrackedInformationOfUserStorySearchInputModel trackedInformationOfUserStorySearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Tracked Information Of UserStory", "trackedInformationOfUserStorySearchInputModel", trackedInformationOfUserStorySearchInputModel, "ActivityTracker Service"));

            return _activityTrackerRepository.GetTrackedInformationOfUserStory(trackedInformationOfUserStorySearchInputModel, loggedInContext, validationMessages);
        }

        public void GetChatActivityTrackerRecorder(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, bool? isSingle = null)
        {
            List<MessageDto> messageDtoValues = _activityTrackerRepository.GetChatActivityTrackerRecorder(loggedInContext, validationMessages, isSingle);
            //if (messageDtoValues != null && messageDtoValues.Count > 0)
            //{
            //    foreach (var item in messageDtoValues)
            //    {
            //        PubNubService.PublishMessageToChannel(JsonConvert.SerializeObject(item), new List<string>());
            //    }
            //}
            //PubNubService.PublishMessageToChannel(JsonConvert.SerializeObject(messageDtoValues), new List<string>());
        }

        public List<EmployeeTrackerOutputModel> GetAppUsageCompleteReport(EmployeeTrackerSearchInputModel employeeTrackerSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Web App Usage Time", "employeeWebAppUsageTimeSearchInputModel", employeeTrackerSearchInputModel, "ActivityTracker Service"));
            
            if (employeeTrackerSearchInputModel.UserId != null && employeeTrackerSearchInputModel.UserId.Count > 0)
            {
                employeeTrackerSearchInputModel.UserIdXml = Utilities.ConvertIntoListXml(employeeTrackerSearchInputModel.UserId.ToArray());
            }
            var result = _activityTrackerRepository.GetAppUsageCompleteReport(employeeTrackerSearchInputModel, loggedInContext, validationMessages);

            if (result != null && result.Count() > 0)
            {
                return result;
            }
            return null;
        }

        public List<ApplicationCategoryModel> GetApplicationCategory(ApplicationCategoryModel applicationCategoryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetApplicationCategory", "employeeWebAppUsageTimeSearchInputModel", applicationCategoryModel, "ActivityTracker Service"));
            
            var result = _activityTrackerRepository.GetApplicationCategory(applicationCategoryModel, loggedInContext, validationMessages);
            return result;
        }

        public Guid? UpsertApplicationCategory(ApplicationCategoryModel applicationCategoryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertApplicationCategory", "employeeWebAppUsageTimeSearchInputModel", applicationCategoryModel, "ActivityTracker Service"));
            
            Guid? result = _activityTrackerRepository.UpsertApplicationCategory(applicationCategoryModel, loggedInContext, validationMessages);
            return result;
        }

        public List<EmployeeTrackerUserstoryOutputModel> GetAppUsageUserStoryReport(EmployeeTrackerSearchInputModel employeeTrackerSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Web App Usage Time", "employeeWebAppUsageTimeSearchInputModel", employeeTrackerSearchInputModel, "ActivityTracker Service"));
           
            if (employeeTrackerSearchInputModel.UserId != null && employeeTrackerSearchInputModel.UserId.Count > 0)
            {
                employeeTrackerSearchInputModel.UserIdXml = Utilities.ConvertIntoListXml(employeeTrackerSearchInputModel.UserId.ToArray());
            }
            var result = _activityTrackerRepository.GetAppUsageUserStoryReport(employeeTrackerSearchInputModel, loggedInContext, validationMessages);

            if (result.Count() > 0)
            {
                return result;
            }
            return null;
        }

        public List<EmployeeTrackerTimesheetOutputModel> GetAppUsageTimesheetReport(EmployeeTrackerSearchInputModel employeeTrackerSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Web App Usage Time", "employeeWebAppUsageTimeSearchInputModel", employeeTrackerSearchInputModel, "ActivityTracker Service"));
           
            if (employeeTrackerSearchInputModel.UserId != null && employeeTrackerSearchInputModel.UserId.Count > 0)
            {
                employeeTrackerSearchInputModel.UserIdXml = Utilities.ConvertIntoListXml(employeeTrackerSearchInputModel.UserId.ToArray());
            }
            var result = _activityTrackerRepository.GetAppUsageTimesheetReport(employeeTrackerSearchInputModel, loggedInContext, validationMessages);

            if (result.Count() > 0)
            {
                return TimePunchDetailsOutput(result);
            }
            return null;
        }

        public List<EmployeeTrackerOutputModel> GetIdleAndInactiveTimeForEmployee(EmployeeTrackerSearchInputModel employeeTrackerSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Idle And Inactive Time For Employee", "employeeWebAppUsageTimeSearchInputModel", employeeTrackerSearchInputModel, "ActivityTracker Service"));
           
            if (employeeTrackerSearchInputModel.UserId != null && employeeTrackerSearchInputModel.UserId.Count > 0)
            {
                employeeTrackerSearchInputModel.UserIdXml = Utilities.ConvertIntoListXml(employeeTrackerSearchInputModel.UserId.ToArray());
            }
            var result = _activityTrackerRepository.GetIdleAndInactiveTimeForEmployee(employeeTrackerSearchInputModel, loggedInContext, validationMessages);

            if (result.Count() > 0)
            {
                return result;
            }
            return null;
        }

        public List<ActivityTrackerDesktopsModel> GetTrackerDesktops(ActivityTrackerDesktopsModel activityTrackerDesktopsModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetTrackerDesktops", "activityTrackerDesktopsModel", activityTrackerDesktopsModel, "ActivityTracker Service"));

            List<ActivityTrackerDesktopsModel> desktops = _activityTrackerRepository.GetTrackerDesktops(activityTrackerDesktopsModel, loggedInContext, validationMessages).ToList();

            return desktops;
        }

        public List<EmployeeTrackerTimesheetOutputModel> TimePunchDetailsOutput(List<EmployeeTrackerTimesheetOutputModel> employeeTrackerTimesheetOutputModel)
        {
            List<EmployeeTrackerTimesheetOutputModel> result = new List<EmployeeTrackerTimesheetOutputModel>();
            var returnList = from res in employeeTrackerTimesheetOutputModel group res by res.UserId;

            foreach (var res in returnList)
            {
                var resultBy = from re in res group re by re.CreatedDate;
                foreach (var re in resultBy)
                {
                    var breakCount = re.Count();//re.Where(x => x.ApplicationTypeName == "Lunch" || x.ApplicationTypeName == "Break").ToList().ToArray().Count();
                    if (breakCount > 1)
                    {
                        var r = re.ToArray();
                        var endTime = r[0].EndTime;
                        r[0].EndTime = r[1].StartTime;
                        result.Add(r[0]);
                        for (var i = 1; i < breakCount; i++)
                        {
                            result.Add(r[i]);
                            EmployeeTrackerTimesheetOutputModel employee = new EmployeeTrackerTimesheetOutputModel();
                            employee.UserId = r[i].UserId;
                            employee.UserName = r[i].UserName;
                            employee.ApplicationTypeName = "Log";
                            employee.CreatedDate = r[i].CreatedDate;
                            employee.ResourceId = r[i].ResourceId;
                            employee.StartTime = r[i].EndTime;
                            if (i == (breakCount - 1))
                            {
                                employee.EndTime = endTime;
                            }
                            else
                            {
                                employee.EndTime = r[i + 1].StartTime;
                            }
                            result.Add(employee);
                        }
                    }
                    else
                    {
                        var r = re.ToArray();
                        result.Add(r[0]);
                    }
                }
            }
            return result;
        }

        public ActivityTrackerTrackingStateOutputModel UpsertUserActivityToken(ActivityTrackerTokenInputModel activityTrackerTokenInputModel, Guid? loggedInUserId, List<ValidationMessage> validationMessages)
        {
            return _activityTrackerRepository.UpsertUserActivityToken(activityTrackerTokenInputModel, loggedInUserId, validationMessages);
        }

        public List<ActivityTrackerUsageOutputModel> GetUserActivityTrackerUsageReport(ActivityTrackerUsageInputModel activityTrackerUsageInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return _activityTrackerRepository.GetUserActivityTrackerUsageReport(activityTrackerUsageInputModel, loggedInContext, validationMessages);
        }

        public bool UpserActivityTrackerUsage(InsertUserActivityInputModel insertUserActivityInputModel, List<ValidationMessage> validationMessages, LoggedInContext loggedInContext)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpserActivityTrackerUsage", "ActivityTrackerService"));

            if (insertUserActivityInputModel != null && !string.IsNullOrEmpty(insertUserActivityInputModel.IdsXML))
            {
                var response = _activityTrackerRepository.UpserActivityTrackerUsage(insertUserActivityInputModel, loggedInContext, validationMessages);

                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpserActivityTrackerUsage", "ActivityTrackerService"));

                return response;
            }

            return false;
        }

        public List<ActivityTrackerMode> GetActivityTrackerModes(List<ValidationMessage> validationMessages, LoggedInContext loggedInContext)
        {
            return _activityTrackerRepository.GetActivityTrackerModes(loggedInContext, validationMessages);
        }

        public bool UpsertActivityTrackerModeConfig(ActivityTrackerModeConfigurationInputModel config, List<ValidationMessage> validationMessages,
            LoggedInContext loggedInContext)
        {
            return _activityTrackerRepository.UpsertActivityTrackerModeConfig(config, loggedInContext, validationMessages);
        }

        public List<ActivityTrackerModeConfigurationOutputModel> GetActivityTrackerModeConfig(List<ValidationMessage> validationMessages, LoggedInContext loggedInContext)
        {
            return _activityTrackerRepository.GetActivityTrackerModeConfig(loggedInContext, validationMessages);
        }

        public TrackerModeOutputModel GetModeType(TrackerModeInputModel trackerModeInput, List<ValidationMessage> validationMessages)
        {
            var siteAddress = string.Copy(trackerModeInput.HostAddress);

            var splits = siteAddress.Split('.');

            trackerModeInput.HostAddress = splits[0];

            return _activityTrackerRepository.GetModeType(trackerModeInput, validationMessages);
        }

        public List<TrackerUserTimelineModel> GetUserTrackerTimeline(EmployeeTrackerSearchInputModel employeeTrackerSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetUserTrackerTimeline", "EmployeeTrackerSearchInputModel", employeeTrackerSearchInputModel, "ActivityTracker Service"));
           
            if (employeeTrackerSearchInputModel.UserId != null && employeeTrackerSearchInputModel.UserId.Count > 0)
            {
                employeeTrackerSearchInputModel.UserIdXml = Utilities.ConvertIntoListXml(employeeTrackerSearchInputModel.UserId.ToArray());
            }
            var resultTimelineDetails = _activityTrackerRepository.GetUserTrackerTimeline(employeeTrackerSearchInputModel, loggedInContext, validationMessages);

            if (resultTimelineDetails.Count > 1)
            {
                for (int i = 0; i + 1 < resultTimelineDetails.Count; i++)
                {
                    int height = Convert.ToInt32((resultTimelineDetails[i + 1].StartedTime - resultTimelineDetails[i].StartedTime).TotalMinutes) * (-1);
                    resultTimelineDetails[i].DifferenceMinutes = (height > 275) ? 275 : height;
                }
            }

            if (resultTimelineDetails.Count() > 0)
            {
                return resultTimelineDetails;
            }
            return null;
        }

        public List<ActivityReportOutputModel> GetActivityReport(ActivityReportInputModel activityReportInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetActivityReport", "EmployeeTrackerSearchInputModel", activityReportInputModel, "ActivityTracker Service"));
            
            if (activityReportInputModel != null && activityReportInputModel.IsForCategories == true)
            {
                return _activityTrackerRepository.GetActivityReport(activityReportInputModel, loggedInContext, validationMessages);
            }
            else if (activityReportInputModel != null && activityReportInputModel.MySelf == true)
            {
                return _activityTrackerRepository.GetActivityReport(activityReportInputModel, loggedInContext, validationMessages);
            }
            else
            {
                return _activityTrackerRepository.GetLeadLevelActivityReport(activityReportInputModel, loggedInContext, validationMessages);
            }
        }

        public List<TeamActivityOutputModel> GetTeamActivity(TeamActivityInputModel teamActivityInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetTeamActivity", "TeamActivityInputModel", teamActivityInputModel, "ActivityTracker Service"));
            
            if (teamActivityInputModel.UserId != null && teamActivityInputModel.UserId.Count > 0)
            {
                teamActivityInputModel.UserIdXml = Utilities.ConvertIntoListXml(teamActivityInputModel.UserId.ToArray());
            }
            if (teamActivityInputModel.RoleId != null && teamActivityInputModel.RoleId.Count > 0)
            {
                teamActivityInputModel.RoleIdXml = Utilities.ConvertIntoListXml(teamActivityInputModel.RoleId.ToArray());
            }
            if (teamActivityInputModel.BranchId != null && teamActivityInputModel.BranchId.Count > 0)
            {
                teamActivityInputModel.BranchIdXml = Utilities.ConvertIntoListXml(teamActivityInputModel.BranchId.ToArray());
            }

            List<TeamActivityOutputModel> result = _activityTrackerRepository.GetTeamActivity(teamActivityInputModel, loggedInContext, validationMessages);

            return result;
        }

        //private List<TrackerUserTimelineModel> GenerateTrackerUserTimeline(List<TrackerUserTimelineModel> employeeTrackerTimelineOutputModel)
        //{
        //    int uniqueNumber = 1;
        //    List<TrackerUserTimelineModel> result = new List<TrackerUserTimelineModel>();
        //    var userTimeLineDetails = employeeTrackerTimelineOutputModel.GroupBy(p => p.UserId).ToList();

        //    foreach (var timeLineDetail in userTimeLineDetails)
        //    {
        //        var timeLineByDate = timeLineDetail.GroupBy(p => p.CreatedDate).ToList();
        //        foreach (var detail in timeLineByDate)
        //        {
        //            var detailsCount = detail.Count();
        //            if (detailsCount > 1)
        //            {
        //                var detailsArray = detail.ToArray();
        //                var endTime = detailsArray[0].End;
        //                var unendedEvent = endTime != null ? -1 : 0;
        //                detailsArray[0].End = detailsArray[1].Start;
        //                detailsArray[0].Id = uniqueNumber;
        //                result.Add(detailsArray[0]);
        //                uniqueNumber++;
        //                for (var i = 1; i < detailsCount; i++)
        //                {
        //                    TrackerUserTimelineModel employee = new TrackerUserTimelineModel();
        //                    employee.UserId = detailsArray[i].UserId;
        //                    employee.FullName = detailsArray[i].FullName;
        //                    employee.Title = detailsArray[i].Title;
        //                    employee.CreatedDate = detailsArray[i].CreatedDate;
        //                    employee.CategoryType = detailsArray[i].CategoryType;
        //                    employee.Start = detailsArray[i].Start;
        //                    employee.Id = uniqueNumber;
        //                    if (i == (detailsCount - 1))
        //                    {
        //                        if (unendedEvent == -1 && detailsArray[i].End == null)
        //                        {
        //                            employee.End = endTime;
        //                        }
        //                        else
        //                        {
        //                            if (detailsArray[i].End == null)
        //                            {
        //                                unendedEvent = -1;
        //                            }
        //                            employee.End = detailsArray[i].End;
        //                        }
        //                        if (employee.End < endTime)
        //                        {
        //                            TrackerUserTimelineModel activeEmployee = new TrackerUserTimelineModel();
        //                            activeEmployee.UserId = detailsArray[i].UserId;
        //                            activeEmployee.FullName = detailsArray[i].FullName;
        //                            activeEmployee.Title = "Active";
        //                            activeEmployee.CreatedDate = detailsArray[i].CreatedDate;
        //                            activeEmployee.CategoryType = "Active";
        //                            activeEmployee.Start = employee.End.Value;
        //                            activeEmployee.End = endTime;
        //                            activeEmployee.Id = uniqueNumber;
        //                            result.Add(activeEmployee);
        //                            uniqueNumber++;
        //                        }
        //                    }
        //                    else
        //                    {
        //                        if (detailsArray[i].End != null && detailsArray[i].CategoryType != "Active" && detailsArray.Length > (i + 1) && detailsArray[i + 1].Start > detailsArray[i].End)
        //                        {
        //                            employee.End = detailsArray[i].End;
        //                            TrackerUserTimelineModel activeEmployee = new TrackerUserTimelineModel();
        //                            activeEmployee.UserId = detailsArray[i].UserId;
        //                            activeEmployee.FullName = detailsArray[i].FullName;
        //                            activeEmployee.Title = "Active";
        //                            activeEmployee.CreatedDate = detailsArray[i].CreatedDate;
        //                            activeEmployee.CategoryType = "Active";
        //                            activeEmployee.Start = detailsArray[i].End.Value;
        //                            activeEmployee.End = detailsArray[i + 1].Start;
        //                            activeEmployee.Id = uniqueNumber;
        //                            result.Add(activeEmployee);
        //                            uniqueNumber++;
        //                        }
        //                        else
        //                        {
        //                            employee.End = detailsArray[i + 1].Start;
        //                        }
        //                    }
        //                    if (unendedEvent == -1 && employee.End > endTime)
        //                    {
        //                        endTime = employee.End;
        //                        unendedEvent = endTime != null ? -1 : i;
        //                    }
        //                    result.Add(employee);
        //                    uniqueNumber++;
        //                }
        //                if (unendedEvent != -1)
        //                {
        //                    TrackerUserTimelineModel employee = new TrackerUserTimelineModel();
        //                    employee.UserId = detailsArray[unendedEvent].UserId;
        //                    employee.FullName = detailsArray[unendedEvent].FullName;
        //                    employee.Title = detailsArray[unendedEvent].Title;
        //                    employee.CreatedDate = detailsArray[unendedEvent].CreatedDate;
        //                    employee.CategoryType = detailsArray[unendedEvent].CategoryType;
        //                    employee.Start = result.Last().End.Value;
        //                    employee.End = null;
        //                    employee.Id = uniqueNumber;
        //                    unendedEvent = -1;
        //                    result.Add(employee);
        //                    uniqueNumber++;
        //                }
        //            }
        //            else
        //            {
        //                var tempArray = detail.ToArray();
        //                tempArray[0].Id = uniqueNumber;
        //                result.Add(tempArray[0]);
        //                uniqueNumber++;
        //            }
        //        }
        //    }
        //    return result;
        //}


        public int GetLateEmployees(ActivityKpiSearchModel activityKpiSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Late Employees", "activityKpiSearchModel", activityKpiSearchModel, "ActivityTracker Service"));
            return _activityTrackerRepository.GetLateEmployee(activityKpiSearchModel, loggedInContext, validationMessages);
        }

        public int GetPresentEmployees(ActivityKpiSearchModel activityKpiSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Present Employees", "activityKpiSearchModel", activityKpiSearchModel, "ActivityTracker Service"));
            return _activityTrackerRepository.GetPresentEmployees(activityKpiSearchModel, loggedInContext, validationMessages);
        }

        public string GetUserStartTime(ActivityKpiSearchModel activityKpiSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetUserStartTime ", "activityKpiSearchModel", activityKpiSearchModel, "ActivityTracker Service"));
            return _activityTrackerRepository.GetUserStartTime(activityKpiSearchModel, loggedInContext, validationMessages);
        }

        public string GetUserFinishTime(ActivityKpiSearchModel activityKpiSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Finish Time ", "activityKpiSearchModel", activityKpiSearchModel, "ActivityTracker Service"));
            return _activityTrackerRepository.GetUserFinishTime(activityKpiSearchModel, loggedInContext, validationMessages);
        }

        public int GetAbsentEmployees(ActivityKpiSearchModel activityKpiSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetAbsentEmployees", "activityKpiSearchModel", activityKpiSearchModel, "ActivityTracker Service"));

            return _activityTrackerRepository.GetAbsentEmployees(activityKpiSearchModel, loggedInContext, validationMessages);
        }

        public List<AvailabilityCalendarOutputModel> GetAvailabilityCalendar(AvailabilityCalendarInputModel availabilityCalendarInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetAvailabilityCalendar", "AvailabilityCalendarInputModel", availabilityCalendarInputModel, "ActivityTracker Service"));

            return _activityTrackerRepository.GetAvailabilityCalendar(availabilityCalendarInputModel, loggedInContext, validationMessages);
        }

        public CompanyStatus GetCompanyStatus(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CompanyStatus result = _activityTrackerRepository.GetCompanyStatus(loggedInContext, validationMessages);
            return result;
        }

        public void SendConfiguredEmailReports()
        {
            var validationMessages = new List<ValidationMessage>();
            List<ScheduledConfigurationsModel> scheduledConfigurations = _activityTrackerRepository.GetScheduledConfigurations(validationMessages);

            foreach (var configuration in scheduledConfigurations)
            {
                configuration.UsersForReminders = JsonConvert.DeserializeObject<List<UsersForEmailModel>>(configuration.UsersJson);

                if (configuration.TemplateName == "UserBirthdayWishesTemplate" && configuration.UsersForReminders.Where(p => p.UserId != null).ToList().Count > 0)
                {
                    SendBirthdayEmailToUser(configuration.CompanyId, configuration.UsersForReminders.Where(p => p.UserId != null).ToList());
                }
                else if (configuration.TemplateName == "BirthdayReminderTemplate" && configuration.UsersForReminders.Count > 0)
                {
                    SendBirthdayEmailReminder(configuration.CompanyId, configuration.UsersForReminders, configuration.SiteUrl);
                }
                else if (configuration.TemplateName == "UserDailyTrackerReportEmailTemplate" && configuration.UsersForReminders.Where(p => p.UserId != null).ToList().Count > 0)
                {
                    SendUserProductiveReportMails(configuration.CompanyId, configuration.UsersForReminders.Where(p => p.UserId != null).ToList());
                }
                else if (configuration.TemplateName == "ManagerDailyAssociateSummaryEmailTemplate" && configuration.UsersForReminders.Where(p => p.UserId != null).ToList().Count > 0)
                {
                    SendAssociatesProductiveReportMails(configuration.CompanyId, configuration.UsersForReminders.Where(p => p.UserId != null).ToList());
                }
                else if (configuration.TemplateName == "CompanyLevelProductivityEmailTemplate" && configuration.UsersForReminders.Count > 0)
                {
                    SendCompanyLevelProductiveReportMails(configuration.CompanyId, configuration.UsersForReminders, configuration.SiteUrl);
                }
            }
        }

        private bool SendCompanyLevelProductiveReportMails(Guid companyId, List<UsersForEmailModel> userTobeNotified, string siteUrl)
        {
            LoggingManager.Info("Entering into SendCompanyLevelProductiveReportMails method in ActivityTrackerService");

            var CurrentDate = DateTime.Now;

            LoggingManager.Info("Fetching CompanyLevelProductivity of date " + CurrentDate);

            List<ValidationMessage> validationMessages = new List<ValidationMessage>();

            CompanySummaryReportModel companyDetails = _activityTrackerRepository.GetCompanyLevelSummaryReport(CurrentDate, companyId, null, validationMessages);

            if (validationMessages.Count > 0)
            {
                LoggingManager.Error("SendCompanyLevelProductiveReportMails failed due to " + validationMessages.FirstOrDefault().ValidationMessaage);
                return false;
            }

            LoggingManager.Info("Fetching email template for SendCompanyLevelProductiveReportMails in ActivityTrackerService");

            var reportHtml = _goalRepository.GetHtmlTemplateByName("CompanyLevelProductivityEmailTemplate", null);

            LoggingManager.Info("Fetching smtp details for companyId " + companyId + " in ActivityTrackerService");

            LoggedInContext loggedInContext = new LoggedInContext
            {
                LoggedInUserId = userTobeNotified.Where(p => p.UserId != null).ToList().Count > 0 ? userTobeNotified.FirstOrDefault(p => p.UserId != null).UserId.Value : Guid.Empty,
                CompanyGuid = companyId
            };

            var smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, new List<ValidationMessage>(), "");

            LoggingManager.Info("got smtp details for companyId " + companyId + " in ActivityTrackerService");

            LoggingManager.Info("Fetched email template for SendCompanyLevelProductiveReportMails in ActivityTrackerService");

            string spacer = " <table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\">"
                       + "   <tbody>"
                       + "     <tr>"
                       + "       <td class=\"o_bg-light o_px-xs\" align=\"center\""
                       + "         style=\"background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;\">"
                       + "         <table class=\"o_block\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\""
                       + "           style=\"max-width: 632px;margin: 0 auto;\">"
                       + "           <tbody>"
                       + "             <tr>"
                       + "               <td class=\"o_bg-white\" style=\"font-size: 20px;line-height: 40px;height: 20px;background-color: #dbe5ea;\">&nbsp; </td>"
                       + "             </tr>"
                       + "           </tbody>"
                       + "         </table>"
                       + "       </td>"
                       + "     </tr>"
                       + "   </tbody>"
                       + " </table>";

            if (string.IsNullOrEmpty(companyDetails.PeopleWorkMoreThanTrackerYesterday))
            {
                reportHtml = reportHtml.Replace("##TrackerWorkedOverTime##", "");
            }
            else
            {
                var appsHtml = "";
                appsHtml = appsHtml + "<table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\">"
                                    + "<tbody>"
                                    + "  <tr>"
                                    + "    <td class=\"o_bg-light o_px-xs\" align=\"center\""
                                    + "      style=\"background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;max-width: 632px;\">"
                                    + "      <table class=\"o_block\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\""
                                    + "        style=\"max-width: 632px;margin: 0 auto; background-color: #ffffff;\">"
                                    + "       <tbody>"
                                    + "       <table class=\"o_block\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\""
                                    + "        style=\"max-width: 632px;margin: 0 auto;\">"
                                    + "       <tbody>"
                                    + "		 <tr>"
                                    + "		    <td class=\"o_bg-white o_px-md o_py o_sans o_text o_text-secondary\" align=\"left\""
                                    + "		      style=\"font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 10px;\">"
                                    + "              <p style=\"margin-top: 10px;margin-bottom: 10px;color: #149a9a;\"><span>People Who Worked More Than Normal Hours Yesterday</span><a href=\"https://" + siteUrl + ".snovasys.io\" style=\"float: right\">go to site..</a></p>";
                var users = JsonConvert.DeserializeObject<List<CompanySummaryBaseModel>>(companyDetails.PeopleWorkMoreThanTrackerYesterday);
                var i = 1;
                users = users.Take(10).ToList();
                foreach (var user in users)
                {
                    appsHtml = appsHtml + "<p style=\"margin-top: 0px;margin-bottom: 3px;margin-left: 10px;\">" + i + ". " + user.Name + "<span style=\"color: green; float: right; margin-right: 200px;\">" + user.Result + "</span></p>";
                    i++;
                }
                appsHtml = appsHtml + "    </td>"
                                    + "			  </tr>"
                                    + "			</tbody>"
                                    + "		  </table>"
                                    + "			</tbody>"
                                    + "		  </table>"
                                    + "        </td>"
                                    + "      </tr>"
                                    + "    </tbody>"
                                    + "  </table>";
                appsHtml = appsHtml + spacer;
                reportHtml = reportHtml.Replace("##TrackerWorkedOverTime##", appsHtml);
            }
            if (string.IsNullOrEmpty(companyDetails.PeopleDidnotFinishTrackerYesterday))
            {
                reportHtml = reportHtml.Replace("##TrackerWorkedLessTime##", "");
            }
            else
            {
                var appsHtml = "";
                appsHtml = appsHtml + "<table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\">"
                                    + "<tbody>"
                                    + "  <tr>"
                                    + "    <td class=\"o_bg-light o_px-xs\" align=\"center\""
                                    + "      style=\"background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;max-width: 632px;\">"
                                    + "      <table class=\"o_block\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\""
                                    + "        style=\"max-width: 632px;margin: 0 auto; background-color: #ffffff;\">"
                                    + "       <tbody>"
                                    + "       <table class=\"o_block\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\""
                                    + "        style=\"max-width: 632px;margin: 0 auto;\">"
                                    + "       <tbody>"
                                    + "		 <tr>"
                                    + "		    <td class=\"o_bg-white o_px-md o_py o_sans o_text o_text-secondary\" align=\"left\""
                                    + "		      style=\"font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 10px;\">"
                                    + "              <p style=\"margin-top: 10px;margin-bottom: 10px;color: #149a9a;\"><span>People Who Didn't Finish Tracker Time Yesterday</span><a href=\"https://" + siteUrl + ".snovasys.io\" style=\"float: right\">go to site..</a></p>";
                var users = JsonConvert.DeserializeObject<List<CompanySummaryBaseModel>>(companyDetails.PeopleDidnotFinishTrackerYesterday);
                var i = 1;
                users = users.Take(10).ToList();
                foreach (var user in users)
                {
                    appsHtml = appsHtml + "<p style=\"margin-top: 0px;margin-bottom: 3px;margin-left: 10px;\">" + i + ". " + user.Name + "<span style=\"color: #dd4a68; float: right; margin-right: 200px;\">" + user.Result + "</span></p>";
                    i++;
                }
                appsHtml = appsHtml + "    </td>"
                                    + "			  </tr>"
                                    + "			</tbody>"
                                    + "		  </table>"
                                    + "			</tbody>"
                                    + "		  </table>"
                                    + "        </td>"
                                    + "      </tr>"
                                    + "    </tbody>"
                                    + "  </table>";
                appsHtml = appsHtml + spacer;
                reportHtml = reportHtml.Replace("##TrackerWorkedLessTime##", appsHtml);
            }
            if (string.IsNullOrEmpty(companyDetails.PeopleLeaveYesterday))
            {
                reportHtml = reportHtml.Replace("##UsersLeaveYesterday##", "");
            }
            else
            {
                var appsHtml = "";
                appsHtml = appsHtml + "<table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\">"
                                    + "<tbody>"
                                    + "  <tr>"
                                    + "    <td class=\"o_bg-light o_px-xs\" align=\"center\""
                                    + "      style=\"background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;max-width: 632px;\">"
                                    + "      <table class=\"o_block\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\""
                                    + "        style=\"max-width: 632px;margin: 0 auto; background-color: #ffffff;\">"
                                    + "       <tbody>"
                                    + "       <table class=\"o_block\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\""
                                    + "        style=\"max-width: 632px;margin: 0 auto;\">"
                                    + "       <tbody>"
                                    + "		 <tr>"
                                    + "		    <td class=\"o_bg-white o_px-md o_py o_sans o_text o_text-secondary\" align=\"left\""
                                    + "		      style=\"font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 10px;\">"
                                    + "              <p style=\"margin-top: 10px;margin-bottom: 10px;color: #149a9a;\"><span>People Who Are On Leave Yesterday</span><a href=\"https://" + siteUrl + ".snovasys.io\" style=\"float: right\">go to site..</a></p>";
                var users = JsonConvert.DeserializeObject<List<CompanySummaryBaseModel>>(companyDetails.PeopleLeaveYesterday);
                var i = 1;
                users = users.Take(10).ToList();
                foreach (var user in users)
                {
                    appsHtml = appsHtml + "<p style=\"margin-top: 0px;margin-bottom: 3px;margin-left: 10px;\">" + i + ". " + user.Name + " - " + user.Result + "</p>";
                    i++;
                }
                appsHtml = appsHtml + "    </td>"
                                    + "			  </tr>"
                                    + "			</tbody>"
                                    + "		  </table>"
                                    + "			</tbody>"
                                    + "		  </table>"
                                    + "        </td>"
                                    + "      </tr>"
                                    + "    </tbody>"
                                    + "  </table>";
                appsHtml = appsHtml + spacer;
                reportHtml = reportHtml.Replace("##UsersLeaveYesterday##", appsHtml);
            }
            if (string.IsNullOrEmpty(companyDetails.PeopleLateToday))
            {
                reportHtml = reportHtml.Replace("##UsersLateYesterday##", "");
            }
            else
            {
                var appsHtml = "";
                appsHtml = appsHtml + "<table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\">"
                                    + "<tbody>"
                                    + "  <tr>"
                                    + "    <td class=\"o_bg-light o_px-xs\" align=\"center\""
                                    + "      style=\"background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;max-width: 632px;\">"
                                    + "      <table class=\"o_block\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\""
                                    + "        style=\"max-width: 632px;margin: 0 auto; background-color: #ffffff;\">"
                                    + "       <tbody>"
                                    + "       <table class=\"o_block\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\""
                                    + "        style=\"max-width: 632px;margin: 0 auto;\">"
                                    + "       <tbody>"
                                    + "		 <tr>"
                                    + "		    <td class=\"o_bg-white o_px-md o_py o_sans o_text o_text-secondary\" align=\"left\""
                                    + "		      style=\"font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 10px;\">"
                                    + "              <p style=\"margin-top: 10px;margin-bottom: 10px;color: #149a9a;\"><span>People Who Started Late Yesterday</span><a href=\"https://" + siteUrl + ".snovasys.io\" style=\"float: right\">go to site..</a></p>";
                var users = JsonConvert.DeserializeObject<List<CompanySummaryBaseModel>>(companyDetails.PeopleLateToday);
                var i = 1;
                users = users.Take(10).ToList();
                foreach (var user in users)
                {
                    appsHtml = appsHtml + "<p style=\"margin-top: 0px;margin-bottom: 3px;margin-left: 10px;\">" + i + ". " + user.Name + " was late by <span style=\"color: red\">" + user.Result + "</p>";
                    i++;
                }
                appsHtml = appsHtml + "    </td>"
                                    + "			  </tr>"
                                    + "			</tbody>"
                                    + "		  </table>"
                                    + "			</tbody>"
                                    + "		  </table>"
                                    + "        </td>"
                                    + "      </tr>"
                                    + "    </tbody>"
                                    + "  </table>";
                appsHtml = appsHtml + spacer;
                reportHtml = reportHtml.Replace("##UsersLateYesterday##", appsHtml);
            }
            if (string.IsNullOrEmpty(companyDetails.PeopleLeaveToday))
            {
                reportHtml = reportHtml.Replace("##UsersLeaveToday##", "");
            }
            else
            {
                var appsHtml = "";
                appsHtml = appsHtml + "<table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\">"
                                    + "<tbody>"
                                    + "  <tr>"
                                    + "    <td class=\"o_bg-light o_px-xs\" align=\"center\""
                                    + "      style=\"background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;max-width: 632px;\">"
                                    + "      <table class=\"o_block\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\""
                                    + "        style=\"max-width: 632px;margin: 0 auto; background-color: #ffffff;\">"
                                    + "       <tbody>"
                                    + "       <table class=\"o_block\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\""
                                    + "        style=\"max-width: 632px;margin: 0 auto;\">"
                                    + "       <tbody>"
                                    + "		 <tr>"
                                    + "		    <td class=\"o_bg-white o_px-md o_py o_sans o_text o_text-secondary\" align=\"left\""
                                    + "		      style=\"font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 10px;\">"
                                    + "              <p style=\"margin-top: 10px;margin-bottom: 10px;color: #149a9a;\"><span>People Who Are On Leave Today</span><a href=\"https://" + siteUrl + ".snovasys.io\" style=\"float: right\">go to site..</a></p>";
                var users = JsonConvert.DeserializeObject<List<CompanySummaryBaseModel>>(companyDetails.PeopleLeaveToday);
                var i = 1;
                users = users.Take(10).ToList();
                foreach (var user in users)
                {
                    appsHtml = appsHtml + "<p style=\"margin-top: 0px;margin-bottom: 3px;margin-left: 10px;\">" + i + ". " + user.Name + " - " + user.Result + "</p>";
                    i++;
                }
                appsHtml = appsHtml + "    </td>"
                                    + "			  </tr>"
                                    + "			</tbody>"
                                    + "		  </table>"
                                    + "			</tbody>"
                                    + "		  </table>"
                                    + "        </td>"
                                    + "      </tr>"
                                    + "    </tbody>"
                                    + "  </table>";
                appsHtml = appsHtml + spacer;
                reportHtml = reportHtml.Replace("##UsersLeaveToday##", appsHtml);
            }
            if (string.IsNullOrEmpty(companyDetails.BirthdayToday))
            {
                reportHtml = reportHtml.Replace("##UsersBirthdayToday##", "");
            }
            else
            {
                var appsHtml = "";
                appsHtml = appsHtml + "<table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\">"
                                    + "<tbody>"
                                    + "  <tr>"
                                    + "    <td class=\"o_bg-light o_px-xs\" align=\"center\""
                                    + "      style=\"background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;max-width: 632px;\">"
                                    + "      <table class=\"o_block\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\""
                                    + "        style=\"max-width: 632px;margin: 0 auto; background-color: #ffffff;\">"
                                    + "       <tbody>"
                                    + "       <table class=\"o_block\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\""
                                    + "        style=\"max-width: 632px;margin: 0 auto;\">"
                                    + "       <tbody>"
                                    + "		 <tr>"
                                    + "		    <td class=\"o_bg-white o_px-md o_py o_sans o_text o_text-secondary\" align=\"left\""
                                    + "		      style=\"font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 10px;\">"
                                    + "              <p style=\"margin-top: 10px;margin-bottom: 10px;color: #149a9a;\"><span>People Who Are Celebrating Their Birthday</span><a href=\"https://" + siteUrl + ".snovasys.io\" style=\"float: right\">go to site..</a></p>";
                var users = JsonConvert.DeserializeObject<List<CompanySummaryBaseModel>>(companyDetails.BirthdayToday);
                var i = 1;
                users = users.Take(10).ToList();
                foreach (var user in users)
                {
                    appsHtml = appsHtml + "<p style=\"margin-top: 0px;margin-bottom: 3px;margin-left: 10px;\">" + i + ". " + user.Name + "</p>";
                    i++;
                }
                appsHtml = appsHtml + "            </td>"
                                    + "			  </tr>"
                                    + "			</tbody>"
                                    + "		  </table>"
                                    + "			</tbody>"
                                    + "		  </table>"
                                    + "        </td>"
                                    + "      </tr>"
                                    + "    </tbody>"
                                    + "  </table>";
                appsHtml = appsHtml + spacer;
                reportHtml = reportHtml.Replace("##UsersBirthdayToday##", appsHtml);
            }
            if (string.IsNullOrEmpty(companyDetails.OfficeAnniversaryToday))
            {
                reportHtml = reportHtml.Replace("##UsersWorkAnniversaryToday##", "");
            }
            else
            {
                var appsHtml = "";
                appsHtml = appsHtml + "<table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\">"
                                    + "<tbody>"
                                    + "  <tr>"
                                    + "    <td class=\"o_bg-light o_px-xs\" align=\"center\""
                                    + "      style=\"background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;max-width: 632px;\">"
                                    + "      <table class=\"o_block\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\""
                                    + "        style=\"max-width: 632px;margin: 0 auto; background-color: #ffffff;\">"
                                    + "       <tbody>"
                                    + "       <table class=\"o_block\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\""
                                    + "        style=\"max-width: 632px;margin: 0 auto;\">"
                                    + "       <tbody>"
                                    + "		 <tr>"
                                    + "		    <td class=\"o_bg-white o_px-md o_py o_sans o_text o_text-secondary\" align=\"left\""
                                    + "		      style=\"font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 10px;\">"
                                    + "              <p style=\"margin-top: 10px;margin-bottom: 10px;color: #149a9a;\"><span>People Who Are Celebrating Their Work Anniversary</span><a href=\"https://" + siteUrl + ".snovasys.io\" style=\"float: right\">go to site..</a></p>";
                var users = JsonConvert.DeserializeObject<List<CompanySummaryBaseModel>>(companyDetails.OfficeAnniversaryToday);
                var i = 1;
                users = users.Take(10).ToList();
                foreach (var user in users)
                {
                    appsHtml = appsHtml + "<p style=\"margin-top: 0px;margin-bottom: 3px;margin-left: 10px;\">" + i + ". " + user.Name + "</p>";
                    i++;
                }
                appsHtml = appsHtml + "            </td>"
                                    + "			  </tr>"
                                    + "			</tbody>"
                                    + "		  </table>"
                                    + "			</tbody>"
                                    + "		  </table>"
                                    + "        </td>"
                                    + "      </tr>"
                                    + "    </tbody>"
                                    + "  </table>";
                appsHtml = appsHtml + spacer;
                reportHtml = reportHtml.Replace("##UsersWorkAnniversaryToday##", appsHtml);
            }
            if (string.IsNullOrEmpty(companyDetails.MarriageAnniversaryToday))
            {
                reportHtml = reportHtml.Replace("##UsersMarriageAnniversaryToday##", "");
            }
            else
            {
                var appsHtml = "";
                appsHtml = appsHtml + "<table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\">"
                                    + "<tbody>"
                                    + "  <tr>"
                                    + "    <td class=\"o_bg-light o_px-xs\" align=\"center\""
                                    + "      style=\"background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;max-width: 632px;\">"
                                    + "      <table class=\"o_block\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\""
                                    + "        style=\"max-width: 632px;margin: 0 auto; background-color: #ffffff;\">"
                                    + "       <tbody>"
                                    + "       <table class=\"o_block\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\""
                                    + "        style=\"max-width: 632px;margin: 0 auto;\">"
                                    + "       <tbody>"
                                    + "		 <tr>"
                                    + "		    <td class=\"o_bg-white o_px-md o_py o_sans o_text o_text-secondary\" align=\"left\""
                                    + "		      style=\"font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 10px;\">"
                                    + "              <p style=\"margin-top: 10px;margin-bottom: 10px;color: #149a9a;\"><span>People Who Are Celebrating Their Marriage Anniversary</span><a href=\"https://" + siteUrl + ".snovasys.io\" style=\"float: right\">go to site..</a></p>";
                var users = JsonConvert.DeserializeObject<List<CompanySummaryBaseModel>>(companyDetails.MarriageAnniversaryToday);
                var i = 1;
                users = users.Take(10).ToList();
                foreach (var user in users)
                {
                    appsHtml = appsHtml + "<p style=\"margin-top: 0px;margin-bottom: 3px;margin-left: 10px;\">" + i + ". " + user.Name + "</p>";
                    i++;
                }
                appsHtml = appsHtml + "             </td>"
                                    + "			  </tr>"
                                    + "			</tbody>"
                                    + "		  </table>"
                                    + "			</tbody>"
                                    + "		  </table>"
                                    + "        </td>"
                                    + "      </tr>"
                                    + "    </tbody>"
                                    + "  </table>";
                appsHtml = appsHtml + spacer;
                reportHtml = reportHtml.Replace("##UsersMarriageAnniversaryToday##", appsHtml);
            }
            reportHtml = reportHtml.Replace("##Date##", CurrentDate.ToString("MMM d, yyyy", new System.Globalization.CultureInfo("en-US")));

            LoggingManager.Info("Sending birthday email to " + userTobeNotified.Select(p => p.Email).ToString() + " in ActivityTrackerService");

            TaskWrapper.ExecuteFunctionInNewThread(() =>
            {
                EmailGenericModel emailModel = new EmailGenericModel
                {
                    SmtpServer = smtpDetails?.SmtpServer,
                    SmtpServerPort = smtpDetails?.SmtpServerPort,
                    SmtpMail = smtpDetails?.SmtpMail,
                    SmtpPassword = smtpDetails?.SmtpPassword,
                    ToAddresses = userTobeNotified.Select(p => p.Email).ToArray(),
                    HtmlContent = reportHtml,
                    Subject = "Team summary report for " + CurrentDate.ToString("MMM d, yyyy", new System.Globalization.CultureInfo("en-US")),
                    MailAttachments = null,
                    IsPdf = null
                };
                _emailService.SendMail(loggedInContext, emailModel);
            });

            return true;
        }

        private bool SendBirthdayEmailToUser(Guid companyId, List<UsersForEmailModel> usersTobeNotified)
        {
            LoggingManager.Info("Entering into SendBirthdayEmailToUser method in ActivityTrackerService");

            var CurrentDate = DateTime.Now;

            SmtpDetailsModel smtpDetails = null;

            LoggingManager.Info("Fetching Users with birthdays on date " + CurrentDate);

            List<ValidationMessage> validationMessages = new List<ValidationMessage>();

            List<UserOutputModel> usersForWishing = _activityTrackerRepository.GetUsersCelebratingTheirBirthday(CurrentDate, companyId, validationMessages);

            if (validationMessages.Count > 0)
            {
                LoggingManager.Error("Sending SendBirthdayEmailToUser failed due to " + validationMessages.FirstOrDefault().ValidationMessaage);
                return false;
            }

            LoggingManager.Info("Fetching email template for SendBirthdayEmailToUser in ActivityTrackerService");

            var birthdayTemplate = _goalRepository.GetHtmlTemplateByName("UserBirthdayWishesTemplate", null);

            LoggingManager.Info("Fetched email template for SendBirthdayEmailToUser in ActivityTrackerService");

            if (usersForWishing.Where(p => usersTobeNotified.Any(q => q.UserId.Equals(p.UserId))).ToList().Count > 0)
            {
                foreach (var userDetails in usersForWishing.Where(p => usersTobeNotified.Any(q => q.UserId.Equals(p.UserId))).ToList())
                {

                    LoggingManager.Info("Framing Summary report template for " + userDetails.FullName + " in ActivityTrackerService");

                    LoggedInContext loggedInContext = new LoggedInContext
                    {
                        LoggedInUserId = userDetails.UserId.Value,
                        CompanyGuid = userDetails.CompanyId
                    };

                    if (smtpDetails == null)
                    {
                        LoggingManager.Info("Fetching smtp details for companyId " + userDetails.CompanyId + " in ActivityTrackerService");

                        smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, new List<ValidationMessage>(), "");

                        LoggingManager.Info("got smtp details for companyId " + userDetails.CompanyId + " in ActivityTrackerService");
                    }

                    string html = string.Copy(birthdayTemplate);
                    html = html.Replace("##userName##", userDetails.FullName);

                    LoggingManager.Info("Sending birthday email to " + userDetails.Email + " in ActivityTrackerService");

                    TaskWrapper.ExecuteFunctionInNewThread(() =>
                    {
                        EmailGenericModel emailModel = new EmailGenericModel
                        {
                            SmtpServer = smtpDetails?.SmtpServer,
                            SmtpServerPort = smtpDetails?.SmtpServerPort,
                            SmtpMail = smtpDetails?.SmtpMail,
                            SmtpPassword = smtpDetails?.SmtpPassword,
                            ToAddresses = new string[] { userDetails.Email },
                            HtmlContent = html,
                            Subject = "Happy birthday " + userDetails.FullName + " !!",
                            MailAttachments = null,
                            IsPdf = null
                        };
                        _emailService.SendMail(loggedInContext, emailModel);
                    });
                }
            }
            return true;
        }

        private bool SendBirthdayEmailReminder(Guid companyId, List<UsersForEmailModel> usersTobeNotified, string siteUrl)
        {
            LoggingManager.Info("Entering into SendBirthdayEmailReminder method in ActivityTrackerService");

            var CurrentDate = DateTime.Now.AddDays(1);

            SmtpDetailsModel smtpDetails = null;

            LoggingManager.Info("Fetching Users with birthdays on date " + CurrentDate);

            List<ValidationMessage> validationMessages = new List<ValidationMessage>();

            List<UserOutputModel> usersForWishing = _activityTrackerRepository.GetUsersCelebratingTheirBirthday(CurrentDate, companyId, validationMessages);

            if (validationMessages.Count > 0)
            {
                LoggingManager.Error("Sending SendBirthdayEmailReminder failed due to " + validationMessages.FirstOrDefault().ValidationMessaage);
                return false;
            }

            LoggingManager.Info("Fetching email template for SendBirthdayEmailReminder in ActivityTrackerService");

            var birthdayTemplate = _goalRepository.GetHtmlTemplateByName("BirthdayReminderTemplate", null);

            LoggingManager.Info("Fetched email template for SendBirthdayEmailReminder in ActivityTrackerService");

            if (usersForWishing.Count > 0)
            {
                LoggedInContext loggedInContext = new LoggedInContext
                {
                    LoggedInUserId = usersForWishing.Where(p => p.UserId != null).ToList().Count > 0 ? usersForWishing.FirstOrDefault(p => p.UserId != null).UserId.Value : Guid.Empty,
                    CompanyGuid = companyId
                };

                if (smtpDetails == null)
                {
                    LoggingManager.Info("Fetching smtp details for companyId " + companyId + " in ActivityTrackerService");

                    smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, new List<ValidationMessage>(), "");

                    LoggingManager.Info("got smtp details for companyId " + companyId + " in ActivityTrackerService");
                }

                var html = string.Empty;
                foreach (var userDetails in usersForWishing)
                {
                    LoggingManager.Info("Framing Summary report template for " + userDetails.FullName + " in ActivityTrackerService");

                    html = html + "<p style=\"margin-top: 5px; margin-bottom: 0px;\"><a href=\"https://" + siteUrl + ".snovasys.io/dashboard/profile/" + userDetails.UserId + "/overview\" target=\"_blank\" style=\"cursor: pointer;font-weight: bold; color: #ff2ca7;font-style: italic;\">" + userDetails.FullName + "</a></p>";
                }

                birthdayTemplate = birthdayTemplate.Replace("##BirthdaysList##", html);

                foreach (var configuredUser in usersTobeNotified)
                {
                    var modifiedHtml = string.Copy(birthdayTemplate);

                    modifiedHtml = modifiedHtml.Replace("##userName##", configuredUser.UserName).Replace("##Date##", CurrentDate.ToString("MMM d, yyyy", new System.Globalization.CultureInfo("en-US")));

                    LoggingManager.Info("Sending birthday reminders email to " + configuredUser.Email + " in ActivityTrackerService");

                    TaskWrapper.ExecuteFunctionInNewThread(() =>
                    {
                        EmailGenericModel emailModel = new EmailGenericModel
                        {
                            SmtpServer = smtpDetails?.SmtpServer,
                            SmtpServerPort = smtpDetails?.SmtpServerPort,
                            SmtpMail = smtpDetails?.SmtpMail,
                            SmtpPassword = smtpDetails?.SmtpPassword,
                            ToAddresses = new string[] { configuredUser.Email },
                            HtmlContent = modifiedHtml,
                            Subject = "Birthday reminder",
                            MailAttachments = null,
                            IsPdf = null
                        };
                        _emailService.SendMail(loggedInContext, emailModel);
                    });

                }
            }
            return true;
        }

        private bool SendUserProductiveReportMails(Guid companyId, List<UsersForEmailModel> usersTobeNotified)
        {
            LoggingManager.Info("Entering into SendTrackerReportEmails method in ActivityTrackerService");

            var CurrentDate = DateTime.Now.AddDays(-1);

            LoggingManager.Info("Fetching TrackerReports of date " + CurrentDate);

            List<ValidationMessage> validationMessages = new List<ValidationMessage>();

            List<UserDailyReminderModel> usersForReminers = _activityTrackerRepository.GetUserTrackerReports(CurrentDate, companyId, null, validationMessages);

            if (validationMessages.Count > 0)
            {
                LoggingManager.Error("Sending TrackerReportEmails failed due to " + validationMessages.FirstOrDefault().ValidationMessaage);
                return false;
            }

            if (usersForReminers.Count == 0)
            {
                return true;
            }

            LoggingManager.Info("Fetching email template for SendTrackerReportEmails in ActivityTrackerService");

            var reportHtml = _goalRepository.GetHtmlTemplateByName("UserDailyTrackerReportEmailTemplate", null);

            SmtpDetailsModel smtpDetails = null;

            LoggingManager.Info("Fetched email template for SendTrackerReportEmails in ActivityTrackerService");

            if (usersForReminers.Where(p => usersTobeNotified.Any(q => q.UserId.Equals(p.UserId))).ToList().Count > 0)
            {
                foreach (var userDetails in usersForReminers.Where(p => usersTobeNotified.Any(q => q.UserId.Equals(p.UserId))).ToList())
                {

                    LoggingManager.Info("Framing Summary report template for " + userDetails.UserName + " in ActivityTrackerService");

                    LoggedInContext loggedInContext = new LoggedInContext
                    {
                        LoggedInUserId = userDetails.UserId,
                        CompanyGuid = userDetails.CompanyId
                    };
                    if (smtpDetails == null)
                    {

                        LoggingManager.Info("Fetching smtp details for companyId " + userDetails.CompanyId + " in ActivityTrackerService");

                        smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, new List<ValidationMessage>(), "");

                        LoggingManager.Info("got smtp details for companyId " + userDetails.CompanyId + " in ActivityTrackerService");
                    }
                    string html = GenerateUserProductiveChart(reportHtml, userDetails);

                    LoggingManager.Info("Completed generating summary report email template for " + userDetails.UserName + " in ActivityTrackerService");

                    TaskWrapper.ExecuteFunctionInNewThread(() =>
                    {
                        EmailGenericModel emailModel = new EmailGenericModel
                        {
                            SmtpServer = smtpDetails?.SmtpServer,
                            SmtpServerPort = smtpDetails?.SmtpServerPort,
                            SmtpMail = smtpDetails?.SmtpMail,
                            SmtpPassword = smtpDetails?.SmtpPassword,
                            ToAddresses = new string[] { userDetails.UserEmail },
                            HtmlContent = html,
                            Subject = "Daily summary report - " + CurrentDate.ToString("MMM d, yyyy", new System.Globalization.CultureInfo("en-US")),
                            MailAttachments = null,
                            IsPdf = null
                        };

                        LoggingManager.Info("Sending generated summary report email to " + userDetails.UserEmail + " in ActivityTrackerService");

                        _emailService.SendMail(loggedInContext, emailModel);
                    });
                }
            }
            return true;
        }

        private string GenerateUserProductiveChart(string reportHtml, UserDailyReminderModel userDetails)
        {
            var html = String.Copy(reportHtml);
            var CurrentDate = DateTime.Now.AddDays(-1);

            html = html.Replace("##CurrentDate##", CurrentDate.ToString("MMM d, yyyy", new System.Globalization.CultureInfo("en-US")));
            html = html.Replace("##userName##", userDetails.UserName);
            html = html.Replace("##AssociateName##", userDetails.UserName);
            html = html.Replace("##TotalDeskTime##", string.IsNullOrEmpty(userDetails.TotalDeskTime) ? "0h 0m" : userDetails.TotalDeskTime);
            html = html.Replace("##TotalProductiveTime##", string.IsNullOrEmpty(userDetails.ProductiveTime) ? "0h 0m" : userDetails.ProductiveTime);
            html = html.Replace("##TotalIdleTime##", string.IsNullOrEmpty(userDetails.TotalIdleTime) ? "0h 0m" : userDetails.TotalIdleTime);

            string spacer = " <table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\">"
                       + "   <tbody>"
                       + "     <tr>"
                       + "       <td class=\"o_bg-light o_px-xs\" align=\"center\""
                       + "         style=\"background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;\">"
                       + "         <table class=\"o_block\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\""
                       + "           style=\"max-width: 632px;margin: 0 auto;\">"
                       + "           <tbody>"
                       + "             <tr>"
                       + "               <td class=\"o_bg-white\" style=\"font-size: 20px;line-height: 40px;height: 20px;background-color: #dbe5ea;\">&nbsp; </td>"
                       + "             </tr>"
                       + "           </tbody>"
                       + "         </table>"
                       + "       </td>"
                       + "     </tr>"
                       + "   </tbody>"
                       + " </table>";

            var isSpacerAdded = false;

            if (string.IsNullOrEmpty(userDetails.MostUsedApps))
            {
                html = html.Replace("##MostlyUsedApps##", "");
            }
            else
            {
                var appsHtml = "";
                if (isSpacerAdded == false)
                {
                    isSpacerAdded = true;
                    appsHtml = appsHtml + spacer;
                }
                appsHtml = appsHtml + "<table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\">"
                                    + "<tbody>"
                                    + "  <tr>"
                                    + "    <td class=\"o_bg-light o_px-xs\" align=\"center\""
                                    + "      style=\"background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;max-width: 632px;\">"
                                    + "      <table class=\"o_block\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\""
                                    + "        style=\"max-width: 632px;margin: 0 auto; background-color: #ffffff;\">"
                                    + "       <tbody>"
                                    + "       <table class=\"o_block\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\""
                                    + "        style=\"max-width: 632px;margin: 0 auto;\">"
                                    + "       <tbody>"
                                    + "		 <tr>"
                                    + "		    <td class=\"o_bg-white o_px-md o_py o_sans o_text o_text-secondary\" align=\"left\""
                                    + "		      style=\"font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 10px;\">"
                                    + "              <p style=\"margin-top: 10px;margin-bottom: 10px;color: #149a9a;\"><span>Most Used Applications & Websites</span></p>";
                var apps = Utilities.GetObjectFromXml<ApplicationReportModel>(userDetails.MostUsedApps, "ApplicationReports");
                apps = apps.Take(5).ToList();
                foreach (var app in apps)
                {
                    appsHtml = appsHtml + "<p style=\"margin-top: 0px;margin-bottom: 3px;margin-left: 0px;\"><span style = \"color: #00675b; font-size: 35px; font-weight: bold;\" >.</span> " + app.ApplicationName + " </p>";
                }
                appsHtml = appsHtml + "             </td>"
                                    + "			  </tr>"
                                    + "			</tbody>"
                                    + "		  </table>"
                                    + "			</tbody>"
                                    + "		  </table>"
                                    + "        </td>"
                                    + "      </tr>"
                                    + "    </tbody>"
                                    + "  </table>";
                appsHtml = appsHtml + spacer;
                html = html.Replace("##MostlyUsedApps##", appsHtml);
            }

            if (string.IsNullOrEmpty(userDetails.Commits))
            {
                html = html.Replace("##CommitDetails##", "");
            }
            else
            {
                var appsHtml = "";
                if (isSpacerAdded == false)
                {
                    isSpacerAdded = true;
                    appsHtml = appsHtml + spacer;
                }
                appsHtml = appsHtml + "<table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\">"
                                    + "<tbody>"
                                    + "  <tr>"
                                    + "    <td class=\"o_bg-light o_px-xs\" align=\"center\""
                                    + "      style=\"background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;max-width: 632px;\">"
                                    + "      <table class=\"o_block\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\""
                                    + "        style=\"max-width: 632px;margin: 0 auto; background-color: #ffffff;\">"
                                    + "       <tbody>"
                                    + "       <table class=\"o_block\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\""
                                    + "        style=\"max-width: 632px;margin: 0 auto;\">"
                                    + "       <tbody>"
                                    + "		 <tr>"
                                    + "		    <td class=\"o_bg-white o_px-md o_py o_sans o_text o_text-secondary\" align=\"left\""
                                    + "		      style=\"font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 10px;\">"
                                    + "              <p style=\"margin-top: 10px;margin-bottom: 10px;color: #149a9a;\"><span>Repository Commits Done</span></p>";
                var commits = userDetails.Commits.Split('$').ToList();
                commits = commits.Take(5).ToList();
                foreach (var commit in commits)
                {
                    var commitMessage = commit.Trim().Length > 50 ? commit.Trim().Substring(0, 48) + ".." : commit.Trim();
                    appsHtml = appsHtml + "<p style=\"margin-top: 0px;margin-bottom: 3px;margin-left: 0px;\"><span style = \"color: #00675b; font-size: 35px; font-weight: bold;\" >.</span> " + commitMessage + " </p>";
                }
                appsHtml = appsHtml + "             </td>"
                                    + "			  </tr>"
                                    + "			</tbody>"
                                    + "		  </table>"
                                    + "			</tbody>"
                                    + "		  </table>"
                                    + "        </td>"
                                    + "      </tr>"
                                    + "    </tbody>"
                                    + "  </table>";
                appsHtml = appsHtml + spacer;
                html = html.Replace("##CommitDetails##", appsHtml);
            }


            if (string.IsNullOrEmpty(userDetails.WorkItemsActivity))
            {
                html = html.Replace("##WorkItemActivity##", "");
            }
            else
            {
                var appsHtml = "";
                if (isSpacerAdded == false)
                {
                    isSpacerAdded = true;
                    appsHtml = appsHtml + spacer;
                }
                appsHtml = appsHtml + "<table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\">"
                                    + "<tbody>"
                                    + "  <tr>"
                                    + "    <td class=\"o_bg-light o_px-xs\" align=\"center\""
                                    + "      style=\"background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;max-width: 632px;\">"
                                    + "      <table class=\"o_block\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\""
                                    + "        style=\"max-width: 632px;margin: 0 auto; background-color: #ffffff;\">"
                                    + "       <tbody>"
                                    + "       <table class=\"o_block\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\""
                                    + "        style=\"max-width: 632px;margin: 0 auto;\">"
                                    + "       <tbody>"
                                    + "		 <tr>"
                                    + "		    <td class=\"o_bg-white o_px-md o_py o_sans o_text o_text-secondary\" align=\"left\""
                                    + "		      style=\"font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 10px;\">"
                                    + "              <p style=\"margin-top: 10px;margin-bottom: 10px;color: #149a9a;\"><span>Activity Related To Work Items</span></p>";
                var userStories = Utilities.GetObjectFromXml<LoggedUserStories>(userDetails.WorkItemsActivity, "WorkItemsActivity").ToList();
                userStories = userStories.Take(5).ToList();
                foreach (var userStory in userStories)
                {
                    appsHtml = appsHtml + "<p style=\"margin-top: 0px;margin-bottom: 3px;margin-left: 0px;\"><span style=\"color: #00675b\">" + userStory.UserStoryUniqueName + ": </span> " + userStory.UserStoryName.Trim() + " - <span style=\"color: " + userStory.StatusColor + " \">" + userStory.CurrentStatus + "</span></p>";
                }
                appsHtml = appsHtml + "             </td>"
                                    + "			  </tr>"
                                    + "			</tbody>"
                                    + "		  </table>"
                                    + "			</tbody>"
                                    + "		  </table>"
                                    + "        </td>"
                                    + "      </tr>"
                                    + "    </tbody>"
                                    + "  </table>";
                appsHtml = appsHtml + spacer;
                html = html.Replace("##WorkItemActivity##", appsHtml);
            }

            if (string.IsNullOrEmpty(userDetails.LoggedWorkItems))
            {
                html = html.Replace("##LoggedWorkItems##", "");
            }
            else
            {
                var appsHtml = "";
                if (isSpacerAdded == false)
                {
                    isSpacerAdded = true;
                    appsHtml = appsHtml + spacer;
                }
                appsHtml = appsHtml + "<table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\">"
                                    + "<tbody>"
                                    + "  <tr>"
                                    + "    <td class=\"o_bg-light o_px-xs\" align=\"center\""
                                    + "      style=\"background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;max-width: 632px;\">"
                                    + "      <table class=\"o_block\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\""
                                    + "        style=\"max-width: 632px;margin: 0 auto; background-color: #ffffff;\">"
                                    + "       <tbody>"
                                    + "       <table class=\"o_block\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\""
                                    + "        style=\"max-width: 632px;margin: 0 auto;\">"
                                    + "       <tbody>"
                                    + "		 <tr>"
                                    + "		    <td class=\"o_bg-white o_px-md o_py o_sans o_text o_text-secondary\" align=\"left\""
                                    + "		      style=\"font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 10px;\">"
                                    + "              <p style=\"margin-top: 10px;margin-bottom: 10px;color: #149a9a;\"><span>Work Log Related Details</span></p>";
                var userStories = Utilities.GetObjectFromXml<LoggedUserStories>(userDetails.LoggedWorkItems, "WorkItemsLog");
                userStories = userStories.Take(5).ToList();
                foreach (var userStory in userStories)
                {
                    appsHtml = appsHtml + "<p style=\"margin-top: 0px;margin-bottom: 3px;margin-left: 0px;\"><span style=\"color: #00675b\">" + userStory.UserStoryUniqueName + ": </span> " + userStory.UserStoryName.Trim() + " - " + userStory.SpentTime + "</p>";
                }
                appsHtml = appsHtml + "             </td>"
                                    + "			  </tr>"
                                    + "			</tbody>"
                                    + "		  </table>"
                                    + "			</tbody>"
                                    + "		  </table>"
                                    + "        </td>"
                                    + "      </tr>"
                                    + "    </tbody>"
                                    + "  </table>";
                appsHtml = appsHtml + spacer;
                html = html.Replace("##LoggedWorkItems##", appsHtml);
            }

            return html;
        }

        private bool SendAssociatesProductiveReportMails(Guid companyId, List<UsersForEmailModel> usersTobeNotified)
        {
            LoggingManager.Info("Entering into SendAssociatesProductiveReportMails method in ActivityTrackerService");

            var CurrentDate = DateTime.Now.AddDays(-1);

            LoggingManager.Info("Fetching email template for SendAssociatesProductiveReportMails in ActivityTrackerService");

            var reportHtml = _goalRepository.GetHtmlTemplateByName("ManagerDailyAssociateSummaryEmailTemplate", null);

            SmtpDetailsModel smtpDetails = null;

            LoggingManager.Info("Fetched email template for SendAssociatesProductiveReportMails in ActivityTrackerService");

            foreach (var userTobeNotified in usersTobeNotified)
            {
                LoggingManager.Info("Fetching TrackerReports of date " + CurrentDate);

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                List<UserDailyReminderModel> associates = _activityTrackerRepository.GetUserTrackerReports(CurrentDate, companyId, userTobeNotified.UserId, validationMessages);

                if (validationMessages.Count > 0)
                {
                    LoggingManager.Error("Sending TrackerReportEmails failed due to " + validationMessages.FirstOrDefault().ValidationMessaage);
                    validationMessages = new List<ValidationMessage>();
                    continue;
                }

                if (associates.Count == 0)
                {
                    continue;
                }

                LoggingManager.Info("Framing associate Summary report template for " + userTobeNotified.UserName + " in ActivityTrackerService");

                LoggedInContext loggedInContext = new LoggedInContext
                {
                    LoggedInUserId = userTobeNotified.UserId.Value,
                    CompanyGuid = companyId
                };

                if (smtpDetails == null)
                {

                    LoggingManager.Info("Fetching smtp details for companyId " + companyId + " in ActivityTrackerService");

                    smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, new List<ValidationMessage>(), "");

                    LoggingManager.Info("got smtp details for companyId " + companyId + " in ActivityTrackerService");
                }

                var repo = "<table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\">"
                         + " <tbody>"
                         + "   <tr>"
                         + "     <td class=\"o_bg-light o_px-xs\" align=\"center\""
                         + "       style=\"background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;max-width: 632px;\">"
                         + "       <table class=\"o_block\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\""
                         + "         style=\"max-width: 632px;margin: 0 auto; background-color: #ffffff;\">"
                         + "         <tbody>"
                         + "           <table class=\"o_block\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\" style=\"max-width: 632px;margin: 0 auto;\">"
                         + "             <tbody>"
                         + "               <tr>"
                         + "                 <td class=\"o_bg-white o_px-md o_py o_sans o_text o_text-secondary\" align=\"left\""
                         + "                   style=\"font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 10px;width:45%; vertical-align: top;\">"
                         + "                   <p style=\"margin-top: 10px;margin-bottom: 10px;color: #149a9a;\">##userName##</p>"
                         + "                   <p style=\"margin-top: 0px;margin-bottom: 3px;margin-left: 0px;\"><span style=\"color: #00675b\">Start Time: </span>##StartTime##</p>"
                         + "                   <p style=\"margin-top: 0px;margin-bottom: 3px;margin-left: 0px;\"><span style=\"color: #00675b\">Finish Time: </span>##FinishTime##</p>"
                         + "                   <p style=\"margin-top: 0px;margin-bottom: 3px;margin-left: 0px;\"><span style=\"color: #00675b\">Desk Time: </span>##DeskTime##</p>"
                         + "                   <p style=\"margin-top: 0px;margin-bottom: 3px;margin-left: 0px;\"><span style=\"color: #00675b\">Productive Time: </span>##ProductiveTime##</p>"
                         + "                   <p style=\"margin-top: 0px;margin-bottom: 3px;margin-left: 0px;\"><span style=\"color: #00675b\">Idle Time: </span>##IdleTime##</p>"
                         + "                   <p style=\"margin-top: 0px;margin-bottom: 3px;margin-left: 0px;\"><span style=\"color: #00675b\">Commits Done: </span>##CommitsCount##</p>"
                         + "                 </td>"
                         + "                 <td class=\"o_bg-white o_px-md o_py o_sans o_text o_text-secondary\" align=\"left\""
                         + "                   style=\"font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #dbe5ea;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 10px;width:2%\">"
                         + "                 </td>"
                         + "                 <td class=\"o_bg-white o_px-md o_py o_sans o_text o_text-secondary\" align=\"left\""
                         + "                   style=\"font-family: Helvetica, Arial, sans-serif;margin-top: 0px;margin-bottom: 0px;font-size: 16px;line-height: 24px;background-color: #ffffff;color: #424651;padding-left: 24px;padding-right: 24px;padding-top: 16px;padding-bottom: 10px; width:53%; vertical-align: top;\">"
                         + "                   <p style=\"margin-top: 10px;margin-bottom: 5px;color: #149a9a;\">Most Used Applications & Websites: </p>"
                         + "                   <div style=\"margin: 0px\">"
                         + "                     ##TopSites##</div>"
                         + "                 </td>"
                         + "               </tr>"
                         + "             </tbody>"
                         + "           </table>"
                         + "         </tbody>"
                         + "       </table>"
                         + "     </td>"
                         + "   </tr>"
                         + " </tbody>"
                         + "</table>"
                         + " <table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\">"
                         + "   <tbody>"
                         + "     <tr>"
                         + "       <td class=\"o_bg-light o_px-xs\" align=\"center\""
                         + "         style=\"background-color: #dbe5ea;padding-left: 8px;padding-right: 8px;\">"
                         + "         <table class=\"o_block\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\""
                         + "           style=\"max-width: 632px;margin: 0 auto;\">"
                         + "           <tbody>"
                         + "             <tr>"
                         + "               <td class=\"o_bg-white\" style=\"font-size: 20px;line-height: 40px;height: 20px;background-color: #dbe5ea;\">&nbsp; </td>"
                         + "             </tr>"
                         + "           </tbody>"
                         + "         </table>"
                         + "       </td>"
                         + "     </tr>"
                         + "   </tbody>"
                         + " </table>";

                var associateDetails = string.Empty;

                foreach (var associate in associates)
                {
                    associateDetails = associateDetails + GenerateAssociateDetailsChart(repo, associate);
                }

                string html = string.Copy(reportHtml);
                html = html.Replace("##userName##", userTobeNotified.UserName);
                html = html.Replace("##CurrentDate##", CurrentDate.ToString("MMM d, yyyy", new System.Globalization.CultureInfo("en-US")));
                html = html.Replace("##AssociateTrackerData##", associateDetails);

                LoggingManager.Info("Completed generating summary report email template for " + userTobeNotified.UserName + " in ActivityTrackerService");

                TaskWrapper.ExecuteFunctionInNewThread(() =>
                {
                    EmailGenericModel emailModel = new EmailGenericModel
                    {
                        SmtpServer = smtpDetails?.SmtpServer,
                        SmtpServerPort = smtpDetails?.SmtpServerPort,
                        SmtpMail = smtpDetails?.SmtpMail,
                        SmtpPassword = smtpDetails?.SmtpPassword,
                        ToAddresses = new string[] { userTobeNotified.Email },
                        HtmlContent = html,
                        Subject = "Daily assocites summary report - " + CurrentDate.ToString("MMM d, yyyy", new System.Globalization.CultureInfo("en-US")),
                        MailAttachments = null,
                        IsPdf = null
                    };

                    LoggingManager.Info("Sending generated summary report email to " + userTobeNotified.Email + " in ActivityTrackerService");

                    _emailService.SendMail(loggedInContext, emailModel);
                });
            }
            return true;
        }

        private string GenerateAssociateDetailsChart(string reportHtml, UserDailyReminderModel userDetails)
        {
            var html = String.Copy(reportHtml);
            html = html.Replace("##userName##", userDetails.UserName);
            html = html.Replace("##AssociateName##", userDetails.UserName);
            html = html.Replace("##DeskTime##", string.IsNullOrEmpty(userDetails.TotalDeskTime) ? "0h 0m" : userDetails.TotalDeskTime);
            html = html.Replace("##ProductiveTime##", string.IsNullOrEmpty(userDetails.ProductiveTime) ? "0h 0m" : userDetails.ProductiveTime);
            html = html.Replace("##IdleTime##", string.IsNullOrEmpty(userDetails.TotalIdleTime) ? "0h 0m" : userDetails.TotalIdleTime);
            html = html.Replace("##StartTime##", string.IsNullOrEmpty(userDetails.StartTime) ? "-" : userDetails.StartTime);
            html = html.Replace("##FinishTime##", string.IsNullOrEmpty(userDetails.FinishTime) ? "0h 0m" : userDetails.FinishTime);
            if (string.IsNullOrEmpty(userDetails.Commits))
            {
                html = html.Replace("##CommitsCount##", "0");
            }
            else
            {
                var commits = userDetails.Commits.Split('$');
                html = html.Replace("##CommitsCount##", commits.ToList().Count.ToString());
            }
            if (string.IsNullOrEmpty(userDetails.MostUsedApps))
            {
                html = html.Replace("##TopSites##", "");
            }
            else
            {
                var appsHtml = "";
                var apps = Utilities.GetObjectFromXml<ApplicationReportModel>(userDetails.MostUsedApps, "ApplicationReports");
                apps = apps.Take(5).ToList();
                foreach (var app in apps)
                {
                    appsHtml = appsHtml + " <p style=\"margin-top: 0px; margin-bottom: 3px; margin-left: 0px;\"><span style = \"color: #00675b; margin: 0px;font-size: 35px; font-weight: bold;\" >.</span> " + app.ApplicationName + " </p> ";
                }
                html = html.Replace("##TopSites##", appsHtml);
            }

            return html;
        }
    }
}