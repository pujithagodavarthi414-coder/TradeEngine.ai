using System;
using System.ComponentModel.DataAnnotations;

namespace Btrak.Models
{
    public class EmployeeContactModel
    {
        public Guid EmployeeId
        {
            get;
            set;
        }

        public Guid Id
        {
            get;
            set;
        }

        public string Address1
        {
            get;
            set;
        }
        public string Address2
        {
            get;
            set;
        }

        public string City
        {
            get;
            set;
        }
        public Guid StateId
        {
            get;
            set;
        }
        public string PostalCode
        {
            get;
            set;
        }
        public Guid CountryId
        {
            get;
            set;
        }
        public string HomeTelephoneno
        {
            get;
            set;
        }
        [RegularExpression(@"^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$", ErrorMessage = "Not a valid Mobile number")]
        public string Mobile
        {
            get;
            set;
        }

        public string WorkTelephoneno
        {
            get;
            set;
        }

        public string WorkEmail
        {
            get;
            set;
        }
        public string OtherEmail
        {
            get;
            set;
        }

        public string ContactPersonName { get; set; }

        public string Relationship
        {
            get;
            set;
        }

        public string Name
        {
            get;
            set;
        }

        public DateTime? DateOfBirth
        {
            get;
            set;
        }

        public string OtherSpecify
        {
            get;
            set;
        }

        public string loggedusername
        {
            get;
            set;
        }
    }

    public class EmployeeEmergencyAndDependentContactModel
    {
        public Guid Id { get; set; }
        public Guid EmployeeId
        {
            get;
            set;
        }
        [Required(ErrorMessage = "Please enter  name.")]
        public string Name
        {
            get;
            set;
        }
        public Guid RelationShipId
        {
            get;
            set;
        }
        public string SpecifiedRelationShip
        {
            get;
            set;
        }
        public string RelationShip
        {
            get;
            set;
        }
        public string HomeTelephoneNumber
        {
            get;
            set;
        }
        [Required]
        [RegularExpression(@"^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$", ErrorMessage = "Not a valid Contact number")]
        public string Mobile
        {
            get;
            set;
        }
        public string WorkTelephoneNumber
        {
            get;
            set;
        }
        public DateTime? DateOfBirth
        {
            get;
            set;
        }

        public bool IsEmergencyContact
        {
            get; set;
        }
        public bool IsDependentContact
        {
            get; set;
        }
        public string HomeTelephone
        {
            get;
            set;
        }
        public string WorkTelephone
        {
            get;
            set;
        }
        public string MobileNo
        {
            get;
            set;
        }
        public string SpecifiedRelation
        {
            get;
            set;
        }
    }
}
