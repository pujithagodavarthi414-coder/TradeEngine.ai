using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Employee
{
    public class EmployeeFieldsModel
    {
        public Guid? Id { get; set; }
        public bool? IsHide { get; set; }
        public bool? IsEdit { get; set; }
        public bool? IsRequired { get; set; }
        public string FieldName { get; set; }
        public byte[] TimeStamp { get; set; }
    }
}
