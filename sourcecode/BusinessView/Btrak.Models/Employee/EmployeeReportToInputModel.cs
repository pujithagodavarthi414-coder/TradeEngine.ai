using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Employee
{
    public class EmployeeReportToInputModel : InputModelBase
    {
        public EmployeeReportToInputModel() : base(InputTypeGuidConstants.EmployeeReportToInputCommandTypeGuid)
        {
        }
       
        public Guid? EmployeeReportToId { get; set; }
        public Guid? EmployeeId { get; set; }
        public Guid? ReportToEmployeeId { get; set; }
        public Guid? ReportingMethodId { get; set; }
        public DateTime? ReportingFrom { get; set; }
        public string Comments { get; set; }
        public bool? IsArchived { get; set; }
        public Guid? OperationsPerformedBy { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" EmployeeReportToId = " + EmployeeReportToId);
            stringBuilder.Append(", EmployeeId = " + EmployeeId);
            stringBuilder.Append(", ReportToEmployeeId = " + ReportToEmployeeId);
            stringBuilder.Append(", ReportingMethodId = " + ReportingMethodId);
            stringBuilder.Append(", ReportingFrom = " + ReportingFrom);
            stringBuilder.Append(", Comments = " + Comments);
            stringBuilder.Append(", OperationsPerformedBy = " + OperationsPerformedBy);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
