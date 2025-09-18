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
    public class SystemCountryRepository : BaseRepository
    {
        public List<SystemCountryApiReturnModel> SearchSystemCountries(SystemCountrySearchCriteriaInputModel systemCountrySearchCriteriaInputModel, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@SearchText", systemCountrySearchCriteriaInputModel.SearchText);
                    vParams.Add("@IsArchived", systemCountrySearchCriteriaInputModel.IsArchived);
                    vParams.Add("@CountryId", systemCountrySearchCriteriaInputModel.CountryId);
                    return vConn.Query<SystemCountryApiReturnModel>(StoredProcedureConstants.SpSearchSystemCountries, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchSystemCountries", "SystemCountryRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchSystemCountries);
                return new List<SystemCountryApiReturnModel>();
            }
        }
    }
}