using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using BTrak.Common;

namespace Btrak.Models.SeatingArrangement
{
    public class SeatingArrangementInputModel : InputModelBase
    {
        public SeatingArrangementInputModel() : base(InputTypeGuidConstants.SeatingArrangementInputCommandTypeGuid)
        {
        }
        public Guid? SeatingId { get; set; }
        public Guid? BranchId { get; set; }
        public Guid? EmployeeId { get; set; }
        public string SeatCode { get; set; }
        public string Description { get; set; }
        public string Comment { get; set; }
        public string EmployeeName { get; set; }
        public bool? IsArchived { get; set; }
        public string CreatedOn { get; set; }
        public string TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", SeatingId = " + SeatingId);
            stringBuilder.Append(", BranchId = " + BranchId);
            stringBuilder.Append(", EmployeeId = " + EmployeeId);
            stringBuilder.Append(", SeatCode = " + SeatCode);
            stringBuilder.Append(", Description = " + Description);
            stringBuilder.Append(", Comment = " + Comment);
            stringBuilder.Append(", EmployeeName = " + EmployeeName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", CreatedOn = " + CreatedOn);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
