using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Lives
{
    public class ESGIndicatorDataSetUpsertModel
    {
        public Guid? ProgramId { get; set; }
        public string UserIds { get; set; }
        public string Template { get; set; }
        public object FormData { get; set; }
        public Guid? KpiId { get; set; }
        public string FormName { get; set; }
    }
}
