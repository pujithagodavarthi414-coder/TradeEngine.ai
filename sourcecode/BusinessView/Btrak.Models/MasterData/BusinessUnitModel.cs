using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.MasterData
{
    public class BusinessUnitModel
    {
        public Guid? BusinessUnitId { get; set; }
        public string BusinessUnitName { get; set; }
        public Guid? ParentBusinessUnitId { get; set; }
        public byte[] TimeStamp { get; set; }
        public string EmployeeIdsXML { get; set; }
        public List<Guid> EmployeeIds { get; set; }
        public bool IsArchive { get; set; }
    }
}
