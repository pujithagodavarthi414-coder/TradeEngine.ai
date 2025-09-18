using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Employee
{
    public class EmployeeLicenceDetailsInputModel : InputModelBase
    {
        public EmployeeLicenceDetailsInputModel() : base(InputTypeGuidConstants.EmployeeLicenceDetailsInputCommandTypeGuid)
        {
        }
        public Guid? EmployeeLicenceDetailId { get; set; }
        public Guid? EmployeeId { get; set; }
        public Guid? LicenceTypeId { get; set; }
        public string LicenceNumber { get; set; }
        public DateTime? LicenceIssuedDate { get; set; }
        public DateTime? LicenceExpiryDate { get; set; }
        public Guid? EmployeeContactTypeId { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EmployeeLiceneDetailId = " + EmployeeLicenceDetailId);
            stringBuilder.Append(", EmployeeId = " + EmployeeId);
            stringBuilder.Append(", LicenceTypeId = " + LicenceTypeId);
            stringBuilder.Append(", LicenceNumber = " + LicenceNumber);
            stringBuilder.Append(", LicenceIssuedDate = " + LicenceIssuedDate);
            stringBuilder.Append(", LicenceExpiryDate = " + LicenceExpiryDate);
            stringBuilder.Append(", EmployeeContactTypeId = " + EmployeeContactTypeId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}

