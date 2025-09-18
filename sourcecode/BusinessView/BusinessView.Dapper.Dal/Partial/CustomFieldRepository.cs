using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.CustomFields;
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
    public class CustomFieldRepository : BaseRepository
    {
        public Guid? UpsertCustomFieldForm(UpsertCustomFieldModel customFieldFormModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CustomFormFieldId", customFieldFormModel.CustomFieldId);
                    vParams.Add("@FormName", customFieldFormModel.FormName);
                    vParams.Add("@FormJson", customFieldFormModel.FormJson);
                    vParams.Add("@FormKeys", customFieldFormModel.FormKeys);
                    vParams.Add("@ModuleTypeId", customFieldFormModel.ModuleTypeId);
                    vParams.Add("@ReferenceId", customFieldFormModel.ReferenceId);
                    vParams.Add("@ReferenceTypeId", customFieldFormModel.ReferenceTypeId);
                    vParams.Add("@TimeZone", customFieldFormModel.TimeZone);
                    vParams.Add("@IsArchived", customFieldFormModel.IsArchived);
                    vParams.Add("@TimeStamp", customFieldFormModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertCustomFieldForm, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCustomFieldForm", " CustomFieldRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionCustomFieldFormUpsert);
                return null;
            }
        }

        public Guid? UpdateCustomFieldForm(UpsertCustomFieldModel customFieldFormModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CustomDataFormFieldId", customFieldFormModel.CustomDataFormFieldId);
                    vParams.Add("@CustomFormFieldId", customFieldFormModel.CustomFieldId);
                    vParams.Add("@FormDataJson", customFieldFormModel.FormDataJson);
                    vParams.Add("@ReferenceId", customFieldFormModel.ReferenceId);
                    vParams.Add("@ReferenceTypeId", customFieldFormModel.ReferenceTypeId);
                    vParams.Add("@TimeZone", customFieldFormModel.TimeZone);
                    vParams.Add("@TimeStamp", customFieldFormModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpdateCustomFieldFormData, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateCustomFieldForm", " CustomFieldRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionCustomFieldDataUpsert);
                return null;
            }
        }

        public List<CustomFieldApiReturnModel> SearchCustomFields(CustomFieldSearchCriteriaInputModel customFieldSearchCriteriaModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CustomFieldId", customFieldSearchCriteriaModel.CustomFieldId);
                    vParams.Add("@ReferenceId", customFieldSearchCriteriaModel.ReferenceId);
                    vParams.Add("@ReferenceTypeId", customFieldSearchCriteriaModel.ReferenceTypeId);
                    vParams.Add("@ModuleTypeId", customFieldSearchCriteriaModel.ModuleTypeId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<CustomFieldApiReturnModel>(StoredProcedureConstants.SpSearchCustomFields, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchCustomFields", " CustomFieldRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionNotGettingFeedbacks);
                return null;
            }
        }

        public List<CustomFieldsHistoryApiReturnModel> SearchCustomFieldsHistory(CustomFieldHistorySearchCriteriaModel customFieldSearchCriteriaModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CustomFieldId", customFieldSearchCriteriaModel.CustomFieldId);
                    vParams.Add("@ReferenceId", customFieldSearchCriteriaModel.ReferenceId);
                    vParams.Add("@ReferenceTypeId", customFieldSearchCriteriaModel.ReferenceTypeId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<CustomFieldsHistoryApiReturnModel>(StoredProcedureConstants.SpGetCustomFieldHistory, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchCustomFieldsHistory", " CustomFieldRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionNotGettingCustomFieldHistory);
                return null;
            }
        }
    }
}
