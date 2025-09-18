using System;
using System.ComponentModel.DataAnnotations;

namespace Btrak.Models.Supplier
{
    public class SupplierModel
    {
        public Guid Id { get; set; }
        [Required]
        public string SupplierName { get; set; }
        public string CompanyName { get; set; }
        //[DataType(DataType.Date)]
        public DateTime CreatedDate { get; set; }
        public string CreatedDateValue { get; set; }
        public string ContactPerson { get; set; }
        public string ContactPosition { get; set; }
        [RegularExpression(@"^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$", ErrorMessage = "Not a valid Phone number")]
        public string CompanyPhoneNumber { get; set; }
        [RegularExpression(@"^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$", ErrorMessage = "Not a valid Contact number")]
        public string ContactPhoneNumber { get; set; }
        public string VendorIntroducedBy { get; set; }
        //[DataType(DataType.Date)]
        [Required]
        public DateTime? StartedWorkingFrom { get; set; }
        public string StartedWorkingFromValue { get; set; }
        public bool? IsArchived { get; set; }
        public DateTime ArchivedDateTime { get; set; }
    }
}
