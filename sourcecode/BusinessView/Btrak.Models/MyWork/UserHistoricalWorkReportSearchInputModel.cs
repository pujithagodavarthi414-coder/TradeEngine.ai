using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.MyWork
{
    public class UserHistoricalWorkReportSearchInputModel : SearchCriteriaInputModelBase
    {
        public UserHistoricalWorkReportSearchInputModel() : base(InputTypeGuidConstants.UserHistoricalWorkReportInputCommandTypeGuid)
        {
        }
        public Guid? UserId { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public DateTime? CreateDateFrom { get; set; }
        public DateTime? CreateDateTo { get; set; }
        public Guid? BoardTypeId { get; set; }
        public Guid? ProjectId { get; set; }
        public Guid? LineManagerId { get; set; }
        public int? NoOfReplansMin { get; set; }
        public int? NoOfReplansMax { get; set; }
        public bool? IsTableView { get; set; }
        public bool? IsProject { get; set; }
        public Guid? BranchId { get; set; }
        public Guid? UserStoryPriorityId { get; set; }
        public Guid? UserStoryTypeId { get; set; }
        public bool? IsUserStoryDealyed { get; set; }
        public bool? IsGoalDealyed { get; set; }
        public DateTime? VerifiedOn { get; set; }
        public Guid? VerifiedBy { get; set; }
        public string GoalSearchText { get; set; }
        public string UserStorySearchText { get; set; }
        public List<string> HiddenColumnList { get; set; }
        public List<WorkReportExcelInputModel> ExcelColumnList { get; set; }
        public int TimeZone { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" UserId = " + UserId);
            stringBuilder.Append(", DateFrom = " + DateFrom);
            stringBuilder.Append(", DateTo = " + DateTo);
            return stringBuilder.ToString();
        }

    }
}