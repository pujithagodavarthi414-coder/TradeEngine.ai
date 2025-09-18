using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.CompanyStructure;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Models.Currency;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class CurrencyRepository : BaseRepository
    {
        public Guid? UpsertCurrency(CurrencyInputModel currencyInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CurrencyId", currencyInputModel.CurrencyId);
                    vParams.Add("@CurrencyName", currencyInputModel.CurrencyName);
                    vParams.Add("@CurrencyCode", currencyInputModel.CurrencyCode);
                    vParams.Add("@CurrencySymbol", currencyInputModel.CurrencySymbol);
                    vParams.Add("@TimeStamp", currencyInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", currencyInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertCurrency, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCurrency", "CurrencyRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionCurrency);
                return null;
            }
        }

        public List<CurrencyOutputModel> SearchCurrency(CurrencySearchCriteriaInputModel currencySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
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
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchCurrency", "CurrencyRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.SearchCurrency);
                return new List<CurrencyOutputModel>();
            }
        }
    }
}
