using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.Crm.Sms;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Dapper.Dal.Partial
{
    public class SmsRepository : BaseRepository
    {
        public Guid? SendMessage(SendSmsInputModel sendSmsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SentTo", sendSmsInputModel.MobileNumber);
                    vParams.Add("@TemplateId", sendSmsInputModel.TemplateId);
                    vParams.Add("@Message", sendSmsInputModel.TextMessage);
                    vParams.Add("@ReceiverId", sendSmsInputModel.ReceiverId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertSmsLog, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SendMessage", "SmsRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSaveSentMessage);
                return null;
            }
        }

        public Guid? UpsertSmsTemplate(SmsTemplateInputModel smsTemplateInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@TemplateId", smsTemplateInputModel.TemplateId);
                    vParams.Add("@TemplateName", smsTemplateInputModel.TemplateName);
                    vParams.Add("@Template", smsTemplateInputModel.Template);
                    vParams.Add("@IsActive", smsTemplateInputModel.IsActive);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertSmsTemplate, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertSmsTemplate", "SmsRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertSmsTemplate);
                return null;
            }
        }

        public List<SmsTemplateOutputModel> SearchSmsTemplate(SmsTemplateSearchTemplateInputModel smsTemplateSearchTemplateInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@TemplateId", smsTemplateSearchTemplateInputModel.TemplateId);
                    vParams.Add("@TemplateName", smsTemplateSearchTemplateInputModel.TemplateName);
                    vParams.Add("@ReceiverId", smsTemplateSearchTemplateInputModel.ReceiverId);
                    vParams.Add("@IsActive", smsTemplateSearchTemplateInputModel.IsActive);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<SmsTemplateOutputModel>(StoredProcedureConstants.SpGetSmsTemplate, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchSmsTemplate", "SmsRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetTemplate);
                return null;
            }
        }

        public SmsTemplateOutputModel GetSmsTemplateById(SmsTemplateSearchTemplateInputModel smsTemplateSearchTemplateInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@TemplateId", smsTemplateSearchTemplateInputModel.TemplateId);
                    vParams.Add("@TemplateName", smsTemplateSearchTemplateInputModel.TemplateName);
                    vParams.Add("@ReceiverId", smsTemplateSearchTemplateInputModel.ReceiverId);
                    vParams.Add("@IsActive", smsTemplateSearchTemplateInputModel.IsActive);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId == Guid.Empty ? smsTemplateSearchTemplateInputModel.UserId : loggedInContext.LoggedInUserId);
                    return vConn.Query<SmsTemplateOutputModel>(StoredProcedureConstants.SpGetSmsTemplate, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetSmsTemplateById", "SmsRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetTemplate);
                return null;
            }
        }
    }
}
