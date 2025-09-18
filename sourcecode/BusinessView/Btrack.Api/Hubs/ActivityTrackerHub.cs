using System;
using System.Collections.Concurrent;
using System.Linq;
using System.Threading.Tasks;
using Btrak.Models.ActivityTracker;
using BTrak.Api.Models.Hub;
using BTrak.Common;
using Microsoft.AspNet.SignalR;
using Microsoft.AspNet.SignalR.Hubs;
using Newtonsoft.Json;
using WebGrease.Css.Extensions;
using BTrak.Api.Helpers;
using System.Timers;

namespace BTrak.Api.Hubs
{
    [HubName("ActivityTrackerHub")]
    public class ActivityTrackerHub : Hub
    {
        private static Timer _hubHeartBeat;
        private static readonly ConcurrentDictionary<string, string> _connections =
            new ConcurrentDictionary<string, string>();

        public ActivityTrackerHub()
        {
            LoggingManager.Info($"ActivityTrackerHub: initialized _connections: {JsonConvert.SerializeObject(_connections)}");
            if (_hubHeartBeat == null)
            {
                _hubHeartBeat = new Timer();
                _hubHeartBeat.Elapsed += HubHeartBeat;
                _hubHeartBeat.Interval = Convert.ToDouble(60000);
                _hubHeartBeat.Enabled = true;
            }
        }

        private void HubHeartBeat(object sender, ElapsedEventArgs e)
        {
            LoggingManager.Info($"ActivityTrackerHub: HubHeartBeat _connections: {JsonConvert.SerializeObject(_connections)}");
        }

        //private static readonly ConcurrentDictionary<string, string> _screenShotConnections =
        //    new ConcurrentDictionary<string, string>();

        // for testing the connection while implementation
        public void MoveShape(double x, double y)
        {
            Clients.Caller.shapeMoved(x + 2, y + 2);
        }

        public void CaptureLiveScreenShot(string hubRequestJson)
        {
            try
            {
                Clients.Caller.contactMade($"CaptureLiveScreenShot: {hubRequestJson}");

                LoggingManager.Info($"CaptureLiveScreenShot: start Capture live screenShot trigger for {hubRequestJson}");

                var requestData = GetRequestData(hubRequestJson);

                var connectionId = _connections.FirstOrDefault(x => x.Value == requestData.TrackerConnectionValue).Key;
                if (connectionId == null)
                {
                    LoggingManager.Info($"CaptureLiveScreenShot: Capture live screenShot trigger for {hubRequestJson} is not available as clinet doesn't exist");
                    Clients.Caller.clientNotAvailable(hubRequestJson);
                }
                else
                {
                    //_screenShotConnections.TryAdd(requestData.TrackerConnectionValue, null);
                    ScreenShotData._screenShotStrings.TryAdd(requestData.TrackerConnectionValue, null);
                    LoggingManager.Info($"CaptureLiveScreenShot: Capture live screenShot trigger for {hubRequestJson} is made");
                    Clients.Client(connectionId).captureLiveScreenShot(hubRequestJson);
                }
            }
            catch(Exception exception)
            {
                LoggingManager.Info($"CaptureLiveScreenShot: error occurred for {hubRequestJson}");
                LoggingManager.Error(exception);
                Clients.Caller.someThingWentWrong($"CaptureLiveScreenShot: {exception.Message}");
            }
        }

