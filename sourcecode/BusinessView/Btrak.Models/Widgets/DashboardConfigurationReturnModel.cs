using System;
using System.Text;

namespace Btrak.Models.Widgets
{
    public class DashboardConfigurationReturnModel
    {
        public Guid? DashboardConfigurationId { get; set; }

        public Guid? DashboardId { get; set; }

        public string DashboardName { get; set; }

        public string DefaultDashboardRoles { get; set; }

        public string ViewRoles { get; set; }

        public string EditRoles { get; set; }

        public string DeleteRoles { get; set; }

        public byte[] TimeStamp { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("DashboardConfigurationId = " + DashboardConfigurationId);
            stringBuilder.Append(", DashboardId = " + DashboardId);
            stringBuilder.Append(", DashboardName = " + DashboardName);
            stringBuilder.Append(", DefaultDashboardRoles = " + DefaultDashboardRoles);
            stringBuilder.Append(", ViewRoles = " + ViewRoles);
            stringBuilder.Append(", EditRoles = " + EditRoles);
            stringBuilder.Append(", DeleteRoles = " + DeleteRoles);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
