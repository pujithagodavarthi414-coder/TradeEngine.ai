using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.ActivityTracker;
using Btrak.Models.MSMQ;
using Btrak.Services.ActivityTracker;
using BTrak.Common;
using BTrak.Common.MSMQ;
using Newtonsoft.Json;
using System.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using Unity;
using Btrak.Services.MSMQPublisher;

namespace BTrak.Api.MSMQ
{
    public class TrackerActivityDataHandler : MessageQueuePublisher<TrackerActivityPublishModel>
    {
        public TrackerActivityDataHandler() : base(MSMQPathConstants.TrackerActivityPublishPath + "_" + ConfigurationManager.AppSettings["EnvironmentUniqueName"])
        {
        }

        public void Init()
        {
            var environmentId = ConfigurationManager.AppSettings["EnvironmentUniqueName"];
            var listener = new MessageQueueListener<TrackerActivityPublishModel>(MSMQPathConstants.TrackerActivityListenerPath + "_" + environmentId, InsertTrackerData);
            listener.StartReceivingMessages();
        }

        private void InsertTrackerData(TrackerActivityPublishModel trackerActivityPublishModel)
        {
            try
            {

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "InsertTrackerData", "TrackerActivityPublishModel", trackerActivityPublishModel, "TrackerActivityDataHandler"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                var loggedInUser = trackerActivityPublishModel.LoggedInUser;
                var insertUserActivityTimeInputModel = trackerActivityPublishModel.ActivityInputModel;

                var unityContainer = UnityConfig.SetUpUnityContainer();
                var activityTrackerService = unityContainer.Resolve<ActivityTrackerService>();
                var activityTrackerRepository = unityContainer.Resolve<ActivityTrackerRepository>();
                var trackerSummaryPublisher = unityContainer.Resolve<TrackerSummaryPublisher>();


                int inValidRecords = insertUserActivityTimeInputModel.UserActivityTime.Where(p =>
                p.ApplicationStartTime < insertUserActivityTimeInputModel.ActivityTime.AddMinutes(-2) ||
                p.ApplicationEndTime > insertUserActivityTimeInputModel.ActivityTime.AddMinutes(2) ||
                p.ApplicationEndTime.Subtract(p.ApplicationStartTime).Minutes != p.SpentTime.Minute
                ).ToList().Count();

                if (inValidRecords == 0)
                {
                    DateTime activityEndTime = insertUserActivityTimeInputModel.UserActivityTime.Max(x => x.ApplicationEndTime);

                        string userTime = Utilities.ConvertIntoListXml(insertUserActivityTimeInputModel.UserActivityTime);

                        string macAddress = Utilities.ConvertIntoListXml(insertUserActivityTimeInputModel.MacAddress.ToArray());

                        userTime.Replace("&", "&amp;");

                    TrackerInsertValidatorReturnModel trackerInsertValidatorReturnModel = activityTrackerRepository.TrackerInsertValidator(new TrackerInsertValidatorInputModel
                    {
                        MacAddress = macAddress,
                        DeviceId = insertUserActivityTimeInputModel.DeviceId,
                        TriggeredDate = activityEndTime,
                        UserId = loggedInUser
                    }, validationMessages);

                    if (trackerInsertValidatorReturnModel != null
                        && trackerInsertValidatorReturnModel.ActivityToken == insertUserActivityTimeInputModel.ActivityToken
                        && trackerInsertValidatorReturnModel.CanInsert)
                    {

                        string status = activityTrackerRepository.InsertUserActivityTime(userTime, insertUserActivityTimeInputModel.DeviceId, validationMessages, loggedInUser);

                        if (status == "Inserted Successfully")
                        {
                            activityTrackerRepository.InsertUserMouseMovementsAndKeyStrokes(new InsertUserActivityInputModel
                            {
                                ActivityTime = activityEndTime,
                                DeviceId = insertUserActivityTimeInputModel.DeviceId,
                                MouseMovements = insertUserActivityTimeInputModel.MouseMovements,
                                KeyStrokes = insertUserActivityTimeInputModel.KeyStrokes,
                                UserIdleRecordXml = insertUserActivityTimeInputModel.UserIdleActivityTime == null ? null : Utilities.GetXmlFromObject(insertUserActivityTimeInputModel.UserIdleActivityTime)
                            }, validationMessages, trackerInsertValidatorReturnModel?.UserId ?? null);

                                LoggingManager.Debug("User Activity has been " + status);

                            if (trackerInsertValidatorReturnModel.UserId != null && trackerInsertValidatorReturnModel.UserId != Guid.Empty)
                            {

                                trackerSummaryPublisher.InsertUserSummary(trackerInsertValidatorReturnModel.UserId,
                                    activityEndTime.ToString("yyyy-MM-dd"), validationMessages);

                                //activityTrackerService.UpdateUserTrackerData(trackerInsertValidatorReturnModel.UserId,
                                //    activityEndTime, validationMessages);
                            }
                        }
                        else
                        {
                            LoggingManager.Error("TrackerActivityDataHandler Failure status - InsertUserActivityTime retured a failure status as - (" + status + ") at retry - (" + trackerActivityPublishModel.RetryCount + ") ");

                            if (trackerActivityPublishModel.RetryCount < 5)
                            {
                                trackerActivityPublishModel.RetryCount = trackerActivityPublishModel.RetryCount + 1;
                                Send(trackerActivityPublishModel);
                            }
                            else if (trackerActivityPublishModel.RetryCount == 5)
                            {
                                LoggingManager.Error("Failed to insert the data related to device id: " + trackerActivityPublishModel.ActivityInputModel.DeviceId + " With failure status" + status);
                            }
                        }
                    }
                    else
                    {
                        LoggingManager.Error($"data is not inserted due to trackerActivityPublishModel: {JsonConvert.SerializeObject(trackerActivityPublishModel, Formatting.Indented)} db activity token: {insertUserActivityTimeInputModel.ActivityToken}");
                    }
                }
            }
            catch (Exception ex)
            {
                LoggingManager.Error("Exception In MSMQ TrackerActivityDataHandler at retry (" + trackerActivityPublishModel.RetryCount + ") - " + ex);

                if (trackerActivityPublishModel.RetryCount < 5)
                {
                    trackerActivityPublishModel.RetryCount = trackerActivityPublishModel.RetryCount + 1;
                    Send(trackerActivityPublishModel);
                }
                else if (trackerActivityPublishModel.RetryCount == 5)
                {
                    LoggingManager.Error("Failed to insert the data related to device id: " + trackerActivityPublishModel.ActivityInputModel.DeviceId + " With exception - " + ex);
                }
            }
        }
    }
}
