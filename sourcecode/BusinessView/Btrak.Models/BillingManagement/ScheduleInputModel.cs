using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.BillingManagement
{
    public class ScheduleInputModel : InputModelBase
    {
        public ScheduleInputModel() : base(InputTypeGuidConstants.ScheduleInputCommandTypeGuid)
        {
        }

        public Guid? InvoiceScheduleId { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public bool? IsArchived { get; set; }
        public string ScheduleName { get; set; }
        public DateTime? ScheduleStartDate { get; set; }
        public string ScheduleType { get; set; }
        public string SearchText { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("InvoiceScheduleId" + InvoiceScheduleId);
            stringBuilder.Append("DateFrom" + DateFrom);
            stringBuilder.Append("DateTo" + DateTo);
            stringBuilder.Append("IsArchived" + IsArchived);
            stringBuilder.Append("ScheduleName" + ScheduleName);
            stringBuilder.Append("ScheduleStartDate" + ScheduleStartDate);
            stringBuilder.Append("ScheduleType" + ScheduleType);
            stringBuilder.Append("SearchText" + SearchText);
            return base.ToString();
        }

    }
}
