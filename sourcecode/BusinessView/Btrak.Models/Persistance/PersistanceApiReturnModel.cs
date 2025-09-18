using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Persistance
{
    public class PersistanceApiReturnModel
    {
        public Guid? PersistanceId { get; set; }
        public Guid? ReferenceId { get; set; }
        public string PersistanceJson { get; set; }
    }
}
