using Dapper;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.UserStory;
using BTrak.Common;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class LogTimeOptionRepository
    {
        public List<LogTimeOptionApiReturnModel> GetAllLogTimeOptions(GetLogTimeOptionsSearchCriteriaInputModel getLogTimeOptionsSearchCriteriaInputModel,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@LogTimeOptionId", getLogTimeOptionsSearchCriteriaInputModel.LogTimeOptionId);
                    vParams.Add("@LogTimeOption", getLogTimeOptionsSearchCriteriaInputModel.LogTimeOption);
                    vParams.Add("@SearchText", getLogTimeOptionsSearchCriteriaInputModel.SearchText);
                    vParams.Add("@IsArchived", getLogTimeOptionsSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<LogTimeOptionApiReturnModel>(StoredProcedureConstants.SpGetAllLogTimeOptions, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllLogTimeOptions", "LogTimeOptionRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllLogTimeOptions);
                return new List<LogTimeOptionApiReturnModel>();
            }
        }
    }
}
