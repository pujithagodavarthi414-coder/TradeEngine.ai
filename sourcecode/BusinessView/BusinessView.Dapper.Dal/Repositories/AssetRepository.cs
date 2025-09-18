using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Models.Assets;
using BTrak.Common;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class AssetRepository : BaseRepository
    {
        public Guid UpsertAsset(AssetDetailsModel assetDetailsModel)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@AssetId", assetDetailsModel.AssetId);
                vParams.Add("@AssetNumber", assetDetailsModel.AssetNumber);
                vParams.Add("@PurchasedDate", assetDetailsModel.PurchasedDate);
                vParams.Add("@ProductDetailsId", assetDetailsModel.ProductDetailsId);
                vParams.Add("@AssetName", assetDetailsModel.AssetName);
                vParams.Add("@Cost", assetDetailsModel.Cost);
                vParams.Add("@CurrencyId", assetDetailsModel.CurrencyId);
                vParams.Add("@IsWriteOff", assetDetailsModel.IsWriteOff);
                vParams.Add("@DamagedDate", assetDetailsModel.DamagedDate);
                vParams.Add("@DamagedReason", assetDetailsModel.DamagedReason);
                vParams.Add("@IsEmpty", assetDetailsModel.IsEmpty);
                vParams.Add("@IsVendor", assetDetailsModel.IsVendor);
                vParams.Add("@AssignedToEmployeeId", assetDetailsModel.AssignedToEmployeeId);
                vParams.Add("@AssignedDateFrom", assetDetailsModel.AssignedDateFrom);
                vParams.Add("@ApprovedByUserId", assetDetailsModel.ApprovedByUserId);
                vParams.Add("@OperationPerformedBy", assetDetailsModel.OperationPerformedBy);
                return vConn.Query<Guid>("USP_UpsertAssets", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }

        public List<AssetDetailsModel> GetAllAssets(LoggedInContext loggedInContext)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@OperationPerformedBy", loggedInContext.LoggedInUserId);
                return vConn.Query<AssetDetailsModel>("USP_GetAllAssets", vParams, commandType: CommandType.StoredProcedure)
                    .ToList();
            }
        }

        public Guid SaveAssetsHistory(Guid? assetId, string assetHistoryJson, LoggedInContext loggedInContext)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@AssetId", assetId);
                vParams.Add("@AssetHistoryJson", assetHistoryJson);
                vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                return vConn.Query<Guid>("USP_InsertAssetHistory", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }
    }
}
