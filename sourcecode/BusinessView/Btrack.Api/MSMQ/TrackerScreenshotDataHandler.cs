using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.ActivityTracker;
using Btrak.Models.ActTracker;
using Btrak.Models.File;
using Btrak.Models.MSMQ;
using Btrak.Services.ActivityTracker;
using Btrak.Services.ActTracker;
using Btrak.Services.FileUpload;
using BTrak.Common;
using BTrak.Common.MSMQ;
using System;
using System.Collections.Generic;
using System.Configuration;
using Unity;

namespace BTrak.Api.MSMQ
{
    public class TrackerScreenshotDataHandler : MessageQueuePublisher<TrackerScreenshotPublishModel>
    {
        public TrackerScreenshotDataHandler() : base(MSMQPathConstants.TrackerScreenshotPublishPath + "_" + ConfigurationManager.AppSettings["EnvironmentUniqueName"])
        {
        }

        public void Init()
        {
            var environmentId = ConfigurationManager.AppSettings["EnvironmentUniqueName"];
            var listener = new MessageQueueListener<TrackerScreenshotPublishModel>(MSMQPathConstants.TrackerScreenshotListenerPath + "_" + environmentId, InsertTrackerScreenshotData);
            listener.StartReceivingMessages();
        }

        private void InsertTrackerScreenshotData(TrackerScreenshotPublishModel trackerScreenshotPublishModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "InsertTrackerScreenshotData", "TrackerScreenshotPublishModel", trackerScreenshotPublishModel, "TrackerScreenshotDataHandler"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                var loggedInUser = trackerScreenshotPublishModel.LoggedInUser;
                var insertUserActivityScreenShotInputModel = trackerScreenshotPublishModel.InsertUserActivityScreenShot;

                var unityContainer = UnityConfig.SetUpUnityContainer();
                var fileService = unityContainer.Resolve<FileService>();
                var activityTrackerRepository = unityContainer.Resolve<ActivityTrackerRepository>();

                var macAddress = Utilities.ConvertIntoListXml(insertUserActivityScreenShotInputModel.MACAddress.ToArray());

                TrackerInsertValidatorReturnModel trackerInsertValidatorReturnModel = activityTrackerRepository.TrackerInsertValidator(new TrackerInsertValidatorInputModel
                {
                    MacAddress = macAddress,
                    DeviceId = insertUserActivityScreenShotInputModel.DeviceId,
                    TriggeredDate = insertUserActivityScreenShotInputModel.ScreenShotDate?.UtcDateTime ?? DateTime.UtcNow,
                    UserId = loggedInUser,
                    TimeZone = insertUserActivityScreenShotInputModel.TimeZone
                }, validationMessages);

                if (trackerInsertValidatorReturnModel != null
                    && trackerInsertValidatorReturnModel.ActivityToken == insertUserActivityScreenShotInputModel.ActivityToken
                    && trackerInsertValidatorReturnModel.CanInsert)
                {
                    loggedInUser = trackerInsertValidatorReturnModel.UserId;
                    insertUserActivityScreenShotInputModel.FileType = "Image";
                    List<FileResult> files = fileService.UploadActivityTrackerScreenShot(insertUserActivityScreenShotInputModel, validationMessages,
                        new UploadScreenshotInputModel
                        {
                            CompanyId = trackerInsertValidatorReturnModel.CompanyId,
                            UserId = trackerInsertValidatorReturnModel.UserId
                        });

                    if (files != null && files.Count > 0 && !string.IsNullOrWhiteSpace(files[0].FileUrl))
                    {
                        insertUserActivityScreenShotInputModel.ScreenShotUrl = files[0].FileUrl;
                        insertUserActivityScreenShotInputModel.ScreenShotName = files[0].FileName;
                        insertUserActivityScreenShotInputModel.Mac = null;

                        string status = string.Empty;
                        if (!insertUserActivityScreenShotInputModel.IsLiveScreenShot)
                        {
                            status = activityTrackerRepository.InsertUserActivityScreenShot(insertUserActivityScreenShotInputModel, insertUserActivityScreenShotInputModel.MACAddress.ToString(), validationMessages, loggedInUser);
                        }

                        if (status != null)
                        {
                            LoggingManager.Debug("User Activity ScreenShot has been " + status);
                        }
                    }
                }

            }
            catch (Exception ex)
            {
                LoggingManager.Error("Exception In MSMQ TrackerScreenshotDataHandler at retry (" + trackerScreenshotPublishModel.RetryCount + ") - " + ex);

                if (trackerScreenshotPublishModel.RetryCount < 5)
                {
                    trackerScreenshotPublishModel.RetryCount = trackerScreenshotPublishModel.RetryCount + 1;
                    Send(trackerScreenshotPublishModel);
                }
                else if (trackerScreenshotPublishModel.RetryCount == 5)
                {
                    LoggingManager.Error("Failed to insert the data related to device id: " + trackerScreenshotPublishModel.InsertUserActivityScreenShot.DeviceId + " With exception - " + ex);
                }
            }
        }
    }
}
