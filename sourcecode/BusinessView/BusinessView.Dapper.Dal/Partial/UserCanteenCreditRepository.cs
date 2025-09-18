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
    public partial class UserCanteenCreditRepository
    {
        public bool? UpsertCanteenCredit(CanteenCreditInputModel canteenCreditInputModel, string listOfUserXml, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserIdGuids", listOfUserXml);
                    vParams.Add("@Amount", canteenCreditInputModel.Amount);
                    vParams.Add("@Currency", canteenCreditInputModel.CurrencyId);
                    vParams.Add("@IsArchived", canteenCreditInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<bool?>(StoredProcedureConstants.SpUpsertCanteenCredit, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCanteenCredit", "UserCanteenCreditRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionCanteenCreditUpsert);
                return null;
            }
        }

        public List<CanteenCreditApiOutputModel> SearchCanteenCredit(CanteenCreditSearchInputModel canteenCreditSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@UserId", canteenCreditSearchInputModel.UserId);
                    vParams.Add("@PageNumber", canteenCreditSearchInputModel.PageNumber);
                    vParams.Add("@PageSize", canteenCreditSearchInputModel.PageSize);
                    vParams.Add("@SortBy", canteenCreditSearchInputModel.SortBy);
                    vParams.Add("@SearchText", canteenCreditSearchInputModel.SearchText);
                    vParams.Add("@SortDirection", canteenCreditSearchInputModel.SortDirection);
                    vParams.Add("@EntityId", canteenCreditSearchInputModel.EntityId);
                    return vConn.Query<CanteenCreditApiOutputModel>(StoredProcedureConstants.SpSearchCanteenCredit, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchCanteenCredit", "UserCanteenCreditRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchCanteenCredit);
                return new List<CanteenCreditApiOutputModel>();
            }
        }
    }
}
