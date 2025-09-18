using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.FormDataServices
{
   public class DataSetHistoryInputModel
    {
        public Guid? Id { get; set; }
        public Guid? DataSetId { get; set; }
        public string OldValue { get; set; }
        public string NewValue { get; set; }
        public string Field { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public string CreatedByUserName { get; set; }
        public string ProfileImage { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public string Description { get; set; }
        public DataSetConversionModel DataSetFormData { get; set; }
        public DataServiceConversionModel DataSourceFormJson { get; set; }
        public string DataSourceName { get; set; }
        public Guid? DataSourceId { get; set; }
        public string Type { get; set; }
        public string Label { get; set; }
        public string Format { get; set; }
        public int? TotalCount { get; set; }
    }
}
