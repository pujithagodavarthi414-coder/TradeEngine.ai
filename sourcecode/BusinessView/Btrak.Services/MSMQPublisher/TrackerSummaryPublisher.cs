using Btrak.Models;
using Btrak.Models.MSMQ;
using BTrak.Common;
using BTrak.Common.MSMQ;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Messaging;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Services.MSMQPublisher
{
    public class TrackerSummaryPublisher : MessageQueuePublisher<TrackerSummaryPublishModel>, ITrackerSummaryPublisher
    {
        public TrackerSummaryPublisher() : base(MSMQPathConstants.TrackerSummaryPublishPath + "_" + ConfigurationManager.AppSettings["EnvironmentUniqueName"])
        {
        }

        public string InsertUserSummary(Guid? userId, string trackedDate, List<ValidationMessage> validationMessages)
        {
            TrackerSummaryPublishModel trackerSummaryPublishModel = new TrackerSummaryPublishModel()
            {
                UserId = userId,
                TrackedDate = trackedDate,
                RetryCount = 0
            };

            try
            {
                LoggingManager.Info("Fetching messages from Queue - " + MSMQPathConstants.TrackerSummaryListenerPath + "_" + ConfigurationManager.AppSettings["EnvironmentUniqueName"]);

                // Connect to a queue on the local computer.
                MessageQueue queue = new MessageQueue(MSMQPathConstants.TrackerSummaryListenerPath + "_" + ConfigurationManager.AppSettings["EnvironmentUniqueName"]);

                // Populate an array with copies of all the messages in the queue.
                Message[] msgs = queue.GetAllMessages();

                if (msgs.ToList().Where(p => p.Label == userId.ToString() + trackedDate).ToList().Count == 0)
                {
                    LoggingManager.Info("Pubishing TrackerSummary to Queue for data " + JsonConvert.SerializeObject(trackerSummaryPublishModel, Formatting.Indented) + " on " + DateTime.UtcNow);
                    Send(trackerSummaryPublishModel, userId.ToString()  + trackedDate);
                }
            }
            catch (Exception ex)
            {
                LoggingManager.Error("Can't messages from Queue - " + MSMQPathConstants.TrackerSummaryListenerPath + "_" + ConfigurationManager.AppSettings["EnvironmentUniqueName"] + " - with ex - " + ex.Message);
                Send(trackerSummaryPublishModel, userId.ToString());
            }

            return "Inserted Successfully";
        }
    }
}
