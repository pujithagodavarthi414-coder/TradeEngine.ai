using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.TimeSheet
{
    public class LoggingComplainceOutputModel
    {
        public bool? IsFinishValid { get; set; }
        public float? SpentTime { get; set; }
        public float? LogTime { get; set; }
        public string IsLoggingMandatory { get; set; }
    }
}
