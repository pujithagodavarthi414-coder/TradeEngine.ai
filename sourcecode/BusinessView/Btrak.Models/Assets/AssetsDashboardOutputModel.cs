using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Assets
{
    public class AssetsDashboardOutputModel : InputModelBase
    {
        public AssetsDashboardOutputModel() : base(InputTypeGuidConstants.AssetsInputCommandTypeGuid)
        {
        }
        public Guid EmployeeId { get; set; }
        public string EmployeeName { get; set; }
        public string AssetName { get; set; }
        public string ProductName { get; set; }
        public string ApprovedBy { get; set; }
        public string AssignedDate { get; set; }
        public string BranchName { get; set; }
        public DateTime AssignedDateFrom { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", EmployeeId = " + EmployeeId);
            stringBuilder.Append(", EmployeeName = " + EmployeeName);
            stringBuilder.Append(", AssetName = " + AssetName);
            stringBuilder.Append(", ProductName = " + ProductName);
            stringBuilder.Append(", ApprovedBy = " + ApprovedBy);
            stringBuilder.Append(", AssignedDate = " + AssignedDate);
            stringBuilder.Append(", BranchName = " + BranchName);
            stringBuilder.Append(", AssignedDateFrom = " + AssignedDateFrom);
            return stringBuilder.ToString();
        }
    }
}
