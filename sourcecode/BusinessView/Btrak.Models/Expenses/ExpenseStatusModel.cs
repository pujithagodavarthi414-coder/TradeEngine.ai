using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Expenses
{
    public class ExpenseStatusModel
    {
        public Guid? ExpenseStatusId { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public byte[] TimeStamp { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ExpenseStatusId = " + ExpenseStatusId);
            stringBuilder.Append(", Name =" + Name);
            stringBuilder.Append(", Description =" + Description);
            stringBuilder.Append(", TimeStamp =" + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
