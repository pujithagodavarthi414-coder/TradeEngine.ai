using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.BillingManagement;
using Btrak.Models.PaymentMethod;
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
   public partial class LeadTemplateRepository : BaseRepository
    {
        public Guid? UpsertLeadTemplate(LeadTemplateUpsertInputModel leadTemplateInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@TemplateId", leadTemplateInputModel.TemplateId);
                    vParams.Add("@FormName", leadTemplateInputModel.FormName);
                    vParams.Add("@IsArchived", leadTemplateInputModel.IsArchived);
                    vParams.Add("@FormJson", leadTemplateInputModel.FormJson);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@TimeStamp", leadTemplateInputModel.TimeStamp, DbType.Binary);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertLeadTemplate, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertLeadTemplate", "LeadTemplateRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertLeadTemplate);
                return null;
            }
        }

        public List<LeadTemplatesOutputReturnModel> SearchLeadTemplate(LeadTemplateSearchInputModel leadTemplateSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@TemplateId", leadTemplateSearchInputModel.TemplateId);
                    vParams.Add("@FormName", leadTemplateSearchInputModel.FormName);
                    vParams.Add("@SearchText", leadTemplateSearchInputModel.SearchText);
                    vParams.Add("@IsArchived", leadTemplateSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<LeadTemplatesOutputReturnModel>(StoredProcedureConstants.SpGetLeadTemplate, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchLeadTemplate", "LeadTemplateRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchLeadTemplate);
                return null;
            }
        }

        public List<LeadStagesSearchOutputModel> GetLeadStages(LeadStagesSearchInputModel leadStagesSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Id", leadStagesSearchInputModel.Id);
                    vParams.Add("@SearchText", leadStagesSearchInputModel.SearchText);
                    vParams.Add("@IsArchived", leadStagesSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<LeadStagesSearchOutputModel>(StoredProcedureConstants.SpGetLeadStages, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetLeadStages", "LeadTemplateRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllStatuses);
                return null;
            }
        }

        public Guid? UpsertLeadContractSubmissions(LeadContractSubmissionsInputModel leadContractUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Id", leadContractUpsertInputModel.Id);
                    vParams.Add("@SalesPersonId", leadContractUpsertInputModel.SalesPersonId);
                    vParams.Add("@LeadDate", leadContractUpsertInputModel.LeadDate);
                    vParams.Add("@ContractId", leadContractUpsertInputModel.ContractId);
                    vParams.Add("@ClientId", leadContractUpsertInputModel.ClientId);
                    vParams.Add("@ProductId", leadContractUpsertInputModel.ProductId);
                    vParams.Add("@GradeId", leadContractUpsertInputModel.GradeId);
                    vParams.Add("@QuantityInMT", leadContractUpsertInputModel.QuantityInMT);
                    vParams.Add("@RateGST", leadContractUpsertInputModel.RateGST);
                    vParams.Add("@PaymentTypeId", leadContractUpsertInputModel.PaymentTypeId);
                    vParams.Add("@VehicleNumberOfTransporter", leadContractUpsertInputModel.VehicleNumberOfTransporter);
                    vParams.Add("@MobileNumberOfTruckDriver", leadContractUpsertInputModel.MobileNumberOfTruckDriver);
                    vParams.Add("@Drums", leadContractUpsertInputModel.Drums);
                    vParams.Add("@PortId", leadContractUpsertInputModel.PortId);
                    vParams.Add("@BLNumber", leadContractUpsertInputModel.BLNumber);
                    vParams.Add("@ExceptionApprovalRequired", leadContractUpsertInputModel.ExceptionApprovalRequired);
                    vParams.Add("@StatusId", leadContractUpsertInputModel.StatusId);
                    vParams.Add("@ShipmentMonth", leadContractUpsertInputModel.ShipmentMonth);
                    vParams.Add("@CountryOriginId", leadContractUpsertInputModel.CountryOriginId);
                    vParams.Add("@TermsOfDelivery", leadContractUpsertInputModel.TermsOfDelivery);
                    vParams.Add("@CustomPoint", leadContractUpsertInputModel.CustomPoint);
                    vParams.Add("@IsClosed", leadContractUpsertInputModel.IsClosed);
                    vParams.Add("@IsArchived", leadContractUpsertInputModel.IsArchived);
                    vParams.Add("@InvoiceNumber", leadContractUpsertInputModel.InvoiceNumber);
                    vParams.Add("@DeliveryNote", leadContractUpsertInputModel.DeliveryNote);
                    vParams.Add("@SuppliersRef", leadContractUpsertInputModel.SuppliersRef);
                    vParams.Add("@ContractTypeId", leadContractUpsertInputModel.ContractTypeId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@TimeStamp", leadContractUpsertInputModel.TimeStamp, DbType.Binary);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertLeadContractSubmissions, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertLeadContractSubmissions", "LeadTemplateRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertStatus);
                return null;
            }
        }
        public List<LeadContractSubmissionsOutputModel> GetLeadContractSubmissions(LeadContractSubmissionsSearchInputModel leadStagesSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Id", leadStagesSearchInputModel.Id);
                    vParams.Add("@SearchText", leadStagesSearchInputModel.SearchText);
                    vParams.Add("@IsArchived", leadStagesSearchInputModel.IsArchived);
                    vParams.Add("@PageNo", leadStagesSearchInputModel.PageNumber);
                    vParams.Add("@PageSize", leadStagesSearchInputModel.PageSize);
                    vParams.Add("@SortBy", leadStagesSearchInputModel.SortBy);
                    vParams.Add("@SortDirection", leadStagesSearchInputModel.SortDirection);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<LeadContractSubmissionsOutputModel>(StoredProcedureConstants.SpGetLeadContractSubmissions, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetLeadContractSubmissions", "LeadTemplateRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllStatuses);
                return null;
            }
        }
        public List<LeadContractSubmissionsOutputModel> GetLeadById(Guid? LeadId, Guid? UserId, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@LeadId", LeadId);
                    vParams.Add("@UserId", UserId);
                    return vConn.Query<LeadContractSubmissionsOutputModel>(StoredProcedureConstants.SpGetLeadById, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetLeadById", "LeadTemplateRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchLeadTemplate);
                return null;
            }
        }
        public Guid? UpsertPaymentTerm(PaymentTermInputModel paymentTermInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Id", paymentTermInputModel.Id);
                    vParams.Add("@Name", paymentTermInputModel.Name);
                    vParams.Add("@TimeStamp", paymentTermInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", paymentTermInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertPaymentTerm, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPaymentTerm", "LeadTemplateRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionPaymentMethod);
                return null;
            }
        }

        public List<PaymentTermOutputModel> GetPaymentTerms(PaymentTermSearchInputModel paymentTermSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Id", paymentTermSearchCriteriaInputModel.Id);
                    vParams.Add("@SearchText", paymentTermSearchCriteriaInputModel.SearchText);
                    vParams.Add("@IsArchived", paymentTermSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<PaymentTermOutputModel>(StoredProcedureConstants.SpGetPaymentTerms, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPaymentTerms", "LeadTemplateRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.SearchPaymentMethod);
                return new List<PaymentTermOutputModel>();
            }
        }
        public Guid? UpsertPortDetails(PaymentTermInputModel paymentMethodInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Id", paymentMethodInputModel.Id);
                    vParams.Add("@Name", paymentMethodInputModel.Name);
                    vParams.Add("@PortCategoryId", paymentMethodInputModel.PortCategoryId);
                    vParams.Add("@TimeStamp", paymentMethodInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", paymentMethodInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertPortDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPortDetails", "LeadTemplateRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionPaymentMethod);
                return null;
            }
        }

        public List<PaymentTermOutputModel> GetPortDetails(PaymentTermSearchInputModel paymentMethodSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Id", paymentMethodSearchCriteriaInputModel.Id);
                    vParams.Add("@PortCategoryId", paymentMethodSearchCriteriaInputModel.PortCategoryId);
                    vParams.Add("@SearchText", paymentMethodSearchCriteriaInputModel.SearchText);
                    vParams.Add("@IsArchived", paymentMethodSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@UserId", paymentMethodSearchCriteriaInputModel.UserId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<PaymentTermOutputModel>(StoredProcedureConstants.SpGetPortDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPortDetails", "LeadTemplateRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.SearchPaymentMethod);
                return new List<PaymentTermOutputModel>();
            }
        }
        public Guid? UpsertLeadInvoice(ClientCreditsUpsertInputModel clientCreditsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@LeadId", clientCreditsUpsertInputModel.LeadId);
                    vParams.Add("@PaidAmount", clientCreditsUpsertInputModel.PaidAmount);
                    vParams.Add("@InvoiceNumber", clientCreditsUpsertInputModel.InvoiceNumber);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertLeadInvoice, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertLeadInvoice", "LeadTemplateRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionPaymentMethod);
                return null;
            }
        }

        public List<ClientCreditsLedgerOutputModel> GetLeadPayments(Guid LeadId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@LeadId", LeadId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ClientCreditsLedgerOutputModel>(StoredProcedureConstants.SpGetLeadPayments, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetLeadPayments", "LeadTemplateRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.SearchPaymentMethod);
                return new List<ClientCreditsLedgerOutputModel>();
            }
        }
        public bool CloseLead(Guid? LeadId, int isClosed, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@LeadId", LeadId);
                    vParams.Add("@IsClosed", isClosed);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<bool>(StoredProcedureConstants.SpCloseLead, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CloseLead", "LeadTemplateRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.SearchPaymentMethod);
                return false;
            }
        }        
        
        public Guid? UpsertWhDetails(WhDetailsInputModel whDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@LeadId", whDetailsInputModel.LeadId);
                    vParams.Add("@UserId", whDetailsInputModel.UserId);
                    vParams.Add("@FinalVehicleNumberOfTransporter", whDetailsInputModel.FinalVehicleNumberOfTransporter);
                    vParams.Add("@FinalMobileNumberOfTruckDriver", whDetailsInputModel.FinalMobileNumberOfTruckDriver);
                    vParams.Add("@FinalQuantityInMT", whDetailsInputModel.FinalQuantityInMT);
                    vParams.Add("@FinalDrums", whDetailsInputModel.FinalDrums);
                    vParams.Add("@FinalNetWeightApprox", whDetailsInputModel.FinalNetWeightApprox);
                    vParams.Add("@FinalPortId", whDetailsInputModel.FinalPortId);
                    vParams.Add("@FinalBLNumber", whDetailsInputModel.FinalBLNumber);
                    vParams.Add("@WeighingSlipNumber", whDetailsInputModel.WeighingSlipNumber);
                    vParams.Add("@WeighingSlipDate", whDetailsInputModel.WeighingSlipDate);
                    vParams.Add("@WeighingSlipPhoto", whDetailsInputModel.WeighingSlipPhoto);
                    vParams.Add("@UploadedOther", whDetailsInputModel.UploadedOther);
                    return vConn.Query<Guid>(StoredProcedureConstants.SpUpsertWhDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CloseLead", "LeadTemplateRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.SearchPaymentMethod);
                return null;
            }
        }
        public Guid? UpsertConsigner(PaymentTermInputModel paymentMethodInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Id", paymentMethodInputModel.Id);
                    vParams.Add("@Name", paymentMethodInputModel.Name);
                    vParams.Add("@TimeStamp", paymentMethodInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", paymentMethodInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertConsigner, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertConsigner", "LeadTemplateRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionPaymentMethod);
                return null;
            }
        }

        public List<PaymentTermOutputModel> GetConsignerList(PaymentTermSearchInputModel paymentMethodSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Id", paymentMethodSearchCriteriaInputModel.Id);
                    vParams.Add("@SearchText", paymentMethodSearchCriteriaInputModel.SearchText);
                    vParams.Add("@IsArchived", paymentMethodSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@UserId", paymentMethodSearchCriteriaInputModel.UserId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<PaymentTermOutputModel>(StoredProcedureConstants.SpGetConsignerList, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetConsignerList", "LeadTemplateRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.SearchPaymentMethod);
                return new List<PaymentTermOutputModel>();
            }
        }
        public Guid? UpsertConsignee(PaymentTermInputModel paymentMethodInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Id", paymentMethodInputModel.Id);
                    vParams.Add("@Name", paymentMethodInputModel.Name);
                    vParams.Add("@TimeStamp", paymentMethodInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", paymentMethodInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertConsignee, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertConsignee", "LeadTemplateRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionPaymentMethod);
                return null;
            }
        }

        public List<PaymentTermOutputModel> GetConsigneeList(PaymentTermSearchInputModel paymentMethodSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Id", paymentMethodSearchCriteriaInputModel.Id);
                    vParams.Add("@SearchText", paymentMethodSearchCriteriaInputModel.SearchText);
                    vParams.Add("@IsArchived", paymentMethodSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@UserId", paymentMethodSearchCriteriaInputModel.UserId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<PaymentTermOutputModel>(StoredProcedureConstants.SpGetConsigneeList, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetConsigneeList", "LeadTemplateRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.SearchPaymentMethod);
                return new List<PaymentTermOutputModel>();
            }
        }
    }
}
