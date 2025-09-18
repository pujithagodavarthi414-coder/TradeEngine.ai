using System;

namespace Btrak.Dapper.Dal.SpModels
{
    public class AssetDetailsSpEntity
    {
        public Guid Id { get; set; }
        public string AssetNumber { get; set; }
        public string AssetName { get; set; }
        public DateTime? PurchaseDate { get; set; }
        public DateTime? CreatedDate { get; set; }
        public decimal? Cost { get; set; }
        public Guid CurrencyId { get; set; }
        public DateTime? ApprovedDateTime { get; set; }
        public DateTime? DamagedDate { get; set; }
        public string DamagedReason { get; set; }
        public string ProductName { get; set; }
        public string ManufacturerId { get; set; }
        public bool IsVendor { get; set; }
        public bool IsEmpty { get; set; }
        public bool IsWriteOff { get; set; }
        public Guid AssignedToEmployee { get; set; }
        public DateTime? AssignedDateFrom { get; set; }
        public DateTime? AssignedDateTo { get; set; }
        public Guid ApprovedBy { get; set; }
        public Guid CreatedBy { get; set; }
    }
}
