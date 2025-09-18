using System;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.Canteen;
using BTrak.Common;
using Dapper;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class UserPurchasedCanteenFoodItemRepository
    {
        public List<Guid> UpsertPurchasedCanteenFoodItem(string listOfCanteenItemXml,bool? isArchived, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CanteenFoodItemsXml", listOfCanteenItemXml);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsArchived", isArchived);
                    return vConn.Query<List<Guid>>(StoredProcedureConstants.SpPurchaseCanteenItem, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPurchasedCanteenFoodItem", "UserPurchasedCanteenFoodItemRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionPurchasedCanteenFoodItem);
                return new List<Guid>();
            }
        }

        public List<CanteenPurchaseOutputModel> SearchCanteenPurchases(SearchCanteenPurcahsesInputModel searchCanteenPurcahsesInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@UserId", searchCanteenPurcahsesInputModel.UserId);
                    vParams.Add("@DateFrom", searchCanteenPurcahsesInputModel.DateFrom);
                    vParams.Add("@DateTo", searchCanteenPurcahsesInputModel.DateTo);
                    vParams.Add("@PageNumber", searchCanteenPurcahsesInputModel.PageNumber);
                    vParams.Add("@PageSize", searchCanteenPurcahsesInputModel.PageSize);
                    vParams.Add("@SortBy", searchCanteenPurcahsesInputModel.SortBy);
                    vParams.Add("@SearchText", searchCanteenPurcahsesInputModel.SearchText);
                    vParams.Add("@SortDirection", searchCanteenPurcahsesInputModel.SortDirection);
                    vParams.Add("@EntityId", searchCanteenPurcahsesInputModel.EntityId);
                    return vConn.Query<CanteenPurchaseOutputModel>(StoredProcedureConstants.SpSearchCanteenPurchases, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchCanteenPurchases", "UserPurchasedCanteenFoodItemRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchCanteenPurchases);
                return new List<CanteenPurchaseOutputModel>();
            }
        }

        public List<CanteenBalanceApiOutputModel> SearchCanteenBalance(SearchCanteenBalanceInputModel searchCanteenBalanceInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@UserId", searchCanteenBalanceInputModel.UserId);
                    vParams.Add("@EntityId", searchCanteenBalanceInputModel.EntityId);
                    vParams.Add("@PageNumber", searchCanteenBalanceInputModel.PageNumber);
                    vParams.Add("@PageSize", searchCanteenBalanceInputModel.PageSize);
                    vParams.Add("@SortBy", searchCanteenBalanceInputModel.SortBy);
                    vParams.Add("@SearchText", searchCanteenBalanceInputModel.SearchText);
                    vParams.Add("@SortDirection", searchCanteenBalanceInputModel.SortDirection);
                    return vConn.Query<CanteenBalanceApiOutputModel>(StoredProcedureConstants.SpSearchCanteenBalanceDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchCanteenBalance", "UserPurchasedCanteenFoodItemRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.SearchCanteenBalance);
                return new List<CanteenBalanceApiOutputModel>();
            }
        }
    }
}
