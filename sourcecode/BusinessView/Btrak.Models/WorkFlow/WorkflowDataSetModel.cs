using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.WorkFlow
{
    public class WorkflowDataSetModel
    {
        public Guid? Id { get; set; }
        public Guid? DataSourceId { get; set; }
        public Guid? CompanyId { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public Guid? ArchivedByUserId { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public DateTime? ArchivedDateTime { get; set; }
        public string DataJson { get; set; }
        public bool? IsArchived { get; set; }
        public Guid? CompanyModuleId { get; set; }
        
    }

    public class DataSetOutputModel
    {
        
        public Guid? Id { get; set; }
        public Guid? DataSourceId { get; set; }
        public object DataJson { get; set; }
        public string Name { get; set; }
        public string DataSourceName { get; set; }
        public string DataSourceType { get; set; }
        public bool? IsArchived { get; set; }
    }
}
