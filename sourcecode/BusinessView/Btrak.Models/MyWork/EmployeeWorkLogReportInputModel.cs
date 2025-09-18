using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.MyWork
{
    public class EmployeeWorkLogReportInputModel : SearchCriteriaInputModelBase
    {
        public EmployeeWorkLogReportInputModel() : base(InputTypeGuidConstants.EmployeeWorkLogReportInputModelInputCommandTypeGuid)
        {
        }
        public Guid? UserId { get; set; }
        public Guid? GoalId { get; set; }
        public Guid? ProjectId { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public Guid? LineManagerId { get; set; }
        public string TimeZone { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" UserId = " + UserId);
            stringBuilder.Append(" ProjectId = " + ProjectId);
            stringBuilder.Append(" GoalId = " + GoalId);
            stringBuilder.Append(", DateFrom = " + DateFrom);
            stringBuilder.Append(", DateTo = " + DateTo);
            stringBuilder.Append(", LineManagerId = " + LineManagerId);
            stringBuilder.Append(", TimeZone = " + TimeZone);
            return stringBuilder.ToString();
        }
    }
}