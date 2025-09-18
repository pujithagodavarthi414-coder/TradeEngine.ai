using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.FormDataServices
{
   public class DataSourceHistoryInputModel
    {
        public Guid? Id { get; set; }
        public Guid? DataSourceId { get; set; }
        public string FieldName { get; set; }
        public string Description { get; set; }
        public string OldValue { get; set; }
        public string NewValue { get; set; }
    }
}
