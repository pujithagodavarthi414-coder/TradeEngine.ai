using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.Canteen;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace Btrak.Dapper.Dal.Partial
{
    public class CanteenFoodItemRepository : BaseRepository
    {
        public List<FoodItemApiReturnModel> SearchCanteenFoodItems(FoodItemSearchCriteriaInputModel foodItemSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FoodItemId", foodItemSearchCriteriaInputModel.FoodItemId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@DateFrom", foodItemSearchCriteriaInputModel.DateFrom);
                    vParams.Add("@DateTo", foodItemSearchCriteriaInputModel.DateTo);
                    vParams.Add("@PageNumber", foodItemSearchCriteriaInputModel.PageNumber);
                    vParams.Add("@PageSize", foodItemSearchCriteriaInputModel.PageSize);
                    vParams.Add("@SortBy", foodItemSearchCriteriaInputModel.SortBy);
                    vParams.Add("@EntityId", foodItemSearchCriteriaInputModel.EntityId);
                    vParams.Add("@IsArchived", foodItemSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@SortDirection", foodItemSearchCriteriaInputModel.SortDirection);
                    vParams.Add("@SearchText", foodItemSearchCriteriaInputModel.SearchText);
                    return vConn.Query<FoodItemApiReturnModel>(StoredProcedureConstants.SpSearchFoodItemsNew, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchCanteenFoodItems", "CanteenFoodItemRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchCanteenFoodItems);
                return new List<FoodItemApiReturnModel>();
            }
        }

        public Guid? UpsertCanteenFoodItem(CanteenFoodItemInputModel canteenFoodItemInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CanteenFoodItemId", canteenFoodItemInputModel.FoodItemId);
                    vParams.Add("@CanteenFoodItemName", canteenFoodItemInputModel.FoodItemName);
                    vParams.Add("@BranchId", canteenFoodItemInputModel.BranchId);
                    vParams.Add("@Price", canteenFoodItemInputModel.Price);
                    vParams.Add("@CurrencyId", canteenFoodItemInputModel.CurrencyId);
                    vParams.Add("@ActiveFrom", canteenFoodItemInputModel.ActiveFrom);
                    vParams.Add("@ActiveTo", canteenFoodItemInputModel.ActiveTo);
                    vParams.Add("@TimeStamp", canteenFoodItemInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsArchived", canteenFoodItemInputModel.IsArchived);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertCanteenFoodItem, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCanteenFoodItem", " CanteenFoodItemRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionCanteenFoodItem);

                return null;
            }
        }

        public FoodItemApiReturnModel GetFoodItemById(Guid? foodItemId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CanteenFoodItemId", foodItemId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<FoodItemApiReturnModel>(StoredProcedureConstants.SpGetCanteenFoodItemById, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetFoodItemById", " CanteenFoodItemRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.NotFoundFoodItemWithTheId);
                return null;
            }
        }
    }
}
