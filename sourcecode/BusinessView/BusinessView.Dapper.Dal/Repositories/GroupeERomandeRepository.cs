using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.EntryForm;
using Btrak.Models.GrERomande;
using Btrak.Models.MessageFieldType;
using Btrak.Models.TVA;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace Btrak.Dapper.Dal.Repositories
{
    public class GroupeERomandeRepository : BaseRepository
    {
        public Guid? UpsertGroupe(GrERomandeInputModel grERomandeInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Id", grERomandeInput.Id);
                    vParams.Add("@SiteId", grERomandeInput.SiteId);
                    vParams.Add("@GrdId", grERomandeInput.GrdId);
                    vParams.Add("@BankId", grERomandeInput.BankId);
                    vParams.Add("@Month", grERomandeInput.Month);
                    vParams.Add("@StartDate", grERomandeInput.StartDate);
                    vParams.Add("@EndDate", grERomandeInput.EndDate);
                    vParams.Add("@Term", grERomandeInput.Term);
                    vParams.Add("@Year", grERomandeInput.Year);
                    vParams.Add("@Production", grERomandeInput.Production);
                    vParams.Add("@Reprise", grERomandeInput.Reprise);
                    vParams.Add("@AutoConsumption", grERomandeInput.AutoConsumption);
                    vParams.Add("@Facturation", grERomandeInput.Facturation);
                    vParams.Add("@PRATotal", grERomandeInput.PRATotal);
                    vParams.Add("@PRAFields", grERomandeInput.PRAFields);
                    vParams.Add("@DFFields", grERomandeInput.DFFields);
                    vParams.Add("@GridInvoice", grERomandeInput.GridInvoice);
                    vParams.Add("@GridInvoiceName", grERomandeInput.GridInvoiceName);
                    vParams.Add("@GridInvoiceDate", grERomandeInput.GridInvoiceDate);
                    vParams.Add("@IsGre", grERomandeInput.IsGre);
                    vParams.Add("@HauteTariff", grERomandeInput.HauteTariff);
                    vParams.Add("@BasTariff", grERomandeInput.BasTariff);
                    vParams.Add("@TariffTotal", grERomandeInput.TariffTotal);
                    vParams.Add("@Distribution", grERomandeInput.Distribution);
                    vParams.Add("@GreFacturation", grERomandeInput.GreFacturation);
                    vParams.Add("@GreTotal", grERomandeInput.GreTotal);
                    vParams.Add("@AdministrationRomandeE", grERomandeInput.AdministrationRomandeE);
                    vParams.Add("@ConfirmDetailsfromGrid", grERomandeInput.ConfirmDetailsfromGrid);
                    vParams.Add("@AutoConsumptionSum", grERomandeInput.AutoConsumptionSum);
                    vParams.Add("@FacturationSum", grERomandeInput.FacturationSum);
                    vParams.Add("@SubTotal", grERomandeInput.SubTotal);
                    vParams.Add("@TVA", grERomandeInput.TVA);
                    vParams.Add("@TVAForSubTotal", grERomandeInput.TVAForSubTotal);
                    vParams.Add("@Total", grERomandeInput.Total);
                    vParams.Add("@AutoCTariff", grERomandeInput.AutoCTariff);
                    vParams.Add("@InvoiceUrl", grERomandeInput.InvoiceUrl);
                    vParams.Add("@GenerateInvoice", grERomandeInput.GenerateInvoice);
                    vParams.Add("@IsArchived", grERomandeInput.IsArchived);
                    vParams.Add("@MessageType", grERomandeInput.MessageType);
                    vParams.Add("@IsInvoiceBit", grERomandeInput.IsInvoiceBit);
                    vParams.Add("@OutStandingAmount", grERomandeInput.OutStandingAmount);
                    vParams.Add("@TimeStamp", grERomandeInput.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid>(StoredProcedureConstants.SpUpsertGrERomande, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertGroupe", "GroupeERomandeRepository", sqlException.Message), sqlException);
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertGrERomande);
                return null;
            }
        }

        public List<GrERomandeSearchOutputModel> GetGroupe(GrERomandeSearchInputModel grERomandeSearchInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Id", grERomandeSearchInput.Id);
                    vParams.Add("@SearchText", grERomandeSearchInput.SearchText);
                    vParams.Add("@FileUrl", grERomandeSearchInput.FileUrl);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<GrERomandeSearchOutputModel>(StoredProcedureConstants.SpGetGrERomande, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetGroupe", "GroupeERomandeRepository", sqlException.Message), sqlException);
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetGrERomande);
                return new List<GrERomandeSearchOutputModel>();
            }
        }

        public List<GreRomandeHistoryOutputModel> GetGroupeRomandeHistory(GrERomandeSearchInputModel grERomandeSearchInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@GreRomandeId", grERomandeSearchInput.Id);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<GreRomandeHistoryOutputModel>(StoredProcedureConstants.SPGetGreRomandeHistory, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetGroupeRomandeHistory", "GroupeERomandeRepository", sqlException.Message), sqlException);
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetGrERomande);
                return new List<GreRomandeHistoryOutputModel>();
            }
        }

        public Guid? UpdateGreRomandeHistory(Guid? historyId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@GreRomandeHistoryId", historyId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid>(StoredProcedureConstants.SPUpdateGreRomandeHistory, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateGreRomandeHistory", "GroupeERomandeRepository", sqlException.Message), sqlException);
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpdateGreRomandeHistory);
                return null;
            }
        }




        public Guid? UpsertTVA(TVAInputModel tvaInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Id", tvaInput.Id);
                    vParams.Add("@StartDate", tvaInput.StartDate);
                    vParams.Add("@EndDate", tvaInput.EndDate);
                    vParams.Add("@TVAValue", tvaInput.TVA);
                    vParams.Add("@IsArchived", tvaInput.IsArchived);
                    vParams.Add("@TimeStamp", tvaInput.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid>(StoredProcedureConstants.SpUpsertTVA, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTVA", "GroupeERomandeRepository", sqlException.Message), sqlException);
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertGrERomande);
                return null;
            }
        }

        public List<TVASearchOutputModel> GetTVA(GrERomandeSearchInputModel grERomandeSearchInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Id", grERomandeSearchInput.Id);
                    vParams.Add("@SearchText", grERomandeSearchInput.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<TVASearchOutputModel>(StoredProcedureConstants.SpGetTVA, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTVA", "GroupeERomandeRepository", sqlException.Message), sqlException);
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetGrERomande);
                return new List<TVASearchOutputModel>();
            }
        }

        public Guid? UpsertMessagefieldType(MessageFieldTypeOutputModel messageTypeModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@MessageId", messageTypeModel.MessageId);
                    vParams.Add("@MessageTypeName", messageTypeModel.MessageType);
                    vParams.Add("@DisplayText", messageTypeModel.DisplayText);
                    vParams.Add("@IsDisplay", messageTypeModel.IsDisplay);
                    vParams.Add("@SelectedGrdIds", messageTypeModel.SelectedGrdIds);
                    vParams.Add("@GrdId", messageTypeModel.GrdId);
                    vParams.Add("@IsArchived", messageTypeModel.IsArchived);
                    vParams.Add("@TimeStamp", messageTypeModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid>(StoredProcedureConstants.SpUpsertMessageFieldType, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertMessagefieldType", "GroupeERomandeRepository", sqlException.Message), sqlException);
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetMessageFieldType);
                return null;
            }
        }

        public List<MessageFieldTypeOutputModel> GetMessageFieldType(MessageFieldSearchInputModel grERomandeSearchInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@MessageId", grERomandeSearchInput.MessageId);
                    vParams.Add("@SearchText", grERomandeSearchInput.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<MessageFieldTypeOutputModel>(StoredProcedureConstants.SpGetMessageFieldType, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetMessageFieldType", "GroupeERomandeRepository", sqlException.Message), sqlException);
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetGrERomande);
                return new List<MessageFieldTypeOutputModel>();
            }
        }

        public Guid? UpsertEntryFormField(EntryFormUpsertInputModel entryFormModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EntryFormId", entryFormModel.EntryFormId);
                    vParams.Add("@Unit", entryFormModel.Unit);
                    vParams.Add("@FieldTypeId", entryFormModel.FieldTypeId);
                    vParams.Add("@DisplayName", entryFormModel.DisplayName);
                    vParams.Add("@FieldName", entryFormModel.FieldName);
                    vParams.Add("@IsDisplay", entryFormModel.IsDisplay);
                    vParams.Add("@GRDId", entryFormModel.GRDId);
                    vParams.Add("@SelectedGrds", entryFormModel.SelectedGrdIds);
                    vParams.Add("@IsArchived", entryFormModel.IsArchived);
                    vParams.Add("@TimeStamp", entryFormModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid>(StoredProcedureConstants.SpUpsertEntryFormField, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEntryFormField", "GroupeERomandeRepository", sqlException.Message), sqlException);
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertEntryFormField);
                return null;
            }
        }

        public List<EntryFormFieldReturnOutputModel> GetEntryFormField(EntryFormFieldSearchInputModel entryFormSearchInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EntryFormId", entryFormSearchInput.EntryFormId);
                    vParams.Add("@SearchText", entryFormSearchInput.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EntryFormFieldReturnOutputModel>(StoredProcedureConstants.SpGetEntryFormField, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEntryFormField", "GroupeERomandeRepository", sqlException.Message), sqlException);
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEntryFormField);
                return new List<EntryFormFieldReturnOutputModel>();
            }
        }

        public Guid? UpsertEntryFormFieldType(FieldTypeSearchModel fieldTypeModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Id", fieldTypeModel.Id);
                    vParams.Add("@FieldTypeName", fieldTypeModel.FieldTypeName);
                    vParams.Add("@IsArchived", fieldTypeModel.IsArchived);
                    vParams.Add("@TimeStamp", fieldTypeModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid>(StoredProcedureConstants.SpUpsertEntryFormFieldType, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEntryFormFieldType", "GroupeERomandeRepository", sqlException.Message), sqlException);
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertEntryFormFieldTypes);
                return null;
            }
        }

        public List<FieldTypeSearchModel> GetEntryFormFieldType(FieldTypeSearchModel entryFormSearchInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EntryFormTypeId", entryFormSearchInput.Id);
                    vParams.Add("@SearchText", entryFormSearchInput.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<FieldTypeSearchModel>(StoredProcedureConstants.SpGetEntryFormFieldTypes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEntryFormFieldType", "GroupeERomandeRepository", sqlException.Message), sqlException);
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEntryFormFieldTypes);
                return new List<FieldTypeSearchModel>();
            }
        }

    }
}
