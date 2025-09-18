using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.HrManagement
{
    public class WebHookSearchInputModel : InputModelBase
    {
        public WebHookSearchInputModel() : base(InputTypeGuidConstants.WebHookSearchInputCommandTypeGuid)
        {
        }

        public Guid? WebHookId { get; set; }
        public string SearchText { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("WebHookId = " + WebHookId);
            stringBuilder.Append(", SearchText  = " + SearchText);
            stringBuilder.Append(", IsArchive = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
