using Btrak.Dapper.Dal.Models;
using Btrak.Models;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models.Currency;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class MasterTableRepository
    {
        public string GetTimeZone(Guid timezoneTableId,Guid timeZoneId)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@TimeZoneTableId", timezoneTableId);
                vParams.Add("@TimeZoneId", timeZoneId);

                return vConn.Query<string>(StoredProcedureConstants.SpGetTimeZone, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }

        public List<CurrencyOutputModel> GetCurrencyList(CurrencySearchCriteriaInputModel currencySearchCriteriaInputModel, List<ValidationMessage> validationMessages,LoggedInContext loggedInContext)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@CurrencyId", currencySearchCriteriaInputModel.CurrencyId);
                    vParams.Add("@CurrencyCode", currencySearchCriteriaInputModel.CurrencyCode);
                    vParams.Add("@CurrencySymbol", currencySearchCriteriaInputModel.CurrencySymbol);
                    vParams.Add("@SearchText", currencySearchCriteriaInputModel.CurrencyNameSearchText);
                    vParams.Add("@IsArchived", currencySearchCriteriaInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);

                    return vConn.Query<CurrencyOutputModel>(StoredProcedureConstants.SpGetCurrenciesNew, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCurrencyList", "MasterTableRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCurrencyList);
                return new List<CurrencyOutputModel>();
            }
        }

        /* New Code*/
        public CurrencyModel GetCurrencyById(LoggedInContext loggedInContext, Guid currencyTypeId, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@CurrencyTypeId", currencyTypeId);

                    return vConn.Query<CurrencyModel>(StoredProcedureConstants.SpGetCurrencyById, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCurrencyById", "MasterTableRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCurrencyById);
                return null;
            }
        }
    }
}
