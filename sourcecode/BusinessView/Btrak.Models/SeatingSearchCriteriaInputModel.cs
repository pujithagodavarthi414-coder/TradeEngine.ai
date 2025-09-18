using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models
{
    public class SeatingSearchCriteriaInputModel:SearchCriteriaInputModelBase
    {
        public SeatingSearchCriteriaInputModel() : base(InputTypeGuidConstants.SeatingSearchCriteriaInputCommandTypeGuid)
        {
        }

        public Guid? EmployeeId { get; set; }
        public Guid? BranchId { get; set; }
        public string SeatCode { get; set; }
        public Guid? SeatingId { get; set; }
        public Guid? EntityId { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", EmployeeId = " + EmployeeId);
            stringBuilder.Append(", BranchId = " + BranchId);
            stringBuilder.Append(", SeatCode = " + SeatCode);
            stringBuilder.Append(", SeatId = " + SeatingId);
            stringBuilder.Append(", EntityId = " + EntityId);
            return stringBuilder.ToString();
        }
    }
}
