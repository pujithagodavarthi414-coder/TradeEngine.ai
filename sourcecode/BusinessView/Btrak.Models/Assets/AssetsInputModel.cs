using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Assets
{
    public class AssetsInputModel : InputModelBase
    {
        public AssetsInputModel() : base(InputTypeGuidConstants.AssetsInputCommandTypeGuid)
        {
        }
        public Guid? AssetId { get; set; }
        public string AssetNumber { get; set; }
        public string AssetUniqueNumber { get; set; }
        public Guid? AssetUniqueNumberId { get; set; }
        public DateTime? PurchasedDate { get; set; }
        public string PurchasedOn { get; set; }
        public Guid? ProductDetailsId { get; set; }
        public string AssetName { get; set; }
        public decimal? Cost { get; set; }
        public Guid CurrencyId { get; set; }
        public bool IsWriteOff { get; set; }
        public bool IsSelfApproved { get; set; }
        public Guid? DamagedByUserId { get; set; }
        public DateTime? DamagedDate { get; set; }
        public string DamagedReason { get; set; }
        public bool IsEmpty { get; set; }
        public bool IsVendor { get; set; }
        public Guid AssignedToEmployeeId { get; set; }
        public DateTime? AssignedDateFrom { get; set; }
        public DateTime? AssignedDateTo { get; set; }
        public string AssignedFrom { get; set; }
        public Guid ApprovedByUserId { get; set; }
        public int TotalCount { get; set; }
        public Guid SeatingId { get; set; }
        public Guid BranchId { get; set; }
        public bool? IsUpdateMultipleAssignee { get; set; }
        public string AssetIds { get; set; }
        public bool? IsToSendNotification { get; set; }
        public bool? ActiveAssignee { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", AssetId = " + AssetId);
            stringBuilder.Append(", AssetNumber = " + AssetNumber);
            stringBuilder.Append(", AssetUniqueNumber = " + AssetUniqueNumber);
            stringBuilder.Append(", AssetUniqueNumberId = " + AssetUniqueNumberId);
            stringBuilder.Append(", PurchaseDate = " + PurchasedDate);
            stringBuilder.Append(", PurchasedOn = " + PurchasedOn);
            stringBuilder.Append(", ProductDetailsId = " + ProductDetailsId);
            stringBuilder.Append(", AssetName = " + AssetName);
            stringBuilder.Append(", Cost = " + Cost);
            stringBuilder.Append(", CurrencyId = " + CurrencyId);
            stringBuilder.Append(", IsWriteOff = " + IsWriteOff);
            stringBuilder.Append(", DamagedDate = " + DamagedDate);
            stringBuilder.Append(", DamagedReason = " + DamagedReason);
            stringBuilder.Append(", IsEmpty = " + IsEmpty);
            stringBuilder.Append(", IsVendor = " + IsVendor);
            stringBuilder.Append(", AssignedToEmployeeId = " + AssignedToEmployeeId);
            stringBuilder.Append(", AssignedDateFrom = " + AssignedDateFrom);
            stringBuilder.Append(", AssignedDateTo = " + AssignedDateTo);
            stringBuilder.Append(", AssignedFrom = " + AssignedFrom);
            stringBuilder.Append(", IsSelfApproved = " + IsSelfApproved);
            stringBuilder.Append(", ApprovedByUserId = " + ApprovedByUserId);
            stringBuilder.Append(", SeatingId = " + SeatingId);
            stringBuilder.Append(", BranchId = " + BranchId);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", ActiveAssignee = " + ActiveAssignee);
            return stringBuilder.ToString();
        }
    }
}
