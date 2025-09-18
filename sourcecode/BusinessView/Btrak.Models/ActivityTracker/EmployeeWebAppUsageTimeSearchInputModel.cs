using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.ActivityTracker
{
    public class EmployeeWebAppUsageTimeSearchInputModel : SearchCriteriaInputModelBase
    {
        public EmployeeWebAppUsageTimeSearchInputModel() : base(InputTypeGuidConstants.EmployeeWebAppUsageTimeSearchInputCommandTypeGuid)
        {

        }

        public List<Guid> UserId { get; set; }
        public string UserIdXml { get; set; }
        public List<Guid> RoleId { get; set; }
        public string RoleIdXml { get; set; }
        public List<Guid> BranchId { get; set; }
        public string BranchIdXml { get; set; }
        public bool? IsApp { get; set; }
        public bool? IsForScreenshots { get; set; }
        public bool? IsAllUser { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public string SearchText { get; set; }
        public string ApplicationType { get; set; }
        public Guid? UserStoryId { get; set; }
        public bool? IsForLatestScreenshots { get; set; }
        public bool? IsIdleNotRequired { get; set; }
        public Guid? UserIdGuid { get; set; }
        public string TimeZone { get; set; }
        public string SelectedUserId { get; set; }
        public bool? IsDetailedView { get; set; } 
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", UserId" + UserId);
            stringBuilder.Append(", UserIdGuid" + UserIdGuid);
            stringBuilder.Append(", UserIdXml" + UserIdXml);
            stringBuilder.Append(", RoleId" + RoleId);
            stringBuilder.Append(", RoleIdXml" + RoleIdXml);
            stringBuilder.Append(", RoleId" + BranchId);
            stringBuilder.Append(", RoleIdXml" + BranchIdXml);
            stringBuilder.Append(",DateFrom" + DateFrom);
            stringBuilder.Append(", DateTo = " + DateTo);
            stringBuilder.Append(", SearchText" + SearchText);
            stringBuilder.Append(", IsAllUser " + IsAllUser);
            stringBuilder.Append(", IsDetailedView " + IsDetailedView);
            stringBuilder.Append(", IsForLatestScreenshots " + IsForLatestScreenshots);
            stringBuilder.Append(", IsIdleNotRequired " + IsIdleNotRequired);
            return stringBuilder.ToString();
        }
    }
}
