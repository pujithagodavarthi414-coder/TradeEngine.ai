using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Widgets
{
    public class DashboardConfigurationInputModel : InputModelBase
    {
        public DashboardConfigurationInputModel() : base(InputTypeGuidConstants.UpsertDashboardConfigurationInputCommandTypeGuid)
        {
        }
        public Guid? DashboardConfigurationId { get; set; }
        public Guid? DashboardId { get; set; }
        public string DefaultDashboardRoles { get; set; }
        public string ViewRoles { get; set; }
        public string EditRoles { get; set; }
        public string DeleteRoles { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("DashboardConfigurationId = " + DashboardConfigurationId);
            stringBuilder.Append("DashboardId = " + DashboardId);
            stringBuilder.Append(", DefaultDashboardRoles = " + DefaultDashboardRoles);
            stringBuilder.Append(", ViewRoles = " + ViewRoles);
            stringBuilder.Append(", EditRoles = " + EditRoles);
            stringBuilder.Append(", DeleteRoles = " + DeleteRoles);
            return stringBuilder.ToString();
        }
    }
}
