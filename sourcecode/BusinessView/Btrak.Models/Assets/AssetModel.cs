using BTrak.Common.Texts;
using System;
using System.Collections.Generic;
using System.Resources;

namespace Btrak.Models.Assets
{
    public class AssetDetailsModel
    {
        public Guid? AssetId { get; set; }
        public string AssetNumber { get; set; }
        public DateTime? PurchasedDate { get; set; }
        public string PurchasedOn { get; set; }
        public Guid? ProductId { get; set; }
        public Guid ProductDetailsId { get; set; }
        public string ProductName { get; set; }
        public string AssetName { get; set; }
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
        public string AssignedToEmployeeName { get; set; }
        public DateTime? AssignedDateFrom { get; set; }
        public string AssignedFrom { get; set; }
        public Guid ApprovedByUserId { get; set; }
        public string ApprovedByEmployeeName { get; set; }
        public Guid OperationPerformedBy { get; set; }
        public Guid SupplierId { get; set; }
        public string SupplierName { get; set; }
        public string ManufacturerCode { get; set; }
        public string ProductCode { get; set; }
        public DateTime? ApprovedDateTime { get; set; }
        public string ApprovedOn { get; set; }
        public int TotalCount { get; set; }
        public Guid? DamagedByUserId { get; set; }
        public string DamagedByFullName { get; set; }
        public string DamagedByProfileImage { get; set; }
        public Guid SeatingId { get; set; }
        public Guid BranchId { get; set; }
        public byte[] TimeStamp { get; set; }
    }

    public class SeatingDetailsModel
    {
        public Guid? SeatingId { get; set; }
        public Guid EmployeeId { get; set; }
        public string SeatCode { get; set; }
        public string Description { get; set; }
        public string Comment { get; set; }
        public string EmployeeName { get; set; }
        public bool IsArchived { get; set; }
        public Guid OperationPerformedBy { get; set; }
        public string CreatedOn { get; set; }
        public string TotalCount { get; set; }
    }

    public class AssetSearchInputModel
    {
        public int? PageSize { get; set; }
        public int? PageNumber { get; set; }
        public bool ByUser { get; set; }
        public bool? AllDamaged { get; set; }
        public bool AllPurchasedAssets { get; set; }
        public bool AllAssigned { get; set; }
        public bool All { get; set; }
        public Guid OperationPerformedBy { get; set; }
        public string SearchAssetName { get; set; }
        public string AssetNumber { get; set; }
        public Guid? UserId { get; set; }
        public Guid? BranchId { get; set; }
        public string SearchText { get; set; }
        public Guid? AssignedToEmployeeId { get; set; }
        public Guid? SupplierId { get; set; }
        public Guid? ProductId { get; set; }
        public Guid? ProductDetailsId { get; set; }
        public string SortBy { get; set; }
        public string SortDirection { get; set; }
        public bool? IsEmpty { get; set; }
        public bool? IsVendor { get; set; }
    }

    public class AssetAssignedUserModel
    {
        public Guid Id { get; set; }
        public Guid AssignedAssetId { get; set; }
        public Guid UserId { get; set; }
        public DateTime? AssignedDate { get; set; }
        public string AssigneeDateValue { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string Comment { get; set; }
        public string Assignto { get; set; }
        public string AssetName { get; set; }
        public string AssetId { get; set; }
    }

    public class AssetDashboardModel
    {
        public Guid EmployeeId { get; set; }
        public string EmployeeName { get; set; }
        public string AssetName { get; set; }
        public string ProductName { get; set; }
        public string ApprovedBy { get; set; }
        public string AssignedDate { get; set; }
        public string BranchName { get; set; }
    }

    public class AssetAuditFields
    {
        public string FieldName { get; set; }
        public string OldValue { get; set; }
        public string NewValue { get; set; }
        public string Description { get; set; }
        public string OldValueText { get; set; }
        public string NewValueText { get; set; }
        public string FullName { get; set; }
    }

    public class AssetAuditFieldsHistory
    {
        public string Description { get; set; }
        public string OldValueText { get; set; }
        public string NewValueText { get; set; }
        public string FullName { get; set; }

        public string HistoryDescription => Description == "AssetAdded" ?
                    string.Format(GetPropValue(Description), FullName):
                    string.Format(GetPropValue(Description), OldValueText, NewValueText, FullName);
            

        public string GetPropValue(string propName)
        {
            object src = new LangText();
            return src.GetType().GetProperty(propName).GetValue(src, null).ToString();
        }
    }

    public class AssetAuditModel
    {
        public AssetAuditModel ()
        {
            AssetsFieldsChangedList = new List<AssetAuditFields>();
        }
        public List<AssetAuditFields> AssetsFieldsChangedList { get; set; }
    }

    public class AssetAuditHistoryModel
    {
        public AssetAuditHistoryModel()
        {
            AssetsFieldsChangedList = new List<AssetAuditFieldsHistory>();
        }

        public List<AssetAuditFieldsHistory> AssetsFieldsChangedList { get; set; }
    }

    public class AssetCommentsAndHistoryModel
    {
        public Guid CreatedByUserId { get; set; }
        public string FirstName { get; set; }
        public string SurName { get; set; }
        public string FullName { get; set; }
        public string ProfileImage { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public string Description { get; set; }
        public string CreatedOn { get; set; }
    }
}