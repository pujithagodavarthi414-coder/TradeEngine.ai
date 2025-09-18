using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Employee
{
    public class EmployeeGradeSearchInputModel : SearchCriteriaInputModelBase
    {
        public EmployeeGradeSearchInputModel() : base(InputTypeGuidConstants.EmployeeInputCommandTypeGuid)
        {
        }

        public Guid? EmployeeGradeId { get; set; }
        public Guid? EmployeeId { get; set; }

    }
}
