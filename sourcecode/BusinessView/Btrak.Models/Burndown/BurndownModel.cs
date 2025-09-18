using Newtonsoft.Json;

namespace Btrak.Models.Burndown
{
    public class BurndownModel
    {
        [JsonProperty("date")]
        public string date { get; set; }

        [JsonProperty("expected")]
        public string expected { get; set; }

        [JsonProperty("actual")]
        public string actual { get; set; }
    }
}