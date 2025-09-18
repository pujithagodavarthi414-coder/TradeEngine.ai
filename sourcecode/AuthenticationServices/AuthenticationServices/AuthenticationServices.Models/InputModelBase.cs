using Newtonsoft.Json;
using System;

namespace AuthenticationServices.Models
{
    public class InputModelBase
    {
        public InputModelBase(Guid inputCommandTypeGuid)
        {
            InputCommandGuid = Guid.NewGuid();
            InputCommandTypeGuid = inputCommandTypeGuid;
        }

        public Guid InputCommandGuid { get; set; }
        public Guid InputCommandTypeGuid { get; set; }
        public byte[] TimeStamp { get; set; }

        public string ToJson()
        {
            return JsonConvert.SerializeObject(this);
        }
    }
}
