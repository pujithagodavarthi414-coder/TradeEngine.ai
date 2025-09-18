using System;
using System.Text;

namespace Btrak.Models.Employee
{
    public class EmployeeLanguageDetailsApiReturnModel
    {
        public Guid? EmployeeId { get; set; }
        public Guid? EmployeeLanguageId { get; set; }
        public string FirstName { get; set; }
        public string SurName { get; set; }
        public string UserName { get; set; }
        public string Email { get; set; }
        public Guid? LanguageId { get; set; }
        public string Language { get; set; }
        public bool CanRead { get; set; }
        public bool CanWrite { get; set; }
        public bool CanSpeak { get; set; }
        public Guid? CompetencyId { get; set; }
        public string Competency { get; set; }
        public string Comments { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }
        public bool IsArchived { get; set; }
        public Guid? UserId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EmployeeId = " + EmployeeId);
            stringBuilder.Append(", EmployeeLanguageId = " + EmployeeLanguageId);
            stringBuilder.Append(", FirstName = " + FirstName);
            stringBuilder.Append(", SurName = " + SurName);
            stringBuilder.Append(", UserName = " + UserName);
            stringBuilder.Append(", Email = " + Email);
            stringBuilder.Append(", LanguageId = " + LanguageId);
            stringBuilder.Append(", Language = " + Language);
            stringBuilder.Append(", CanRead = " + CanRead);
            stringBuilder.Append(", CanWrite = " + CanWrite);
            stringBuilder.Append(", CanSpeak = " + CanSpeak);
            stringBuilder.Append(", CompetencyId = " + CompetencyId);
            stringBuilder.Append(", Competency = " + Competency);
            stringBuilder.Append(", Comments = " + Comments);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", UserId = " + UserId);
            return stringBuilder.ToString();
        }
    }
}
