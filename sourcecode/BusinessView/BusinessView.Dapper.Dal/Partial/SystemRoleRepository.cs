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
    public class SystemRoleRepository : BaseRepository
    {
        public List<SystemRoleApiReturnModel> SearchSystemRoles(SystemRoleSearchCriteriaInputModel systemRoleSearchCriteriaInputModel, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@SearchText", systemRoleSearchCriteriaInputModel.SearchText);
                    vParams.Add("@IsArchived", systemRoleSearchCriteriaInputModel.IsArchived);
                    return vConn.Query<SystemRoleApiReturnModel>(StoredProcedureConstants.SpSearchSystemRoles, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                   LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchSystemRoles"," SystemRoleRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchSystemRoles);
                return new List<SystemRoleApiReturnModel>();
            }
        }
    }
}