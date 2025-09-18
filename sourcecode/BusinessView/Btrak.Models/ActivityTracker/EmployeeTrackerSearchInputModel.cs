using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ActivityTracker
{
    public class EmployeeTrackerSearchInputModel : SearchCriteriaInputModelBase
    {
        public EmployeeTrackerSearchInputModel() : base(InputTypeGuidConstants.EmployeeTrackerSearchInputCommandTypeGuid)
        {

        }

        public List<Guid> UserId { get; set; }
        public string UserIdXml { get; set; }
        public Guid? BranchId { get; set; }
        public string BranchIdXml { get; set; }
        public bool? IsApp { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public DateTime? OnDate { get; set; }
        public string SearchText { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", UserId" + UserId);
            stringBuilder.Append(", UserIdXml" + UserIdXml);
            stringBuilder.Append(", BranchId" + BranchId);
            stringBuilder.Append(",DateFrom" + DateFrom);
            stringBuilder.Append(", DateTo = " + DateTo);
            stringBuilder.Append(", SearchText" + SearchText);
            return stringBuilder.ToString();
        }

    }
}
