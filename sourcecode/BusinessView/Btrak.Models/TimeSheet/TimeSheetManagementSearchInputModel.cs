using System;
using System.Collections.Generic;
using System.Text;
using Btrak.Models.MyWork;
using BTrak.Common;

namespace Btrak.Models.TimeSheet
{
    public class TimeSheetManagementSearchInputModel : SearchCriteriaInputModelBase
    {
        public TimeSheetManagementSearchInputModel() : base(InputTypeGuidConstants.TimeSheetManagementSearchCriteriaInputCommandTypeGuid)
        {
        }
        public Guid? UserId { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public Guid? EntityId { get; set; }
        public Guid TeamLeadId { get; set; }
        public bool? IncludeEmptyRecords { get; set; }
        public string EmployeeSearchText { get; set; }
        public int TimeZone { get; set; }
        public List<WorkReportExcelInputModel> ExcelColumnList { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", UserId = " + UserId);
            stringBuilder.Append(", DateFrom = " + DateFrom);
            stringBuilder.Append(", DateTo = " + DateTo);
            stringBuilder.Append(", EntityId = " + EntityId);
            stringBuilder.Append(", TeamLeadId = " + TeamLeadId);
            stringBuilder.Append(", IncludeEmptyRecords = " + IncludeEmptyRecords);
            stringBuilder.Append(", EmployeeSearchText = " + EmployeeSearchText);
            stringBuilder.Append(", TimeZone = " + TimeZone);
            return stringBuilder.ToString();
        }
    }
}
