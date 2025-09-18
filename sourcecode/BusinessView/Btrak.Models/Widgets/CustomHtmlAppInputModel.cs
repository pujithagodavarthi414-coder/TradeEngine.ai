using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.Widgets
{
    public class CustomHtmlAppInputModel : InputModelBase
    {
        public CustomHtmlAppInputModel() : base(InputTypeGuidConstants.CustomWidgetUpsertInputCommandTypeGuid)
        {
        }
        public Guid? CustomHtmlAppId { get; set; }

        public string CustomHtmlAppName { get; set; }

        public string Description { get; set; }

        public List<Guid> SelectedRoleIds { get; set; }

        public List<Guid> ModuleIds { get; set; }

        public string HtmlCode { get; set; }

        public string RoleIdsXml { get; set; }

        public string ModuleIdsXml { get; set; }

        public bool? IsArchived { get; set; }

        public string FileUrls { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CustomWidgetId = " + CustomHtmlAppId);
            stringBuilder.Append(", CustomWidgetName = " + CustomHtmlAppName);
            stringBuilder.Append(", Description = " + Description);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", WidgetQuery = " + HtmlCode);
            stringBuilder.Append(", SelectedRoleIds = " + SelectedRoleIds);
            stringBuilder.Append(", RoleIdsXml = " + RoleIdsXml);
            stringBuilder.Append(", ModuleIds = " + ModuleIds);
            stringBuilder.Append(", ModuleIdsXml = " + ModuleIdsXml);
            stringBuilder.Append(", FileUrls = " + FileUrls);
            return stringBuilder.ToString();
        }
    }
}
