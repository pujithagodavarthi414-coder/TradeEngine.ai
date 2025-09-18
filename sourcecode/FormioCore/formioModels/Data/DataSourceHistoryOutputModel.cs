using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioModels.Data
{
   public class DataSourceHistoryOutputModel
    {
        public Guid? Id { get; set; }
        public Guid? DataSourceId { get; set; }
        public string DataSourceName { get; set; }
        public string FieldName { get; set; }
        public string Description { get; set; }
        public string OldValue { get; set; }
        public string NewValue { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime CreatedDateTime { get; set; }
    }
}
