using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.Widgets
{
    public class CustomWidgetsInputModel : InputModelBase
    {
        public CustomWidgetsInputModel() : base(InputTypeGuidConstants.CustomWidgetUpsertInputCommandTypeGuid)
        {
        }
        public Guid? CustomWidgetId { get; set; }

        public string CustomWidgetName { get; set; }

        public string Description { get; set; }

        public List<Guid> SelectedRoleIds { get; set; }

        public string WidgetQuery { get; set; }
        public string MongoQuery { get; set; }

        public string RoleIdsXml { get; set; }
        public string ModuleIdsXML { get; set; }
        public List<Guid> ModuleIds { get; set; }

        public string ChartsDetailsXml { get; set; }

        public bool? IsArchived { get; set; }
         

        public bool? IsEditable { get; set; }

        public List<CustomWidgetHeaderModel> DefaultColumns { get; set; }

        public string DefaultColumnsXml { get; set; }

        public List<CustomAppChartModel> ChartsDetails { get; set; }
        public string VisualisationModelJson { get; set; }

        public bool? IsProc { get; set; }

        public bool? IsApi { get; set; }

        public string ProcName { get; set; }
        public List<Guid> TagsIds { get; set; }
        public string TagIdsXml { get; set; }
        public string TestSuiteId { get; set; }

        public bool? IsQuery { get; set; }
        public bool? IsMongoQuery { get; set; }
        public string CollectionName { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CustomWidgetId = " + CustomWidgetId);
            stringBuilder.Append("ModuleIds = " + ModuleIds);
            stringBuilder.Append("ModuleIdsXML = " + ModuleIdsXML);
            stringBuilder.Append(", CustomWidgetName = " + CustomWidgetName);
            stringBuilder.Append(", Description = " + Description);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", WidgetQuery = " + WidgetQuery);
            stringBuilder.Append(", ChartsDetails = " + ChartsDetails);
            stringBuilder.Append(", ChartsDetailsXml = " + ChartsDetailsXml);
            stringBuilder.Append(", SelectedRoleIds = " + SelectedRoleIds);
            stringBuilder.Append(", RoleIdsXml = " + RoleIdsXml);
            stringBuilder.Append(", IsProc = " + IsProc);
            stringBuilder.Append(", IsApi = " + IsApi);
            stringBuilder.Append(", IsQuery = " + IsQuery);
            stringBuilder.Append(", ProcName = " + ProcName);
            return stringBuilder.ToString();
        }
    }
}
