using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Crm.Call
{
    public class MakeCallInputModel
    {
        public string CallFrom { get; set; }
        public string CallTo { get; set; }
        public string CallPathSID { get; set; }
        public string RecordingPathSID { get; set; }

    }
}
