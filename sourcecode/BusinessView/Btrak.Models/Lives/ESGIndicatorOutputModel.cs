using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Lives
{
    public class ESGIndicatorOutputModel
    {
        public Guid? Id { get; set; }
        public string KpiName { get; set; }
        public Guid? ProgramId { get; set; }
        public Guid? DataSourceId { get; set; }
        public object ProgramFormData { get; set; }
        public string TargetArea { get; set; }
        public string SDGIndicator { get; set; }
        public string ESGIndicator { get; set; }
        public string FormName { get; set; }
        public string Template { get; set; }
        public ESGIndicatorDataSetUpsertModel DataJson { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public Guid? KpiId { get; set; }
        public object FormData { get; set; }

    }
}
