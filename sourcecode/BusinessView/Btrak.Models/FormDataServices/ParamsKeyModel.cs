using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.FormDataServices
{
    public class ParamsKeyModel
    {
        public string KeyName { get; set; }
        public string KeyValue { get; set; }
        public string Type { get; set; }
        public bool? IsFormData { get; set; }
    }
}
