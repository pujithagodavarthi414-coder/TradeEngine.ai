using System;
using System.Text;

namespace Btrak.Models.Employee
{
    public class EmployeeReportToDetailsApiReturnModel
    {
        public Guid? EmployeeId { get; set; }
        public string FirstName { get; set; }
        public string SurName { get; set; }
        public string UserName { get; set; }
        public string Email { get; set; }
        public Guid? EmployeeReportToId { get; set; }
        public Guid? ReportToEmployeeId { get; set; }
        public string ReportToEmployeeFirstName { get; set; }
        public string ReportToEmployeeSurName { get; set; }
        public string ReportToEmployeeEmail { get; set; }
        public string ReportToEmployeeName { get; set; }
        public Guid? ReportingMethodId { get; set; }
        public string ReportingMethod { get; set; }
        public string OtherText { get; set; }
        public DateTime? ReportingFrom { get; set; }
        public DateTime? ReportingTo { get; set; }
        public string Comments { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }
        public bool IsArchived { get; set; }
        public string DesignationName { get; set; }
        public Guid? UserId { get; set; }
        public Guid? ReportToUserId { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EmployeeId = " + EmployeeId);
            stringBuilder.Append(", FirstName = " + FirstName);
            stringBuilder.Append(", SurName = " + SurName);
            stringBuilder.Append(", UserName = " + UserName);
            stringBuilder.Append(", Email = " + Email);
            stringBuilder.Append(", ReportToEmployeeId = " + ReportToEmployeeId);
            stringBuilder.Append(", ReportToEmployeeFirstName = " + ReportToEmployeeFirstName);
            stringBuilder.Append(", ReportToEmployeeSurName = " + ReportToEmployeeSurName);
            stringBuilder.Append(", ReportToEmployeeEmail = " + ReportToEmployeeEmail);
            stringBuilder.Append(", ReportToEmployeeName = " + ReportToEmployeeName);
            stringBuilder.Append(", ReportingMethodId = " + ReportingMethodId);
            stringBuilder.Append(", ReportingMethod = " + ReportingMethod);
            stringBuilder.Append(", DesignationName = " + DesignationName);
            stringBuilder.Append(", OtherText = " + OtherText);
            stringBuilder.Append(", ReportingFrom = " + ReportingFrom);
            stringBuilder.Append(", ReportingTo = " + ReportingTo);
            stringBuilder.Append(", Comments = " + Comments);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", UserId = " + UserId);
            return stringBuilder.ToString();
        }
    }
}
