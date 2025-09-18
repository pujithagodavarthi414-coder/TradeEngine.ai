using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Widgets
{
   public class ArchivedRecurringExpressionModel
    {
        public Guid? CustomWidgetId { get; set; }
        public Guid? CronExpressionId { get; set; }
        public bool? IsArchived { get; set; }
     
    }
}
