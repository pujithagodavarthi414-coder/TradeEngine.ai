using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.HrManagement
{
    public class EmployeeRateSheetDetailsInputModel : InputModelBase
    {
        public EmployeeRateSheetDetailsInputModel() : base(InputTypeGuidConstants.EmployeeRatesheetDetailsInputCommandTypeGuid)
        {
        }

        public Guid? EmployeeRatesheetId { get; set; }
        public string SearchText { get; set; }
        public Guid? EmployeeId { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EmployeeId = " + EmployeeId);
            stringBuilder.Append(", SearchText = " + SearchText);
            stringBuilder.Append(", EmployeeRatesheetId = " + EmployeeRatesheetId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
