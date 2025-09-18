using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.HrManagement
{
    public class EmployeeDependentContactSearchInputModel : SearchCriteriaInputModelBase
    {
        public EmployeeDependentContactSearchInputModel (): base(InputTypeGuidConstants.GetEmployeeDependentContact)
        {
        }
        public Guid? ContactId { get; set; }
        public Guid? EmployeeId { get; set; }
        public Guid? RelationshipId { get; set; }
        public string LastName { get; set; }
        public string FirstName { get; set; }
        public string OtherRelation { get; set; }
        public string HomeTelephone { get; set; }
        public string MobileNo { get; set; }
        public string WorkTelephone { get; set; }
        public bool? IsEmergencyContact { get; set; }
        public bool? IsDependentContact { get; set; }
        public string AddressStreetOne { get; set; }
        public string AddressStreetTwo { get; set; }
        public string ZipOrPostalCode { get; set; }
        public Guid? StateOrProvinceId { get; set; }
        public Guid? CountryId { get; set; }
        public Guid? EmployeeDependentId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" EmployeeId= " + EmployeeId);
            stringBuilder.Append(" ContactId= " + ContactId);
            stringBuilder.Append(" FirstName= " + FirstName);
            stringBuilder.Append(" RelationshipId= " + RelationshipId);
            stringBuilder.Append(" LastName= " + LastName);
            stringBuilder.Append(" OtherRelation= " + OtherRelation);
            stringBuilder.Append(" HomeTelephone= " + HomeTelephone);
            stringBuilder.Append(" MobileNo= " + MobileNo);
            stringBuilder.Append(" WorkTelephone= " + WorkTelephone);
            stringBuilder.Append(" IsEmergencyContact= " + IsEmergencyContact);
            stringBuilder.Append(" IsDependentContact= " + IsDependentContact);
            stringBuilder.Append(" ZipOrPostalCode= " + ZipOrPostalCode);
            stringBuilder.Append(" StaStateOrProvinceId= " + StateOrProvinceId);
            stringBuilder.Append(" AddressStreetOne= " + AddressStreetOne);
            stringBuilder.Append(" AddressStreetTwo= " + AddressStreetTwo);
            stringBuilder.Append(" CountryId= " + CountryId);
            stringBuilder.Append(" EmployeeDependentId= " + EmployeeDependentId);

            stringBuilder.Append(" IsArchived= " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
