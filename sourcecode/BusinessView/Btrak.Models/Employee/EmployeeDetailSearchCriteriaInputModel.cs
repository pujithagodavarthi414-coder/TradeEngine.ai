using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Employee
{
    public class EmployeeDetailSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public EmployeeDetailSearchCriteriaInputModel() : base(InputTypeGuidConstants.EmployeeDetailSearchCriteriaInputCommandTypeGuid)
        {
        }

        public Guid? EmployeeReportToId { get; set; }
        public Guid? EmployeeId { get; set; }
        public Guid? BranchId { get; set; }
        public string EmployeeDetailType { get; set; }
        public Guid? RateTagRoleBranchConfigurationId { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public int? GroupPriority { get; set; }
        public bool IsReporting { get; set; }
        public bool IsPermission { get; set; }
        


        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EmployeeId = " + EmployeeId);
            stringBuilder.Append(", EmployeeReportToId = " + EmployeeReportToId);
            stringBuilder.Append(", EmployeeDetailType = " + EmployeeDetailType);
            stringBuilder.Append(", StartDate = " + StartDate);
            stringBuilder.Append(", EndDate = " + EndDate);
            stringBuilder.Append(", GroupPriority = " + GroupPriority);
            stringBuilder.Append(", RateTagRoleBranchConfigurationId = " + RateTagRoleBranchConfigurationId);
            return stringBuilder.ToString();
        }
    }
}