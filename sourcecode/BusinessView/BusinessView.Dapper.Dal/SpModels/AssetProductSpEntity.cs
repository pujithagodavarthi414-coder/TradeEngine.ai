using System;

namespace Btrak.Dapper.Dal.SpModels
{
    public class AssetProductSpEntity
    {
        public Guid ProductId { get; set; }
        public string ProductName { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public Guid CreatedByUserId { get; set; }
    }

    public class AssetDashboardSpEntity
    {
        public Guid AssignedToEmployeeId { get; set; }
        public string EmployeeName { get; set; }
        public string AssetName { get; set; }
        public string ProductName { get; set; }
        public DateTime? AssignedDateFrom { get; set; }
        public string BranchName { get; set; }
    }
}
