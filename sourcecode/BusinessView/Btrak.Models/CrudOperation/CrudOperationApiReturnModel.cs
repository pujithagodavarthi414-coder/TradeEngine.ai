using System;
using System.Text;

namespace Btrak.Models.CrudOperation
{
    public class CrudOperationApiReturnModel
    {
        public Guid? CrudOperationId { get; set; }
        public string OperationName { get; set; }
		public DateTimeOffset CreatedDateTime { get; set; }
		public bool IsArchived { get; set; }
		public byte[] TimeStamp { get; set; }
		public int TotalCount { get; set; }

		public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CrudOperationId = " + CrudOperationId);
            stringBuilder.Append(", OperationName = " + OperationName);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
			stringBuilder.Append(", IsArchived = " + IsArchived);
			stringBuilder.Append(", TimeStamp = " + TimeStamp);
			stringBuilder.Append(", TotalCount = " + TotalCount);
			return stringBuilder.ToString();
        }
    }
}
