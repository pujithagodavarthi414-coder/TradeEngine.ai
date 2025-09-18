using Btrak.Dapper.Dal.Helpers;
using Btrak.Models.Assets;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Models;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class AssetRepository
    {
        public Guid? UpsertAsset(AssetsInputModel assetDetailsModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@AssetId", assetDetailsModel.AssetId);
                    vParams.Add("@AssetNumber", assetDetailsModel.AssetNumber);
                    vParams.Add("@AssetUniqueNumber", assetDetailsModel.AssetUniqueNumber);
                    vParams.Add("@AssetUniqueNumberId", assetDetailsModel.AssetUniqueNumberId);
                    vParams.Add("@PurchasedDate", assetDetailsModel.PurchasedDate);
                    vParams.Add("@ProductDetailsId", assetDetailsModel.ProductDetailsId);
                    vParams.Add("@AssetName", assetDetailsModel.AssetName);
                    vParams.Add("@Cost", assetDetailsModel.Cost);
                    vParams.Add("@CurrencyId", assetDetailsModel.CurrencyId);
                    vParams.Add("@IsWriteOff", assetDetailsModel.IsWriteOff);
                    vParams.Add("@DamagedByUserId", assetDetailsModel.DamagedByUserId);
                    vParams.Add("@DamagedDate", assetDetailsModel.DamagedDate);
                    vParams.Add("@DamagedReason", assetDetailsModel.DamagedReason);
                    vParams.Add("@IsEmpty", assetDetailsModel.IsEmpty);
                    vParams.Add("@IsVendor", assetDetailsModel.IsVendor);
                    vParams.Add("@AssignedToEmployeeId", assetDetailsModel.AssignedToEmployeeId);
                    vParams.Add("@AssignedDateFrom", assetDetailsModel.AssignedDateFrom);
                    vParams.Add("@AssignedDateTo", assetDetailsModel.AssignedDateTo);
                    vParams.Add("@ApprovedByUserId", assetDetailsModel.ApprovedByUserId);
                    vParams.Add("@TimeStamp", assetDetailsModel.TimeStamp, DbType.Binary);
                    vParams.Add("@SeatingId", assetDetailsModel.SeatingId);
                    vParams.Add("@BranchId", assetDetailsModel.BranchId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertAssets, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertAsset", " AssetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionAssetUpsert);
                return null;
            }
        }

        public List<AssetsMultipleUpdateReturnModel> UpdateAssigneeForMultipleAssets(AssetsInputModel assetDetailsModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@AssetIds", assetDetailsModel.AssetIds);
                    vParams.Add("@AssignedToEmployeeId", assetDetailsModel.AssignedToEmployeeId);
                    vParams.Add("@AssignedDateFrom", assetDetailsModel.AssignedDateFrom);
                    vParams.Add("@ApprovedByUserId", assetDetailsModel.ApprovedByUserId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<AssetsMultipleUpdateReturnModel>(StoredProcedureConstants.SpUpdateAssigneeForMultipleAssets, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateAssigneeForMultipleAssets", " AssetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionAssetUpsert);
                return null;
            }
        }

        public AssetDetailsModel GetAssetById(Guid? assetId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@AssetId", assetId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<AssetDetailsModel>(StoredProcedureConstants.SpGetAssetById, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAssetById", " AssetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionIndustryModule);
                return null;
            }
        }

        public List<AssetsOutputModel> SearchAssets(AssetSearchCriteriaInputModel assetSearchCriteriaModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@PageSize", assetSearchCriteriaModel.PageSize);
                    vParams.Add("@PageNumber", assetSearchCriteriaModel.PageNumber);
                    vParams.Add("@AssetId", assetSearchCriteriaModel.AssetId);
                    vParams.Add("@GetByUser", assetSearchCriteriaModel.ByUser);
                    vParams.Add("@GetAllDamaged", assetSearchCriteriaModel.AllDamaged);
                    vParams.Add("@GetAllAssigned", assetSearchCriteriaModel.AllAssigned);
                    vParams.Add("@SearchText", assetSearchCriteriaModel.SearchText);
                    vParams.Add("@IsListOfAssetsPage", assetSearchCriteriaModel.IsListOfAssetsPage);
                    vParams.Add("@AssignedToEmployeeId", assetSearchCriteriaModel.AssignedToEmployeeId);
                    vParams.Add("@SupplierId", assetSearchCriteriaModel.SupplierId);
                    vParams.Add("@SortBy", assetSearchCriteriaModel.SortBy);
                    vParams.Add("@SortDirection", assetSearchCriteriaModel.SortDirection);
                    vParams.Add("@SearchAssetCode", assetSearchCriteriaModel.SearchAssetCode);
                    vParams.Add("@ProductId", assetSearchCriteriaModel.ProductId);
                    vParams.Add("@DamagedByUserId", assetSearchCriteriaModel.DamagedByUserId);
                    vParams.Add("@ProductDetailsId", assetSearchCriteriaModel.ProductDetailsId);
                    vParams.Add("@IsEmpty", assetSearchCriteriaModel.IsEmpty);
                    vParams.Add("@IsVendor", assetSearchCriteriaModel.IsVendor);
                    vParams.Add("@UserId", assetSearchCriteriaModel.UserId);
                    vParams.Add("@BranchId", assetSearchCriteriaModel.BranchId);
                    vParams.Add("@SeatingId", assetSearchCriteriaModel.SeatingId);
                    vParams.Add("@EntityId", assetSearchCriteriaModel.EntityId);
                    vParams.Add("@AllPurchasedAssets", assetSearchCriteriaModel.AllPurchasedAssets);
                    vParams.Add("@ActiveAssignee", assetSearchCriteriaModel.ActiveAssignee);
                    vParams.Add("@PurchasedDate", assetSearchCriteriaModel.PurchasedDate);
                    vParams.Add("@AssignedDate", assetSearchCriteriaModel.AssignedDate);
                    vParams.Add("@AssetIds", assetSearchCriteriaModel.AssetIds);
                    //vParams.Add("@IsWriteOff", assetSearchCriteriaModel.IsWriteOff);
                    return vConn.Query<AssetsOutputModel>(StoredProcedureConstants.SpSearchAssets, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchAssets", " AssetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchAssets);
                return null;
            }
        }

        public List<AllUsersAssetsModel> GetAllUsersAssets(AssetSearchCriteriaInputModel assetSearchCriteriaModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@AssetId", assetSearchCriteriaModel.AssetId);
                    vParams.Add("@SearchText", assetSearchCriteriaModel.SearchText);
                    vParams.Add("@AssignedToEmployeeId", assetSearchCriteriaModel.AssignedToEmployeeId);
                    vParams.Add("@SupplierId", assetSearchCriteriaModel.SupplierId);
                    vParams.Add("@SearchAssetCode", assetSearchCriteriaModel.SearchAssetCode);
                    vParams.Add("@ProductId", assetSearchCriteriaModel.ProductId);
                    vParams.Add("@DamagedByUserId", assetSearchCriteriaModel.DamagedByUserId);
                    vParams.Add("@ProductDetailsId", assetSearchCriteriaModel.ProductDetailsId);
                    vParams.Add("@IsEmpty", assetSearchCriteriaModel.IsEmpty);
                    vParams.Add("@IsVendor", assetSearchCriteriaModel.IsVendor);
                    vParams.Add("@UserId", assetSearchCriteriaModel.UserId);
                    vParams.Add("@BranchId", assetSearchCriteriaModel.BranchId);
                    vParams.Add("@SeatingId", assetSearchCriteriaModel.SeatingId);
                    vParams.Add("@ActiveAssignee", assetSearchCriteriaModel.ActiveAssignee);
                    vParams.Add("@PurchasedDate", assetSearchCriteriaModel.PurchasedDate);
                    vParams.Add("@AssignedDate", assetSearchCriteriaModel.AssignedDate);

                    return vConn.Query<AllUsersAssetsModel>(StoredProcedureConstants.SpGetAllUsersAssets, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllUsersAssets", " AssetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllUsersAssets);
                return null;
            }
        }

        public List<AssetsDashboardOutputModel> GetAssetsAssignedToEmployees(AssetSearchCriteriaInputModel assertSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserId", assertSearchModel.UserId);
                    vParams.Add("@BranchId", assertSearchModel.BranchId);
                    vParams.Add("@TypeOfAsset", assertSearchModel.SearchAssetCode);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<AssetsDashboardOutputModel>(StoredProcedureConstants.SpGetAssetsAssignedToEmployee, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAssetsAssignedToEmployees", " AssetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAssetsAssignedToEmployees);
                return null;
            }
        }

        public List<AssetCommentsAndHistoryOutputModel> GetAssetCommentsAndHistory(AssetCommentAndHistorySearchCriteriaInputModel assetCommentAndHistorySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@AssetId", assetCommentAndHistorySearchCriteriaInputModel.AssetId);
                    vParams.Add("@PageNumber", assetCommentAndHistorySearchCriteriaInputModel.PageNumber);
                    vParams.Add("@PageSize", assetCommentAndHistorySearchCriteriaInputModel.PageSize);
                    return vConn.Query<AssetCommentsAndHistoryOutputModel>(StoredProcedureConstants.SpGetAssetHistory, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAssetCommentsAndHistory", " AssetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAssetCommentsAndHistory);
                return null;
            }
        }
    }
}
