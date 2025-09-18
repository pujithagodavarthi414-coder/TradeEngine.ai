using System;

namespace Btrak.Dapper.Dal.SpModels
{
    public class AssetSpEntity
    {
        public Guid Id { get; set; }
        public string AssetNumber { get; set; }
        public string AssetName { get; set; }
        public Guid AssignedToEmployeeId { get; set; }
        public string AssignedToFirstName { get; set; }
        public string AssignedToSurName { get; set; }
        public Guid ApprovedByUserId { get; set; }
        public string AssignedByFirstName { get; set; }
        public DateTime PurchasedDate { get; set; }
        public DateTime AssignedDateFrom { get; set; }
        public string AssignedBySurName { get; set; }
        public DateTime ApprovedDateTime{ get; set; }
        public decimal Cost { get; set; }
        public Guid CurrencyId { get; set; }
        public string CurrencyDetails { get; set; }
        public bool IsVendor { get; set; }
        public bool IsEmpty { get; set; }
        public bool IsWriteOff { get; set; }
        public DateTime DamagedDate { get; set; }
        public string DamagedReason { get; set; }
        public string ProductName { get; set; }
        public string ManufacturerCode { get; set; }
        public string ProductCode { get; set; }
        public string SupplierName { get; set; }
        public Guid CompanyId { get; set; }
        public Guid ProductId { get; set; }
        public Guid SupplierId { get; set; }
    }
}
