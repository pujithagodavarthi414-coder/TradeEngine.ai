using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.PayRoll
{
   public class EmployeePayRollConfiguration
    {
        public Guid? Id { get; set; }
        public Guid EmployeeId { get; set; }
        public Guid PayrollTemplateId { get; set; }
        public string EmployeeName { get; set; }
        public DateTime? ActiveFrom { get; set; }
        public DateTime? ActiveTo { get; set; }
        public  bool IsApproved { get; set; }
        public string PayrollName { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("Id = " + Id);
            stringBuilder.Append(",PayRollTemplateId = " + PayrollTemplateId);
            stringBuilder.Append(",EmployeeId = " + EmployeeId);
            stringBuilder.Append(",EmployeeName = " + EmployeeName);
            stringBuilder.Append(",ActiveFrom = " + ActiveFrom);
            stringBuilder.Append(",ActiveTo = " + ActiveTo);
            stringBuilder.Append(",IsApproved = " + IsApproved);
            return stringBuilder.ToString();
        }

    }
}
