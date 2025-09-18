using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Employee
{
    public class EmployeeWorkExperienceInputModel : InputModelBase
    {
        public EmployeeWorkExperienceInputModel() : base(InputTypeGuidConstants.EmployeeWorkExperienceInputCommandTypeGuid)
        {
        }

        public Guid? EmployeeWorkExperienceId { get; set; }
        public Guid? EmployeeId { get; set; }
        public Guid? DesignationId { get; set; }
        public string Company { get; set; }
        public string Comments { get; set; }
        public DateTime? FromDate { get; set; }
        public DateTime? ToDate { get; set; }
        public bool? IsArchived { get; set; }
        public Guid? OperationsPerformedBy { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" EmployeeWorkExperienceId = " + EmployeeWorkExperienceId);
            stringBuilder.Append(", EmployeeId = " + EmployeeId);
            stringBuilder.Append(", DesignationId = " + DesignationId);
            stringBuilder.Append(", Company = " + Company);
            stringBuilder.Append(", Comments = " + Comments);
            stringBuilder.Append(", FromDate = " + FromDate);
            stringBuilder.Append(", ToDate = " + ToDate);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", OperationsPerformedBy = " + OperationsPerformedBy);
            return stringBuilder.ToString();
        }
    }
}
