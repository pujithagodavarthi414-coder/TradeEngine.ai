using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.Widgets
{
    public class WidgetInputModel : InputModelBase
    {
        public WidgetInputModel() : base(InputTypeGuidConstants.WidgetUpsertInputCommandTypeGuid)
        {
        }
        public Guid? WidgetId { get; set; }
        public List<Guid> SelectedRoleIds { get; set; }
        public string RoleIdsXml { get; set; }
        public string WidgetName { get; set; }
        public string Description { get; set; }
        public bool? IsArchived { get; set; }
        public bool? IsCustomWidget { get; set; }
        public string TagNames { get; set; }
        public List<Guid> TagsIds { get; set; }
        public string TagIdsXml { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("WidgetId = " + WidgetId);
            stringBuilder.Append(", WidgetName = " + WidgetName);
            stringBuilder.Append(", Description = " + Description);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", SelectedRoleIds = " + SelectedRoleIds);
            stringBuilder.Append(", RoleIdsXml = " + RoleIdsXml);
            return stringBuilder.ToString();
        }
    }
}
