using System;
using Btrak.Models.Status;
using BTrak.Common;
using Dapper;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class BugPriorityRepository
    {
        public List<BugPriorityApiReturnModel> GetAllBugPriorities(BugPriorityInputModel bugPriorityInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@BugPriorityId", bugPriorityInputModel.BugPriorityId);
                    vParams.Add("@PriorityName", bugPriorityInputModel.PriorityName);
                    vParams.Add("@Color", bugPriorityInputModel.Color);
                    vParams.Add("@IsArchived", bugPriorityInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<BugPriorityApiReturnModel>(StoredProcedureConstants.SpGetBugPriorities, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllBugPriorities", "BugPriorityRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllBugPriorities);
                return new List<BugPriorityApiReturnModel>();
            }
        }

        public Guid? UpsertBugPriority(UpsertBugPriorityInputModel upsertBugPriorityInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@BugPriorityId", upsertBugPriorityInputModel.BugPriorityId);
                    vParams.Add("@PriorityName", upsertBugPriorityInputModel.PriorityName);
                    vParams.Add("@Description", upsertBugPriorityInputModel.Description);
                    vParams.Add("@Color", upsertBugPriorityInputModel.Color);
                    vParams.Add("@TimeZone", upsertBugPriorityInputModel.TimeZone);
                    vParams.Add("@Icon", upsertBugPriorityInputModel.Icon);
                    vParams.Add("@Order", upsertBugPriorityInputModel.Order);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsArchived", upsertBugPriorityInputModel.IsArchived);
                    vParams.Add("@TimeStamp", upsertBugPriorityInputModel.TimeStamp, DbType.Binary);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertBugPriority, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertBugPriority", "BugPriorityRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionBugPriority);
                return null;
            }
        }
    }
}
