using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.PayRoll
{
    public class PayRollReportsSearchInputModel : SearchCriteriaInputModelBase
    {
        public PayRollReportsSearchInputModel() : base(InputTypeGuidConstants.PayRollTemplateSearchInputCommandTypeGuid)
        {
        }
        public DateTime? Date { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public Guid? EntityId { get; set; }
        public Guid? UserId { get; set; }
        public bool? IsActiveEmployeesOnly { get; set; }
        public Guid? LocationId { get; set; }
        public Guid? BranchId { get; set; }
        public bool? IsFinantialYearBased { get; set; }
        public string CompleteAddress { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("Date = " + Date);
            stringBuilder.Append(",DateFrom = " + DateFrom);
            stringBuilder.Append(",DateTo = " + DateTo);
            stringBuilder.Append(",EntityId = " + EntityId);
            stringBuilder.Append(", UserId = " + UserId);
            stringBuilder.Append(", IsActiveEmployeesOnly = " + IsActiveEmployeesOnly);
            stringBuilder.Append(", LocationId = " + LocationId);
            stringBuilder.Append(", BranchId = " + BranchId);
            stringBuilder.Append(", CompleteAddress = " + CompleteAddress);
            return stringBuilder.ToString();
        }
    }
}
