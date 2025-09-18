using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.MasterData
{
    public class LeaveStatusSearchInputModel:SearchCriteriaInputModelBase
    {
        public LeaveStatusSearchInputModel() : base(InputTypeGuidConstants.GetLeaveStatus)
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