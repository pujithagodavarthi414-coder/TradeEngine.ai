using System;
using System.Text;

namespace Btrak.Models.Employee
{
    public class EmployeeContactDetailsApiReturnModel
    {
        public Guid? EmployeeContactDetailId { get; set; }
        public Guid? EmployeeId { get; set; }
        public string FirstName { get; set; }
        public string SurName { get; set; }
        public string UserName { get; set; }
        public string Email { get; set; }
        public Guid? StateId { get; set; }
        public string StateName { get; set; }
        public string Address1 { get; set; }
        public string Address2 { get; set; }
        public string PostalCode { get; set; }
        public Guid? CountryId { get; set; }
        public string CountryName { get; set; }
        public string CountryCode { get; set; }
        public string HomeTelephone { get; set; }
        public string Mobile { get; set; }
        public string WorkTelephone { get; set; }
        public string WorkEmail { get; set; }
        public string OtherEmail { get; set; }
        public string ContactPersonName { get; set; }
        public Guid? RelationshipId { get; set; }
        public DateTime? DateOfBirth { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }
        public bool IsArchived { get; set; }
        public Guid? UserId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EmployeeContactDetailId = " + EmployeeContactDetailId);
            stringBuilder.Append(", EmployeeId = " + EmployeeId);
            stringBuilder.Append(", FirstName = " + FirstName);
            stringBuilder.Append(", SurName = " + SurName);
            stringBuilder.Append(", UserName = " + UserName);
            stringBuilder.Append(", Email = " + Email);
            stringBuilder.Append(", StateId = " + StateId);
            stringBuilder.Append(", StateName = " + StateName);
            stringBuilder.Append(", Address1 = " + Address1);
            stringBuilder.Append(", Address2 = " + Address2);
            stringBuilder.Append(", PostalCode = " + PostalCode);
            stringBuilder.Append(", CountryId = " + CountryId);
            stringBuilder.Append(", CountryName = " + CountryName);
            stringBuilder.Append(", CountryCode = " + CountryCode);
            stringBuilder.Append(", HomeTelephone = " + HomeTelephone);
            stringBuilder.Append(", Mobile = " + Mobile);
            stringBuilder.Append(", WorkTelephone = " + WorkTelephone);
            stringBuilder.Append(", WorkEmail = " + WorkEmail);
            stringBuilder.Append(", OtherEmail = " + OtherEmail);
            stringBuilder.Append(", ContactPersonName = " + ContactPersonName);
            stringBuilder.Append(", RelationshipId = " + RelationshipId);
            stringBuilder.Append(", DateOfBirth = " + DateOfBirth);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", UserId = " + UserId);
            return stringBuilder.ToString();
        }
    }
}
