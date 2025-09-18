using System;
using System.ComponentModel.DataAnnotations;

namespace Btrak.Models
{
   public  class ImmigrationModel
    {
        public Guid Id
        {
            get;
            set;
        }
        public Guid EmployeeId
        {
            get;
            set;
        }
        [Required(ErrorMessage = "Please enter Document type.")]
        public string Document
        {
            get;
            set;
        }
        [Required(ErrorMessage = "Please enter Document Number.")]
        public string DocumentNumber
        {
            get;
            set;
        }
        public DateTime? IssuedDate
        {
            get;
            set;
        }
        public DateTime? ExpiryDate
        {
            get;
            set;
        }
        public string EligibleStatus
        {
            get;
            set;
        }
        public Guid CountryId
        {
            get;
            set;
        }
        public DateTime? EligibleReviewDate
        {
            get;
            set;
        }
        public string Comments
        {
            get;
            set;
        }
        public string CountryName
        {
            get;
            set;
        }
    }
}
