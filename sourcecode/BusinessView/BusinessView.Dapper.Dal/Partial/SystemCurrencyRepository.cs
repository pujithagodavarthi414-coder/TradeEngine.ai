using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using BTrak.Common;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.SystemManagement;
using Dapper;

namespace Btrak.Dapper.Dal.Partial
{
    public class SystemCurrencyRepository : BaseRepository
    {
        public List<SystemCurrencyApiReturnModel> SearchSystemCurrencies(SystemCurrencySearchCriteriaInputModel systemCurrencySearchCriteriaInputModel, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@SearchText", systemCurrencySearchCriteriaInputModel.SearchText);
                    vParams.Add("@IsArchived", systemCurrencySearchCriteriaInputModel.IsArchived);
                    return vConn.Query<SystemCurrencyApiReturnModel>(StoredProcedureConstants.SpSearchSystemCurrencies, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchSystemCurrencies", "SystemCurrencyRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchSystemCurrencies);
                return new List<SystemCurrencyApiReturnModel>();
            }
        }
    }
}
