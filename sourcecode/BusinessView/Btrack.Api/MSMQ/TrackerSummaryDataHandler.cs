using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.MSMQ;
using BTrak.Common;
using BTrak.Common.MSMQ;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using Unity;

namespace BTrak.Api.MSMQ
{
    public class TrackerSummaryDataHandler : MessageQueuePublisher<TrackerSummaryPublishModel>
    {
        public TrackerSummaryDataHandler() : base(MSMQPathConstants.TrackerSummaryPublishPath + "_" + ConfigurationManager.AppSettings["EnvironmentUniqueName"])
        {
        }

        public void Init()
        {
            var environmentId = ConfigurationManager.AppSettings["EnvironmentUniqueName"];
            var listener = new MessageQueueListener<TrackerSummaryPublishModel>(MSMQPathConstants.TrackerSummaryListenerPath + "_" + environmentId, InsertTrackerSummaryData);
            listener.StartReceivingMessages();
        }

        public void InsertTrackerSummaryData(TrackerSummaryPublishModel trackerSummaryPublishModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "InsertTrackerSummaryData", "trackerSummaryPublishModel", trackerSummaryPublishModel, "TrackerSummaryDataHandler"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                var unityContainer = UnityConfig.SetUpUnityContainer();
                var activityTrackerRepository = unityContainer.Resolve<ActivityTrackerRepository>();

                activityTrackerRepository.UpdateUserTrackerData(trackerSummaryPublishModel.UserId, trackerSummaryPublishModel.TrackedDate, validationMessages);
            }
            catch (Exception ex)
            {
                LoggingManager.Error("Exception In MSMQ TrackerSummaryDataHandler at retry (" + trackerSummaryPublishModel.RetryCount + ") - " + ex);

                if (trackerSummaryPublishModel.RetryCount < 5)
                {
                    trackerSummaryPublishModel.RetryCount = trackerSummaryPublishModel.RetryCount + 1;
                    Send(trackerSummaryPublishModel);
                }
                else if (trackerSummaryPublishModel.RetryCount == 5)
                {
                    LoggingManager.Error("Failed to insert the summary data related to user id: " + trackerSummaryPublishModel.UserId + " With exception - " + ex);
                }
            }
        }
    }
}