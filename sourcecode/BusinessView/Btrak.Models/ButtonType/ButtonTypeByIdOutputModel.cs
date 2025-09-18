using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ButtonType
{
    public class ButtonTypeByIdOutputModel
    {
        public Guid? ButtonTypeId { get; set; }
        public string ButtonTypeName { get; set; }
        public bool IsStart { get; set; }
        public bool IsFinish { get; set; }
        public bool IsLunchStart { get; set; }
        public bool IsLunchEnd { get; set; }
        public bool IsBreakIn { get; set; }
        public bool BreakOut { get; set; }
    }
}
