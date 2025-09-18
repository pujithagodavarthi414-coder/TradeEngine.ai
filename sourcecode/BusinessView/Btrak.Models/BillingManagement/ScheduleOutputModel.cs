using System;
using System.Text;

namespace Btrak.Models.BillingManagement
{
    public class ScheduleOutputModel
    {
        public Guid? InvoiceScheduleId { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public string SearchText { get; set; }
        public bool? IsArchived { get; set; }
        public string ScheduleName { get; set; }
        public Guid? InvoiceId { get; set; }        
        public Guid? CurrencyId { get; set; }
        public Guid? CompanyId { get; set; }
        public DateTime? ScheduleStartDate { get; set; }
        public Guid? ScheduleTypeId { get; set; }
        public int Extension { get; set; }
        public decimal RatePerHour { get; set; }
        public int HoursPerSchedule { get; set; }
        public decimal ExcessHoursRate { get; set; }
        public int ExcessHours { get; set; }                    
        public Guid? ScheduleSequenceId { get; set; }
        public int ScheduleSequenceQuantity { get; set; }
        public decimal LateFees { get; set; }
        public int LateFeesDays { get; set; }
        public string Description { get; set; }
        public decimal SendersName { get; set; }
        public decimal SendersAddress { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("InvoiceScheduleId" + InvoiceScheduleId);
            stringBuilder.Append("DateFrom" + DateFrom);
            stringBuilder.Append("DateTo" + DateTo);
            stringBuilder.Append("SearchText" + SearchText);
            stringBuilder.Append("IsArchived" + IsArchived);
            stringBuilder.Append("ScheduleName" + ScheduleName);           
            stringBuilder.Append("InvoiceId" + InvoiceId);
            stringBuilder.Append("CurrencyId" + CurrencyId);
            stringBuilder.Append("CompanyId" + CompanyId);
            stringBuilder.Append("ScheduleStartDate" + ScheduleStartDate);
            stringBuilder.Append("ScheduleTypeId" + ScheduleTypeId);
            stringBuilder.Append("Extension" + Extension);
            stringBuilder.Append("RatePerHour" + RatePerHour);
            stringBuilder.Append("HoursPerSchedule" + HoursPerSchedule);
            stringBuilder.Append("ExcessHoursRate" + ExcessHoursRate);
            stringBuilder.Append("ExcessHours" + ExcessHours);
            stringBuilder.Append("ScheduleSequenceId" + ScheduleSequenceId);
            stringBuilder.Append("ScheduleSequenceQuantity" + ScheduleSequenceQuantity);
            stringBuilder.Append("LateFees" + LateFees);
            stringBuilder.Append("LateFeesDays" + LateFeesDays);
            stringBuilder.Append("Description" + Description);
            stringBuilder.Append("SendersName" + SendersName);           
            stringBuilder.Append("SendersAddress" + SendersAddress);
            stringBuilder.Append("TimeStamp" + TimeStamp);
            stringBuilder.Append("TotalCount" + TotalCount);
            return base.ToString();
        }
    }
}
