using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Employee
{
    public class EmployeeImmigrationDetailsInputModel : InputModelBase
    {
        public EmployeeImmigrationDetailsInputModel() : base(InputTypeGuidConstants.EmployeeImmigrationDetailsInputCommandTypeGuid)
        {
        }

        public Guid? EmployeeImmigrationId { get; set; }
        public Guid? EmployeeId { get; set; }
        public string Document { get; set; }
        public string DocumentNumber { get; set; }
        public DateTime? IssuedDate { get; set; }
        public DateTime? ExpiryDate { get; set; }
        public string EligibleStatus { get; set; }
        public Guid? CountryId { get; set; }
        public DateTime? EligibleReviewDate { get; set; }
        public string Comments { get; set; }
        public DateTime? ActiveFrom { get; set; }
        public DateTime? ActiveTo { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" EmployeeImmigrationId = " + EmployeeImmigrationId);
            stringBuilder.Append(", EmployeeId = " + EmployeeId);
            stringBuilder.Append(", Document = " + Document);
            stringBuilder.Append(", DocumentNumber = " + DocumentNumber);
            stringBuilder.Append(", IssuedDate = " + IssuedDate);
            stringBuilder.Append(", ExpiryDate = " + ExpiryDate);
            stringBuilder.Append(", EligibleStatus = " + EligibleStatus);
            stringBuilder.Append(", CountryId = " + CountryId);
            stringBuilder.Append(", EligibleReviewDate = " + EligibleReviewDate);
            stringBuilder.Append(", Comments = " + Comments);
            stringBuilder.Append(", ActiveFrom = " + ActiveFrom);
            stringBuilder.Append(", ActiveTo = " + ActiveTo);
            return stringBuilder.ToString();
        }
    }
}
