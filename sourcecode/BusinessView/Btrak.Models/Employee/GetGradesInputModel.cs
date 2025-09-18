using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Employee
{
    public class GetGradesInputModel : InputModelBase
    {
        public GetGradesInputModel() : base(InputTypeGuidConstants.EmployeeInputCommandTypeGuid)
        {
        }
        public Guid? GradeId { get; set; }
        public string SearchText { get; set; }
        public bool? IsArchived { get; set; }
    }
}
