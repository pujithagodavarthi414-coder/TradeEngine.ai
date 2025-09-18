using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioModels
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
