using Btrak.Models.Lives;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.FormDataServices
{
    public class DataSetGenericModel<T>
    {
        public Guid? Id { get; set; }
        public Guid? DataSourceId { get; set; }
        public T DataJson { get; set; }
        public string Name { get; set; }
        public string DataSourceName { get; set; }
        public string DataSourceType { get; set; }
        public bool? IsArchived { get; set; }
        public object DataSourceFormJson { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public Guid? ProgramId { get; set; }
        public object ProgramFormData { get; set; }
        public int? TotalCount { get; set; }
    }

  
}
