using System;

namespace Btrak.Models.CrudOperation
{
    public class CrudOperationSpReturnModel
    {
        public Guid? CrudOperationId { get; set; }
        public string OperationName { get; set; }
        public DateTimeOffset CreatedDateTime { get; set; }
		public bool IsArchived { get; set; }
		public byte[] TimeStamp { get; set; }
		public int TotalCount { get; set; }
	}
}
