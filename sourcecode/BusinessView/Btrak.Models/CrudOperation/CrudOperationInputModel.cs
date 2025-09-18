using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.CrudOperation
{
    public class CrudOperationInputModel : InputModelBase
    {
        public CrudOperationInputModel() : base(InputTypeGuidConstants.CrudOperationInputCommandTypeGuid)
        {
        }

        public Guid? CrudOperationId { get; set; }
        public string OperationName { get; set; }
		public bool IsArchived { get; set; }

		public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CrudOperationId = " + CrudOperationId);
            stringBuilder.Append(", CrudOperationId = " + CrudOperationId);
			stringBuilder.Append(", IsArchived = " + IsArchived);
			return stringBuilder.ToString();
        }
    }
}

