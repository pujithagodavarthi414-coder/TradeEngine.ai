using BTrak.Api.Models.Hub;
using System.Collections.Concurrent;

namespace BTrak.Api.Helpers
{
    public static class ScreenShotData
    {
        public static readonly ConcurrentDictionary<string, string> _screenShotStrings =
            new ConcurrentDictionary<string, string>();

        public static void UploadScreenShot(string requestDataJson)
        {
            var requestData = Newtonsoft.Json.JsonConvert.DeserializeObject<HubRequestData>(requestDataJson);
            _screenShotStrings.TryAdd(requestData.TrackerConnectionValue, requestData.ScreenShotBase64);
            _screenShotStrings[requestData.TrackerConnectionValue] = requestData.ScreenShotBase64;
        }
    }
}