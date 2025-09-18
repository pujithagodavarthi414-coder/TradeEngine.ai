using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.BoardType
{
    public class BoardTypeWorkFlowUpsertInputModel : InputModelBase
    {
        public BoardTypeWorkFlowUpsertInputModel() : base(InputTypeGuidConstants.BoardTypeWorkFlowUpsertInputCommandTypeGuid)
        {
        }

        public Guid? BoardTypeWorkFlowId { get; set; }
        public Guid? BoardTypeId { get; set; }
        public Guid? WorkFlowId { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("BoardTypeWorkFlowId = " + BoardTypeWorkFlowId);
            stringBuilder.Append(", BoardTypeId = " + BoardTypeId);
            stringBuilder.Append(", WorkFlowId = " + WorkFlowId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
