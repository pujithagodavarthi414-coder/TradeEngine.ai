using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.MasterData
{
    public class TimeSheetJobDetails
    {
        public string JobId { get; set; }
        public Guid? CronExpressionId { get; set; }
    }
}
