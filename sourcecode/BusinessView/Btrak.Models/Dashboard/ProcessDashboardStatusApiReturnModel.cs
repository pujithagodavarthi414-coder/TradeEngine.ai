using System;
using System.Text;

namespace Btrak.Models.Dashboard
{
    public class ProcessDashboardStatusApiReturnModel
    {
        public Guid? ProcessDashboardStatusId { get; set; }
        public string ProcessDashboardStatusName { get; set; }
        public string ProcessDashboardStatusHexaValue { get; set; }
        public string StatusShortName { get; set; }
        public DateTimeOffset CreatedDateTime { get; set; }
		public bool IsArchived { get; set; }
		public byte[] TimeStamp { get; set; }
		public int TotalCount { get; set; }

		public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ProcessDashboardStatusId = " + ProcessDashboardStatusId);
            stringBuilder.Append(", ProcessDashboardStatusName = " + ProcessDashboardStatusName);
            stringBuilder.Append(", ProcessDashboardStatusHexaValue = " + ProcessDashboardStatusHexaValue);
			stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
			stringBuilder.Append(", IsArchived = " + IsArchived);
			stringBuilder.Append(", TimeStamp = " + TimeStamp);
			stringBuilder.Append(", TotalCount = " + TotalCount);
			return stringBuilder.ToString();
        }
    }
}
