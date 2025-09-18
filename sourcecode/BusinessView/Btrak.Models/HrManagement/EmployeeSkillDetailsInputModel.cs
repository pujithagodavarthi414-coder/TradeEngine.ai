using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.HrManagement
{
    public class EmployeeSkillDetailsInputModel : InputModelBase
    {
        public EmployeeSkillDetailsInputModel() : base(InputTypeGuidConstants.EmployeeSkillSearchInputCommandTypeGuid)
        {
        }

        public Guid? EmployeeSkillId { get; set; }
        public string SearchText { get; set; }
        public Guid? EmployeeId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EmployeeId = " + EmployeeId);
            stringBuilder.Append(", SearchText = " + SearchText);
            stringBuilder.Append(",EmployeeSkillId = " + EmployeeSkillId);
            return stringBuilder.ToString();
        }
    }
}