using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.MasterData
{
    public class GetLeavestatusSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public GetLeavestatusSearchCriteriaInputModel() : base(InputTypeGuidConstants.GetLeaveStatus)
        {
        }

        public Guid? LeaveStatusId { get; set; }
        public string LeaveStatusName { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" LeaveStatusId = " + LeaveStatusId);
            stringBuilder.Append(" LeaveStatusName = " + LeaveStatusName);
            stringBuilder.Append(" IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
