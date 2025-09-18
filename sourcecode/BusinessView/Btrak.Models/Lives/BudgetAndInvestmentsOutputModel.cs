using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Lives
{
    public class BudgetAndInvestmentsOutputModel
    {
        public string ContractType { get; set; }
        public object FormData { get; set; }
        public Guid? DataSourceId { get; set; }
        public Guid? DataSetId { get; set; }
        public Guid? ProgramId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public object ProgramFormData { get; set; }
    }
}
