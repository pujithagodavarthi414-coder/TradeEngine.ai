using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Employee
{
    public class EmployeeGradeInputModel : InputModelBase
    {
        public EmployeeGradeInputModel() : base(InputTypeGuidConstants.EmployeeInputCommandTypeGuid)
        {
        }
        public Guid? EmployeeGradeId { get; set; }
        public Guid? GradeId { get; set; }
        public Guid? EmployeeId { get; set; }
        public DateTime ActiveFrom { get; set; }
        public DateTime ActiveTo { get; set; }
        public bool IsArchived { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", EmployeeGradeId = " + EmployeeGradeId);
            stringBuilder.Append(", GradeId = " + GradeId);
            stringBuilder.Append(", EmployeeId = " + EmployeeId);
            stringBuilder.Append(", ActiveFrom = " + ActiveFrom);
            stringBuilder.Append(", ActiveTo = " + ActiveTo);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
