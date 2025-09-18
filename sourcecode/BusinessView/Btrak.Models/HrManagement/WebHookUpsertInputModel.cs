using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.HrManagement
{
    public class WebHookUpsertInputModel : InputModelBase
    {
        public WebHookUpsertInputModel() : base(InputTypeGuidConstants.DepartmentUpsertInputCommandTypeGuid)
        {
        }

        public Guid? WebHookId { get; set; }
        public string WebHookName { get; set; }
        public string WebHookUrl { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("WebHookId = " + WebHookId);
            stringBuilder.Append(", WebHookName = " + WebHookName);
            stringBuilder.Append(", WebHookUrl = " + WebHookUrl);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}

