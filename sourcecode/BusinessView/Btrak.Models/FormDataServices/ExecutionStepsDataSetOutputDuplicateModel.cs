using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.FormDataServices
{
    public class ExecutionStepsDataSetOutputDuplicateModel
    {

        public Guid? Id { get; set; }
        public Guid? DataSourceId { get; set; }
        public PurchaseExecutionDuplicateModel DataJson { get; set; }
        public string Name { get; set; }
        public string DataSourceName { get; set; }
        public string DataSourceType { get; set; }
        public bool? IsArchived { get; set; }
        public object DataSourceFormJson { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public int? TotalCount { get; set; }
    }

    public class PurchaseExecutionDuplicateModel
    {
        public Guid? Id { get; set; }
        public Guid? ContractId { get; set; }
        public Guid? StepId { get; set; }
        public Guid? PurchaseId { get; set; }
        public string StepName { get; set; }
        public Guid? StatusId { get; set; }
        public Guid? DataSourceId { get; set; }
        public Guid? StampClientId { get; set; }
        public string ContractType { get; set; }
        public int ReminderCount { get; set; }
        public string StatusName { get; set; }
    }


}
