using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.GRD;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;

namespace Btrak.Dapper.Dal.Repositories
{
    public class GRDRepository : BaseRepository
    {
        public Guid? UpsertGRD(GRDInputModel grdInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Id", grdInputModel.Id);
                    vParams.Add("@StartDate", grdInputModel.StartDate);
                    vParams.Add("@EndDate", grdInputModel.EndDate);
                    vParams.Add("@IsArchived", grdInputModel.IsArchived);
                    vParams.Add("@Name", grdInputModel.Name);
                    vParams.Add("@RepriseTariff", grdInputModel.RepriseTariff);
                    vParams.Add("@AutoCTariff", grdInputModel.AutoCTariff);
                    vParams.Add("@TimeStamp", grdInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid>(StoredProcedureConstants.SpUpsertGRD, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertGRD", "GRDRepository", sqlException.Message), sqlException);
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertGRD);
                return null;
            }
        }

        public List<GRDSearchOutputModel> GetGRD(GRDSearchInputModel grdInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Id", grdInput.Id);
                    vParams.Add("@CompanyId", grdInput.CompanyId);
                    vParams.Add("@SearchText", grdInput.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<GRDSearchOutputModel>(StoredProcedureConstants.SpGetGRD, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetGRD", "GRDRepository", sqlException.Message), sqlException);
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetGRD);
                return new List<GRDSearchOutputModel>();
            }
        }
        public Guid? UpsertCreditNote(CreditNoteUpsertInputModel creditNoteUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Id", creditNoteUpsertInputModel.Id);
                    vParams.Add("@SiteId", creditNoteUpsertInputModel.SiteId);
                    vParams.Add("@GrdId", creditNoteUpsertInputModel.GrdId);
                    vParams.Add("@Month", creditNoteUpsertInputModel.Month);
                    vParams.Add("@StartDate", creditNoteUpsertInputModel.StartDate);
                    vParams.Add("@EntryDate", creditNoteUpsertInputModel.EntryDate);
                    vParams.Add("@EndDate", creditNoteUpsertInputModel.EndDate);
                    vParams.Add("@Term", creditNoteUpsertInputModel.Term);
                    vParams.Add("@Name", creditNoteUpsertInputModel.Name);
                    vParams.Add("@IsTVAApplied", creditNoteUpsertInputModel.IsTVAApplied);
                    vParams.Add("@Year", creditNoteUpsertInputModel.Year);
                    vParams.Add("@IsArchived", creditNoteUpsertInputModel.IsArchived);
                    vParams.Add("@IsGenerateInvoice", creditNoteUpsertInputModel.IsGenerateInvoice);
                    vParams.Add("@InvoiceUrl", creditNoteUpsertInputModel.InvoiceUrl);
                    vParams.Add("@TimeStamp", creditNoteUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertCreditNote, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCreditNote", "GRDRepository", sqlException.Message), sqlException);
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertCreditNote);
                return null;
            }
        }

