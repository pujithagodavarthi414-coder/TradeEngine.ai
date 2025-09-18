using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.HrManagement
{
    public class EmployeeLanguageDetailsInputModel : InputModelBase
    {
        public EmployeeLanguageDetailsInputModel() : base(InputTypeGuidConstants.EmployeeLanguageSearchInputCommandTypeGuid)
        {
        }

        public Guid? EmployeeLanguageId { get; set; }
        public string SearchText { get; set; }
        public Guid? EmployeeId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EmployeeId = " + EmployeeId);
            stringBuilder.Append(", SearchText = " + SearchText);
            stringBuilder.Append(",EmployeeLanguageId = " + EmployeeLanguageId);
            return stringBuilder.ToString();
        }
    }
}