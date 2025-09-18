using System;
using System.Collections.Generic;
using System.Text;
using System.Web.UI.WebControls;
using BTrak.Common;

namespace Btrak.Models.ActTracker
{
    public class ActTrackerRoleConfigurationUpsertInputModel : InputModelBase
    {
        public ActTrackerRoleConfigurationUpsertInputModel() : base(InputTypeGuidConstants.ActTrackerRoleConfigurationUpsertInputCommandTypeGuid)
        {
        }

        public List<Guid?> RoleId { get; set; }
        public Guid? AppUrlId { get; set; }
        public bool ConsiderPunchCard { get; set; }
        public string RoleIdXml { get; set; }
        public List<Guid?> ConfigurationRoleIds { get; set; }
        public int? FrequencyIndex { get; set; }
        public bool? Remove { get; set; }
        public bool SelectAll { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("RoleIds = " + RoleId);
            stringBuilder.Append(", AppUrlId = " + AppUrlId);
            stringBuilder.Append(",FrequencyIndex = " + FrequencyIndex);
            stringBuilder.Append(", Remove = " + Remove);
            stringBuilder.Append(", SelectAll = " + SelectAll);
            return stringBuilder.ToString();
        }
    }
}
