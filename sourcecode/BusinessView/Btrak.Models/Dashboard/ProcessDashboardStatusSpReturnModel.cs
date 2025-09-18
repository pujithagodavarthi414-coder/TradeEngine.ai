using System;

namespace Btrak.Models.Dashboard
{
    public class ProcessDashboardStatusSpReturnModel
    {
        public Guid? ProcessDashboardStatusId { get; set; }
        public string ProcessDashboardStatusName { get; set; }
        public string ProcessDashboardStatusHexaValue { get; set; }
		public DateTimeOffset CreatedDateTime { get; set; }
		public bool IsArchived { get; set; }
		public byte[] TimeStamp { get; set; }
		public int TotalCount { get; set; }
	}
}
