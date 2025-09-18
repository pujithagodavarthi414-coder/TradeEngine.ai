using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.MasterData
{
    public class BusinessUnitDropDownModel
    {
        public Guid? BusinessUnitId { get; set; }
        public string BusinessUnitName { get; set; }
        public Guid? ParentBusinessUnitId { get; set; }
        public bool IsFromHR { get; set; }
    }
}
