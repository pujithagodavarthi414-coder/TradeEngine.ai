using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.BillingManagement
{
    public class UpsertInvoiceScheduleInputModel : InputModelBase
    {
        public UpsertInvoiceScheduleInputModel() : base(InputTypeGuidConstants.UpsertInvoiceScheduleInputCommandTypeGuid)
        {
        }

        public Guid? InvoiceScheduleId { get; set; }
        public Guid? CurrencyId { get; set; }
        public Guid? InvoiceId { get; set; }
        public Guid? CompanyId { get; set; }
        public string CompanyLogo { get; set; }
        public string ScheduleName { get; set; }
        public Guid? ScheduleTypeId { get; set; }
        public string ScheduleType { get; set; }
        public decimal RatePerHour { get; set; }
        public int HoursPerSchedule { get; set; }
        public Guid? ScheduleSequenceId { get; set; }
        public int ScheduleSequenceQuantity { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("InvoiceScheduleId" + InvoiceScheduleId);
            stringBuilder.Append("CurrencyId" + CurrencyId);
            stringBuilder.Append("InvoiceId" + InvoiceId);
            stringBuilder.Append("CompanyId" + CompanyId);
            stringBuilder.Append("CompanyLogo" + CompanyLogo);
            stringBuilder.Append("ScheduleName" + ScheduleName);
            stringBuilder.Append("ScheduleTypeId" + ScheduleTypeId);
            stringBuilder.Append("ScheduleType" + ScheduleType);
            stringBuilder.Append("RatePerHour" + RatePerHour);
            stringBuilder.Append("HoursPerSchedule" + HoursPerSchedule);
            stringBuilder.Append("ScheduleSequenceId" + ScheduleSequenceId);
            stringBuilder.Append("ScheduleSequenceQuantity" + ScheduleSequenceQuantity);
            stringBuilder.Append("TimeStamp" + TimeStamp);
            stringBuilder.Append("TotalCount" + TotalCount);
            return base.ToString();
        }
    }
}
