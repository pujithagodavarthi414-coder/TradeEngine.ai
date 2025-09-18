
using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.MyWork
{
    public class GetEmployeeYearlyProductivityReportInputModel : SearchCriteriaInputModelBase
    {
        public GetEmployeeYearlyProductivityReportInputModel() : base(InputTypeGuidConstants.EmployeeWorkLogReportInputModelInputCommandTypeGuid)
        {
        }
        public Guid? UserId { get; set; }
        public Guid? ProjectId { get; set; }
        public DateTime? Date { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" UserId = " + UserId);
            stringBuilder.Append(" ProjectId = " + ProjectId);
            stringBuilder.Append(", Date = " + Date);
            return stringBuilder.ToString();
        }
    }
}