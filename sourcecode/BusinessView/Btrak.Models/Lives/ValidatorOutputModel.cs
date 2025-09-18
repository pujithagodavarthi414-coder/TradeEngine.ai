using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Lives
{
    public class ValidatorOutputModel
    {
        public object FormData { get; set; }
        public string ContractType { get; set; }
        public Guid? DataSourceId { get; set; }
    }
}
