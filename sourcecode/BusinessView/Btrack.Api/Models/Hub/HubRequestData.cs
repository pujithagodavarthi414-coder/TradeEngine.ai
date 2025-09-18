namespace BTrak.Api.Models.Hub
{
    public class HubRequestData
    {
        public string WebConnectionValue { get; set; }
        public string TrackerConnectionValue { get; set; }
        public bool FromWeb { get; set; }
        public bool FromTracker { get; set; }
        public string ScreenShotBase64 { get; set; }
    }
}
