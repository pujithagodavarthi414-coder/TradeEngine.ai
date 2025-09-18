using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.BoardType
{
    public class BoardTypeApiInputModel : InputModelBase
    {
        public BoardTypeApiInputModel() : base(InputTypeGuidConstants.BoardTypeApiInputCommandTypeGuid)
        {
        }

        public Guid? BoardTypeApiId { get; set; }
        public string ApiName { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("BoardTypeApiId = " + BoardTypeApiId);
            stringBuilder.Append(", ApiName = " + ApiName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
