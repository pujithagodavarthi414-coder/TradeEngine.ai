using System;
using System.Text;

namespace Btrak.Models.Employee
{
    public class EmployeeSkillDetailsApiReturnModel
    {
        public Guid? EmployeeId { get; set; }
		public Guid? EmployeeSkillId { get; set; }
		public string FirstName { get; set; }
        public string SurName { get; set; }
        public string UserName { get; set; }
        public string Email { get; set; }
        public Guid? SkillId { get; set; }
		public string SkillName { get; set; }
        public float? YearsOfExperience { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public string Comments { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }
        public bool IsArchived { get; set; }
        public Guid? UserId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EmployeeId = " + EmployeeId);
			stringBuilder.Append(", EmployeeSkillId = " + EmployeeSkillId);
			stringBuilder.Append(", FirstName = " + FirstName);
            stringBuilder.Append(", SurName = " + SurName);
            stringBuilder.Append(", UserName = " + UserName);
            stringBuilder.Append(", Email = " + Email);
            stringBuilder.Append(", SkillId = " + SkillId);
            stringBuilder.Append(", SkillName = " + SkillName);
            stringBuilder.Append(", YearsOfExperience = " + YearsOfExperience);
            stringBuilder.Append(", DateFrom = " + DateFrom);
            stringBuilder.Append(", DateTo = " + DateTo);
            stringBuilder.Append(", Comments = " + Comments);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", UserId = " + UserId);
            return stringBuilder.ToString();
        }
    }
}
