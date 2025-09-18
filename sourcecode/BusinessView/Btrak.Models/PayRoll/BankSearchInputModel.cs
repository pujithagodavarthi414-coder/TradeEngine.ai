using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class BankSearchInputModel : InputModelBase
    {
        public BankSearchInputModel() : base(InputTypeGuidConstants.BankSearchInputCommandTypeGuid)
        {
        }

        public Guid?  BankId { get; set; }
        public string SearchText { get; set; }
        public bool? IsArchived { get; set; }
        public Guid? EmployeeId { get; set; }
        public Guid? BranchId { get; set; }
        public bool? IsApp { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("BankId = " +  BankId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", EmployeeId = " + EmployeeId);
            stringBuilder.Append(", BranchId = " + IsArchived);
            stringBuilder.Append(", IsApp = " + IsApp);
            stringBuilder.Append(", IsArchived = " + IsApp);
            return stringBuilder.ToString();
        }
    }
}
