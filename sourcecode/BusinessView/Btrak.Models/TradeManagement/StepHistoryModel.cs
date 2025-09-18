using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.TradeManagement
{
   public class StepHistoryModel
    {
        public string OldValue { get; set; }
        public string NewValue { get; set; }
        public string Field { get; set; }
    }
}
