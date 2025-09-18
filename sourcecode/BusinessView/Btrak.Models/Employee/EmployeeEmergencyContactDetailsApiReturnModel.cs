using System;
using System.Text;

namespace Btrak.Models.Employee
{
    public class EmployeeEmergencyContactDetailsApiReturnModel
    {
        public Guid? Id { get; set; }
        public Guid? EmployeeId { get; set; }

        public Guid? EmergencyContactId { get; set; }
        public string FirstName { get; set; }
        public string UserFirstName { get; set; }
        public string UserSurName { get; set; }
        public string UserName { get; set; }
        public string Email { get; set; }
        public Guid? RelationshipId { get; set; }
        public string Relationship { get; set; }
        public string LastName { get; set; }
        public string OtherRelation { get; set; }
        public string HomeTelephone { get; set; }
        public string MobileNo { get; set; }
        public string WorkTelephone { get; set; }
        public bool? IsEmergencyContact { get; set; }
        public bool? IsDependentContact { get; set; }
        public Guid? StateOrProvinceId { get; set; }
        public string StateName { get; set; }
        public string ZipOrPostalCode { get; set; }
        public string AddressStreetOne { get; set; }
        public string AddressStreetTwo { get; set; }
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
            stringBuilder.Append(", EmergencyContactId = " + EmergencyContactId);
            stringBuilder.Append(", FirstName = " + FirstName);
            stringBuilder.Append(", UserFirstName = " + UserFirstName);
            stringBuilder.Append(", UserSurName = " + UserSurName);
            stringBuilder.Append(", UserName = " + UserName);
            stringBuilder.Append(", Email = " + Email);
            stringBuilder.Append(", RelationshipId = " + RelationshipId);
            stringBuilder.Append(", Relationship = " + Relationship);
            stringBuilder.Append(", LastName = " + LastName);
            stringBuilder.Append(", OtherRelation = " + OtherRelation);
            stringBuilder.Append(", HomeTelephone = " + HomeTelephone);
            stringBuilder.Append(", MobileNo = " + MobileNo);
            stringBuilder.Append(", WorkTelephone = " + WorkTelephone);
            stringBuilder.Append(", IsEmergencyContact = " + IsEmergencyContact);
            stringBuilder.Append(", IsDependentContact = " + IsDependentContact);
            stringBuilder.Append(", StateOrProvinceId = " + StateOrProvinceId);
            stringBuilder.Append(", StateName = " + StateName);
            stringBuilder.Append(", ZipOrPostalCode = " + ZipOrPostalCode);
            stringBuilder.Append(", AddressStreetOne = " + AddressStreetOne);
            stringBuilder.Append(", AddressStreetTwo = " + AddressStreetTwo);
            stringBuilder.Append(", IsDependentContact = " + IsDependentContact);
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
