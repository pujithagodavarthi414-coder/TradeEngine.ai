using System;
using System.Text;

namespace Btrak.Models.Employee
{
    public class EmployeeImmigrationDetailsApiReturnModel
    {
        public Guid? EmployeeId { get; set; }
        public Guid? EmployeeImmigrationId { get; set; }
        public string FirstName { get; set; }
        public string SurName { get; set; }
        public string UserName { get; set; }
        public string Email { get; set; }
        public string Document { get; set; }
        public string DocumentNumber { get; set; }
        public DateTime? IssuedDate { get; set; }
        public DateTime? ExpiryDate { get; set; }
        public string EligibleStatus { get; set; }
        public DateTime? EligibleReviewDate { get; set; }
        public string Comments { get; set; }
        public DateTime? ActiveFrom { get; set; }
        public DateTime? ActiveTo { get; set; }
        public Guid? CountryId { get; set; }
        public string CountryName { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }
        public bool IsArchived { get; set; }
        public Guid? UserId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EmployeeId = " + EmployeeId);
            stringBuilder.Append(", EmployeeImmigrationId = " + EmployeeImmigrationId);
            stringBuilder.Append(", FirstName = " + FirstName);
            stringBuilder.Append(", SurName = " + SurName);
            stringBuilder.Append(", UserName = " + UserName);
            stringBuilder.Append(", Email = " + Email);
            stringBuilder.Append(", Document = " + Document);
            stringBuilder.Append(", DocumentNumber = " + DocumentNumber);
            stringBuilder.Append(", IssuedDate = " + IssuedDate);
            stringBuilder.Append(", ExpiryDate = " + ExpiryDate);
            stringBuilder.Append(", EligibleStatus = " + EligibleStatus);
            stringBuilder.Append(", EligibleReviewDate = " + EligibleReviewDate);
            stringBuilder.Append(", Comments = " + Comments);
            stringBuilder.Append(", ActiveFrom = " + ActiveFrom);
            stringBuilder.Append(", ActiveTo = " + ActiveTo);
            stringBuilder.Append(", CountryId = " + CountryId);
            stringBuilder.Append(", CountryName = " + CountryName);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", UserId = " + UserId);
            return stringBuilder.ToString();
        }
    }
}
