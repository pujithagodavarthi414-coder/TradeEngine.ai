using System;
using System.Text;

namespace Btrak.Models.Widgets
{
    public class DashboardPersistanceInputModel
    {
        public Guid? DashboardId { get; set; }
        public string PersistanceJson { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("DashboardId = " + DashboardId);
            stringBuilder.Append(", PersistanceJson = " + PersistanceJson);
            return stringBuilder.ToString();
        }
    }
}
