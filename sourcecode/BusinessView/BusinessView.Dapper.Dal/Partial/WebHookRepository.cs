using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.HrManagement;
using BTrak.Common;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class WebHookRepository : BaseRepository
    {
        public Guid? UpsertWebHook(WebHookUpsertInputModel webhookUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@WebHookId", webhookUpsertInputModel.WebHookId);
                    vParams.Add("@WebHookName", webhookUpsertInputModel.WebHookName);
                    vParams.Add("@WebHookUrl", webhookUpsertInputModel.WebHookUrl);
                    vParams.Add("@IsArchived", webhookUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", webhookUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertWebhook, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertWebHook", "WebHookRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertWebHook);
                return null;
            }
        }

        public List<WebHookApiReturnModel> GetWebHooks(WebHookSearchInputModel webhookSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@WebHookId", webhookSearchInputModel.WebHookId);
                    vParams.Add("@SearchText", webhookSearchInputModel.SearchText);
                    vParams.Add("@IsArchived", webhookSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<WebHookApiReturnModel>(StoredProcedureConstants.SpGetAllWebHooks, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetWebHooks", "WebHookRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetWebHook);
                return new List<WebHookApiReturnModel>();
            }
        }
    }
}
