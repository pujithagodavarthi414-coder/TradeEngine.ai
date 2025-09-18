using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.GrERomande
{
   public  class GreRomandeHistoryOutputModel
    {
        public Guid? HistoryId { get; set; }
        public Guid? GreRomandeId { get; set; }
        public string OldValue { get; set; }
        public string NewValue { get; set; }
        public string FieldName { get; set; }
        public string Description { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public string GridInvoice { get; set; }
        public string OldJson { get; set; }
    }
}
