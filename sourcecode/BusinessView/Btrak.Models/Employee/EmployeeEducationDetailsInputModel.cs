using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Employee
{
    public class EmployeeEducationDetailsInputModel : InputModelBase
    {
        public EmployeeEducationDetailsInputModel() : base(InputTypeGuidConstants.EmployeeEducationDetailsInputCommandTypeGuid)
        {
        }
         
        public Guid? EmployeeEducationDetailId { get; set; }
        public Guid? EmployeeId { get; set; }
        public Guid? EducationLevelId { get; set; }
        public string Institute { get; set; }
        public Guid? EducationLevelName { get; set; }
        public string MajorSpecialization { get; set; }
        public decimal? GpaOrScore { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public bool IsArchived { get; set; }
        public Guid? OperationsPerformedBy { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EmployeeEducationDetailId = " + EmployeeEducationDetailId);
            stringBuilder.Append(", EmployeeId = " + EmployeeId);
            stringBuilder.Append(", EducationLevelId = " + EducationLevelId);
            stringBuilder.Append(",EducationLevelName = " + EducationLevelName);
            stringBuilder.Append(", Institute = " + Institute);
            stringBuilder.Append(", MajorSpecialization = " + MajorSpecialization);
            stringBuilder.Append(", GpaOrScore = " + GpaOrScore);
            stringBuilder.Append(", StartDate = " + StartDate);
            stringBuilder.Append(", EndDate = " + EndDate);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", OperationsPerformedBy = " + OperationsPerformedBy);
            return stringBuilder.ToString();
        }
    }
}

