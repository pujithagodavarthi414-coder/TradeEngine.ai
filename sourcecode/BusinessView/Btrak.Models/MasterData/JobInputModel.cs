using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.MasterData
{
    public class JobInputModel
    {
        public Boolean IsForProbation { get; set; }
        public Boolean IsArchived { get; set; }
        public string JobId { get; set; }
    }
}
