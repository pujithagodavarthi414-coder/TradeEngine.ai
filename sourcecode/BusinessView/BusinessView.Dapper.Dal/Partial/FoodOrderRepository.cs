using Btrak.Dapper.Dal.Helpers;
using Btrak.Dapper.Dal.SpModels;
using Btrak.Models.FoodOrders;
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
    public partial class FoodOrderRepository
    {
        public Guid? UpsertFoodOrder(FoodOrderManagementInputModel foodOrderManagementInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, string xmlOfMemberId)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FoodOrderId", foodOrderManagementInputModel.FoodOrderId);
                    vParams.Add("@FoodOrderItems", foodOrderManagementInputModel.FoodOrderItems);
                    vParams.Add("@Amount", foodOrderManagementInputModel.Amount);
                    vParams.Add("@CurrencyId", foodOrderManagementInputModel.CurrencyId);
                    vParams.Add("@OrderedDateTime", foodOrderManagementInputModel.OrderedDate);
                    vParams.Add("@FoodOrderedUsersXml", xmlOfMemberId);
                    vParams.Add("@Comment", foodOrderManagementInputModel.Comment);
                    vParams.Add("@StatusId", foodOrderManagementInputModel.StatusId);
                    vParams.Add("@Reason", foodOrderManagementInputModel.Reason);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@TimeStamp", foodOrderManagementInputModel.TimeStamp, DbType.Binary);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertFoodOrder, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertFoodOrder", "FoodOrderRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionFoodOrderUpsert);
                return null;
            }
        }

        public Guid? ChangeFoodOrderStatus(ChangeFoodOrderStatusInputModel changeFoodOrderStatusInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FoodOrderId", changeFoodOrderStatusInputModel.FoodOrderId);
                    vParams.Add("@IsApproveOrder", changeFoodOrderStatusInputModel.IsFoodOrderApproved);
                    vParams.Add("@Reason", changeFoodOrderStatusInputModel.RejectReason);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@TimeStamp", changeFoodOrderStatusInputModel.TimeStamp, DbType.Binary);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertFoodOrderStatus, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ChangeFoodOrderStatus", "FoodOrderRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchCanteenFoodItems);
                return null;
            }
        }

        public List<FoodOrderManagementApiReturnModel> SearchFoodOrders(FoodOrderManagementSearchCriteriaInputModel foodOrderManagementSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FoodOrderId", foodOrderManagementSearchCriteriaInputModel.FoodOrderId);
                    vParams.Add("@SearchText", foodOrderManagementSearchCriteriaInputModel.SearchText);
                    vParams.Add("@Amount", foodOrderManagementSearchCriteriaInputModel.Amount);
                    vParams.Add("@CurrencyId", foodOrderManagementSearchCriteriaInputModel.CurrencyId);
                    vParams.Add("@OrderedDateTime", foodOrderManagementSearchCriteriaInputModel.OrderDateTime);
                    vParams.Add("@ClaimedByUserId", foodOrderManagementSearchCriteriaInputModel.ClaimedByUserId);
                    vParams.Add("@StatusId", foodOrderManagementSearchCriteriaInputModel.StatusId);
                    vParams.Add("@Date", foodOrderManagementSearchCriteriaInputModel.Date);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@PageSize", foodOrderManagementSearchCriteriaInputModel.PageSize);
                    vParams.Add("@PageNumber", foodOrderManagementSearchCriteriaInputModel.PageNumber);
                    vParams.Add("@SortBy", foodOrderManagementSearchCriteriaInputModel.SortBy);
                    vParams.Add("@SortDirection", foodOrderManagementSearchCriteriaInputModel.SortDirection);
                    vParams.Add("@IsRecent", foodOrderManagementSearchCriteriaInputModel.IsRecent);
                    vParams.Add("@EntityId", foodOrderManagementSearchCriteriaInputModel.EntityId);
                    return vConn.Query<FoodOrderManagementApiReturnModel>(StoredProcedureConstants.SpNewSearchFoodOrders, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchFoodOrders", "FoodOrderRepository", sqlException.Message),sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchFoodOrders);
                return new List<FoodOrderManagementApiReturnModel>();
            }
        }

        public List<FoodOrderManagementSpReturnModel> GetMonthlyFoodOrderReport(FoodOrderManagementSearchCriteriaInputModel foodOrderManagementSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Date", foodOrderManagementSearchCriteriaInputModel.Date);
                    vParams.Add("@EntityId", foodOrderManagementSearchCriteriaInputModel.EntityId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<FoodOrderManagementSpReturnModel>(StoredProcedureConstants.SpSearchFoodOrdersOnDailyBasis, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetMonthlyFoodOrderReport", "FoodOrderRepository", sqlException.Message),sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchFoodOrders);
                return new List<FoodOrderManagementSpReturnModel>();
            }
        }


        /*Old Code*/
        public IList<FoodOrderExpensesSpEntity> GetFoodOrderExpenseDetail(string orderedDate)
        {
            using (IDbConnection vConn = OpenConnection())
            {
                DynamicParameters vParams = new DynamicParameters();
                vParams.Add("@Date", orderedDate);
                return vConn.Query<FoodOrderExpensesSpEntity>(StoredProcedureConstants.SpGetFoodOrderExpenses, vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        public List<FoodOrderSpEntity> GetFoodOrders(FoodOrderSearchCriteriaInputModel foodOrderSearchCriteriaInputModel, LoggedInContext loggedInContext)
        {
            using (IDbConnection vConn = OpenConnection())
            {
                DynamicParameters vParams = new DynamicParameters();
                vParams.Add("@CompanyId", loggedInContext.CompanyGuid);
                vParams.Add("@PageSize", foodOrderSearchCriteriaInputModel.PageSize);
                vParams.Add("@skip", foodOrderSearchCriteriaInputModel.Skip);
                vParams.Add("@SearchText", foodOrderSearchCriteriaInputModel.SearchText);
                vParams.Add("@OrderByColumnName", foodOrderSearchCriteriaInputModel.OrderByField);
                vParams.Add("@OrderByDirectionAsc", foodOrderSearchCriteriaInputModel.OrderByDirection);
                return vConn.Query<FoodOrderSpEntity>(StoredProcedureConstants.SpSearchFoodOrders, vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }
        public List<FoodOrderReceiptSpEntity> GetFoodOrderReceipt(FoodOrderSearchCriteriaInputModel foodOrderSearchCriteriaInputModel, LoggedInContext loggedInContext)
        {
            using (IDbConnection vConn = OpenConnection())
            {
                DynamicParameters vParams = new DynamicParameters();
                vParams.Add("@CompanyId", loggedInContext.CompanyGuid);
                vParams.Add("@PageSize", foodOrderSearchCriteriaInputModel.PageSize);
                vParams.Add("@skip", foodOrderSearchCriteriaInputModel.Skip);
                vParams.Add("@SearchText", foodOrderSearchCriteriaInputModel.SearchText);

                return vConn.Query<FoodOrderReceiptSpEntity>(StoredProcedureConstants.SpFoodOrderWithReceipt, vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        public bool UpdateFoodOrderStatus(FoodOrderStatusModel foodOrderStatusModel, LoggedInContext loggedInContext)
        {
            bool blResult = false;
            using (IDbConnection vConn = OpenConnection())
            {
                DynamicParameters vParams = new DynamicParameters();
                vParams.Add("@Id", foodOrderStatusModel.Id);
                vParams.Add("@CompanyId", loggedInContext.CompanyGuid);
                vParams.Add("@StatusSetByUserId", loggedInContext.LoggedInUserId);
                vParams.Add("@FoodOrderStatusId", foodOrderStatusModel.FoodOrderStatusId);
                vParams.Add("@Reason", foodOrderStatusModel.Reason);
                vParams.Add("@UpdatedDateTime", DateTime.Now);
                vParams.Add("@UpdatedByUserId", loggedInContext.LoggedInUserId);
                vParams.Add("@StatusSetDateTime", DateTime.Now);
                int iResult = vConn.Execute(StoredProcedureConstants.SpUpdateFoodOrderStatus, vParams, commandType: CommandType.StoredProcedure);
                if (iResult == -1)
                {
                    blResult = true;
                }
            }
            return blResult;
        }
    }
}
