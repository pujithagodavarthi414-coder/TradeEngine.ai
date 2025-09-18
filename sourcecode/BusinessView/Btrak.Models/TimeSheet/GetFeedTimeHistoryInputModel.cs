using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.TimeSheet
{
    public class GetFeedTimeHistoryInputModel : InputModelBase
    {
        public GetFeedTimeHistoryInputModel() : base(InputTypeGuidConstants.GetFeedTimeHistoryInputCommandTypeGuid)
        {

        }
         
        public Guid? UserId { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public Guid? OperationsPerformedBy { get; set; }
        public string SortDirection { get; set;}
        public string SortBy { get; set;}
        public int? PageNumber { get; set; } = 1;
        public int? PageSize { get; set; } = int.MaxValue;
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" UserId = " + UserId);
            stringBuilder.Append(", DateFrom = " + DateFrom);
            stringBuilder.Append(", DateTo = " + DateTo);
            stringBuilder.Append(", SortDirection = " + SortDirection);
            stringBuilder.Append(", SortBy = " + SortBy);
            stringBuilder.Append(", PageNumber = " + PageNumber);
            stringBuilder.Append(", PageSize = " + PageSize);
            stringBuilder.Append(", OperationsPerformedBy = " + OperationsPerformedBy);
            return stringBuilder.ToString();
        }
    }
}
