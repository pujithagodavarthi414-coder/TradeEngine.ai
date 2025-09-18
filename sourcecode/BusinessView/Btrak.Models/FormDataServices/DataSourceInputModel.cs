using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.FormDataServices
{
    public class DataSourceInputModel
    {
        public Guid? Id { get; set; }
        public Guid? CompanyId { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public Guid? ArchivedByUserId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public DateTime? ArchivedDateTime { get; set; }
        public string Description { get; set; }
        public string Name { get; set; }
        public string FormBgColor { get; set; }
        public string DataSourceType { get; set; }
        public string Tags { get; set; }
        public string Fields { get; set; }
        public bool IsArchived { get; set; }
        public Guid? CompanyModuleId { get; set; }
        public int? DataSourceTypeNumber { get; set; }
        public Guid[] ViewFormRoleIds { get; set; }
        public Guid[] EditFormRoleIds { get; set; }

    }
}
