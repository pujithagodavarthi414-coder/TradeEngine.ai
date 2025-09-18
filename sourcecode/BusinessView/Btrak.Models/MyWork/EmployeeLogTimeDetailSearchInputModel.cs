using BTrak.Common;
using System;

namespace Btrak.Models.MyWork
{
    public class EmployeeLogTimeDetailSearchInputModel : SearchCriteriaInputModelBase
    {
        public EmployeeLogTimeDetailSearchInputModel() : base(InputTypeGuidConstants.UserHistoricalWorkReportInputCommandTypeGuid)
        {
        }
        public Guid? UserId { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public Guid? BoardTypeId { get; set; }
        public Guid? ProjectId { get; set; }
        public bool? ShowComments { get; set; }
        public Guid? LineManagerId { get; set; }
        public string TimeZone { get; set; }

    }
}
