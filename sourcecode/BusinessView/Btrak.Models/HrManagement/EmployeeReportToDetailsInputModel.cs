using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.HrManagement
{
    public class EmployeeReportToDetailsInputModel : InputModelBase
    {
        public EmployeeReportToDetailsInputModel() : base(InputTypeGuidConstants.EmployeeReportToSearchInputCommandTypeGuid)
        {
        }

        public Guid? EmployeeReportToId { get; set; }
        public string SearchText { get; set; }
        public Guid? EmployeeId { get; set; }
        public Guid? UserId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EmployeeId = " + EmployeeId);
            stringBuilder.Append(", SearchText = " + SearchText);
            stringBuilder.Append(",EmployeeReportToId = " + EmployeeReportToId);
            return stringBuilder.ToString();
        }
    }
}