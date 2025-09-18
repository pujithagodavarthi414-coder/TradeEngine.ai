using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;

namespace BusinessView.Api.Helpers
{
    public class UiHelper
    {
        public static JsonSerializerSettings JsonSerializerSettings = new JsonSerializerSettings
        {
            ContractResolver = new CamelCasePropertyNamesContractResolver(),
            NullValueHandling = NullValueHandling.Ignore
        };
    }
}