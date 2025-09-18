using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Employee
{
    public class EmployeeContactDetailsInputModel : InputModelBase
    {
        public EmployeeContactDetailsInputModel() : base(InputTypeGuidConstants.EmployeeContactDetailsInputCommandTypeGuid)
        {
        }

        public Guid? EmployeeContactDetailId { get; set; }
        public Guid? EmployeeId { get; set; }
        public Guid? StateId { get; set; }
        public string Address1 { get; set; }
        public string Address2 { get; set; }
        public string PostalCode { get; set; }
        public Guid? CountryId { get; set; }
        public string HomeTelephone { get; set; }
        public string Mobile { get; set; }
        public string WorkTelephone { get; set; }
        public string WorkEmail { get; set; }
        public string OtherEmail { get; set; }
        public string ContactPersonName { get; set; }
        public Guid? RelationshipId { get; set; }
        public DateTime? DateOfBirth { get; set; }
        public Guid? EmployeeContactTypeId { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EmployeeContactDetailId = " + EmployeeContactDetailId);
            stringBuilder.Append(", EmployeeId = " + EmployeeId);
            stringBuilder.Append(", StateId = " + StateId);
            stringBuilder.Append(", Address1 = " + Address1);
            stringBuilder.Append(", Address2 = " + Address2);
            stringBuilder.Append(", PostalCode = " + PostalCode);
            stringBuilder.Append(", CountryId = " + CountryId);
            stringBuilder.Append(", HomeTelephone = " + HomeTelephone);
            stringBuilder.Append(", Mobile = " + Mobile);
            stringBuilder.Append(", WorkTelephone = " + WorkTelephone);
            stringBuilder.Append(", WorkEmail = " + WorkEmail);
            stringBuilder.Append(", OtherEmail = " + OtherEmail);
            stringBuilder.Append(", ContactPersonName = " + ContactPersonName);
            stringBuilder.Append(", RelationshipId = " + RelationshipId);
            stringBuilder.Append(", DateOfBirth = " + DateOfBirth);
            stringBuilder.Append(", EmployeeContactTypeId = " + EmployeeContactTypeId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}