        public void CancelLiveScreenCast(string hubRequestJson)
        {
            try
            {
                Clients.Caller.contactMade($"CaptureLiveScreenCast: {hubRequestJson}");

                LoggingManager.Info($"CaptureLiveScreenCast: start Capture live screenShot trigger for {hubRequestJson}");

                var requestData = GetRequestData(hubRequestJson);

                var connectionId = _connections.FirstOrDefault(x => x.Value == requestData.TrackerConnectionValue).Key;
                if (connectionId == null)
                {
                    LoggingManager.Info($"CaptureLiveScreenCast: Capture live screenShot trigger for {hubRequestJson} is not available as clinet doesn't exist");
                    Clients.Caller.clientNotAvailable(hubRequestJson);
                }
                else
                {
                    ScreenShotData._screenShotStrings.TryAdd(requestData.TrackerConnectionValue, null);
                    LoggingManager.Info($"CaptureLiveScreenCast: Capture live screenShot trigger for {hubRequestJson} is made");
                    Clients.Client(connectionId).cancelLiveScreenCast(hubRequestJson);
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Info($"CaptureLiveScreenCast: error occurred for {hubRequestJson}");
                LoggingManager.Error(exception);
                Clients.Caller.someThingWentWrong($"CaptureLiveScreenCast: {exception.Message}");
            }
        }

        public void CaptureLiveScreenCast(string hubRequestJson)
        {
            try
            {
                Clients.Caller.contactMade($"CaptureLiveScreenCast: {hubRequestJson}");

                LoggingManager.Info($"CaptureLiveScreenCast: start Capture live screenShot trigger for {hubRequestJson}");

                var requestData = GetRequestData(hubRequestJson);

                var connectionId = _connections.FirstOrDefault(x => x.Value == requestData.TrackerConnectionValue).Key;
                if (connectionId == null)
                {
                    LoggingManager.Info($"CaptureLiveScreenCast: Capture live screenShot trigger for {hubRequestJson} is not available as clinet doesn't exist");
                    Clients.Caller.clientNotAvailable(hubRequestJson);
                }
                else
                {
                    ScreenShotData._screenShotStrings.TryAdd(requestData.TrackerConnectionValue, null);
                    LoggingManager.Info($"CaptureLiveScreenCast: Capture live screenShot trigger for {hubRequestJson} is made");
                    Clients.Client(connectionId).captureLiveScreenCast(hubRequestJson);
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Info($"CaptureLiveScreenCast: error occurred for {hubRequestJson}");
                LoggingManager.Error(exception);
                Clients.Caller.someThingWentWrong($"CaptureLiveScreenCast: {exception.Message}");
            }
        }

        public void LiveScreenShotChunkUpdater(string chunk, string hubRequestJson)
        {
            try
            {
                var requestData = GetRequestData(hubRequestJson);

                ScreenShotData._screenShotStrings[requestData.TrackerConnectionValue] = ScreenShotData._screenShotStrings[requestData.TrackerConnectionValue] + chunk;
            }
            catch(Exception exception)
            {
                LoggingManager.Error(exception);
            }
        }

        public void LiveScreenShotCaptured(ScreenShotOutputModel screenShotData, string hubRequestJson)
        {
            try
            {
                //var screenShotData = JsonConvert.DeserializeObject<ScreenShotOutputModel>(screenShotJson);

                Clients.Caller.contactMade($"LiveScreenShotCaptured: screenShotJson: {JsonConvert.SerializeObject(screenShotData)} clientValue: {hubRequestJson}");

                LoggingManager.Info($"LiveScreenShotCaptured: screenShot captured {hubRequestJson}");

                var requestData = GetRequestData(hubRequestJson);

                var connectionId = _connections.FirstOrDefault(x => x.Value == requestData.WebConnectionValue).Key;

                var screenShotConnectionId = ScreenShotData._screenShotStrings.FirstOrDefault(x => x.Key == requestData.TrackerConnectionValue).Key;

                if (connectionId == null)
                {
                    LoggingManager.Info($"LiveScreenShotCaptured: unable to send it to web as connection not available {hubRequestJson}");
                    Clients.Caller.clientNotAvailable(hubRequestJson);
                }
                else
                {
                    var base64String = ScreenShotData._screenShotStrings.FirstOrDefault(x => x.Key == screenShotConnectionId).Value;

                    LoggingManager.Info($"LiveScreenShotCaptured: sending screenShotJson to web: {JsonConvert.SerializeObject(screenShotData)}");
                    screenShotData.ScreenShotUrl = base64String;
                    Clients.Client(connectionId).screenShotCaptured(JsonConvert.SerializeObject(screenShotData));
                }

                if (screenShotData.ScreenCast)
                {
                    ScreenShotData._screenShotStrings[screenShotConnectionId] = null;
                }
                else
                {
                    ScreenShotData._screenShotStrings.TryRemove(screenShotConnectionId, out string value);
                }
            }
            catch(Exception exception)
            {
                LoggingManager.Info($"LiveScreenShotCaptured: error occurred for {hubRequestJson}");
                LoggingManager.Error(exception);
                Clients.Caller.someThingWentWrong($"LiveScreenShotCaptured: {exception.Message}");
            }
        }

        public void LiveScreenShotCapturedFailed(string failedMessage, string hubRequestJson)
        {
            try
            {
                Clients.Caller.contactMade($"LiveScreenShotCapturedFailed clientValue: {hubRequestJson}");

                LoggingManager.Info($"LiveScreenShotCapturedFailed: screenShot not captured {failedMessage}");

                var requestData = GetRequestData(hubRequestJson);

                var connectionId = _connections.FirstOrDefault(x => x.Value == requestData.WebConnectionValue).Key;
                if(connectionId == null)
                {
                    LoggingManager.Info($"LiveScreenShotCapturedFailed: unable to send it to web as connection not available {hubRequestJson}");
                    Clients.Caller.clientNotAvailable(hubRequestJson);
                }
                else
                {
                    LoggingManager.Info($"LiveScreenShotCapturedFailed: sending clientValue to web: {hubRequestJson}");
                    Clients.Client(connectionId).screenShotFailed(failedMessage);
                }
            }
            catch(Exception exception)
            {
                LoggingManager.Info($"LiveScreenShotCapturedFailed: error occurred for {hubRequestJson}");
                LoggingManager.Error(exception);
                Clients.Caller.someThingWentWrong($"LiveScreenShotCapturedFailed: {exception.Message}");
            }
        }

        public void UpdateClientCredData(string clientCredJson)
        {
            try
            {
                Clients.Caller.contactMade($"UpdateClientCredData clientValue: {clientCredJson}");

                LoggingManager.Info($"UpdateClientCredData: updated keyValue {clientCredJson}");

                var clientData = JsonConvert.DeserializeObject<HubClientData>(clientCredJson);

                var userClients = _connections.Where(x => x.Value == clientData.ClientUserId && x.Key != Context.ConnectionId);
                if (userClients.Any())
                {
                    LoggingManager.Info($"UpdateClientCredData: existed clients with same value deleted {clientCredJson}");
                    userClients.ForEach(x => _connections.TryRemove(x.Key, out string value));
                }

                _connections[Context.ConnectionId] = clientData.ClientUserId;
            }
            catch(Exception exception)
            {
                LoggingManager.Info($"UpdateClientCredData: error occurred for {clientCredJson}");
                LoggingManager.Error(exception);
                Clients.Caller.someThingWentWrong($"UpdateClientCredData: {exception.Message}");
            }
        }

        private HubRequestData GetRequestData(string requestJson)
        {
            try
            {
                return JsonConvert.DeserializeObject<HubRequestData>(requestJson);
            }
            catch (Exception exception)
            {
                LoggingManager.Info($"GetRequestData: error occurred for {requestJson}");
                LoggingManager.Error(exception);
                Clients.Caller.someThingWentWrong($"GetRequestData: {exception.Message}");
            }
            return null;
        }

        public override Task OnConnected()
        {
            _connections.TryAdd(Context.ConnectionId, null);
            return Clients.All.clientCountChanged(_connections.Count);
        }

        public override Task OnReconnected()
        {
            _connections.TryAdd(Context.ConnectionId, null);
            return Clients.All.clientCountChanged(_connections.Count);
        }

        public override Task OnDisconnected()
        {
            _connections.TryRemove(Context.ConnectionId, out string value);
            return Clients.All.clientCountChanged(_connections.Count);
        }
    }
}