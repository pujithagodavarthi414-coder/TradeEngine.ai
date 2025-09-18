using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.MasterData
{
    public class HolidaysOutputModel
    {
        public Guid? HolidayId { get; set; }
        public string Reason { get; set; }
        public bool? Archived { get; set; }
        public Guid? CompanyId { get; set; }
        public int? DateKey { get; set; }
        public DateTime? Date { get; set; }
        public Guid? CountryId { get; set; }
        public string CountryName { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public int? TotalCount { get; set; }
        public byte[] TimeStamp { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public bool? IsWeekOff { get; set; }
        public Guid? BranchId { get; set; }
        public string BranchName { get; set; }
        public string WeekOff { get; set; }
        public List<string> WeekOffDays { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" HolidayId = " + HolidayId);
            stringBuilder.Append(", Reason = " + Reason);
            stringBuilder.Append(", Archived = " + Archived);
            stringBuilder.Append(", CompanyId = " + CompanyId);
            stringBuilder.Append(", DateKey = " + DateKey);
            stringBuilder.Append(", Date = " + Date);
            stringBuilder.Append(", CountryId = " + CountryId);
            stringBuilder.Append(", CountryName= " + CountryName);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", UpdatedByUserId = " + UpdatedByUserId);
            stringBuilder.Append(", UpdatedDateTime = " + UpdatedDateTime);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", IsWeekOff = " + IsWeekOff);
            stringBuilder.Append(", WeekOffDays = " + WeekOffDays);
            stringBuilder.Append(", DateFrom = " + DateFrom);
            stringBuilder.Append(", DateTo = " + DateTo);
            stringBuilder.Append(", BranchId = " + BranchId);
            return stringBuilder.ToString();
        }
    }
}
