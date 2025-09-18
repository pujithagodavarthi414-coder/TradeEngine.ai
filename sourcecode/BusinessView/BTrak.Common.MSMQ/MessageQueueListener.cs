using System.Messaging;
using Newtonsoft.Json;
using System;

namespace BTrak.Common.MSMQ
{
    public class MessageQueueListener<T> : IDisposable
    {
        private readonly MessageQueue _msgQ;
        private readonly Action<T> _messageHandler;
        private readonly string _queueName;
        private bool _isDisposed;

        public MessageQueueListener(string messageQueueName, Action<T> messageHandler)
        {
            _queueName = messageQueueName;

            if (messageHandler == null)
            {
                messageHandler = s => { };
            }

            _messageHandler = messageHandler;

            LoggingManager.Info(string.Format("Creating listener on queue '{0}'", messageQueueName));

            try
            {
                if (MessageQueue.Exists(messageQueueName))
                {
                    _msgQ = new MessageQueue(messageQueueName);
                }
                else
                {
                    LoggingManager.Info(string.Format("Queue '{0}' doesn't exist. Creating listener for existing queue '{0}'", messageQueueName));
                    _msgQ = MessageQueue.Create(messageQueueName);
                }

                _msgQ.Formatter = new BinaryMessageFormatter();
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format("Cannot create listener on queue '{0}'", messageQueueName));
                LoggingManager.Error(ex);
                throw;
            }

            LoggingManager.Info(string.Format("Listener created on queue '{0}'", messageQueueName));
        }

        public void StartReceivingMessages()
        {
            LoggingManager.Info(string.Format("Queue '{0}' listening..", _queueName));
            _msgQ.ReceiveCompleted += QueueMessageReceived;
            _msgQ.BeginReceive();
        }

        private void QueueMessageReceived(object source, ReceiveCompletedEventArgs args)
        {
            if (_isDisposed)
            {
                return;
            }

            MessageQueue msQueue = (MessageQueue)source;
            Message m = msQueue.EndReceive(args.AsyncResult);

            string content = (string)m.Body;
            if (m != null)
            {
                try
                {
                    T typedMessage = JsonConvert.DeserializeObject<T>(content);
                    _messageHandler(typedMessage);

                }
                catch (Exception ex)
                {
                    LoggingManager.Error("Unexpected exception in message handler", ex);
                }
            }

            if (!_isDisposed)
            {
                msQueue.BeginReceive();
            }
            else
            {
                LoggingManager.Info(string.Format("Queue '{0}' listener stopped", _queueName));
            }
        }

        public void Dispose()
        {
            LoggingManager.Info(string.Format("Queue '{0}' listener stopping", _queueName));

            _isDisposed = true;

            if (_msgQ != null)
            {
                _msgQ.Dispose();
            }
        }
    }
}
