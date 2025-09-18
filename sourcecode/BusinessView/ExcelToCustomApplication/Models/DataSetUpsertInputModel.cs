using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExcelToCustomApplication.Models
{
    public class DataSetUpsertInputModel
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
        public object DataJson { get; set; }
        public bool? IsArchived { get; set; }
        public string CommodityName { get; set; }
        public bool? IsNewRecord { get; set; }
        public Guid? SubmittedUserId { get; set; }
        public Guid? SubmittedCompanyId { get; set; }
        public bool SubmittedByFormDrill { get; set; }
        public string RecordAccessibleUsers { get; set; }
    }
}
