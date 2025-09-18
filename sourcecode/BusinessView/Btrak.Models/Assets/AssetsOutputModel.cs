using System;
using System.Text;

namespace Btrak.Models.Assets
{
    public class AssetsOutputModel
    {
        public Guid? AssetId { get; set; }
        public string AssetNumber { get; set; }
        public DateTime? PurchasedDate { get; set; }
        public string PurchasedOn { get; set; }
        public Guid? ProductDetailsId { get; set; }
        public Guid? ProductId { get; set; }
        public string ProductName { get; set; }
        public string AssetName { get; set; }
        public string AssetUniqueNumber { get; set; }
        public Guid? AssetUniqueNumberId { get; set; }
        public decimal? Cost { get; set; }
        public Guid CurrencyId { get; set; }
        public string CurrencyType { get; set; }
        public string CurrencySymbol { get; set; }
        public bool IsWriteOff { get; set; }
        public DateTime? DamagedDate { get; set; }
        public string DamagedOn { get; set; }
        public string DamagedReason { get; set; }
        public bool IsEmpty { get; set; }
        public bool IsVendor { get; set; }
        public Guid AssignedToEmployeeId { get; set; }
        public Guid AssignedToUserId { get; set; }
        public string AssignedToEmployeeName { get; set; }
        public string AssignedToEmployeeProfileImage { get; set; }
        public DateTime? AssignedDateFrom { get; set; }
        public string AssignedFrom { get; set; }
        public Guid ApprovedByUserId { get; set; }
        public string ApprovedByEmployeeName { get; set; }
        public Guid SupplierId { get; set; }
        public string SupplierName { get; set; }
        public string ManufacturerCode { get; set; }
        public string ProductCode { get; set; }
        public Guid? DamagedByUserId { get; set; }
        public string DamagedByFullName { get; set; }
        public string DamagedByProfileImage { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public Guid? BranchId { get; set; }
        public string BranchName { get; set; }
        public Guid SeatingId { get; set; }
        public string SeatCode { get; set; }
        public int? PageSize { get; set; }
        public int? PageNumber { get; set; }
        public int? TotalCount { get; set; }
        public bool? IsSelfApproved { get; set; }
        public byte[] TimeStamp { get; set; }
        
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", AssetId = " + AssetId);
            stringBuilder.Append(", AssetNumber = " + AssetNumber);
            stringBuilder.Append(", PurchasedDate = " + PurchasedDate);
            stringBuilder.Append(", PurchasedOn = " + PurchasedOn);
            stringBuilder.Append(", ProductDetailsId = " + ProductDetailsId);
            stringBuilder.Append(", ProductId = " + ProductId);
            stringBuilder.Append(", ProductName = " + ProductName);
            stringBuilder.Append(", AssetName = " + AssetName);
            stringBuilder.Append(", AssetUniqueNumber = " + AssetUniqueNumber);
            stringBuilder.Append(", AssetUniqueNumberId = " + AssetUniqueNumberId);
            stringBuilder.Append(", Cost = " + Cost);
            stringBuilder.Append(", CurrencyId = " + CurrencyId);
            stringBuilder.Append(", CurrencyType = " + CurrencyType);
            stringBuilder.Append(", IsWriteOff = " + IsWriteOff);
            stringBuilder.Append(", DamagedDate = " + DamagedDate);
            stringBuilder.Append(", DamagedOn = " + DamagedOn);
            stringBuilder.Append(", DamagedReason = " + DamagedReason);
            stringBuilder.Append(", IsEmpty = " + IsEmpty);
            stringBuilder.Append(", IsVendor = " + IsVendor);
            stringBuilder.Append(", AssignedToEmployeeId = " + AssignedToEmployeeId);
            stringBuilder.Append(", AssignedToUserId = " + AssignedToUserId);
            stringBuilder.Append(", AssignedToEmployeeName = " + AssignedToEmployeeName);
            stringBuilder.Append(", AssignedToEmployeeProfileImage = " + AssignedToEmployeeName);
            stringBuilder.Append(", AssignedDateFrom = " + AssignedDateFrom);
            stringBuilder.Append(", AssignedFrom = " + AssignedFrom);
            stringBuilder.Append(", ApprovedByUserId = " + ApprovedByUserId);
            stringBuilder.Append(", ApprovedByEmployeeName = " + ApprovedByEmployeeName);
            stringBuilder.Append(", SupplierId = " + SupplierId);
            stringBuilder.Append(", SupplierName = " + SupplierName);
            stringBuilder.Append(", ManufacturerCode = " + ManufacturerCode);
            stringBuilder.Append(", ProductCode = " + ProductCode);
            stringBuilder.Append(", DamagedByUserId = " + DamagedByUserId);
            stringBuilder.Append(", DamagedByFullName = " + DamagedByFullName);
            stringBuilder.Append(", DamagedByProfileImage = " + DamagedByProfileImage);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", UpdatedDateTime = " + UpdatedDateTime);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", UpdatedByUserId = " + UpdatedByUserId);
            stringBuilder.Append(", BranchId = " + BranchId);
            stringBuilder.Append(", BranchName = " + BranchName);
            stringBuilder.Append(", SeatingId = " + SeatingId);
            stringBuilder.Append(", SeatCode = " + SeatCode);
            stringBuilder.Append(", PageSize = " + PageSize);
            stringBuilder.Append(", PageNumber = " + PageNumber);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", IsSelfApproved = " + IsSelfApproved);
            return stringBuilder.ToString();
        }
    }
}
