using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Employee
{
    public class GradeInputModel : InputModelBase
    {
        public GradeInputModel() : base(InputTypeGuidConstants.EmployeeInputCommandTypeGuid)
        {
        }
        public Guid? GradeId { get; set; }
        public string GradeName { get; set; }
        public int GradeOrder { get; set; }
        public bool IsArchived { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", GradeId = " + GradeId);
            stringBuilder.Append(", GradeName = " + GradeName);
            stringBuilder.Append(", GradeOrder = " + GradeOrder);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
