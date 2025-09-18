using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.BoardType
{
    public class BoardTypeApiUpsertInputModel : InputModelBase
    {
        public BoardTypeApiUpsertInputModel() : base(InputTypeGuidConstants.BoardTypeApiUpsertInputCommandTypeGuid)
        {
        }

        public Guid? BoardTypeApiId { get; set; }
        public string ApiName { get; set; }
        public string ApiUrl { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("BoardTypeApiId = " + BoardTypeApiId);
            stringBuilder.Append(", ApiName = " + ApiName);
            stringBuilder.Append(", ApiUrl = " + ApiUrl);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
