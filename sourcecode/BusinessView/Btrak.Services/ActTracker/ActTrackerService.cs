using Btrak.Dapper.Dal.Partial;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.ActivityTracker;
using Btrak.Models.ActTracker;
using Btrak.Services.Audit;
using Btrak.Services.Email;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.ActTrrackerValidationHelper;
using BTrak.Common;
using BTrak.Common.Texts;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Btrak.Services.ActTracker
{
    public class ActTrackerService : IActTrackerService
    {
        private readonly IAuditService _auditService;
        private readonly ActTrackerRepository _actTrackerRepository;
        private readonly GoalRepository _goalRepository = new GoalRepository();
        private readonly IEmailService _emailService;

        public ActTrackerService(IAuditService auditService, ActTrackerRepository actTrackerRepository, IEmailService emailService)
        {
            _auditService = auditService;
            _actTrackerRepository = actTrackerRepository;
            _emailService = emailService;
        }

        public List<Guid?> UpsertActTrackerRoleConfiguration(ActTrackerRoleConfigurationUpsertInputModel actTrackerRoleConfigurationUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertActTrackerRoleConfiguration", "actTrackerRoleConfigurationUpsertInputModel", actTrackerRoleConfigurationUpsertInputModel, "ActTrackerService"));

            if (!ActTrackerValidationHelper.ActTrackerRoleConfigurationValidation(actTrackerRoleConfigurationUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            actTrackerRoleConfigurationUpsertInputModel.RoleIdXml = Utilities.ConvertIntoListXml(actTrackerRoleConfigurationUpsertInputModel.RoleId);

            actTrackerRoleConfigurationUpsertInputModel.ConfigurationRoleIds = _actTrackerRepository.UpsertActTrackerRoleConfiguration(actTrackerRoleConfigurationUpsertInputModel, loggedInContext, validationMessages);

            LoggingManager.Debug("ConfigurationRoleIds with the id " + actTrackerRoleConfigurationUpsertInputModel.ConfigurationRoleIds);

            _auditService.SaveAudit(AppCommandConstants.UpsertGenericFormTypeCommandId, actTrackerRoleConfigurationUpsertInputModel, loggedInContext);

            return actTrackerRoleConfigurationUpsertInputModel.ConfigurationRoleIds;
        }

        public List<ActTrackerAppUrlOutputModel> GetActTrackerAppUrlType(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetActTrackerAppUrl", "ActTrackerService"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<ActTrackerAppUrlOutputModel> actTrackerApp = _actTrackerRepository.GetActTrackerAppUrlType(loggedInContext, validationMessages);

            return actTrackerApp;
        }

        public List<Guid?> UpsertActTrackerScreenSHotFrequency(ActTrackerScreenShotFrequencyUpsertInputModel actTrackerScreenShotFrequencyUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertActTrackerScreenSHotFrequency", "actTrackerScreenShotFrequencyUpsertInputModel", actTrackerScreenShotFrequencyUpsertInputModel, "ActTrackerService"));

            if (!ActTrackerValidationHelper.ActTrackerScreenSHotFrequencyValidation(actTrackerScreenShotFrequencyUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            actTrackerScreenShotFrequencyUpsertInputModel.RoleIdXml = Utilities.ConvertIntoListXml(actTrackerScreenShotFrequencyUpsertInputModel.RoleIds);
            if (actTrackerScreenShotFrequencyUpsertInputModel.UserIds.Count > 0)
            {
                actTrackerScreenShotFrequencyUpsertInputModel.UserIdXml = Utilities.ConvertIntoListXml(actTrackerScreenShotFrequencyUpsertInputModel.UserIds);
            }

            actTrackerScreenShotFrequencyUpsertInputModel.ConfiguredRoleIds = _actTrackerRepository.UpsertActTrackerScreenSHotFrequency(actTrackerScreenShotFrequencyUpsertInputModel, loggedInContext, validationMessages);

            LoggingManager.Debug("ConfigurationRoleIds with the id " + actTrackerScreenShotFrequencyUpsertInputModel.ConfiguredRoleIds);

            _auditService.SaveAudit(AppCommandConstants.UpsertGenericFormTypeCommandId, actTrackerScreenShotFrequencyUpsertInputModel, loggedInContext);

            return actTrackerScreenShotFrequencyUpsertInputModel.ConfiguredRoleIds;
        }

        public List<ActTrackerRoleDropOutputModel> GetActTrackerRoleDropDown(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetActTrackerAppUrl", "ActTrackerService"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<ActTrackerRoleDropOutputModel> roleDropDown = _actTrackerRepository.GetActTrackerRoleDropDown(loggedInContext, validationMessages);

            return roleDropDown;
        }


        public List<Guid?> UpsertActTrackerRolePermission(ActTrackerRolePermissionUpsertInputModel actTrackerRolePermissionUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertActTrackerRolePermission", "actTrackerRolePermissionUpsertInputModel", actTrackerRolePermissionUpsertInputModel, "ActTrackerService"));

            if (!ActTrackerValidationHelper.ActTrackerRolePermissionValidation(actTrackerRolePermissionUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            if (actTrackerRolePermissionUpsertInputModel.RoleId != null && actTrackerRolePermissionUpsertInputModel.RoleId.Count > 0)
            {
                actTrackerRolePermissionUpsertInputModel.RoleIdXml = Utilities.ConvertIntoListXml(actTrackerRolePermissionUpsertInputModel.RoleId);
            }

            actTrackerRolePermissionUpsertInputModel.ConfiguredRoleIds = _actTrackerRepository.UpsertActTrackerRolePermission(actTrackerRolePermissionUpsertInputModel, loggedInContext, validationMessages);

            LoggingManager.Debug("ConfigurationRoleIds with the id " + actTrackerRolePermissionUpsertInputModel.ConfiguredRoleIds);

            _auditService.SaveAudit(AppCommandConstants.UpsertGenericFormTypeCommandId, actTrackerRolePermissionUpsertInputModel, loggedInContext);

            return actTrackerRolePermissionUpsertInputModel.ConfiguredRoleIds;
        }

        public List<ActTrackerRoleDropOutputModel> GetActTrackerRoleDeleteDropDown(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetActTrackerAppUrl", "ActTrackerService"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<ActTrackerRoleDropOutputModel> roleDropDown = _actTrackerRepository.GetActTrackerRoleDeleteDropDown(loggedInContext, validationMessages);

            return roleDropDown;
        }

        public List<Guid?> UpsertActTrackerAppUrls(ActTrackerAppUrlsUpsertInputModel actTrackerAppUrlsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertActTrackerAppUrls", "actTrackerAppUrlsUpsertInputModel", actTrackerAppUrlsUpsertInputModel, "ActTrackerService"));

            if (!ActTrackerValidationHelper.ActTrackerAppUrlsValidation(actTrackerAppUrlsUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            //actTrackerAppUrlsUpsertInputModel.RoleIdXml = Utilities.ConvertIntoListXml(actTrackerAppUrlsUpsertInputModel.RoleIds);

            if (actTrackerAppUrlsUpsertInputModel != null && actTrackerAppUrlsUpsertInputModel.ProductiveRoleIds != null)
            {
                actTrackerAppUrlsUpsertInputModel.ProductiveRoleIdsXml = Utilities.ConvertIntoListXml(actTrackerAppUrlsUpsertInputModel.ProductiveRoleIds);
            }

            if (actTrackerAppUrlsUpsertInputModel != null && actTrackerAppUrlsUpsertInputModel.UnproductiveRoleIds != null)
            {
                actTrackerAppUrlsUpsertInputModel.UnProductiveRoleIdsXml = Utilities.ConvertIntoListXml(actTrackerAppUrlsUpsertInputModel.UnproductiveRoleIds);
            }

            _auditService.SaveAudit(AppCommandConstants.UpsertGenericFormTypeCommandId, actTrackerAppUrlsUpsertInputModel, loggedInContext);

            actTrackerAppUrlsUpsertInputModel.ConfiguredIds = _actTrackerRepository.UpsertActTrackerAppUrls(actTrackerAppUrlsUpsertInputModel, loggedInContext, validationMessages);

            return actTrackerAppUrlsUpsertInputModel.ConfiguredIds;

        }

        public List<ActTrackerAppUrlApiOutputModel> GetActTrackerAppUrls(ActTrackerAppUrlsSearchInputModel actTrackerAppUrlsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetActTrackerAppUrl", "ActTrackerService"));

            //if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            //{
            //    return null;
            //}

            List<ActTrackerAppUrlApiOutputModel> actTrackerAppUrlsOutputModels = _actTrackerRepository.GetActTrackerAppUrls(actTrackerAppUrlsSearchInputModel, loggedInContext, validationMessages);

            Parallel.ForEach(actTrackerAppUrlsOutputModels, record =>
            {
                record.ProductiveRoleIds = record.ProductiveRoles?.Split(',').ToList().ConvertAll(Guid.Parse);
                record.UnproductiveRoleIds = record.UnproductiveRoles?.Split(',').ToList().ConvertAll(Guid.Parse);
            });

            return actTrackerAppUrlsOutputModels;
        }

        public PermissionRoles GetActTrackerRolePermissionRoles(ActTrackerRolePermissionRolesInputModel actTrackerRolePermissionRolesInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetActTrackerAppUrl", "ActTrackerService"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<ActTrackerRolePermissionRolesOutputModel> actTrackerAppUrlsOutputModels = _actTrackerRepository.GetActTrackerRolePermissionRoles(actTrackerRolePermissionRolesInputModel, loggedInContext, validationMessages);

            return ConvertToOutputModel(actTrackerAppUrlsOutputModels);
        }

        public List<ActTrackerAppReportUsageSearchOutputModel> GetActTrackerAppReportUsage(EmployeeWebAppUsageTimeSearchInputModel employeeWebAppUsageTimeSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetActTrackerAppReportUsage", "employeeWebAppUsageTimeSearchInputModel", employeeWebAppUsageTimeSearchInputModel, "ActivityTracker Service"));
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

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

            return _actTrackerRepository.GetActTrackerAppReportUsage(employeeWebAppUsageTimeSearchInputModel, loggedInContext, validationMessages);
        }

        public List<ActTrackerAppReportUsageSearchOutputModel> GetActTrackerAppReportUsageForChart(EmployeeWebAppUsageTimeSearchInputModel employeeWebAppUsageTimeSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetActTrackerAppReportUsageForChart", "employeeWebAppUsageTimeSearchInputModel", employeeWebAppUsageTimeSearchInputModel, "ActivityTracker Service"));
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

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

            return _actTrackerRepository.GetActTrackerAppReportUsageForChart(employeeWebAppUsageTimeSearchInputModel, loggedInContext, validationMessages);
        }

        public ActTrackerScreenshotFrequencySearchOutputModel GetActTrackerUserScreenshotFrequency(ActTrackerScreenshotFrequencySearchInputModel actTrackerScreenshotFrequencySearchInputModel, List<ValidationMessage> validationMessages, Guid? loggedInUser)
        {
            ActTrackerScreenshotFrequencySearchOutputModel actTrackerScreenshotFrequencySearchOutputModel = _actTrackerRepository.GetActTrackerUserScreenshotFrequency(actTrackerScreenshotFrequencySearchInputModel.DeviceId, validationMessages, loggedInUser);

            if (actTrackerScreenshotFrequencySearchOutputModel != null)
            {
                return actTrackerScreenshotFrequencySearchOutputModel;
            }

            return null;
        }

        public List<ActTrackerScreenshotsApiOutputModel> GetActTrackerUserActivityScreenshots(EmployeeWebAppUsageTimeSearchInputModel employeeWebAppUsageTimeSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Act Tracker User Activity Screenshots", "employeeWebAppUsageTimeSearchInputModel", employeeWebAppUsageTimeSearchInputModel, "ActivityTracker Service"));
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                employeeWebAppUsageTimeSearchInputModel.TimeZone = userTimeDetails?.TimeZone;
            }

            if (employeeWebAppUsageTimeSearchInputModel.TimeZone == null)
            {
                var indianTimeDetails = TimeZoneHelper.GetIstTime();
                employeeWebAppUsageTimeSearchInputModel.TimeZone = indianTimeDetails?.TimeZone;
            }

            if (employeeWebAppUsageTimeSearchInputModel != null && employeeWebAppUsageTimeSearchInputModel.DateFrom == employeeWebAppUsageTimeSearchInputModel.DateTo)
            {
                employeeWebAppUsageTimeSearchInputModel.DateFrom = new DateTime(employeeWebAppUsageTimeSearchInputModel.DateFrom.Value.Year, employeeWebAppUsageTimeSearchInputModel.DateFrom.Value.Month, employeeWebAppUsageTimeSearchInputModel.DateFrom.Value.Day, 0, 0, 1);
                employeeWebAppUsageTimeSearchInputModel.DateTo = new DateTime(employeeWebAppUsageTimeSearchInputModel.DateTo.Value.Year, employeeWebAppUsageTimeSearchInputModel.DateTo.Value.Month, employeeWebAppUsageTimeSearchInputModel.DateTo.Value.Day, 23, 59, 59);
            }

            if (employeeWebAppUsageTimeSearchInputModel.UserId != null && employeeWebAppUsageTimeSearchInputModel.UserId.Count > 0)
            {
                employeeWebAppUsageTimeSearchInputModel.UserIdXml = Utilities.ConvertIntoListXml(employeeWebAppUsageTimeSearchInputModel.UserId.ToArray());
            }
            else
            {
                employeeWebAppUsageTimeSearchInputModel.UserIdXml = null;
            }

            List<ActTrackerScreenshotsOutputModel> getActTrackerUserActivityScreenshotsOutputModel;//= new List<ActTrackerScreenshotsOutputModel>();

            if (employeeWebAppUsageTimeSearchInputModel.IsAllUser == true)
            {
                getActTrackerUserActivityScreenshotsOutputModel = _actTrackerRepository.GetActTrackerAllUserActivityScreenshots(employeeWebAppUsageTimeSearchInputModel,
                        loggedInContext, validationMessages);
            }
            else
            {
                getActTrackerUserActivityScreenshotsOutputModel = _actTrackerRepository.GetActTrackerUserActivityScreenshots(employeeWebAppUsageTimeSearchInputModel,
                        loggedInContext, validationMessages);
            }

            if (getActTrackerUserActivityScreenshotsOutputModel.Count > 0)
            {
                List<ActTrackerScreenshotsApiOutputModel> actTrackerScreenshotsApiOutputModel = new List<ActTrackerScreenshotsApiOutputModel>();

                getActTrackerUserActivityScreenshotsOutputModel.ToList().ForEach(x =>
                {
                    if (x.ScreenshotDetails != null)
                    {
                        ActTrackerScreenshotsApiOutputModel actTrackerScreenshots = new ActTrackerScreenshotsApiOutputModel();
                        actTrackerScreenshots.Date = x.Date;
                        actTrackerScreenshots.IsDelete = x.IsDelete;
                        actTrackerScreenshots.TotalCount = x.TotalCount;
                        actTrackerScreenshots.ScreenshotDetails = JsonConvert.DeserializeObject<List<ActTrackerUserActivityScreenshotsOutputModel>>(x.ScreenshotDetails);
                        if (x.TrackerChartDetails != null)
                        {
                            actTrackerScreenshots.TrackerChartDetails = JsonConvert.DeserializeObject<List<TrackerChartDetails>>(x.TrackerChartDetails);
                        }
                        actTrackerScreenshotsApiOutputModel.Add(actTrackerScreenshots);
                    }
                });

                return actTrackerScreenshotsApiOutputModel;
            }

            return new List<ActTrackerScreenshotsApiOutputModel>();
        }

        public string MultipleDeleteScreenShot(ActTrackerScreenshotDeleteInputModel actTrackerScreenshotDeleteInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "MultipleDeleteScreenShot", "actTrackerScreenshotDeleteInputModel", actTrackerScreenshotDeleteInputModel, "ActivityTracker Service"));
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            actTrackerScreenshotDeleteInputModel.ScreenshotXml = Utilities.ConvertIntoListXml(actTrackerScreenshotDeleteInputModel.ScreenshotId.ToArray());
            return _actTrackerRepository.MultipleDeleteScreenShot(actTrackerScreenshotDeleteInputModel, loggedInContext, validationMessages);
        }

        public bool? GetActTrackerRecorder(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetActTrackerRecorder", "actTrackerScreenshotDeleteInputModel", " ", "ActivityTracker Service"));
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            return _actTrackerRepository.GetActTrackerRecorder(loggedInContext, validationMessages);
        }

        public ActivityTrackerConfigModel GetActTrackerRecorderForTracker(ActivityTrackerInsertStatusInputModel activityTrackerInsertStatusInputModel, List<ValidationMessage> validationMessages, Guid? loggedInUser)
        {
            activityTrackerInsertStatusInputModel.MacAddressXml = Utilities.ConvertIntoListXml(activityTrackerInsertStatusInputModel.MacAddress.ToArray());
            return _actTrackerRepository.GetActTrackerRecorderForTracker(activityTrackerInsertStatusInputModel, validationMessages, loggedInUser);
        }

        public byte[] UpsertActivityTrackerConfigurationState(ActivityTrackerConfigurationStateInputModel activityTrackerConfigurationStateInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertActivityTrackerConfigurationState", "activityTrackerConfigurationStateInputModel", activityTrackerConfigurationStateInputModel, "ActivityTracker Service"));
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            return _actTrackerRepository.UpsertActivityTrackerConfigurationState(activityTrackerConfigurationStateInputModel, loggedInContext, validationMessages);
        }

        public List<ActivityTrackerHistoryOutputModel> GetActivityTrackerHistory(ActivityTrackerHistoryModel activityTrackerHistoryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetActivityTrackerHistory", "activityTrackerHistoryModel", activityTrackerHistoryModel, "ActivityTracker Service"));
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<ActivityTrackerHistoryOutputModel> HistoryDetails = _actTrackerRepository.GetActivityTrackerHistory(activityTrackerHistoryModel, loggedInContext, validationMessages);

            if (HistoryDetails.Count > 0)
            {
                BuildingDescription(HistoryDetails);
            }

            return HistoryDetails;
        }

        //public Guid? UpsertActivityTrackerUserConfiguration(ActivityTrackerUserConfigurationInputModel activityTrackerUserConfigurationInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        //{
        //    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertActivityTrackerUserConfiguration", "activityTrackerUserConfigurationInputModel", activityTrackerUserConfigurationInputModel, "ActivityTracker Service"));
        //    if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
        //    {
        //        return null;
        //    }
        //    return _actTrackerRepository.UpsertActivityTrackerUserConfiguration(activityTrackerUserConfigurationInputModel, loggedInContext, validationMessages);
        //}

        public Guid? UpsertActivityTrackerUserConfiguration(ActivityTrackerUserConfigurationInputModel activityTrackerUserConfigurationInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertActivityTrackerUserConfiguration", "activityTrackerUserConfigurationInputModel", activityTrackerUserConfigurationInputModel, "ActivityTracker Service"));
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            ActivityTrackerUserDetailsOutputModel trackedDetails = _actTrackerRepository.UpsertActivityTrackerUserConfiguration(activityTrackerUserConfigurationInputModel, loggedInContext, validationMessages);
            trackedDetails.TrackStart = DateTime.Now;
            if (activityTrackerUserConfigurationInputModel.Track == true)
            {
                try
                {
                    //SendTrackingMailToRegisteredEmailAddress(trackedDetails, new List<ValidationMessage>(), loggedInContext);
                }
                catch (Exception exception)
                {
                    LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertActivityTrackerUserConfiguration", "ActTrackerService ", exception.Message), exception);

                }
            }
            return trackedDetails.Id;
        }

        public ActivityTrackerConfigurationStateOutputModel GetActivityTrackerConfigurationState(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetActTrackerRecorder", "", " ", "ActivityTracker Service"));
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            return _actTrackerRepository.GetActivityTrackerConfigurationState(loggedInContext, validationMessages);
        }

        public List<ActivityTrackerUserStatusOutputModel> GetActTrackerUserStatus(EmployeeWebAppUsageTimeSearchInputModel employeeWebAppUsageTimeSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetActTrackerUserStatus", "", " ", "ActivityTracker Service"));
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            return _actTrackerRepository.GetActTrackerUserStatus(employeeWebAppUsageTimeSearchInputModel, loggedInContext, validationMessages);
        }

        private void SendTrackingMailToRegisteredEmailAddress(ActivityTrackerUserDetailsOutputModel activityTrackerUserDetailsOutputModel, List<ValidationMessage> validationMessages, LoggedInContext loggedInContext)
        {
            var tim = activityTrackerUserDetailsOutputModel.TrackStart.ToString();
            var html = _goalRepository.GetHtmlTemplateByName("ActivityTrackerTrackingEmailTemplate", loggedInContext.CompanyGuid).Replace("##EmployeeName##", activityTrackerUserDetailsOutputModel.FirstName + " " + activityTrackerUserDetailsOutputModel.LastName).Replace("##TrackDateTime##", activityTrackerUserDetailsOutputModel.TrackStart.ToString());
            var toMails = activityTrackerUserDetailsOutputModel.WorkEmail.Split('\n');
            EmailGenericModel emailModel = new EmailGenericModel
            {
                SmtpMail = null,
                SmtpPassword = null,
                ToAddresses = toMails,
                HtmlContent = html,
                Subject = "Snovasys Business Suite: Activity Watcher Confirmation",
                CCMails = null,
                BCCMails = null,
                MailAttachments = null,
                IsPdf = null
            };
            _emailService.SendMail(loggedInContext, emailModel);
        }

        public static PermissionRoles ConvertToOutputModel(List<ActTrackerRolePermissionRolesOutputModel> actTrackerAppUrlsOutputModels)
        {

            if (actTrackerAppUrlsOutputModels == null)
            {
                return null;
            }

            List<ActTrackerRoleDropOutputModel> deleteRolesIds = actTrackerAppUrlsOutputModels.Where(i => i.IsDeleteScreenShots == true).Select(i => new ActTrackerRoleDropOutputModel()
            {
                RoleId = i.RoleId,
                RoleName = i.RoleName
            }).ToList();

            List<ActTrackerRoleDropOutputModel> recordActivityIds = actTrackerAppUrlsOutputModels.Where(i => i.IsRecordActivity == true).Select(i => new ActTrackerRoleDropOutputModel()
            {
                RoleId = i.RoleId,
                RoleName = i.RoleName
            }).ToList();

            List<ActTrackerIdleRolesModel> idleTimeIds = actTrackerAppUrlsOutputModels.Where(i => i.IsIdleTime == true).Select(i => new ActTrackerIdleRolesModel()
            {
                RoleId = i.RoleId,
                RoleName = i.RoleName,
                IdleAlertTime = i.IdleAlertTime,
                IdleScreenShotCaptureTime = i.IdleScreenShotCaptureTime,
                MinimumIdelTime = i.MinimumIdelTime

            }).ToList();

            List<ActTrackerRoleDropOutputModel> manualEntryRoleIds = actTrackerAppUrlsOutputModels.Where(i => i.IsManualEntryTime == true).Select(i => new ActTrackerRoleDropOutputModel()
            {
                RoleId = i.RoleId,
                RoleName = i.RoleName
            }).ToList();

            List<ActTrackerRoleDropOutputModel> offlineRoles = actTrackerAppUrlsOutputModels.Where(i => i.IsOfflineTracking == true).Select(i => new ActTrackerRoleDropOutputModel()
            {
                RoleId = i.RoleId,
                RoleName = i.RoleName
            }).ToList();

            List<ActTrackerRoleDropOutputModel> mouseRoles = actTrackerAppUrlsOutputModels.Where(i => i.IsMouseTracking == true).Select(i => new ActTrackerRoleDropOutputModel()
            {
                RoleId = i.RoleId,
                RoleName = i.RoleName
            }).ToList();

            PermissionRoles permissionRoles = new PermissionRoles()
            {
                DeleteScreenShotRoleIds = deleteRolesIds,
                IdleTimeRoleIds = idleTimeIds,
                ManualEntryRoleIds = manualEntryRoleIds,
                RecordActivityRoleIds = recordActivityIds,
                OfflineTrackingRoleIds = offlineRoles,
                MouseTrackingRoleIds = mouseRoles
            };
            return permissionRoles;
        }

        public ActTrackerRoleConfiguration GetActTrackerRoleConfigurationRoles(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetActTrackerRoleConfigurationRoles", "ActTrackerService"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<GetActTrackerRoleConfigurationRolesOutputModel> roleDropDown = _actTrackerRepository.GetActTrackerRoleConfigurationRoles(loggedInContext, validationMessages);

            // List<ActTrackerRoleConfigurationRoles> roleConfigurationRoles = new List<ActTrackerRoleConfigurationRoles>();

            if (roleDropDown.Count > 0)
            {
                return ConvertToOutputModel(roleDropDown);
            }

            return null;
        }

        public ActTrackerScreenShotFrequency GetActTrackerScreenShotFrequencyRoles(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetActTrackerScreenShotFrequencyRoles", "ActTrackerService"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<GetActTrackerScreenShotFrequencyRolesOutputModel> roleDropDown = _actTrackerRepository.GetActTrackerScreenShotFrequencyRoles(loggedInContext, validationMessages);
            List<GetActTrackerScreenShotFrequencyRolesOutputModel> userDropDown = _actTrackerRepository.GetActTrackerScreenShotFrequencyUser(loggedInContext, validationMessages);

            //List<ActTrackerScreenShotFrequencyRoles> screenShotFrequencyRoles = new List<ActTrackerScreenShotFrequencyRoles>();

            if (roleDropDown.Count > 0)
            {
                return ConvertToOutputModelFrequency(roleDropDown, userDropDown);
            }

            return null;
        }

        public static ActTrackerRoleConfiguration ConvertToOutputModel(List<GetActTrackerRoleConfigurationRolesOutputModel> roleDropDown)
        {
            Guid? appUrlId = new Guid();
            bool considerPunchCard = false;
            List<ActTrackerRoleConfigurationRoles> roleConfigurationRoles = new List<ActTrackerRoleConfigurationRoles>();

            //if (roleDropDown[0]?.FrequencyIndex == 1)
            //{
            //  appUrlId = roleDropDown[0].AppUrlId;
            //}
            //else
            //{
            var roles = from r in roleDropDown group r by r.FrequencyIndex;

            foreach (var role in roles)
            {
                ActTrackerRoleConfigurationRoles actTrackerRoleConfigurationRoles = new ActTrackerRoleConfigurationRoles()
                {
                    ActTrackerRoleConfigId = new List<Guid?>(),
                    AppURL = string.Empty,
                    RoleId = new List<Guid?>(),
                    RoleName = new List<string>(),
                    AppUrlId = new Guid(),
                    FrequencyIndex = new int()
                };
                foreach (var roleConfiguration in role)
                {
                    if (roleConfiguration.FrequencyIndex > -1)
                    {
                        actTrackerRoleConfigurationRoles.ActTrackerRoleConfigId.Add(roleConfiguration.ActTrackerRoleConfigId);
                        actTrackerRoleConfigurationRoles.RoleId.Add(roleConfiguration.RoleId);
                        actTrackerRoleConfigurationRoles.RoleName.Add(roleConfiguration.RoleName);
                        actTrackerRoleConfigurationRoles.AppUrlId = roleConfiguration.AppUrlId;
                        actTrackerRoleConfigurationRoles.ConsiderPunchCard = roleConfiguration.ConsiderPunchCard;
                        actTrackerRoleConfigurationRoles.AppURL = roleConfiguration.AppURL;
                        actTrackerRoleConfigurationRoles.FrequencyIndex = roleConfiguration.FrequencyIndex;
                        actTrackerRoleConfigurationRoles.SelectAll = roleConfiguration.SelectAll == true ? true : false;
                    }
                    else
                    {
                        appUrlId = roleConfiguration.AppUrlId;
                        considerPunchCard = roleConfiguration.ConsiderPunchCard;
                    }
                }
                roleConfigurationRoles.Add(actTrackerRoleConfigurationRoles);
            }
            //}

            ActTrackerRoleConfiguration actTrackerRoleConfiguration = new ActTrackerRoleConfiguration()
            {
                AppUrlId = appUrlId,
                ConsiderPunchCard = considerPunchCard,
                IndividualRoles = roleConfigurationRoles

            };

            return actTrackerRoleConfiguration;
        }

        public static ActTrackerScreenShotFrequency ConvertToOutputModelFrequency(List<GetActTrackerScreenShotFrequencyRolesOutputModel> roleDropDown, List<GetActTrackerScreenShotFrequencyRolesOutputModel> userDropDown)
        {
            int? screenShotFrequency = new int();
            int? multiplier = new int();
            bool? randomScreenshot = false;
            multiplier = null;
            List<ActTrackerScreenShotFrequencyRoles> screenShotFrequencyRoles = new List<ActTrackerScreenShotFrequencyRoles>();

            //if (roleDropDown[0]?.FrequencyIndex == 1)
            //{
            //    screenShotFrequency = roleDropDown[0].ScreenShotFrequency;
            //    multiplier = roleDropDown[0].Multiplier;
            //}
            //else
            //{
            screenShotFrequency = roleDropDown[0].ScreenShotFrequency;

            randomScreenshot = roleDropDown[0].RandomScreenshot == null ? false : roleDropDown[0].RandomScreenshot;

            var roles = from r in roleDropDown group r by r.FrequencyIndex;

            var userLength = userDropDown.Count;

            //var users = from u in userDropDown group u by u.FrequencyIndex;

            foreach (var role in roles)
            {
                ActTrackerScreenShotFrequencyRoles actTrackerScreenShotFrequencyRoles = new ActTrackerScreenShotFrequencyRoles()
                {
                    ActTrackerScreenShotId = new List<Guid?>(),
                    Multiplier = new int(),
                    RoleId = new List<Guid?>(),
                    RoleName = new List<string>(),
                    UserId = new List<Guid?>(),
                    ScreenShotFrequency = new int(),
                    FrequencyIndex = new int()
                };
                foreach (var screenShotRole in role)
                {
                    if (screenShotRole.FrequencyIndex > -1)
                    {
                        actTrackerScreenShotFrequencyRoles.ActTrackerScreenShotId.Add(screenShotRole.ActTrackerScreenShotId);
                        if (!actTrackerScreenShotFrequencyRoles.RoleId.Contains(screenShotRole.RoleId))
                        {
                            actTrackerScreenShotFrequencyRoles.RoleId.Add(screenShotRole.RoleId);
                            actTrackerScreenShotFrequencyRoles.RoleName.Add(screenShotRole.RoleName);
                        }
                        actTrackerScreenShotFrequencyRoles.Multiplier = screenShotRole.Multiplier;
                        actTrackerScreenShotFrequencyRoles.ScreenShotFrequency = screenShotRole.ScreenShotFrequency;
                        actTrackerScreenShotFrequencyRoles.FrequencyIndex = screenShotRole.FrequencyIndex;
                        actTrackerScreenShotFrequencyRoles.SelectAll = screenShotRole.SelectAll == true ? true : false;
                    }
                    else
                    {
                        multiplier = screenShotRole.Multiplier;
                    }
                }
                if (userLength > 0)
                {
                    var users = from u in userDropDown group u by u.FrequencyIndex;
                    foreach (var user in users)
                    {
                        foreach (var screenShotUser in user)
                        {
                            if (screenShotUser.FrequencyIndex > -1 && actTrackerScreenShotFrequencyRoles.FrequencyIndex == screenShotUser.FrequencyIndex)
                            {
                                if (!actTrackerScreenShotFrequencyRoles.UserId.Contains(screenShotUser.UserId))
                                {
                                    actTrackerScreenShotFrequencyRoles.UserId.Add(screenShotUser.UserId);
                                }
                                actTrackerScreenShotFrequencyRoles.IsUserSelectAll = screenShotUser.IsUserSelectAll == true ? true : false;
                            }
                        }
                    }
                }
                screenShotFrequencyRoles.Add(actTrackerScreenShotFrequencyRoles);
            }
            // }

            ActTrackerScreenShotFrequency actTrackerScreenShotFrequency = new ActTrackerScreenShotFrequency()
            {
                Multiplier = multiplier,
                ScreenShotFrequency = screenShotFrequency,
                RandomScreenshot = randomScreenshot,
                IndividualRoles = screenShotFrequencyRoles

            };

            return actTrackerScreenShotFrequency;
        }

        public void BuildingDescription(List<ActivityTrackerHistoryOutputModel> historyDetailsList)
        {
            Parallel.ForEach(historyDetailsList, (historyDetails) =>

            {
                if (historyDetails.FieldName == "TrackingEnable")
                {
                    historyDetails.Description = string.Format(GetPropValue(historyDetails.FieldName), historyDetails.UserName, historyDetails.OldValue, historyDetails.NewValue);
                }
                if (historyDetails.FieldName == "BasicTracking")
                {
                    historyDetails.Description = string.Format(GetPropValue(historyDetails.FieldName), historyDetails.UserName, historyDetails.OldValue, historyDetails.NewValue);
                }
                if (historyDetails.FieldName == "DisableUrlsEnable")
                {
                    historyDetails.Description = string.Format(GetPropValue(historyDetails.FieldName), historyDetails.UserName, historyDetails.OldValue, historyDetails.NewValue);
                }
                if (historyDetails.FieldName == "Screenshot")
                {
                    historyDetails.Description = string.Format(GetPropValue(historyDetails.FieldName), historyDetails.UserName, historyDetails.OldValue, historyDetails.NewValue);
                }
                if (historyDetails.FieldName == "DeleteScreenShot")
                {
                    historyDetails.Description = string.Format(GetPropValue(historyDetails.FieldName), historyDetails.UserName, historyDetails.OldValue, historyDetails.NewValue);
                }
                if (historyDetails.FieldName == "DeleteRoles")
                {
                    historyDetails.Description = string.Format(GetPropValue(historyDetails.FieldName), historyDetails.UserName, historyDetails.OldValue, historyDetails.NewValue);
                }
                if (historyDetails.FieldName == "KeyBoard")
                {
                    historyDetails.Description = string.Format(GetPropValue(historyDetails.FieldName), historyDetails.UserName, historyDetails.OldValue, historyDetails.NewValue);
                }
                if (historyDetails.FieldName == "KeyBoardRoles")
                {
                    historyDetails.Description = string.Format(GetPropValue(historyDetails.FieldName), historyDetails.UserName, historyDetails.OldValue, historyDetails.NewValue);
                }
                if (historyDetails.FieldName == "Mouse")
                {
                    historyDetails.Description = string.Format(GetPropValue(historyDetails.FieldName), historyDetails.UserName, historyDetails.OldValue, historyDetails.NewValue);
                }
                if (historyDetails.FieldName == "MouseRoles")
                {
                    historyDetails.Description = string.Format(GetPropValue(historyDetails.FieldName), historyDetails.UserName, historyDetails.OldValue, historyDetails.NewValue);
                }
                if (historyDetails.FieldName == "IdealTime")
                {
                    historyDetails.Description = string.Format(GetPropValue(historyDetails.FieldName), historyDetails.UserName, historyDetails.OldValue, historyDetails.NewValue);
                }
                if (historyDetails.FieldName == "IdealTimeRoles")
                {
                    historyDetails.Description = string.Format(GetPropValue(historyDetails.FieldName), historyDetails.UserName, historyDetails.OldValue, historyDetails.NewValue);
                }
                if (historyDetails.FieldName == "OfflineTracking")
                {
                    historyDetails.Description = string.Format(GetPropValue(historyDetails.FieldName), historyDetails.UserName, historyDetails.OldValue, historyDetails.NewValue);
                }
                if (historyDetails.FieldName == "OfflineTrackingRoles")
                {
                    historyDetails.Description = string.Format(GetPropValue(historyDetails.FieldName), historyDetails.UserName, historyDetails.OldValue, historyDetails.NewValue);
                }

                if (historyDetails.FieldName == "ScreenShotFrequency")
                {
                    historyDetails.Description = string.Format(GetPropValue(historyDetails.FieldName), historyDetails.UserName, historyDetails.OldValue, historyDetails.NewValue);
                }
                if (historyDetails.FieldName == "Multiplier")
                {
                    historyDetails.Description = string.Format(GetPropValue(historyDetails.FieldName), historyDetails.UserName, historyDetails.OldValue, historyDetails.NewValue);
                }
                if (historyDetails.FieldName == "RandomScreenshot")
                {
                    historyDetails.Description = string.Format(GetPropValue(historyDetails.FieldName), historyDetails.UserName, historyDetails.OldValue, historyDetails.NewValue);
                }
                if (historyDetails.FieldName == "AppUrl")
                {
                    historyDetails.Description = string.Format(GetPropValue(historyDetails.FieldName), historyDetails.UserName, historyDetails.OldValue, historyDetails.NewValue);
                }
                if (historyDetails.FieldName == "ConsiderPunchCard")
                {
                    historyDetails.Description = string.Format(GetPropValue(historyDetails.FieldName), historyDetails.UserName, historyDetails.OldValue, historyDetails.NewValue);
                }
            });
        }

        private string GetPropValue(string propName)
        {
            object src = new LangText();
            return src.GetType().GetProperty(propName)?.GetValue(src, null).ToString();
        }

        public List<ActTrackerScreenshotsApiOutputModel> GetActTrackerUserActivityScreenshotsBasedOnId(EmployeeWebAppUsageTimeSearchInputModel employeeWebAppUsageTimeSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Act Tracker User Activity Screenshots", "employeeWebAppUsageTimeSearchInputModel", employeeWebAppUsageTimeSearchInputModel, "ActivityTracker Service"));
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                employeeWebAppUsageTimeSearchInputModel.TimeZone = userTimeDetails?.TimeZone;
            }

            if (employeeWebAppUsageTimeSearchInputModel.TimeZone == null)
            {
                var indianTimeDetails = TimeZoneHelper.GetIstTime();
                employeeWebAppUsageTimeSearchInputModel.TimeZone = indianTimeDetails?.TimeZone;
            }

            List<ActTrackerScreenshotsOutputModel> getActTrackerUserActivityScreenshotsOutputModel;//= new List<ActTrackerScreenshotsOutputModel>();

            //if (employeeWebAppUsageTimeSearchInputModel.IsAllUser == true)
            //{
            //    getActTrackerUserActivityScreenshotsOutputModel = _actTrackerRepository.GetActTrackerAllUserActivityScreenshots(employeeWebAppUsageTimeSearchInputModel,
            //            loggedInContext, validationMessages);
            //}
            //else
            //{
            getActTrackerUserActivityScreenshotsOutputModel = _actTrackerRepository.GetActTrackerUserActivityScreenshotsBasedOnId(employeeWebAppUsageTimeSearchInputModel,
                    loggedInContext, validationMessages);
            //}

            if (getActTrackerUserActivityScreenshotsOutputModel.Count > 0)
            {
                List<ActTrackerScreenshotsApiOutputModel> actTrackerScreenshotsApiOutputModel = new List<ActTrackerScreenshotsApiOutputModel>();

                getActTrackerUserActivityScreenshotsOutputModel.ToList().ForEach(x =>
                {
                    if (x.ScreenshotDetails != null)
                    {
                        ActTrackerScreenshotsApiOutputModel actTrackerScreenshots = new ActTrackerScreenshotsApiOutputModel();
                        actTrackerScreenshots.Date = x.Date;
                        actTrackerScreenshots.IsDelete = x.IsDelete;
                        actTrackerScreenshots.TotalCount = x.TotalCount;
                        actTrackerScreenshots.ScreenshotDetails = JsonConvert.DeserializeObject<List<ActTrackerUserActivityScreenshotsOutputModel>>(x.ScreenshotDetails);
                        if (x.TrackerChartDetails != null)
                        {
                            actTrackerScreenshots.TrackerChartDetails = JsonConvert.DeserializeObject<List<TrackerChartDetails>>(x.TrackerChartDetails);
                        }
                        actTrackerScreenshotsApiOutputModel.Add(actTrackerScreenshots);
                    }
                });

                return actTrackerScreenshotsApiOutputModel;
            }

            return new List<ActTrackerScreenshotsApiOutputModel>();
        }

        public List<MostProductiveUsersOutputModel> GetMostProductiveUsers(MostProductiveUsersInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetMostProductiveUsers", "", " ", "ActivityTracker Service"));
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            return _actTrackerRepository.GetMostProductiveUsers(inputModel, loggedInContext, validationMessages);
        }
        public List<TrackingUserModel> GetTrackingUsers(TrackingUserModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetTrackingUsers", "", " ", "ActivityTracker Service"));
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            return _actTrackerRepository.GetTrackingUsers(inputModel, loggedInContext, validationMessages);
        }
    }
}
