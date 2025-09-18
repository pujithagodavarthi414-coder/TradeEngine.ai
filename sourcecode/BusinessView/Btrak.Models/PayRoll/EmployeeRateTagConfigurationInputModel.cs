using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class EmployeeRateTagConfigurationInputModel : InputModelBase
    {
        public EmployeeRateTagConfigurationInputModel() : base(InputTypeGuidConstants.EmployeeRateTagConfigurationInputCommandTypeGuid)
        {
        }

        public Guid? EmployeeId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", EmployeeId = " + EmployeeId);
            return stringBuilder.ToString();
        }
    }
}
