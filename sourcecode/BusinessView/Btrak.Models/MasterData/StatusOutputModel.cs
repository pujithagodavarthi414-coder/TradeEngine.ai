using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.MasterData
{
    public class StatusOutputModel
    {
        public Guid StatusId { get; set; }
        public string StatusName { get; set; }
        public string StatusColour { get; set; }
        public byte[] TimeStamp { get; set; }

    }
}
