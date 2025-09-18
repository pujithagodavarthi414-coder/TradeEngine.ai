using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Supplier
{
    public class SupplierDetailsOutputModel : InputModelBase
    {
        public SupplierDetailsOutputModel() : base(InputTypeGuidConstants.SupplierInputCommandTypeGuid)
        {
        }
        public Guid? SupplierId { get; set; }
        public string SupplierName { get; set; }
        public string SupplierCompanyName { get; set; }
        public Guid? CompanyId { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string CreatedOn { get; set; }
        public string ContactPerson { get; set; }
        public string ContactPosition { get; set; }
        public string CompanyPhoneNumber { get; set; }
        public string ContactPhoneNumber { get; set; }
        public string VendorIntroducedBy { get; set; }
        public DateTime? StartedWorkingFrom { get; set; }
        public string StartedWorkingOn { get; set; }
        public bool IsArchived { get; set; }
        public DateTime ArchivedDateTime { get; set; }
        public string TotalCount { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", SupplierId = " + SupplierId);
            stringBuilder.Append(", SupplierName = " + SupplierName);
            stringBuilder.Append(", SupplierCompanyName = " + SupplierCompanyName);
            stringBuilder.Append(", CompanyId = " + CompanyId);
            stringBuilder.Append(", CreatedDate = " + CreatedDate);
            stringBuilder.Append(", CreatedOn = " + CreatedOn);
            stringBuilder.Append(", ContactPerson = " + ContactPerson);
            stringBuilder.Append(", ContactPosition = " + ContactPosition);
            stringBuilder.Append(", CompanyPhoneNumber = " + CompanyPhoneNumber);
            stringBuilder.Append(", ContactPhoneNumber = " + ContactPhoneNumber);
            stringBuilder.Append(", VendorIntroducedBy = " + VendorIntroducedBy);
            stringBuilder.Append(", StartedWorkingFrom = " + StartedWorkingFrom);
            stringBuilder.Append(", StartedWorkingOn = " + StartedWorkingOn);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", ArchivedDateTime = " + ArchivedDateTime);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}

