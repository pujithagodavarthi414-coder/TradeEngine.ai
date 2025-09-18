using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Dashboard
{
    public class ProcessDashboardStatusInputModel : InputModelBase
    {
        public ProcessDashboardStatusInputModel() : base(InputTypeGuidConstants.ProcessDashboardStatusInputCommandTypeGuid)
        {
        }

        public Guid? ProcessDashboardStatusId { get; set; }
        public string ProcessDashboardStatusName { get; set; }
        public string ProcessDashboardStatusHexaValue { get; set; }
		public bool? IsArchived { get; set; }

		public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ProcessDashboardStatusId = " + ProcessDashboardStatusId);
            stringBuilder.Append(", ProcessDashboardStatusName = " + ProcessDashboardStatusName);
            stringBuilder.Append(", ProcessDashboardStatusHexaValue = " + ProcessDashboardStatusHexaValue);
			stringBuilder.Append(", IsArchived = " + IsArchived);
			return stringBuilder.ToString();
        }
    }
}
