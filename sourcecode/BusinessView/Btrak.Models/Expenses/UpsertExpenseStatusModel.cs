using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Expenses
{
    public class UpsertExpenseStatusModel : InputModelBase
    {
        public UpsertExpenseStatusModel() : base(InputTypeGuidConstants.UpsertExpenseStatusInputCommandTypeGuid)
        {
        }

        public Guid? Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("Id =" + Id);
            stringBuilder.Append(", Name =" + Name);
            stringBuilder.Append(", Description" + Description);
            stringBuilder.Append(", Timestamp" + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
