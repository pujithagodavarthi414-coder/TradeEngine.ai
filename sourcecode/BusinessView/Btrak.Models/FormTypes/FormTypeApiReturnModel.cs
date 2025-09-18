using System;
using System.Text;

namespace Btrak.Models.FormTypes
{
    public class FormTypeApiReturnModel
    {
        public Guid Id { get; set; }
        public string FormTypeName { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public int TotalCount { get; set; }
        public byte[] TimeStamp { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("Id = " + Id);
            stringBuilder.Append(", FormTypeName = " + FormTypeName);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
