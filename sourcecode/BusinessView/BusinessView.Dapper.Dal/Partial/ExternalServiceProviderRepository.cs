using Btrak.Dapper.Dal.Helpers;
using Btrak.Models.Comments;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Models;
using Btrak.Models.Crm;

namespace Btrak.Dapper.Dal.Partial
{
    public class ExternalServiceProviderRepository: BaseRepository
    {
        public List<ExpernalServiceProviderOutputModel> GetExternalServiceProperties(string serviceName, Guid UserId, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ExternalServiceName", serviceName);
                    vParams.Add("@OperationsPerformedBy", UserId);
                    return vConn.Query<ExpernalServiceProviderOutputModel>(StoredProcedureConstants.SpGetExternalServiceProperties, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetExternalServiceProperties", "ExternalServiceProviderRepository ", sqlException.Message), sqlException);
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionExternalServiceFetch);
                return null;
            }
        }
    }
}
