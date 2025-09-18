using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Models.Currency;
using Btrak.Models.CurrencyConversion;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class CurrencyConversionRepository : BaseRepository
    {
        public Guid? UpsertCurrencyConversion(CurrencyConversionInputModel currencyConversionInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CurrencyConversionId", currencyConversionInputModel.CurrencyConversionId);
                    vParams.Add("@FromCurrency", currencyConversionInputModel.FromCurrency);
                    vParams.Add("@ToCurrency", currencyConversionInputModel.ToCurrency);
                    vParams.Add("@EffectiveFrom", currencyConversionInputModel.EffectiveFrom);
                    vParams.Add("@CurrencyRate", currencyConversionInputModel.CurrencyRate);
                    vParams.Add("@TimeStamp", currencyConversionInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", currencyConversionInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertCurrencyConversion, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCurrencyConversion", "CurrencyConversionRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionCurrencyConversion);
                return null;
            }
        }

        public List<CurrencyConversionOutputModel> GetCurrencyConversion(CurrencyConversionSearchCriteriaInputModel currencyConversionSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FromCurrency", currencyConversionSearchCriteriaInputModel.FromCurrency);
                    vParams.Add("@ToCurrency", currencyConversionSearchCriteriaInputModel.ToCurrency);
                    vParams.Add("@EffectiveFrom", currencyConversionSearchCriteriaInputModel.EffectiveFrom);
                    vParams.Add("@CurrencyRate", currencyConversionSearchCriteriaInputModel.CurrencyRate);
                    vParams.Add("@CurrencyConversionId", currencyConversionSearchCriteriaInputModel.CurrencyConversionId);
                    vParams.Add("@IsArchived", currencyConversionSearchCriteriaInputModel.IsActive);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<CurrencyConversionOutputModel>(StoredProcedureConstants.SpGetCurrencyConversions, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCurrencyConversion", "CurrencyConversionRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.SearchCurrencyConversion);
                return new List<CurrencyConversionOutputModel>();
            }
        }
    }
}
