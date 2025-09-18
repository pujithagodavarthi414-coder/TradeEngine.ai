using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Expenses
{
    public class UpsertExpenseReportStatusModel : InputModelBase
    {
        public UpsertExpenseReportStatusModel() : base(InputTypeGuidConstants.UpsertExpenseStatusReportInputCommandTypeGuid)
        {
        }

        public Guid? ExpenseReportStatusId { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ExpenseReportStatusId" + ExpenseReportStatusId);
            stringBuilder.Append(", Name" + Name);
            stringBuilder.Append(", TimeStamp" + TimeStamp);
            stringBuilder.Append(", Description" + Description);
            return stringBuilder.ToString();
        }
    }
}
