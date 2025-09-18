using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Roster
{
    public class RosterSearchInputModel: SearchCriteriaInputModelBase
    {
        public RosterSearchInputModel() : base(InputTypeGuidConstants.GetRosterPlans)
        {
        }

        public Guid? RequestId { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public bool IsTemplate { get; set; }
        public Guid? BranchId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", RequestId = " + RequestId);
            stringBuilder.Append(", IsTemplate = " + IsTemplate);
            stringBuilder.Append(", StartDate = " + (StartDate.HasValue ? StartDate.Value.ToShortDateString(): ""));
            stringBuilder.Append(", EndDate = " + (EndDate.HasValue ? EndDate.Value.ToShortDateString() : ""));
            stringBuilder.Append(", BranchId = " + BranchId);
            return stringBuilder.ToString();
        }
    }
}