        public List<CreditNoteSearchOutputModel> GetCreditNote(CreditNoteSearchInputModel creditNoteSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CreditNoteId", creditNoteSearchInputModel.CreditNoteId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<CreditNoteSearchOutputModel>(StoredProcedureConstants.SpGetCreditNote, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCreditNote", "GRDRepository", sqlException.Message), sqlException);
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCreditNote);
                return new List<CreditNoteSearchOutputModel>();
            }
        }
        public Guid? UpsertMasterAccount(MasterAccountUpsertInputModel masterAccountUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Id", masterAccountUpsertInputModel.Id);
                    vParams.Add("@Account", masterAccountUpsertInputModel.Account);
                    vParams.Add("@AccountNo", masterAccountUpsertInputModel.AccountNo);
                    vParams.Add("@AccountNoF", masterAccountUpsertInputModel.AccountNoF);
                    vParams.Add("@ClassNo", masterAccountUpsertInputModel.ClassNo);
                    vParams.Add("@ClassNoF", masterAccountUpsertInputModel.ClassNoF);
                    vParams.Add("@Class", masterAccountUpsertInputModel.Class);
                    vParams.Add("@ClassF", masterAccountUpsertInputModel.ClassF);
                    vParams.Add("@Group", masterAccountUpsertInputModel.Group);
                    vParams.Add("@GroupF", masterAccountUpsertInputModel.GroupF);
                    vParams.Add("@SubGroup", masterAccountUpsertInputModel.SubGroup);
                    vParams.Add("@SubGroupF", masterAccountUpsertInputModel.SubGroupF);
                    vParams.Add("@Compte", masterAccountUpsertInputModel.Compte);
                    vParams.Add("@IsArchived", masterAccountUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", masterAccountUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid>(StoredProcedureConstants.SpUpsertMasterAccount, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertMasterAccount", "GRDRepository", sqlException.Message), sqlException);
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertMasterAccount);
                return null;
            }
        }
        public List<MasterAccountSearchOutputModel> GetMasterAccounts(MasterAccountSearchInputModel masterAccountSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@MasterAccountId", masterAccountSearchInputModel.MasterAccountId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<MasterAccountSearchOutputModel>(StoredProcedureConstants.SpGetMasterAccounts, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetMasterAccounts", "GRDRepository", sqlException.Message), sqlException);
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetMasterAccounts);
                return new List<MasterAccountSearchOutputModel>();
            }
        }
        public Guid? UpsertExpenseBooking(ExpenseBookingUpsertInputModel expenseBookingUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Id", expenseBookingUpsertInputModel.Id);
                    vParams.Add("@Type", expenseBookingUpsertInputModel.Type);
                    vParams.Add("@Term", expenseBookingUpsertInputModel.Term);
                    vParams.Add("@VendorName", expenseBookingUpsertInputModel.VendorName);
                    vParams.Add("@InvoiceNo", expenseBookingUpsertInputModel.InvoiceNo);
                    vParams.Add("@Description", expenseBookingUpsertInputModel.Description);
                    vParams.Add("@Comments", expenseBookingUpsertInputModel.Comments);
                    vParams.Add("@EntryDate", expenseBookingUpsertInputModel.EntryDate);
                    vParams.Add("@Month", expenseBookingUpsertInputModel.Month);
                    vParams.Add("@Year", expenseBookingUpsertInputModel.Year);
                    vParams.Add("@InvoiceDate", expenseBookingUpsertInputModel.InvoiceDate);
                    vParams.Add("@SiteId", expenseBookingUpsertInputModel.SiteId);
                    vParams.Add("@AccountId", expenseBookingUpsertInputModel.AccountId);
                    vParams.Add("@IsTVAApplied", expenseBookingUpsertInputModel.IsTVAApplied);
                    vParams.Add("@IsArchived", expenseBookingUpsertInputModel.IsArchived);
                    vParams.Add("@InvoiceValue", expenseBookingUpsertInputModel.InvoiceValue);
                    vParams.Add("@TimeStamp", expenseBookingUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid>(StoredProcedureConstants.SpUpsertExpenseBooking, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertExpenseBooking", "GRDRepository", sqlException.Message), sqlException);
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertExpenseBooking);
                return null;
            }
        }
        public List<ExpenseBookingSearchOutputModel> GetExpenseBookings(ExpenseBookingSearchInputModel expenseBookingSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ExpenseBookingId", expenseBookingSearchInputModel.ExpenseBookingId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ExpenseBookingSearchOutputModel>(StoredProcedureConstants.SpGetExpenseBookings, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetExpenseBookings", "GRDRepository", sqlException.Message), sqlException);
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetExpenseBookings);
                return new List<ExpenseBookingSearchOutputModel>();
            }
        }
        public Guid? UpsertPaymentReceipt(PaymentReceiptUpsertInputModel paymentReceiptUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Id", paymentReceiptUpsertInputModel.Id);
                    vParams.Add("@Term", paymentReceiptUpsertInputModel.Term);
                    vParams.Add("@Comments", paymentReceiptUpsertInputModel.Comments);
                    vParams.Add("@EntryDate", paymentReceiptUpsertInputModel.EntryDate);
                    vParams.Add("@Month", paymentReceiptUpsertInputModel.Month);
                    vParams.Add("@Year", paymentReceiptUpsertInputModel.Year);
                    vParams.Add("@BankReceiptDate", paymentReceiptUpsertInputModel.BankReceiptDate);
                    vParams.Add("@BankReference", paymentReceiptUpsertInputModel.BankReference);
                    vParams.Add("@SiteId", paymentReceiptUpsertInputModel.SiteId);
                    vParams.Add("@BankId", paymentReceiptUpsertInputModel.BankId);
                    vParams.Add("@PayValue", paymentReceiptUpsertInputModel.PayValue);
                    vParams.Add("@CreditNoteIds", paymentReceiptUpsertInputModel.CreditNoteIds);
                    vParams.Add("@EntryFormIds", paymentReceiptUpsertInputModel.EntryFormIds);
                    vParams.Add("@IsArchived", paymentReceiptUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", paymentReceiptUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid>(StoredProcedureConstants.SpUpsertPaymentReceipt, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPaymentReceipt", "GRDRepository", sqlException.Message), sqlException);
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertPaymentReceipt);
                return null;
            }
        }
        public List<PaymentReceiptSearchOutputModel> GetPaymentReceipts(PaymentReceiptSearchInputModel paymentReceiptSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@PaymentReceiptId", paymentReceiptSearchInputModel.PaymentReceiptId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<PaymentReceiptSearchOutputModel>(StoredProcedureConstants.SpGetPaymentReceipts, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPaymentReceipts", "GRDRepository", sqlException.Message), sqlException);
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetPaymentReceipts);
                return new List<PaymentReceiptSearchOutputModel>();
            }
        }
    }
}
