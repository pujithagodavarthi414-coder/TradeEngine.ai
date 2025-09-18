using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.MasterData
{
    public class SearchBusinessUnitApiOutputModel
    {
        public Guid? BusinessUnitId { get; set; }
        public string BusinessUnitName { get; set; }
        public Guid? ParentBusinessUnitId { get; set; }
        public byte[] TimeStamp { get; set; }
        public string EmployeeIdsJson { get; set; }
        public DateTime? InactiveDateTime { get; set; }
        public bool IsArchive { get; set; }
        public List<SearchBusinessUnitApiOutputModel> Children { get; set; }
        public bool CanAddEmployee { get; set; }
        public List<Guid?> EmployeeIds { get; set; }
        public string EmployeeNames { get; set; }
    }

    public class EmployeeIdsModel
    {
        public Guid? EmployeeId { get; set; }
    }
}
