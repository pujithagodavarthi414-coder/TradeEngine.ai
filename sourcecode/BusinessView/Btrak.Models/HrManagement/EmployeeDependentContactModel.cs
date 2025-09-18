using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.HrManagement
{
    public class EmployeeDependentContactModel
    {
        public Guid? EmployeeDependentId { get; set; }
        public Guid? EmployeeId { get; set; }
        public string FirstName { get; set; }
        public string SurName { get; set; }
        public string UserName { get; set; }
        public string Email { get; set; }
        public Guid? RelationshipId { get; set; }
        public string Relationship { get; set; }
        public string EmployeeEmergencyContactFirstName { get; set; }
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


        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" EmployeeDependentId= " + EmployeeDependentId);
            stringBuilder.Append(" EmployeeId= " + EmployeeId);
            stringBuilder.Append(" FirstName= " + FirstName);
            stringBuilder.Append(" SurName= " + SurName);
            stringBuilder.Append(" UserName= " + UserName);
            stringBuilder.Append(" Email= " + Email);
            stringBuilder.Append(" RelationshipId= " + RelationshipId);
            stringBuilder.Append(" Relationship= " + Relationship);
            stringBuilder.Append(" EmployeeEmergencyContactFirstName= " + EmployeeEmergencyContactFirstName);
            stringBuilder.Append(" LastName= " + LastName);
            stringBuilder.Append(" OtherRelation= " + OtherRelation);
            stringBuilder.Append(" HomeTelephone= " + HomeTelephone);
            stringBuilder.Append(" MobileNo= " + MobileNo);
            stringBuilder.Append(" WorkTelephone= " + WorkTelephone);
            stringBuilder.Append(" IsEmergencyContact= " + IsEmergencyContact);
            stringBuilder.Append(" IsDependentContact= " + IsDependentContact);
            stringBuilder.Append(" ZipOrPostalCode= " + ZipOrPostalCode);
            stringBuilder.Append(" StateOrProvinceId= " + StateOrProvinceId);
            stringBuilder.Append(" StateName= " + StateName);
            stringBuilder.Append(" AddressStreetOne= " + AddressStreetOne);
            stringBuilder.Append(" AddressStreetTwo= " + AddressStreetTwo);
            stringBuilder.Append(" CountryId= " + CountryId);
            stringBuilder.Append(" CountryName= " + CountryName);
            stringBuilder.Append(" IsArchived= " + IsArchived);
            stringBuilder.Append(" TimeStamp= " + TimeStamp);
            stringBuilder.Append(" TotalCount= " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
