using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.BoardType
{
    public class BoardTypeUpsertInputModel : InputModelBase
    {
        public BoardTypeUpsertInputModel() : base(InputTypeGuidConstants.BoardTypeUpsertInputCommandTypeGuid)
        {
        }

        public Guid? BoardTypeId { get; set; }
        public string BoardTypeName { get; set; }
        public Guid? BoardTypeUiId { get; set; }
        public Guid? WorkFlowId { get; set; }
        public bool IsArchived { get; set; }
        public bool IsApi { get; set; }
        public bool IsBugBoard { get; set; }
        public bool IsSuperAgileBoard { get; set; }
        public bool IsDefault { get; set; }
        public string TimeZone { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("BoardTypeId = " + BoardTypeId);
            stringBuilder.Append(", BoardTypeName = " + BoardTypeName);
            stringBuilder.Append(", BoardTypeUiId = " + BoardTypeUiId);
            stringBuilder.Append(", WorkFlowId = " + WorkFlowId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", IsBugBoard = " + IsBugBoard);
            stringBuilder.Append(", IsSuperAgileBoard = " + IsSuperAgileBoard);
            stringBuilder.Append(", IsDefault = " + IsDefault);
            return stringBuilder.ToString();
        }
    }
}
