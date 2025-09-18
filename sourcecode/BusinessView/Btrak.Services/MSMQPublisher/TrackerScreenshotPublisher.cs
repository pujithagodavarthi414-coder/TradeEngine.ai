using Btrak.Models;
using Btrak.Models.ActivityTracker;
using Btrak.Models.MSMQ;
using Btrak.Services.Helpers.ActivityTracker;
using BTrak.Common;
using BTrak.Common.MSMQ;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Services.MSMQPublisher
{
    public class TrackerScreenshotPublisher : MessageQueuePublisher<TrackerScreenshotPublishModel>, ITrackerScreenshotPublisher
    {
        private readonly ActivityTrackerValidationHelpers _activityTrackerValidationHelpers = new ActivityTrackerValidationHelpers();

        public TrackerScreenshotPublisher() : base(MSMQPathConstants.TrackerScreenshotPublishPath + "_" + ConfigurationManager.AppSettings["EnvironmentUniqueName"])
        {
        }

        public string InsertUserActivityScreenShot(InsertUserActivityScreenShotInputModel insertUserActivityScreenShotInputModel, List<ValidationMessage> validationMessages, Guid? loggedInUser)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Insert User Activity ScreenShot", "insertUserActivityScreenShotInputModel", insertUserActivityScreenShotInputModel, "ActivityTracker Service"));

            _activityTrackerValidationHelpers.InsertUserActivityScreenShotValidation(insertUserActivityScreenShotInputModel, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            TrackerScreenshotPublishModel trackerScreenshotPublishModel = new TrackerScreenshotPublishModel()
            {
                InsertUserActivityScreenShot = insertUserActivityScreenShotInputModel,
                LoggedInUser = loggedInUser,
                RetryCount = 0
            };

            Send(trackerScreenshotPublishModel);

            return "Screenshot Captured Successfully";
        }
    }
}
