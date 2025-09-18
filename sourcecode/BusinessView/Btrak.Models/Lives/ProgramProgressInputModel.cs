using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Lives
{
     public class ProgramProgressInputModel
    {

        public Guid? ProgramId { get; set; }
        public Guid? DataSetId { get; set; }
        public Guid? DataSourceId { get; set; }
        public bool? IsArchived { get; set; }
        public bool? IsVerified { get; set; }
        public object FormData { get; set; }
        public string Template { get; set; }
        public string KPIType { get; set; }
        public bool? IsNewRecord { get; set; }
    }
    
}
