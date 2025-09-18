using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.BoardType
{
    public class BoardTypeInputModel : InputModelBase
    {
        public BoardTypeInputModel() : base(InputTypeGuidConstants.BoardTypeInputCommandTypeGuid)
        {
        }

        public Guid? BoardTypeId { get; set; }
        public string BoardTypeName { get; set; }
        public Guid? BoardTypeUiId { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("BoardTypeName = " + BoardTypeName);
            stringBuilder.Append(", BoardTypeId = " + BoardTypeId);
            stringBuilder.Append(", BoardTypeUiId = " + BoardTypeUiId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
