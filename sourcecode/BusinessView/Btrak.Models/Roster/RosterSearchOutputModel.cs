using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Roster
{
    public class RosterSearchOutputModel
    {
        public Guid? RequestId { get; set; }
        public string RequestName { get; set; }
        public DateTime RequiredFromDate { get; set; }
        public DateTime RequiredToDate { get; set; }
        public decimal RequiredBudget { get; set; }
        public decimal RequiredBreakMins { get; set; }
        public int RequiredEmployee { get; set; }
        public bool IncludeHolidays { get; set; }
        public bool IncludeWeekends { get; set; }
        public int TotalWorkingDays { get; set; }
        public int TotalWorkingHours { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public Guid CreatedByUserId { get; set; }
        public string CreatedByUserName { get; set; }
        public string ProfileImage { get; set; }
        public string StatusName { get; set; }
        public string StatusColor { get; set; }
        public Guid CompanyId { get; set; }
        public bool IsArchived { get; set; }
        public int TotalCount { get; set; }
        public Guid? PreviousValue { get; set; }
        public Guid? NextValue { get; set; }
        public string BranchName { get; set; }
        public Guid? BranchId { get; set; }
		public bool IsTemplate { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", RequestId = " + RequestId);
            stringBuilder.Append(", RequestName = " + RequestName);
            stringBuilder.Append(", RequiredFromDate = " + RequiredFromDate);
            stringBuilder.Append(", RequiredToDate = " + RequiredToDate);
            stringBuilder.Append(", RequiredBudget = " + RequiredBudget);
            stringBuilder.Append(", RequiredBreakMins = " + RequiredBreakMins);
            stringBuilder.Append(", RequiredEmployee = " + RequiredEmployee);
            stringBuilder.Append(", IncludeHolidays = " + IncludeHolidays);
            stringBuilder.Append(", IncludeWeekends = " + IncludeWeekends);
            stringBuilder.Append(", TotalWorkingDays = " + TotalWorkingDays);
            stringBuilder.Append(", TotalWorkingHours = " + TotalWorkingHours);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", CreatedByUserName = " + CreatedByUserName);
            stringBuilder.Append(", ProfileImage = " + ProfileImage);
            stringBuilder.Append(", StatusColor = " + StatusColor);
            stringBuilder.Append(", CompanyId = " + CompanyId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", PreviousValue = " + PreviousValue);
            stringBuilder.Append(", NextValue = " + NextValue);
            stringBuilder.Append(", BranchName = " + BranchName);
            stringBuilder.Append(", BranchId= " + BranchId);
            return stringBuilder.ToString();
        }
    }
}
