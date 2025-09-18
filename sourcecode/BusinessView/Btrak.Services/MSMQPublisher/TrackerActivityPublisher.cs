using Btrak.Models;
using Btrak.Models.ActivityTracker;
using Btrak.Models.MSMQ;
using Btrak.Services.Helpers.ActivityTracker;
using BTrak.Common;
using BTrak.Common.MSMQ;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Services.MSMQPublisher
{
    public class TrackerActivityPublisher : MessageQueuePublisher<TrackerActivityPublishModel>, ITrackerActivityPublisher
    {
        private readonly ActivityTrackerValidationHelpers _activityTrackerValidationHelpers = new ActivityTrackerValidationHelpers();

        public TrackerActivityPublisher() : base(MSMQPathConstants.TrackerActivityPublishPath + "_" + ConfigurationManager.AppSettings["EnvironmentUniqueName"])
        {
        }

        public string InsertUserActivityTime(InsertUserActivityInputModel insertUserActivityTimeInputModel, List<ValidationMessage> validationMessages, Guid? loggedInUser)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "InsertUserActivityTime", "InsertUserActivityInputModel", insertUserActivityTimeInputModel, "TrackerActivityPublisher"));

            _activityTrackerValidationHelpers.InsertUserActivityTimeValidation(insertUserActivityTimeInputModel, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            TrackerActivityPublishModel trackerActivityPublishModel = new TrackerActivityPublishModel()
            {
                ActivityInputModel = insertUserActivityTimeInputModel,
                LoggedInUser = loggedInUser,
                RetryCount = 0
            };

            LoggingManager.Info("Pubishing TrackerActivity to Queue for data " + JsonConvert.SerializeObject(trackerActivityPublishModel, Formatting.Indented) + " on " + DateTime.UtcNow);

            Send(trackerActivityPublishModel);

            return "Inserted Successfully";
        }
    }
}
