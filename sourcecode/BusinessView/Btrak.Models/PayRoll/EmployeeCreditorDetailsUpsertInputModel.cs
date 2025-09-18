using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class EmployeeCreditorDetailsUpsertInputModel : InputModelBase
    {

        public EmployeeCreditorDetailsUpsertInputModel() : base(InputTypeGuidConstants.EmployeeCreditorDetailsInputCommandTypeGuid)
        {
        }

        public Guid? EmployeeCreditorDetailsId { get; set; }
        public Guid? BranchId { get; set; }
        public string BankName { get; set; }
        public string AccountNumber { get; set; }
        public string AccountName { get; set; }
        public string IfScCode { get; set; }
        public bool? IsArchived { get; set; }
        public bool? UseForPerformaInvoice { get; set; }
        public Guid? BankId { get; set; }
        public string Email { get; set; }
        public string MobileNo { get; set; }
        public string PanNumber { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EmployeeCreditorDetailsId = " + EmployeeCreditorDetailsId);
            stringBuilder.Append(",BranchId = " + BranchId);
            stringBuilder.Append(",AccountNumber = " + AccountNumber);
            stringBuilder.Append(",AccountName = " + AccountName);
            stringBuilder.Append(",BankName = " + BankName);
            stringBuilder.Append(",IfScCode = " + IfScCode);
            stringBuilder.Append(",IsArchived = " + IsArchived);
            stringBuilder.Append(",BankId = " + BankId);
            stringBuilder.Append(",Email = " + Email);
            stringBuilder.Append(",MobileNo = " + MobileNo);
            return stringBuilder.ToString();
        }
    }
}
