using System;
using System.Text;

namespace Btrak.Models.Employee
{
    public class EmployeeWorkExperienceDetailsApiReturnModel
    {
        public Guid? EmployeeId { get; set; }
        public Guid? EmployeeWorkExperienceId { get; set; }
        public string FirstName { get; set; }
        public string SurName { get; set; }
        public string UserName { get; set; }
        public string Email { get; set; }
        public Guid? DesignationId { get; set; }
        public string DesignationName { get; set; }
        public string Company { get; set; }
        public string Comments { get; set; }
        public DateTime? FromDate { get; set; }
        public DateTime? ToDate { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }
        public bool IsArchived { get; set; }
        public Guid? UserId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EmployeeId = " + EmployeeId);
            stringBuilder.Append(", EmployeeWorkExperienceId = " + EmployeeWorkExperienceId);
            stringBuilder.Append(", FirstName = " + FirstName);
            stringBuilder.Append(", SurName = " + SurName);
            stringBuilder.Append(", UserName = " + UserName);
            stringBuilder.Append(", Email = " + Email);
            stringBuilder.Append(", DesignationId = " + DesignationId);
            stringBuilder.Append(", DesignationName = " + DesignationName);
            stringBuilder.Append(", Company = " + Company);
            stringBuilder.Append(", Comments = " + Comments);
            stringBuilder.Append(", FromDate = " + FromDate);
            stringBuilder.Append(", ToDate = " + ToDate);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", UserId = " + UserId);
            return stringBuilder.ToString();
        }
    }
}
