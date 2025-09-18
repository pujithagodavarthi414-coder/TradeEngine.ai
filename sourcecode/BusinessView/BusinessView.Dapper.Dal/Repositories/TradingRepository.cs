using System;
using System.Collections.Generic;
using System.Linq;
using BTrak.Common;
using Dapper;
using System.Data;
using System.Data.SqlClient;
using Btrak.Models;
using Btrak.Models.TradeManagement;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models.BillingManagement;

namespace Btrak.Dapper.Dal.Repositories
{
    public class TradingRepository : BaseRepository
    {
        public Guid? UpsertTolerance(ToleranceModel ToleranceModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)

        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@ToleranceId", ToleranceModel.ToleranceId);
                    vParams.Add("@ToleranceName", ToleranceModel.ToleranceName);
                    vParams.Add("@IsArchived", ToleranceModel.IsArchived);
                    vParams.Add("@TimeStamp", ToleranceModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertTolerance, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTolerance", "TradeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.UpsertToleranceException);
                return null;
            }
        }

        public ClientAccessModel GetClientAccss(Guid FeatureId,Guid? UserId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();

                    vParams.Add("@FeatureId", FeatureId);
                    vParams.Add("@UserId", UserId == null || UserId == Guid.Empty? loggedInContext.LoggedInUserId : UserId);
                    return vConn.Query<ClientAccessModel>("USP_EnsureUserCanHaveStepsAccess", vParams, commandType: CommandType.StoredProcedure)?.FirstOrDefault();
                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetClientAccss", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetClients);
                return new ClientAccessModel();
            }

        }


        public List<ToleranceModel> GetAllTolerances(ToleranceModel ToleranceModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@ToleranceId", ToleranceModel.ToleranceId);
                    vParams.Add("@IsArchived", ToleranceModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ToleranceModel>(StoredProcedureConstants.SpGetAllTolerances, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllTolerances", "TradeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetToleranceException);
                return new List<ToleranceModel>();
            }
        }


        public Guid? UpsertPaymentCondition(PaymentConditionModel PaymentConditionModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)

        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@PaymentConditionId", PaymentConditionModel.PaymentConditionId);
                    vParams.Add("@PaymentConditionName", PaymentConditionModel.PaymentConditionName);
                    vParams.Add("@IsArchived", PaymentConditionModel.IsArchived);
                    vParams.Add("@TimeStamp", PaymentConditionModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertPaymentCondition, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPaymentCondition", "TradeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.UpsertPaymentConditionException);
                return null;
            }
        }


        public List<PaymentConditionModel> GetAllPaymentConditions(PaymentConditionModel PaymentConditionModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@PaymentConditionId", PaymentConditionModel.PaymentConditionId);
                    vParams.Add("@IsArchived", PaymentConditionModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<PaymentConditionModel>(StoredProcedureConstants.SpGetAllPaymentConditions, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllPaymentConditions", "TradeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetPaymentConditionException);
                return new List<PaymentConditionModel>();
            }
        }        
        
        public List<TradeTemplateTypes> GetTradeTemplateTypes(TradeTemplateTypes TradeTemplateTypes, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TemplateTypeId", TradeTemplateTypes.TemplateTypeId);
                    vParams.Add("@TemplateTypeName", TradeTemplateTypes.TemplateTypeName);
                    vParams.Add("@IsArchived", TradeTemplateTypes.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<TradeTemplateTypes>(StoredProcedureConstants.SpGetTradeTemplateTypes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTradeTemplateTypes", "TradeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetTemplateTypeException);
                return new List<TradeTemplateTypes>();
            }
        }

        public Guid? UpsertRFQRequestAndSend(RFQRequestModel rFQRequestModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@DataSourceId", rFQRequestModel.DataSourceId);
                    vParams.Add("@TemplateId", rFQRequestModel.TemplateId);
                    vParams.Add("@TemplateTypeId", rFQRequestModel.TemplateTypeId);
                    vParams.Add("@ClientIdXml", rFQRequestModel.ClientIdXml);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertRFQRequest, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch(SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertRFQRequestAndSend", "TradeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.UpsertRFQRequest);
                return null;
            }
        }

        public List<RFQStatusModel> GetAllRFQStatus(RFQStatusModel rfqStatusModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@RFQStatusId", rfqStatusModel.RFQStatusId);
                    vParams.Add("@IsArchived", rfqStatusModel.IsArchived);
                    vParams.Add("@SearchText", rfqStatusModel.StatusName);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<RFQStatusModel>(StoredProcedureConstants.SpGetAllRFQStatus, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllRFQStatus", "TradeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetContractStatusException);
                return new List<RFQStatusModel>();
            }
        }

        public Guid? UpsertRFQStatus(RFQStatusModel rfqStatusModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@RFQStatusId", rfqStatusModel.RFQStatusId);
                    vParams.Add("@RFQStatusName", rfqStatusModel.RFQStatusName);
                    vParams.Add("@StatusName", rfqStatusModel.StatusName);
                    vParams.Add("@RFQStatusColor", rfqStatusModel.RFQStatusColor);
                    vParams.Add("@IsArchived", rfqStatusModel.IsArchived);
                    vParams.Add("@TimeStamp", rfqStatusModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertRFQStatus, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertRFQStatus", "TradeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.UpsertContractException);
                return null;
            }
        }

        public List<VesselConfirmationStatusModel> GetAllVesselConfirmationStatus(VesselConfirmationStatusModel vesselConfirmationStatus, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@StatusId", vesselConfirmationStatus.StatusId);
                    vParams.Add("@IsArchived", vesselConfirmationStatus.IsArchived);
                    vParams.Add("@SearchText", vesselConfirmationStatus.StatusName);
                    vParams.Add("@SearchTextStatus", vesselConfirmationStatus.StatusNameSearch);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<VesselConfirmationStatusModel>(StoredProcedureConstants.SpGetAllVesselConfirmationStatus, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllVesselConfirmationStatus", "TradeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetContractStatusException);
                return new List<VesselConfirmationStatusModel>();
            }
        }

        public Guid? UpsertVesselConfirmationStatus(VesselConfirmationStatusModel vesselConfirmationStatus, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@StatusId", vesselConfirmationStatus.StatusId);
                    vParams.Add("@VesselConfirmationStatusName", vesselConfirmationStatus.VesselConfirmationStatusName);
                    vParams.Add("@StatusName", vesselConfirmationStatus.StatusName);
                    vParams.Add("@StatusColor", vesselConfirmationStatus.StatusColor);
                    vParams.Add("@IsArchived", vesselConfirmationStatus.IsArchived);
                    vParams.Add("@TimeStamp", vesselConfirmationStatus.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertVesselConfirmationStatus, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertVesselConfirmationStatus", "TradeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.UpsertContractException);
                return null;
            }
        }

        public List<PortCategoryModel> GetAllPortCategory(PortCategorySearchInputModel portCategorySearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@Id", portCategorySearchInputModel.Id);
                    vParams.Add("@SearchText", portCategorySearchInputModel.SearchText);
                    vParams.Add("@IsArchived", portCategorySearchInputModel.IsArchived);
                    vParams.Add("@UserId", portCategorySearchInputModel.UserId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<PortCategoryModel>(StoredProcedureConstants.SpGetPortCategory, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllPortCategory", "TradeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetAllPortCategoryException);
                return new List<PortCategoryModel>();
            }
        }

        public Guid? UpsertPortCategory(PortCategoryModel portCategoryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@Id", portCategoryModel.Id);
                    vParams.Add("@Name", portCategoryModel.Name);
                    vParams.Add("@TimeStamp", portCategoryModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", portCategoryModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertPortCategory, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPortCategory", "TradeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.UpsertPortCategoryException);
                return null;
            }
        }

        public List<UserMiniModel> GetUsersForBinding(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    string query = "SELECT Id, UserAuthenticationId, CONCAT(FirstName, ISNULL(SurName, '')) AS [Name], ProfileImage AS ProfileImage FROM [User] WHERE CompanyId = '" + loggedInContext.CompanyGuid + "'";
                    return vConn.Query<UserMiniModel>(query, commandType: CommandType.Text).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUsersForBinding", "TradeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, "GetUsersForBinding");
                return new List<UserMiniModel>();
            }
        }
        public List<ContractStatusModel> GetPurchaseStatusForBinding(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    string query = "select Id AS ContractStatusId,StatusName from ContractStatus WHERE CompanyId = '" + loggedInContext.CompanyGuid + "'";
                    return vConn.Query<ContractStatusModel>(query, commandType: CommandType.Text).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUsersForBinding", "TradeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, "GetUsersForBinding");
                return new List<ContractStatusModel>();
            }
        }
    }
}
