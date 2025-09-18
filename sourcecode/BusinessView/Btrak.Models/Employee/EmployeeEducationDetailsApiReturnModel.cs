using System;
using System.Text;

namespace Btrak.Models.Employee
{
    public class EmployeeEducationDetailsApiReturnModel
    {
        public Guid? EmployeeId { get; set; }
        public Guid? EmployeeEducationDetailId { get; set; }
        public string FirstName { get; set; }
        public string SurName { get; set; }
        public string UserName { get; set; }
        public string Email { get; set; }
        public Guid? EducationLevelId { get; set; }
        public string EducationLevel { get; set; }
        public decimal? GpaOrScore { get; set; }
        public string Institute { get; set; }
        public string MajorSpecialization { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }
        public bool IsArchived { get; set; }
        public Guid? UserId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EmployeeId = " + EmployeeId);
            stringBuilder.Append(", EmployeeEducationDetailId = " + EmployeeEducationDetailId);
            stringBuilder.Append(", FirstName = " + FirstName);
            stringBuilder.Append(", SurName = " + SurName);
            stringBuilder.Append(", UserName = " + UserName);
            stringBuilder.Append(", Email = " + Email);
            stringBuilder.Append(", EducationLevelId = " + EducationLevelId);
            stringBuilder.Append(", EducationLevel = " + EducationLevel);
            stringBuilder.Append(", GpaOrScore = " + GpaOrScore);
            stringBuilder.Append(", Institute = " + Institute);
            stringBuilder.Append(", MajorSpecialization = " + MajorSpecialization);
            stringBuilder.Append(", StartDate = " + StartDate);
            stringBuilder.Append(", EndDate = " + EndDate);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", UserId = " + UserId);
            return stringBuilder.ToString();
        }
    }
}
