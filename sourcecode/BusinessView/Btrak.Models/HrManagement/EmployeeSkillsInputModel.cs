using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.HrManagement
{
    public class EmployeeSkillsInputModel : InputModelBase
    {
        public EmployeeSkillsInputModel() : base(InputTypeGuidConstants.EmployeeSkillInputCommandTypeGuid)
        {
        }
      
        public Guid? EmployeeSkillId { get; set; }
        public Guid? EmployeeId { get; set; }
        public Guid? SkillId { get; set; }
        public float? YearsOfExperience { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public string Comments { get; set; }
        public bool? IsArchived { get; set; }
        public Guid? OperationsPerformedBy { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" EmployeeSkillId = " + EmployeeSkillId);
            stringBuilder.Append(", EmployeeId = " + EmployeeId);
            stringBuilder.Append(", SkillId = " + SkillId);
            stringBuilder.Append(", YearsOfExperience = " + YearsOfExperience);
            stringBuilder.Append(", DateFrom = " + DateFrom);
            stringBuilder.Append(", DateTo = " + DateTo);
            stringBuilder.Append(", Comments = " + Comments);
            stringBuilder.Append(", OperationsPerformedBy = " + OperationsPerformedBy);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
