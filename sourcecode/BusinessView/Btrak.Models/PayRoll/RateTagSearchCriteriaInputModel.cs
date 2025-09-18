using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.PayRoll
{
    public class RateTagSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public RateTagSearchCriteriaInputModel() : base(InputTypeGuidConstants.GetRateTag)
        {
        }
        public Guid? RateTagId { get; set; }
        public string RateTagName { get; set; }
        public Guid? RateTagForId { get; set; }
        public Guid? RoleId { get; set; }
        public Guid? BranchId { get; set; }
        public Guid? EmployeeId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" RateTagId = " + RateTagId);
            stringBuilder.Append(", RateTagName = " + RateTagName);
            stringBuilder.Append(", RateTagForId = " + RateTagForId);
            stringBuilder.Append(", RoleId = " + RoleId);
            stringBuilder.Append(", BranchId = " + BranchId);
            stringBuilder.Append(", EmployeeId = " + EmployeeId);
            return stringBuilder.ToString();
        }
    }
}
