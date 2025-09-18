using System;
using System.Text;

namespace Btrak.Models.Employee
{
    public class EmployeeLicenceDetailsApiReturnModel
    {
        public Guid? EmployeeId { get; set; }
        public Guid? EmployeeLicenceDetailId { get; set; }
        public string FirstName { get; set; }
        public string SurName { get; set; }
        public string UserName { get; set; }
        public string Email { get; set; }
        public Guid? LicenceTypeId { get; set; }
        public string LicenceType { get; set; }
        public string LicenceNumber { get; set; }
        public DateTime? LicenceIssuedDate { get; set; }
        public DateTime? LicenceExpiryDate { get; set; }
        public Guid? EmployeeContactTypeId { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }
        public bool IsArchived { get; set; }
        public Guid? UserId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EmployeeId = " + EmployeeId);
            stringBuilder.Append(", EmployeeLicenceDetailId = " + EmployeeLicenceDetailId);
            stringBuilder.Append(", FirstName = " + FirstName);
            stringBuilder.Append(", SurName = " + SurName);
            stringBuilder.Append(", UserName = " + UserName);
            stringBuilder.Append(", Email = " + Email);
            stringBuilder.Append(", LicenceTypeId = " + LicenceTypeId);
            stringBuilder.Append(", LicenceType = " + LicenceType);
            stringBuilder.Append(", LicenceNumber = " + LicenceNumber);
            stringBuilder.Append(", LicenceIssuedDate = " + LicenceIssuedDate);
            stringBuilder.Append(", LicenceExpiryDate = " + LicenceExpiryDate);
            stringBuilder.Append(", EmployeeContactTypeId = " + EmployeeContactTypeId);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", UserId = " + UserId);
            return stringBuilder.ToString();
        }
    }
}
