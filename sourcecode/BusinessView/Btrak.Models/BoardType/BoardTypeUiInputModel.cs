using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.BoardType
{
    public class BoardTypeUiInputModel : InputModelBase
    {
        public BoardTypeUiInputModel() : base(InputTypeGuidConstants.BoardTypeUiInputCommandTypeGuid)
        {
        }

        public Guid? BoardTypeUiId { get; set; }
        public string BoardTypeUiName { get; set; }
        public string BoardTypeUiView { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("BoardTypeUiId = " + BoardTypeUiId);
            stringBuilder.Append(", BoardTypeUiName = " + BoardTypeUiName);
            stringBuilder.Append(", BoardTypeUiView = " + BoardTypeUiView);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
