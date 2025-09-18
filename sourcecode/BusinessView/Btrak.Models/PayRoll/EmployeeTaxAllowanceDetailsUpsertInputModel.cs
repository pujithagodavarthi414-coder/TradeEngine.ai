using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class EmployeeTaxAllowanceDetailsUpsertInputModel : InputModelBase
    {

        public EmployeeTaxAllowanceDetailsUpsertInputModel() : base(InputTypeGuidConstants.EmployeeTaxAllowanceDetailsInputCommandTypeGuid)
        {
        }

        public Guid? EmployeeTaxAllowanceId { get; set; }
        public DateTime? ApprovedDateTime { get; set; }
        public Guid? EmployeeId { get; set; }
        public Guid? ApprovedByEmployeeId { get; set; }
        public Guid? TaxAllowanceId { get; set; }
        public decimal? InvestedAmount { get; set; }
        public bool IsAutoApproved { get; set; }
        public bool IsOnlyEmployee { get; set; }
        public bool? IsArchived { get; set; }
        public DateTime? SubmittedDate { get; set; }
        public string Comments { get; set; }
        public bool? IsFilesExist { get; set; }
        public bool? IsRelatedToHRA { get; set; }
        public string OwnerPanNumber { get; set; }
        public bool IsApproved { get; set; }
        public bool RelatedToMetroCity { get; set; }
        

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EmployeeTaxAllowanceId = " + EmployeeTaxAllowanceId);
            stringBuilder.Append(", ApprovedDateTime = " + ApprovedDateTime);
            stringBuilder.Append(", EmployeeId = " + EmployeeId);
            stringBuilder.Append(", ApprovedByEmployeeId = " + ApprovedByEmployeeId);
            stringBuilder.Append(", TaxAllowanceId = " + TaxAllowanceId);
            stringBuilder.Append(", InvestedAmount = " + InvestedAmount);
            stringBuilder.Append(", IsAutoApproved = " + IsAutoApproved);
            stringBuilder.Append(", IsOnlyEmployee = " + IsOnlyEmployee);
            stringBuilder.Append(", SubmittedDate = " + SubmittedDate);
            stringBuilder.Append(", Comments = " + Comments);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", RelatedToMetroCity = " + RelatedToMetroCity);
            stringBuilder.Append(", IsFilesExist = " + IsFilesExist);

            return stringBuilder.ToString();
        }
    }
}
