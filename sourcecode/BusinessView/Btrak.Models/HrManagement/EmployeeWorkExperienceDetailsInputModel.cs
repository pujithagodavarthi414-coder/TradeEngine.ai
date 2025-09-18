using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.HrManagement
{
    public class EmployeeWorkExperienceDetailsInputModel : InputModelBase
    {
        public EmployeeWorkExperienceDetailsInputModel() : base(InputTypeGuidConstants.EmployeeWorkExperienceSearchInputCommandTypeGuid)
        {
        }

        public Guid? EmployeeWorkExperienceId { get; set; }
        public string SearchText { get; set; }
        public Guid? EmployeeId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EmployeeId = " + EmployeeId);
            stringBuilder.Append(", SearchText = " + SearchText);
            stringBuilder.Append(",EmployeeWorkExperienceId = " + EmployeeWorkExperienceId);
            return stringBuilder.ToString();
        }
    }
}
