using System;
using System.ComponentModel.DataAnnotations;

namespace Btrak.Models
{
   public  class EmployeeLicenceModel
    {
        public Guid EmployeeLicenceId { get; set; }

        public Guid EmployeeId
        {
            get;
            set;
        }

        [Required(ErrorMessage = "Please select Licence.")]
        public Guid LicenceTypeId
        {
            get;
            set;
        }

        public string LicenceTypeName
        {
            get;
            set;
        }

        [Required(ErrorMessage = "Please Enter  Licence Number")]
        public string LicenceNumber
        {
            get;
            set;
        }
        [Required(ErrorMessage = "Please Enter Issued Date.")]
        public DateTime? IssuedDate
        {
            get;
            set;
        }
        [Required(ErrorMessage = "Please Enter Expiry Date.")]
        public DateTime? ExpiryDate
        {
            get;
            set;
        }
        
    }
}
