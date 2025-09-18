using Newtonsoft.Json;
using System;
using System.Messaging;

namespace BTrak.Common.MSMQ
{
    public class MessageQueuePublisher<T> : IDisposable
    {
        private static bool IsEnabled = true;
        private readonly MessageQueue _msgQ;

        public MessageQueuePublisher(string messageQueueName)
        {
            if (!IsEnabled)
            {
                LoggingManager.Warn("MSMQ publish is not enabled");
                return;
            }

            _msgQ = new MessageQueue(messageQueueName);
            _msgQ.Formatter = new BinaryMessageFormatter();
        }

        public void Send(T message, string label = "")
        {
            try
            {
                string json = JsonConvert.SerializeObject(message);

                using (var m = new Message { Body = json, Recoverable = true, Formatter = new BinaryMessageFormatter(), Label = label })
                {
                    _msgQ.Send(m);
                }
            }
            catch (Exception ex)
            {
                LoggingManager.Error("Cannot send message to the queue", ex);
            }
        }

        public void Dispose()
        {
            if (_msgQ != null)
            {
                _msgQ.Dispose();
            }
        }
    }
}
