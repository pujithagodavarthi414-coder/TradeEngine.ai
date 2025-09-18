using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Assets
{
    public class AssetSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public AssetSearchCriteriaInputModel() : base(InputTypeGuidConstants.AssetSearchCriteriaInputCommandTypeGuid)
        {
        }

        public bool ByUser { get; set; }
        public bool? AllDamaged { get; set; }
        public bool AllAssigned { get; set; }
        public Guid? AssetId { get; set; }
        public Guid? AssignedToEmployeeId { get; set; }
        public Guid? SupplierId { get; set; }
        public string SearchAssetCode { get; set; }
        public Guid? ProductId { get; set; }
        public Guid? DamagedByUserId { get; set; }
        public Guid? ProductDetailsId { get; set; }
        public bool? IsEmpty { get; set; }
        public bool? IsVendor { get; set; }
        public Guid? UserId { get; set; }
        public Guid? BranchId { get; set; }
        public Guid? SeatingId { get; set; }
        public Guid? EntityId { get; set; }
        public bool AllPurchasedAssets { get; set; }
        public bool? ActiveAssignee { get; set; }
        public DateTime? PurchasedDate { get; set; }
        public DateTime? AssignedDate { get; set; }
        public string AssetIds { get; set; }
        public bool IsListOfAssetsPage { get; set; }
       // public bool IsWriteOff { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", ByUser = " + ByUser);
            stringBuilder.Append(", AllDamaged = " + AllDamaged);
            stringBuilder.Append(", AllAssigned = " + AllAssigned);
            stringBuilder.Append(", AssetId = " + AssetId);
            stringBuilder.Append(", AssignedToEmployeeId = " + AssignedToEmployeeId);
            stringBuilder.Append(", SupplierId = " + SupplierId);
            stringBuilder.Append(", SearchAssetCode = " + SearchAssetCode);
            stringBuilder.Append(", ProductId = " + ProductId);
            stringBuilder.Append(", DamagedByUserId" + DamagedByUserId);
            stringBuilder.Append(", ProductDetailsId = " + ProductDetailsId);
            stringBuilder.Append(", IsEmpty = " + IsEmpty);
            stringBuilder.Append(", IsVendor = " + IsVendor);
            stringBuilder.Append(", UserId = " + UserId);
            stringBuilder.Append(", BranchId = " + BranchId);
            stringBuilder.Append(", SeatingId = " + SeatingId);
            stringBuilder.Append(", AllPurchasedAssets = " + AllPurchasedAssets);
            stringBuilder.Append(", PurchasedDate = " + PurchasedDate);
            stringBuilder.Append(", AssignedDate = " + AssignedDate);
            stringBuilder.Append(", ActiveAssignee = " + ActiveAssignee);
            stringBuilder.Append(", IsListOfAssetsPage = " + IsListOfAssetsPage);
            return stringBuilder.ToString();
        }
    }
}
