using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class EmployeeRateTagDetailsInputModel : InputModelBase
    {
        public EmployeeRateTagDetailsInputModel() : base(InputTypeGuidConstants.EmployeeRateTagDetailsInputCommandTypeGuid)
        {
        }

        public Guid? EmployeeRateTagId { get; set; }
        public string SearchText { get; set; }
        public Guid? EmployeeId { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EmployeeId = " + EmployeeId);
            stringBuilder.Append(", SearchText = " + SearchText);
            stringBuilder.Append(", EmployeeRateTagId = " + EmployeeRateTagId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
