using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.TimeSheet
{
    public class GetUserBreakDetailsInputModel : SearchCriteriaInputModelBase
    {
        public GetUserBreakDetailsInputModel() : base(InputTypeGuidConstants.GetFeedTimeHistoryInputCommandTypeGuid)
        {

        }

        public Guid? UserId { get; set; }
        public DateTime? DateFrom { get; set; }
        public Guid? OperationsPerformedBy { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" UserId = " + UserId);
            stringBuilder.Append(", DateFrom = " + DateFrom);
            stringBuilder.Append(", SortBy = " + SortBy);
            stringBuilder.Append(", PageNumber = " + PageNumber);
            stringBuilder.Append(", PageSize = " + PageSize);
            stringBuilder.Append(", OperationsPerformedBy = " + OperationsPerformedBy);
            return stringBuilder.ToString();
        }
    }
}

