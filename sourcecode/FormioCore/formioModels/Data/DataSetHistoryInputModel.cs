using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioModels.Data
{
    public class DataSetHistoryInputModel
    {
        public Guid? Id { get; set; }
        public Guid? DataSetId { get; set; }
        public string Field { get; set; }
        public string OldValue { get; set; }
        public string NewValue { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public string Description { get; set; }
        public object DataSetFormData { get; set; }
        public object DataSourceFormJson { get; set; }
        public string DataSourceName { get; set; }
        public Guid? DataSourceId { get; set; }
        public object datasets { get; set; }
        public object dataSource { get; set; }
        public object DataSourceKeys { get; set; }
        public int? TotalCount { get; set; }
        public string Label { get; set; }
        public string Type { get; set; }
        public string Format { get; set; }
    }

    public class DataSetHistoryConversionModel
    {
        public DataSetHistoryInputModel Data { get; set; }
        public int? TotalCount { get; set; }
    }
}
