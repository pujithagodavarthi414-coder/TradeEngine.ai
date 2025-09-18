using Btrak.Dapper.Dal.Helpers;
using Btrak.Dapper.Dal.Models;
using Btrak.Models;
using Btrak.Models.BillingManagement;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace Btrak.Dapper.Dal.Repositories
{
    public class ClientRepository : BaseRepository
    {
        public List<ClientOutputModel> GetClients(ClientInputModel clientInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ClientId", clientInputModel.ClientId);
                    vParams.Add("@ProjectTypeId", clientInputModel.ProjectTypeId);
                    vParams.Add("@BranchId", clientInputModel.BranchId);
                    vParams.Add("@UserId", clientInputModel.UserId);
                    vParams.Add("@SearchText", clientInputModel.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsArchived", clientInputModel.IsArchived);
                    vParams.Add("@PageNumber", clientInputModel.PageNumber);
                    vParams.Add("@PageSize", clientInputModel.PageSize);
                    vParams.Add("@SortBy", clientInputModel.SortBy);
                    vParams.Add("@SortDirection", clientInputModel.SortDirection);
                    vParams.Add("@EntityId", clientInputModel.EntityId);
                    vParams.Add("@ClientType", clientInputModel.ClientType);
                    vParams.Add("@ClientTypeName", clientInputModel.ClientTypeName);
                    vParams.Add("@IsForMail", clientInputModel.IsForMail);
                    vParams.Add("@IsForAPI", clientInputModel.IsForAPI);
                    vParams.Add("@ReferenceType", clientInputModel.ReferenceType);
                    return vConn.Query<ClientOutputModel>(StoredProcedureConstants.SpGetClients, vParams, commandType: CommandType.StoredProcedure).ToList();

                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetClients", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetClients);
                return new List<ClientOutputModel>();
            }

        }

        public virtual ClientOutputModel GetClientByUserId(string clientTypeName, Guid? UserId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages,Guid? ClientId)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ClientTypeName", clientTypeName);
                    vParams.Add("@UserId", UserId);
                    vParams.Add("@ClientId", ClientId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ClientOutputModel>(StoredProcedureConstants.SpGetClientByUserId, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();

                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetClientByUserId", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetClients);
                return new ClientOutputModel();
            }

        }

        public Guid? GetUserIdByClient(Guid clientId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    string query = "SELECT U.Id FROM [User] U INNER JOIN Client C ON C.UserId = U.Id INNER JOIN ClientType CT ON CT.Id = C.ClientTypeId WHERE CT.ClientTypeName IN ('Vessel Owner', 'Ship Broker', 'Supplier', 'Buyer', 'Banker') AND C.Id ='" + clientId+"'";
                    return vConn.Query<Guid>(query, commandType: CommandType.Text).FirstOrDefault();

                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserIdByClient", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetClients);
                return null;
            }

        }

        public string GetUserNameByClientId(Guid clientId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ClientId", clientId);
                    return vConn.Query<string>(StoredProcedureConstants.SpGetUserNameByClientId, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();

                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserNameByClientId", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetClients);
                return null;
            }
        }

        public string GetUserFullNameByClientId(Guid clientId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    var query = "SELECT TOP(1) CONCAT(U.FirstName, ' ', ISNULL(U.SurName, '')) AS FullName FROM[User] U INNER JOIN Client C ON C.UserId = U.Id WHERE C.Id ='" + clientId + "'"; ;
                    return vConn.Query<string>(query, commandType: CommandType.Text).FirstOrDefault();

                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserFullNameByClientId", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetClients);
                return null;
            }
        }

        public Guid? GetUserAuthenticationIdByClient(Guid clientId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    string query = "SELECT U.UserAuthenticationId FROM [User] U INNER JOIN Client C ON C.UserId = U.Id INNER JOIN ClientType CT ON CT.Id = C.ClientTypeId WHERE CT.ClientTypeName IN ('Vessel Owner', 'Ship Broker', 'Supplier', 'Buyer', 'Banker') AND C.Id ='" + clientId + "'";
                    return vConn.Query<Guid>(query, commandType: CommandType.Text).FirstOrDefault();

                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserIdByClient", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetClients);
                return null;
            }

        }

        public Guid? GetUserAuthenticationIdByUserId(Guid userId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    string query = "SELECT U.UserAuthenticationId FROM [User] U WHERE U.Id ='" + userId + "' AND U.UserAuthenticationId IS NOT NULL";
                    var data = vConn.Query<Guid>(query, commandType: CommandType.Text).ToList();
                    if(data != null && data.Count > 0)
                    {
                        var authenticationId = data[0];
                        return authenticationId;
                    }
                    else
                    {
                        return null;
                    }
                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserAuthenticationIdByUserId", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetClients);
                return null;
            }

        }

        public Guid? UpsertSCOStatus(LeadSubmissionsDetails clientInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@LeadFormId", clientInputModel.LeadFormId);
                    //vParams.Add("@ClientId", clientInputModel.ClientId);
                    vParams.Add("@Comments", clientInputModel.Comments);
                    vParams.Add("@IsScoAccepted", clientInputModel.IsScoAccepted);
                    vParams.Add("@ScoId", clientInputModel.ScoId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertSCOStatus, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();

                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertSCOStatus", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetClients);
                return null;
            }

        }

        public Guid? UpsertClient(UpsertClientInputModel upsertClientInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ClientId", upsertClientInputModel.ClientId);
                    vParams.Add("@FirstName", upsertClientInputModel.FirstName);
                    vParams.Add("@LastName", upsertClientInputModel.LastName);
                    vParams.Add("@Email", upsertClientInputModel.Email);
                    vParams.Add("@MobileNo", upsertClientInputModel.MobileNo);
                    vParams.Add("@Password", upsertClientInputModel.Password);
                    vParams.Add("@ProfileImage", upsertClientInputModel.ProfileImage);
                    vParams.Add("@CompanyName", upsertClientInputModel.CompanyName);
                    vParams.Add("@CompanyWebsite", upsertClientInputModel.CompanyWebsite);
                    vParams.Add("@Note", upsertClientInputModel.Note);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsArchived", upsertClientInputModel.IsArchived);
                    vParams.Add("@RoleIds", upsertClientInputModel.RoleIds);
                    vParams.Add("@ContractTemplateIds", upsertClientInputModel.ContractTemplateIds);
                    vParams.Add("@ClientTypeId", upsertClientInputModel.ClientType);
                    vParams.Add("@ClientKycId", upsertClientInputModel.KycDocument);
                    vParams.Add("@TimeStamp", upsertClientInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@LeadFormId", upsertClientInputModel.LeadFormId);
                    vParams.Add("@LeadFormData", upsertClientInputModel.LeadFormData);
                    vParams.Add("@ContarctFormId", upsertClientInputModel.ContractFormId);
                    vParams.Add("@ContractFromData", upsertClientInputModel.ContractFormData);
                    vParams.Add("@ContractFromJson", upsertClientInputModel.ContractFormJson);
                    vParams.Add("@CreditLimit", upsertClientInputModel.CreditLimit);
                    vParams.Add("@LeadFormJson", upsertClientInputModel.LeadFormJson);
                    vParams.Add("@IsForLeadSubmission", upsertClientInputModel.IsForLeadSubmission);
                    vParams.Add("@AvailableCreditLimit", upsertClientInputModel.AvailableCreditLimit);
                    vParams.Add("@AddressLine1", upsertClientInputModel.AddressLine1);
                    vParams.Add("@AddressLine2", upsertClientInputModel.AddressLine2);
                    vParams.Add("@PanNumber", upsertClientInputModel.PanNumber);
                    vParams.Add("@BusinessEmail", upsertClientInputModel.BusinessEmail);
                    vParams.Add("@BusinessNumber", upsertClientInputModel.BusinessNumber);
                    vParams.Add("@EximCode", upsertClientInputModel.EximCode);
                    vParams.Add("@GstNumber", upsertClientInputModel.GstNumber);
                    vParams.Add("@KycExpiryDays", upsertClientInputModel.KycExpiryDays);
                    vParams.Add("@LegalEntityId", upsertClientInputModel.LegalEntityId);
                    vParams.Add("@TimeZoneId", upsertClientInputModel.TimeZoneId);
                    vParams.Add("@IsKycSybmissionMailSent", upsertClientInputModel.IsKycSybmissionMailSent);
                    vParams.Add("@IsVerified", upsertClientInputModel.IsVerified);
                    vParams.Add("@UserAuthenticationId", upsertClientInputModel.UserAuthenticationId);
                    vParams.Add("@BrokerageValue", upsertClientInputModel.BrokerageValue);
                    vParams.Add("@BusinesCountryCode", upsertClientInputModel.BusinesCode);
                    vParams.Add("@PhNoCountryCode", upsertClientInputModel.PhoneCountryCode);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertClient, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();

                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertClient", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertClient);
                return null;
            }
        }

        public Guid? UpsertClientAddress(UpsertClientInputModel upsertClientAddressInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ClientAddressId", upsertClientAddressInputModel.ClientAddressId);
                    vParams.Add("@ClientId", upsertClientAddressInputModel.ClientId);
                    vParams.Add("@CountryId", upsertClientAddressInputModel.CountryId);
                    vParams.Add("@Street", upsertClientAddressInputModel.Street);
                    vParams.Add("@City", upsertClientAddressInputModel.City);
                    vParams.Add("@State", upsertClientAddressInputModel.State);
                    vParams.Add("@Zipcode", upsertClientAddressInputModel.Zipcode);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@TimeStamp", upsertClientAddressInputModel.ClientAddressTimeStamp, DbType.Binary);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertClientAddress, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();

                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertClientAddress", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertClientAddress);
                return null;
            }
        }

        public Guid? UpdateClientTemplates(UpsertClientInputModel upsertClientAddressInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ClientId", upsertClientAddressInputModel.ClientId);
                    vParams.Add("@IsSavingContractTemplates", upsertClientAddressInputModel.IsSavingContractTemplates);
                    vParams.Add("@IsSavingTradeTemplates", upsertClientAddressInputModel.IsSavingTradeTemplates);
                    vParams.Add("@ContractTemplateIds", upsertClientAddressInputModel.ContractTemplateIds);
                    vParams.Add("@TradeTemplateIds", upsertClientAddressInputModel.TradeTemplateIds);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@TimeStamp", upsertClientAddressInputModel.TimeStamp, DbType.Binary);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpdateClientTemplates, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();

                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateClientTemplates", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertClient);
                return null;
            }
        }

        public Guid? UpsertClientSecondaryContact(UpsertClientSecondaryContactModel upsertClientSecondaryContactModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ClientSecondaryContactId", upsertClientSecondaryContactModel.ClientSecondaryContactId);
                    vParams.Add("@ClientId", upsertClientSecondaryContactModel.ClientId);
                    vParams.Add("@FirstName", upsertClientSecondaryContactModel.FirstName);
                    vParams.Add("@Password", upsertClientSecondaryContactModel.Password);
                    vParams.Add("@LastName", upsertClientSecondaryContactModel.LastName);
                    vParams.Add("@Email", upsertClientSecondaryContactModel.Email);
                    vParams.Add("@MobileNo", upsertClientSecondaryContactModel.MobileNo);
                    vParams.Add("@ProfileImage", upsertClientSecondaryContactModel.ProfileImage);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@TimeStamp", upsertClientSecondaryContactModel.TimeStamp, DbType.Binary);
                    vParams.Add("@RoleIds", upsertClientSecondaryContactModel.RoleIds);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertClientSecondaryContact, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();

                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertClientSecondaryContact", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertClientSecondaryContact);
                return null;
            }
        }

        public List<ClientSecondaryContactOutputModel> GetClientSecondaryContacts(ClientSecondaryContactsInputModel clientSecondaryContactsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ClientSecondaryContactId", clientSecondaryContactsInputModel.ClientSecondaryContactId);
                    vParams.Add("@ClientId", clientSecondaryContactsInputModel.ClientId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ClientSecondaryContactOutputModel>(StoredProcedureConstants.SpGetClientSecondaryContacts, vParams, commandType: CommandType.StoredProcedure).ToList();

                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetClientSecondaryContacts", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetClients);
                return new List<ClientSecondaryContactOutputModel>();
            }

        }

        public List<Guid?> MultipleClientDelete(MultipleClientDeleteModel multipleClientDeleteModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@ClientId", multipleClientDeleteModel.ClientIdXml);
                    vParams.Add("@IsArchived", multipleClientDeleteModel.IsArchived);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpMultipleClientDelete, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "MultipleClientDelete", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionMultipleClientDelete);
                return null;
            }
        }

        public List<ClientHistoryModel> GetClientHistory(ClientHistoryModel clientHistoryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ClientHistoryId", clientHistoryModel.ClientHistoryId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ClientHistoryModel>(StoredProcedureConstants.SpGetClientHistory, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetClientHistory", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetClientHistory);
                return new List<ClientHistoryModel>();
            }
        }

        public Guid? UpsertClientProjects(UpsertClientProjectsModel upsertClientProjectsModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ClientProjectId", upsertClientProjectsModel.ClientProjectId);
                    vParams.Add("@ClientId", upsertClientProjectsModel.ClientId);
                    vParams.Add("@ProjectId", upsertClientProjectsModel.ProjectId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@TimeStamp", upsertClientProjectsModel.TimeStamp, DbType.Binary);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertClientProjects, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();

                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertClientProjects", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertClientProjects);
                return null;
            }
        }

        public List<ClientProjectsOutputModel> GetClientProjects(ClientProjectsInputModel clientProjectsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ClientProjectId", clientProjectsInputModel.ClientProjectId);
                    vParams.Add("@ClientId", clientProjectsInputModel.ClientId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsArchived", clientProjectsInputModel.IsArchived);
                    return vConn.Query<ClientProjectsOutputModel>(StoredProcedureConstants.SpGetClientProjects, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetClientProjects", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetClientProjects);
                return new List<ClientProjectsOutputModel>();
            }
        }
        public List<ClientTypeOutputModel> GetClientTypesBasedOnRoles(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ClientTypeOutputModel>(StoredProcedureConstants.SpGetClientTypesBasedOnRoles, vParams, commandType: CommandType.StoredProcedure).ToList();

                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetClientTypesBasedOnRoles", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetClientTypes);
                return new List<ClientTypeOutputModel>();
            }
        }

        public List<ClientTypeOutputModel> GetClientTypes(ClientInputModel clientInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ClientId", clientInputModel.ClientId);
                    vParams.Add("@SearchText", clientInputModel.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsArchived", clientInputModel.IsArchived);
                    vParams.Add("@PageNumber", clientInputModel.PageNumber);
                    vParams.Add("@PageSize", clientInputModel.PageSize);
                    vParams.Add("@SortBy", clientInputModel.SortBy);
                    vParams.Add("@SortDirection", clientInputModel.SortDirection);
                    return vConn.Query<ClientTypeOutputModel>(StoredProcedureConstants.SpGetClientTypes, vParams, commandType: CommandType.StoredProcedure).ToList();

                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetClients", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetClientTypes);
                return new List<ClientTypeOutputModel>();
            }
        }
        public Guid? UpsertClientType(ClientTypeUpsertInputModel clientTypeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ClientTypeId", clientTypeUpsertInputModel.ClientTypeId);
                    vParams.Add("@ClientTypeName", clientTypeUpsertInputModel.ClientTypeName);
                    vParams.Add("@ClientTypeRoles", clientTypeUpsertInputModel.RoleIds);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsArchived", clientTypeUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", clientTypeUpsertInputModel.TimeStamp, DbType.Binary);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertClientType, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();

                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertClientType", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertClientTypes);
                return null;
            }

        }
        public Guid? ReOrderClientTypes(ClientTypeUpsertInputModel clientTypeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@clientTypeIdsXml", clientTypeUpsertInputModel.clientTypeIdsXml);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpReOrderClientTypes, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ReOrderWorkflowStatuses", "UserStoryRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionReOrderClientTypes);
                return null;
            }
        }

        public List<ShipToAddressSearchOutputModel> GetShipToAddresses(ShipToAddressSearchInputModel shipToAddressSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@AddressId", shipToAddressSearchInputModel.AddressId);
                    vParams.Add("@ClientId", shipToAddressSearchInputModel.ClientId);
                    vParams.Add("@IsShiptoAddress", shipToAddressSearchInputModel.IsShiptoAddress);
                    vParams.Add("@IsVerified", shipToAddressSearchInputModel.IsVerified);
                    vParams.Add("@SearchText", shipToAddressSearchInputModel.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsArchived", shipToAddressSearchInputModel.IsArchived);
                    vParams.Add("@PageNo", shipToAddressSearchInputModel.PageNumber);
                    vParams.Add("@PageSize", shipToAddressSearchInputModel.PageSize);
                    vParams.Add("@SortBy", shipToAddressSearchInputModel.SortBy);
                    vParams.Add("@SortDirection", shipToAddressSearchInputModel.SortDirection);
                    return vConn.Query<ShipToAddressSearchOutputModel>(StoredProcedureConstants.SpGetShipToAddresses, vParams, commandType: CommandType.StoredProcedure).ToList();

                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetShipToAddresses", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetShipToAddresses);
                return new List<ShipToAddressSearchOutputModel>();
            }
        }
        public Guid? UpsertShipToAddress(ShipToAddressUpsertInputModel shipToAddressUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@AddressId", shipToAddressUpsertInputModel.AddressId);
                    vParams.Add("@ClientId", shipToAddressUpsertInputModel.ClientId);
                    vParams.Add("@AddressName", shipToAddressUpsertInputModel.AddressName);
                    vParams.Add("@Description", shipToAddressUpsertInputModel.Description);
                    vParams.Add("@Comments", shipToAddressUpsertInputModel.Comments);
                    vParams.Add("@IsVerified", shipToAddressUpsertInputModel.IsVerified);
                    vParams.Add("@IsShiptoAddress", shipToAddressUpsertInputModel.IsShiptoAddress);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsArchived", shipToAddressUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", shipToAddressUpsertInputModel.TimeStamp, DbType.Binary);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertShipToAddress, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();

                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertShipToAddress", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertShipToAddress);
                return null;
            }

        }

        public Guid? UpsertClientKycConfiguration(ClientKycConfiguration kycConfiguration, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ConfigurationId", kycConfiguration.ClientKycId);
                    vParams.Add("@ClientTypeId", kycConfiguration.ClientTypeId);
                    vParams.Add("@LegalEntityTypeId", kycConfiguration.LegalEntityTypeId);
                    vParams.Add("@ConfigurationName", kycConfiguration.ClientKycName);
                    vParams.Add("@SelectedRoles", kycConfiguration.SelectedRoles);
                    //vParams.Add("@SelectedLegalEntities", kycConfiguration.SelectedLegalEntites);
                    vParams.Add("@FormJson", kycConfiguration.FormJson);
                    vParams.Add("@IsDraft", kycConfiguration.IsDraft);
                    vParams.Add("@TimeStamp", kycConfiguration.TimeStamp, DbType.Binary);
                    vParams.Add("@FormBgColor", kycConfiguration.FormBgColor);
                    vParams.Add("@IsArchived", kycConfiguration.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertClientKycConfiguration, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertClientKycConfiguration", "kycRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertPerformanceConfiguration);
                return null;
            }
        }

        public Guid? UpsertClientKycForm(ClientKycConfiguration kycConfiguration, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ConfigurationId", kycConfiguration.ClientKycId);
                    vParams.Add("@ClientId", kycConfiguration.ClientId);
                    vParams.Add("@FormJson", kycConfiguration.FormJson);
                    vParams.Add("@FormData", kycConfiguration.FormData);
                    vParams.Add("@IsArchived", kycConfiguration.IsArchived);
                    vParams.Add("@IsSubmitted", kycConfiguration.IsSubmitted);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertClientKycForm, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertClientKycConfiguration", "kycRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertPerformanceConfiguration);
                return null;
            }
        }

        public List<ClientKycConfigurationOutputModel> GetClientKycConfiguration(ClientKycConfiguration kycConfiguration, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@IsArchived", kycConfiguration.IsArchived);
                    vParams.Add("@IsDraft", kycConfiguration.IsDraft);
                    vParams.Add("@ConsiderRole", kycConfiguration.ConsiderRole);
                    vParams.Add("@OfUserId", kycConfiguration.OfUserId);
                    vParams.Add("@ClientTypeId", kycConfiguration.ClientTypeId);
                    vParams.Add("@LegalEntityTypeId", kycConfiguration.LegalEntityTypeId);
                    vParams.Add("@RoleId", kycConfiguration.RoleId);
                    vParams.Add("@ClientKycId", kycConfiguration.ClientKycId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ClientKycConfigurationOutputModel>(StoredProcedureConstants.SpGetClientKycConfiguration, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetClientKycConfiguration", "kycRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetPerformanceConfigurations);
                return new List<ClientKycConfigurationOutputModel>();
            }
        }
        public List<PurchaseConfigOutputModel> GetPurchaseConfiguration(PurchaseConfigInputModel kycConfiguration, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@IsArchived", kycConfiguration.IsArchived);
                    vParams.Add("@IsDraft", kycConfiguration.IsDraft);
                    vParams.Add("@ConsiderRole", kycConfiguration.ConsiderRole);
                    vParams.Add("@OfUserId", kycConfiguration.OfUserId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<PurchaseConfigOutputModel>(StoredProcedureConstants.SpGetPurchaseConfiguration, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPurchaseConfiguration", "kycRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetPerformanceConfigurations);
                return new List<PurchaseConfigOutputModel>();
            }
        }
        public Guid? UpsertPurchaseConfiguration(PurchaseConfigInputModel kycConfiguration, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ConfigurationId", kycConfiguration.PurchaseId);
                    vParams.Add("@ConfigurationName", kycConfiguration.PurchaseName);
                    vParams.Add("@SelectedRoles", kycConfiguration.SelectedRoles);
                    vParams.Add("@FormJson", kycConfiguration.FormJson);
                    vParams.Add("@IsDraft", kycConfiguration.IsDraft);
                    vParams.Add("@TimeStamp", kycConfiguration.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", kycConfiguration.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertPurchaseConfiguration, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertClientKycConfiguration", "kycRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertPerformanceConfiguration);
                return null;
            }
        }

        public List<ContractSubmissionDetails> GetContractSubmissions(ContractSubmissionDetails clientInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@SearchText", clientInputModel.SearchText);
                    return vConn.Query<ContractSubmissionDetails>(StoredProcedureConstants.SpGetContractSubmission, vParams, commandType: CommandType.StoredProcedure).ToList();

                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetContractSubmissions", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetClients);
                return new List<ContractSubmissionDetails>();
            }

        }



        public List<SCOGenerationsOutputModel> GetSCOGenerations(SCOGenerationSerachInputModel sCOGenerationSerachInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsArchived", sCOGenerationSerachInputModel.IsArchived);
                    vParams.Add("@IsScoAccepted", sCOGenerationSerachInputModel.IsScoAccepted);
                    vParams.Add("@Id", sCOGenerationSerachInputModel.Id);
                    vParams.Add("@LeadSubmissionId", sCOGenerationSerachInputModel.LeadSubmissionId);
                    return vConn.Query<SCOGenerationsOutputModel>(StoredProcedureConstants.SpGetSCOGenerations, vParams, commandType: CommandType.StoredProcedure).ToList();

                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetSCOGenerations", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetSCOException);
                return new List<SCOGenerationsOutputModel>();
            }
        }        
        
        public List<SCOGenerationsOutputModel> GetScoGenerationById(SCOGenerationSerachInputModel sCOGenerationSerachInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@LeadSubmissionId", sCOGenerationSerachInputModel.LeadSubmissionId);
                    vParams.Add("@ScoId", sCOGenerationSerachInputModel.ScoId);
                    return vConn.Query<SCOGenerationsOutputModel>(StoredProcedureConstants.SpGetSCOGenerationsById, vParams, commandType: CommandType.StoredProcedure).ToList();

                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetSCOGenerations", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetSCOException);
                return new List<SCOGenerationsOutputModel>();
            }
        }
        public Guid? UpsertSCOGeneration(SCOUpsertInputModel sCOUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Id", sCOUpsertInputModel.Id);
                    vParams.Add("@ClientId", sCOUpsertInputModel.ClientId);
                    vParams.Add("@Comments", sCOUpsertInputModel.Comments);
                    vParams.Add("@LeadSubmissionId", sCOUpsertInputModel.LeadSubmissionId);
                    vParams.Add("@IsScoAccepted", sCOUpsertInputModel.IsScoAccepted);
                    vParams.Add("@TimeStamp", sCOUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", sCOUpsertInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@CreditsAllocated", sCOUpsertInputModel.CreditsAllocated);
                    vParams.Add("@IsForPdfs", sCOUpsertInputModel.IsForPdfs);
                    vParams.Add("@ScoPdf", sCOUpsertInputModel.ScoPdf);
                    vParams.Add("@PerformaPdf", sCOUpsertInputModel.PerformaPdf);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertSCOGenerations, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertSCOGeneration", "kycRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.UpsertSCOException);
                return null;
            }
        }

        public Guid? UpsertProductList(MasterProduct masterProductModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ProductId", masterProductModel.ProductId);
                    vParams.Add("@ProductName", masterProductModel.ProductName);
                    vParams.Add("@TimeStamp", masterProductModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", masterProductModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertProductList, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertClientKycConfiguration", "kycRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertPerformanceConfiguration);
                return null;
            }
        }

        public Guid? UpsertMasterContractDetails(MasterContractInputModel masterProductModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ContractId", masterProductModel.ContractId);
                    vParams.Add("@ContractName", masterProductModel.ContractName);
                    vParams.Add("@RateOrTon", masterProductModel.RateOrTon);
                    vParams.Add("@GradeId", masterProductModel.GradeId);
                    vParams.Add("@ProductId", masterProductModel.ProductId);
                    vParams.Add("@ContractQuantity", masterProductModel.ContractQuantity);
                    vParams.Add("@RemaningQuantity", masterProductModel.RemaningQuantity);
                    vParams.Add("@UsedQuantity", masterProductModel.UsedQuantity);
                    vParams.Add("@ContractUniqueName", masterProductModel.ContractUniqueName);
                    vParams.Add("@ContractDocument", masterProductModel.ContractDocument);
                    vParams.Add("@ContractDateFrom", masterProductModel.ContractDateFrom);
                    vParams.Add("@ContractDateTo", masterProductModel.ContractDateTo);
                    vParams.Add("@ClientId", masterProductModel.ClientId);
                    vParams.Add("@TimeStamp", masterProductModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", masterProductModel.IsArchived);
                    vParams.Add("@ContractNumber", masterProductModel.ContractNumber);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertMasterContractDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertClientKycConfiguration", "kycRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertPerformanceConfiguration);
                return null;
            }
        }

        public List<ProductListOutPutModel> GetProductsList(MasterProduct masterProductModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ProductId", masterProductModel.ProductId);
                    vParams.Add("@ProductName", masterProductModel.ProductName);
                    vParams.Add("@SearchText", masterProductModel.SearchText);
                    vParams.Add("@IsArchived", masterProductModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ProductListOutPutModel>(StoredProcedureConstants.SpGetProductList, vParams, commandType: CommandType.StoredProcedure).ToList();

                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ProductList", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetSCOException);
                return new List<ProductListOutPutModel>();
            }
        }

        public List<MasterContractOutputModel> GetMasterContractDetails(MasterContractInputModel clientInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@SearchText", clientInputModel.SearchText);
                    //vParams.Add("@ContractUniqueName", clientInputModel.ContractUniqueName);
                    vParams.Add("@ClientId", clientInputModel.ClientId);
                    vParams.Add("@IsArchived", clientInputModel.IsArchived);
                    vParams.Add("@PageNo", clientInputModel.PageNumber);
                    vParams.Add("@PageSize", clientInputModel.PageSize);
                    vParams.Add("@SortBy", clientInputModel.SortBy);
                    vParams.Add("@SortDirection", clientInputModel.SortDirection);
                    return vConn.Query<MasterContractOutputModel>(StoredProcedureConstants.SpGetMasterContractDetails, vParams, commandType: CommandType.StoredProcedure).ToList();

                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetContractSubmissions", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetClients);
                return new List<MasterContractOutputModel>();
            }

        }
        public Guid? UpsertGrades(GradeInputModel gradeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@GradeId", gradeInputModel.GradeId);
                    vParams.Add("@GstCode", gradeInputModel.GstCode);
                    vParams.Add("@ProductId", gradeInputModel.ProductId);
                    vParams.Add("@GradeName", gradeInputModel.GradeName);
                    vParams.Add("@IsArchived", gradeInputModel.IsArchived);
                    vParams.Add("@TimeStamp", gradeInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertGrades, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertGrade", "EmployeeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertGrade);
                return null;
            }
        }

        public List<GradeOutputModel> GetAllGrades(GradeInputModel gradeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@GradeId", gradeInputModel.GradeId);
                    vParams.Add("@IsArchived", gradeInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<GradeOutputModel>(StoredProcedureConstants.SpGetAllGrades, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetGrades", "EmployeeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetGrades);
                return new List<GradeOutputModel>();
            }
        }
        
        public List<CreditLimitLogsModel> GetAllCreditLogs(CreditLimitLogsModel creditLimitLogsModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@IsArchived", creditLimitLogsModel.IsArchived);
                    vParams.Add("@ClientId", creditLimitLogsModel.ClientId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<CreditLimitLogsModel>(StoredProcedureConstants.SpGetAllCreditLogs, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetGrades", "EmployeeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetGrades);
                return new List<CreditLimitLogsModel>();
            }
        }

        public List<UserDbEntity> GetWareHoseUsers(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<UserDbEntity>(StoredProcedureConstants.SpGetWareHouseUsers, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetWareHoseUsers", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetGrades);
                return new List<UserDbEntity>();
            }
        }
        public Guid? UpsertPurchaseContract(MasterContractInputModel masterProductModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ContractId", masterProductModel.ContractId);
                    vParams.Add("@ClientId", masterProductModel.ClientId);
                    vParams.Add("@Price", masterProductModel.RateOrTon);
                    vParams.Add("@GradeId", masterProductModel.GradeId);
                    vParams.Add("@ProductId", masterProductModel.ProductId);
                    vParams.Add("@TotalQuantity", masterProductModel.ContractQuantity);
                    vParams.Add("@RemaningQuantity", masterProductModel.RemaningQuantity);
                    vParams.Add("@UsedQuantity", masterProductModel.UsedQuantity);
                    vParams.Add("@ContractDocument", masterProductModel.ContractDocument);
                    vParams.Add("@StartDate", masterProductModel.ContractDateFrom);
                    vParams.Add("@EndDate", masterProductModel.ContractDateTo);
                    vParams.Add("@TimeStamp", masterProductModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", masterProductModel.IsArchived);
                    vParams.Add("@ContractNumber", masterProductModel.ContractNumber);
                    vParams.Add("@Description", masterProductModel.Description);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertPurchaseContract, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPurchaseContract", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertPerformanceConfiguration);
                return null;
            }
        }
        public List<MasterContractOutputModel> GetPurchaseContract(MasterContractInputModel clientInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@SearchText", clientInputModel.SearchText);
                    vParams.Add("@ClientId", clientInputModel.ClientId);
                    vParams.Add("@ContractId", clientInputModel.ContractId);
                    vParams.Add("@IsArchived", clientInputModel.IsArchived);
                    vParams.Add("@PageNo", clientInputModel.PageNumber);
                    vParams.Add("@PageSize", clientInputModel.PageSize);
                    vParams.Add("@SortBy", clientInputModel.SortBy);
                    vParams.Add("@SortDirection", clientInputModel.SortDirection);
                    return vConn.Query<MasterContractOutputModel>(StoredProcedureConstants.SpGetPurchaseContract, vParams, commandType: CommandType.StoredProcedure).ToList();

                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPurchaseContract", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetClients);
                return new List<MasterContractOutputModel>();
            }
        }

        public Guid? UpsertShipmentExecutions(PurchaseShipmentExecutionInputModel purchaseShipmentExecutionInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@PurchaseShipmentId", purchaseShipmentExecutionInputModel.PurchaseShipmentId);
                    vParams.Add("@ContractId", purchaseShipmentExecutionInputModel.ContractId);
                    vParams.Add("@ShipmentNumber", purchaseShipmentExecutionInputModel.ShipmentNumber);
                    vParams.Add("@ShipmentQuantity", purchaseShipmentExecutionInputModel.ShipmentQuantity);
                    vParams.Add("@BLQuantity", purchaseShipmentExecutionInputModel.BLQuantity);
                    vParams.Add("@VesselId", purchaseShipmentExecutionInputModel.VesselId);
                    vParams.Add("@PortLoadId", purchaseShipmentExecutionInputModel.PortLoadId);
                    vParams.Add("@PortDischargeId", purchaseShipmentExecutionInputModel.PortDischargeId);
                    vParams.Add("@WorkEmployeeId", purchaseShipmentExecutionInputModel.WorkEmployeeId);
                    vParams.Add("@ETADate", purchaseShipmentExecutionInputModel.ETADate);
                    vParams.Add("@FillDueDate", purchaseShipmentExecutionInputModel.FillDueDate);
                    vParams.Add("@VoyageNumber", purchaseShipmentExecutionInputModel.VoyageNumber);
                    vParams.Add("@TimeStamp", purchaseShipmentExecutionInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", purchaseShipmentExecutionInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertPurchaseShipmentExecution, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertShipmentExecutions", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertPerformanceConfiguration);
                return null;
            }
        }
        public List<PurchaseShipmentExecutionSearchOutputModel> GetShipmentExecutions(PurchaseShipmentExecutionSearchInputModel purchaseShipmentExecutionSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@SearchText", purchaseShipmentExecutionSearchInputModel.SearchText);
                    vParams.Add("@PurchaseShipmentId", purchaseShipmentExecutionSearchInputModel.PurchaseShipmentId);
                    vParams.Add("@IsArchived", purchaseShipmentExecutionSearchInputModel.IsArchived);
                    vParams.Add("@PageNo", purchaseShipmentExecutionSearchInputModel.PageNumber);
                    vParams.Add("@PageSize", purchaseShipmentExecutionSearchInputModel.PageSize);
                    vParams.Add("@SortBy", purchaseShipmentExecutionSearchInputModel.SortBy);
                    vParams.Add("@SortDirection", purchaseShipmentExecutionSearchInputModel.SortDirection);
                    return vConn.Query<PurchaseShipmentExecutionSearchOutputModel>(StoredProcedureConstants.SpGetPurchaseShipmentExecutions, vParams, commandType: CommandType.StoredProcedure).ToList();

                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetShipmentExecutions", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetClients);
                return new List<PurchaseShipmentExecutionSearchOutputModel>();
            }
        }
        public Guid? UpsertShipmentExecutionBL(PurchaseShipmentExecutionBLInputModel purchaseShipmentExecutionBLInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@BLDate", purchaseShipmentExecutionBLInputModel.BLDate);
                    vParams.Add("@BLNumber", purchaseShipmentExecutionBLInputModel.BLNumber);
                    vParams.Add("@BLQuantity", purchaseShipmentExecutionBLInputModel.BLQuantity);
                    vParams.Add("@ChaId", purchaseShipmentExecutionBLInputModel.ChaId);
                    vParams.Add("@ConsignerId", purchaseShipmentExecutionBLInputModel.ConsignerId);
                    vParams.Add("@ConsigneeId", purchaseShipmentExecutionBLInputModel.ConsigneeId);
                    vParams.Add("@NotifyParty", purchaseShipmentExecutionBLInputModel.NotifyParty);
                    vParams.Add("@PackingDetails", purchaseShipmentExecutionBLInputModel.PackingDetails);
                    vParams.Add("@IsDocumentsSent", purchaseShipmentExecutionBLInputModel.IsDocumentsSent);
                    vParams.Add("@SentDate", purchaseShipmentExecutionBLInputModel.SentDate);
                    vParams.Add("@DraftEntryDate", purchaseShipmentExecutionBLInputModel.DraftEntryDate);
                    vParams.Add("@DraftBLNumber", purchaseShipmentExecutionBLInputModel.DraftBLNumber);
                    vParams.Add("@DraftBLDescription", purchaseShipmentExecutionBLInputModel.DraftBLDescription);
                    vParams.Add("@DraftBasicCustomsDuty", purchaseShipmentExecutionBLInputModel.DraftBasicCustomsDuty);
                    vParams.Add("@DraftSWC", purchaseShipmentExecutionBLInputModel.DraftSWC);
                    vParams.Add("@DraftIGST", purchaseShipmentExecutionBLInputModel.DraftIGST);
                    vParams.Add("@DraftEduCess", purchaseShipmentExecutionBLInputModel.DraftEduCess);
                    vParams.Add("@DraftOthers", purchaseShipmentExecutionBLInputModel.DraftOthers);
                    vParams.Add("@ConfoEntryDate", purchaseShipmentExecutionBLInputModel.ConfoEntryDate);
                    vParams.Add("@ConfoBLNumber", purchaseShipmentExecutionBLInputModel.ConfoBLNumber);
                    vParams.Add("@ConfoBLDescription", purchaseShipmentExecutionBLInputModel.ConfoBLDescription);
                    vParams.Add("@ConfoBasicCustomsDuty", purchaseShipmentExecutionBLInputModel.ConfoBasicCustomsDuty);
                    vParams.Add("@ConfoSWC", purchaseShipmentExecutionBLInputModel.ConfoSWC);
                    vParams.Add("@ConfoIGST", purchaseShipmentExecutionBLInputModel.ConfoIGST);
                    vParams.Add("@ConfoEduCess", purchaseShipmentExecutionBLInputModel.ConfoEduCess);
                    vParams.Add("@ConfoOthers", purchaseShipmentExecutionBLInputModel.ConfoOthers);
                    vParams.Add("@IsConfirmedBill", purchaseShipmentExecutionBLInputModel.IsConfirmedBill);
                    vParams.Add("@ConfirmationDate", purchaseShipmentExecutionBLInputModel.ConfirmationDate);
                    vParams.Add("@ConfoIsPaymentDone", purchaseShipmentExecutionBLInputModel.ConfoIsPaymentDone);
                    vParams.Add("@ConfoPaymentDate", purchaseShipmentExecutionBLInputModel.ConfoPaymentDate);
                    vParams.Add("@ShipmentBLId", purchaseShipmentExecutionBLInputModel.ShipmentBLId);
                    vParams.Add("@PurchaseExecutionId", purchaseShipmentExecutionBLInputModel.PurchaseExecutionId);
                    vParams.Add("@TimeStamp", purchaseShipmentExecutionBLInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", purchaseShipmentExecutionBLInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertShipmentExecutionBL, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertShipmentExecutionBL", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertPerformanceConfiguration);
                return null;
            }
        }
        public Guid? UpsertBlDescription(PurchaseShipmentExecutionBLInputModel purchaseShipmentExecutionBLInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ShipmentBLId", purchaseShipmentExecutionBLInputModel.ShipmentBLId);
                    vParams.Add("@PurchaseExecutionId", purchaseShipmentExecutionBLInputModel.PurchaseExecutionId);
                    vParams.Add("@InitialDescriptionsXml", purchaseShipmentExecutionBLInputModel.InitialDocumentsDescriptionsXml);
                    vParams.Add("@FinalDescriptionsXml", purchaseShipmentExecutionBLInputModel.FinalDocumentsDescriptionsXml);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertBlDescription, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertBlDescription", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertPerformanceConfiguration);
                return null;
            }
        }
        public PurchaseShipmentExecutionBLSearchOutputModel GetBlDescriptions(PurchaseShipmentExecutionSearchInputModel purchaseShipmentExecutionSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@PurchaseShipmentBLId", purchaseShipmentExecutionSearchInputModel.PurchaseShipmentBLId);
                    return vConn.Query<PurchaseShipmentExecutionBLSearchOutputModel>(StoredProcedureConstants.SpGetBlDescriptions, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();

                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetBlDescriptions", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetClients);
                return new PurchaseShipmentExecutionBLSearchOutputModel();
            }
        }
        public Guid? UpsertDocumentsDescription(PurchaseShipmentExecutionBLInputModel purchaseShipmentExecutionBLInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ReferenceTypeId", purchaseShipmentExecutionBLInputModel.ShipmentBLId);
                    vParams.Add("@DescriptionsXml", purchaseShipmentExecutionBLInputModel.InitialDocumentsDescriptionsXml);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertDocumentsDescriptions, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertDocumentsDescription", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertPerformanceConfiguration);
                return null;
            }
        }
        public PurchaseShipmentExecutionBLSearchOutputModel GetDocumentsDescriptions(Guid referenceTypeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@ReferenceTypeId", referenceTypeId);
                    return vConn.Query<PurchaseShipmentExecutionBLSearchOutputModel>(StoredProcedureConstants.SpGetDocumentsDescriptions, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();

                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDocumentsDescriptions", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetClients);
                return new PurchaseShipmentExecutionBLSearchOutputModel();
            }
        }
        public List<PurchaseShipmentExecutionBLSearchOutputModel> GetShipmentExecutionBLs(PurchaseShipmentExecutionSearchInputModel purchaseShipmentExecutionSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@SearchText", purchaseShipmentExecutionSearchInputModel.SearchText);
                    vParams.Add("@PurchaseShipmentId", purchaseShipmentExecutionSearchInputModel.PurchaseShipmentId);
                    vParams.Add("@IsArchived", purchaseShipmentExecutionSearchInputModel.IsArchived);
                    return vConn.Query<PurchaseShipmentExecutionBLSearchOutputModel>(StoredProcedureConstants.SpGetPurchaseShipmentExecutionBLs, vParams, commandType: CommandType.StoredProcedure).ToList();

                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetShipmentExecutionBLs", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetClients);
                return new List<PurchaseShipmentExecutionBLSearchOutputModel>();
            }
        }

        public Guid? UpsertVessels(VesselModel vesselModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@VesselId", vesselModel.VesselId);
                    vParams.Add("@VesselName", vesselModel.VesselName);
                    vParams.Add("@IsArchived", vesselModel.IsArchived);
                    vParams.Add("@TimeStamp", vesselModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertVessel, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertGrade", "EmployeeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertGrade);
                return null;
            }
        }

        public List<VesselModel> GetAllVessels(VesselModel vesselModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@VesselId", vesselModel.VesselId);
                    vParams.Add("@IsArchived", vesselModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<VesselModel>(StoredProcedureConstants.SpGetAllVessels, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetGrades", "EmployeeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetGrades);
                return new List<VesselModel>();
            }
        }
            public PurchaseShipmentExecutionBLSearchOutputModel GetShipmentExecutionBLById(PurchaseShipmentExecutionSearchInputModel purchaseShipmentExecutionSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
            {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@PurchaseShipmentBLId", purchaseShipmentExecutionSearchInputModel.PurchaseShipmentBLId);
                    return vConn.Query<PurchaseShipmentExecutionBLSearchOutputModel>(StoredProcedureConstants.SpGetPurchaseShipmentExecutionBLById, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();

                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetShipmentExecutionBLById", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetClients);
                return new PurchaseShipmentExecutionBLSearchOutputModel();
            }
        }

        public Guid? UpsertLegalEntity(LegalEntityModel legalEntityModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)

        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@LegalEntityId", legalEntityModel.LegalEntityId);
                    vParams.Add("@LegalEntityName", legalEntityModel.LegalEntityName);
                    vParams.Add("@IsArchived", legalEntityModel.IsArchived);
                    vParams.Add("@TimeStamp", legalEntityModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertLegalEntity, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertLegalEntity", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.UpsertLegalEntityEception);
                return null;
            }
        }


        public List<LegalEntityModel> GetAllLegalEntities(LegalEntityModel legalEntityModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@LegalEntityId", legalEntityModel.LegalEntityId);
                    vParams.Add("@IsArchived", legalEntityModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<LegalEntityModel>(StoredProcedureConstants.SpGetAllLegalEntities, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllLegalEntities", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetLegalEntityException);
                return new List<LegalEntityModel>();
            }
        }

        public List<ClientOutputModel> GetClientKycDetails(ClientInputModel clientInputModel, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ClientId", clientInputModel.ClientId);
                    return vConn.Query<ClientOutputModel>(StoredProcedureConstants.SpGetClientKycDetails, vParams, commandType: CommandType.StoredProcedure).ToList();

                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetClientKycDetails", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetClientKycException);
                return new List<ClientOutputModel>();
            }
        }

        public Guid? UpsertKycDetails(ClientKycSubmissionDetails ClientKycSubmissionDetails, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)

        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@ClientId", ClientKycSubmissionDetails.ClientId);
                    vParams.Add("@FormJson", ClientKycSubmissionDetails.FormJson);
                    vParams.Add("@FormData", ClientKycSubmissionDetails.FormData);
                    vParams.Add("@CompanyId", ClientKycSubmissionDetails.CompanyId);
                    vParams.Add("@TimeStamp", ClientKycSubmissionDetails.TimeStamp, DbType.Binary);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpdateClientKycDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertKycDetails", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.UpsertLegalEntityEception);
                return null;
            }
        }

        public Guid? UpsertCounterPartySettings(CounterPartySettingsModel CounterPartySettingsModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)

        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@CounterPartySettingsId", CounterPartySettingsModel.CounterPartySettingsId);
                    vParams.Add("@Key", CounterPartySettingsModel.Key);
                    vParams.Add("@Value", CounterPartySettingsModel.Value);
                    vParams.Add("@Description", CounterPartySettingsModel.Description);
                    vParams.Add("@IsArchived", CounterPartySettingsModel.IsArchived);
                    vParams.Add("@ClientId", CounterPartySettingsModel.ClientId);
                    vParams.Add("@TimeStamp", CounterPartySettingsModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsVisible", CounterPartySettingsModel.IsVisible);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertCounterPartySettings, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCounterPartySettings", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.UpsertCompanySettingsException);
                return null;
            }
        }

        public List<CounterPartySettingsModel> GetCounterPartySettings(CounterPartySettingsModel CounterPartySettingsModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CounterPartySettingsId", CounterPartySettingsModel.CounterPartySettingsId);
                    vParams.Add("@ClientId", CounterPartySettingsModel.ClientId);
                    vParams.Add("@Key", CounterPartySettingsModel.Key);
                    vParams.Add("@Description", CounterPartySettingsModel.Description);
                    vParams.Add("@Value", CounterPartySettingsModel.Value);
                    vParams.Add("@SearchText", CounterPartySettingsModel.SearchText);
                    vParams.Add("@IsArchived", CounterPartySettingsModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext?.LoggedInUserId);
                    return vConn.Query<CounterPartySettingsModel>(StoredProcedureConstants.SpGetCounterPartySettings, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCounterPartySettings", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetClientSettingsException);
                return new List<CounterPartySettingsModel>();
            }
        }


        public Guid? UpsertKycStatus(KycFormStatusModel KycFormStatusModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)

        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@KycStatusId", KycFormStatusModel.KycStatusId);
                    vParams.Add("@KycStatusName", KycFormStatusModel.KycStatusName);
                    vParams.Add("@StatusName", KycFormStatusModel.StatusName);
                    vParams.Add("@KycStatusColor", KycFormStatusModel.KycStatusColor);
                    vParams.Add("@IsArchived", KycFormStatusModel.IsArchived);
                    vParams.Add("@TimeStamp", KycFormStatusModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertKycStatus, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertKycStatus", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.UpsertKycStatusException);
                return null;
            }
        }


        public List<KycFormStatusModel> GetAllkycStatus(KycFormStatusModel KycFormStatusModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@KycStatusId", KycFormStatusModel.KycStatusId);
                    vParams.Add("@IsArchived", KycFormStatusModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<KycFormStatusModel>(StoredProcedureConstants.SpGetAllKycStatus, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllkycStatus", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetKycStatusException);
                return new List<KycFormStatusModel>();
            }
        }

        public List<KycFormHistoryModel> GetClientKycHistory(KycFormHistoryModel KycFormHistoryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@IsArchived", KycFormHistoryModel.IsArchived);
                    vParams.Add("@ClientId", KycFormHistoryModel.ClientId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<KycFormHistoryModel>(StoredProcedureConstants.SpGetKycHistory, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetClientKycHistory", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetGrades);
                return new List<KycFormHistoryModel>();
            }
        }

        public Guid? UpsertTemplateConfiguration(TemplateConfigurationModel TemplateConfigurationModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)

        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TemplateConfigurationId", TemplateConfigurationModel.TemplateConfigurationId);
                    vParams.Add("@TemplateConfigurationName", TemplateConfigurationModel.TemplateConfigurationName);
                    vParams.Add("@TemplateConfiguration", TemplateConfigurationModel.TemplateConfiguration);
                    vParams.Add("@ContractTypeId", TemplateConfigurationModel.ContractTypeIds);
                    vParams.Add("@IsArchived", TemplateConfigurationModel.IsArchived);
                    vParams.Add("@TimeStamp", TemplateConfigurationModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertTemplateConfiguration, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTemplateConfiguration", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.UpsertTemplateConfigurationException);
                return null;
            }
        }


        public List<TemplateConfigurationModel> GetAllTemplateConfigurations(TemplateConfigurationModel TemplateConfigurationModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TemplateConfigurationId", TemplateConfigurationModel.TemplateConfigurationId);
                    vParams.Add("@IsArchived", TemplateConfigurationModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<TemplateConfigurationModel>(StoredProcedureConstants.SpGetAllTemplateConfiguration, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllTemplateConfigurations", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetTemplateConfigurationException);
                return new List<TemplateConfigurationModel>();
            }
        }

        public Guid? UpsertEmailTemplate(EmailTemplateModel EmailTemplateModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)

        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@EmailTemplateId", EmailTemplateModel.EmailTemplateId);
                    vParams.Add("@EmailTemplateName", EmailTemplateModel.EmailTemplateName);
                    vParams.Add("@EmailTemplate", EmailTemplateModel.EmailTemplate);
                    vParams.Add("@EmailSubject", EmailTemplateModel.EmailSubject);
                    vParams.Add("@ClientId", EmailTemplateModel.ClientId);
                    vParams.Add("@IsArchived", EmailTemplateModel.IsArchived);
                    vParams.Add("@TimeStamp", EmailTemplateModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertEmailTemplate, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmailTemplate", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.UpsertTemplateConfigurationException);
                return null;
            }
        }

        public List<EmailTemplateModel> GetAllEmailTemplates(EmailTemplateModel EmailTemplateModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@EmailTemplateId", EmailTemplateModel.EmailTemplateId);
                    vParams.Add("@EmailTemplateName", EmailTemplateModel.EmailTemplateName);
                    vParams.Add("@ClientId", EmailTemplateModel.ClientId);
                    vParams.Add("@IsArchived", EmailTemplateModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmailTemplateModel>(StoredProcedureConstants.SpGetEmailTemplate, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllEmailTemplates", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetTemplateConfigurationException);
                return new List<EmailTemplateModel>();
            }
        }        
        
        public List<EmailTemplateModel> GetHtmlTagsById(EmailTemplateModel EmailTemplateModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@EmailTemplateReferenceId", EmailTemplateModel.EmailTemplateReferenceId);
                    vParams.Add("@IsArchived", EmailTemplateModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmailTemplateModel>(StoredProcedureConstants.SpGetHtmlTagsById, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetHtmlTagsById", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetHtmlTagsException);
                return new List<EmailTemplateModel>();
            }
        }

        public Guid? UpsertContractStatus(ContractStatusModel ContractStatusModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)

        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@ContractStatusId", ContractStatusModel.ContractStatusId);
                    vParams.Add("@ContractStatusName", ContractStatusModel.ContractStatusName);
                    vParams.Add("@StatusName", ContractStatusModel.StatusName);
                    vParams.Add("@ContractStatusColor", ContractStatusModel.ContractStatusColor);
                    vParams.Add("@IsArchived", ContractStatusModel.IsArchived);
                    vParams.Add("@TimeStamp", ContractStatusModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertContractStatus, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertContractStatus", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.UpsertContractException);
                return null;
            }
        }


        public List<ContractStatusModel> GetAllContractStatus(ContractStatusModel ContractStatusModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@ContractStatusId", ContractStatusModel.ContractStatusId);
                    vParams.Add("@IsArchived", ContractStatusModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ContractStatusModel>(StoredProcedureConstants.SpGetAllContractStatus, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllContractStatus", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetContractStatusException);
                return new List<ContractStatusModel>();
            }
        }


        public Guid? UpsertInvoiceStatus(ClientInvoiceStatus ClientInvoiceStatus, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)

        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@InvoiceStatusId", ClientInvoiceStatus.InvoiceStatusId);
                    vParams.Add("@InvoiceStatusName", ClientInvoiceStatus.InvoiceStatusName);
                    vParams.Add("@StatusName", ClientInvoiceStatus.StatusName);
                    vParams.Add("@InvoiceStatusColor", ClientInvoiceStatus.InvoiceStatusColor);
                    vParams.Add("@IsArchived", ClientInvoiceStatus.IsArchived);
                    vParams.Add("@TimeStamp", ClientInvoiceStatus.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertInvoiceStatus, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertInvoiceStatus", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.UpsertInvoiceException);
                return null;
            }
        }


        public List<ClientInvoiceStatus> GetAllInvoiceStatus(ClientInvoiceStatus ClientInvoiceStatus, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@InvoiceStatusId", ClientInvoiceStatus.InvoiceStatusId);
                    vParams.Add("@IsArchived", ClientInvoiceStatus.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ClientInvoiceStatus>(StoredProcedureConstants.SpGetAllInvoiceStatus, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllInvoiceStatus", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetInvoiceStatusException);
                return new List<ClientInvoiceStatus>();
            }
        }
        public List<ClientInvoiceStatus> GetAllInvoicePaymentStatus(ClientInvoiceStatus ClientInvoiceStatus, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@InvoiceStatusId", ClientInvoiceStatus.InvoiceStatusId);
                    vParams.Add("@IsArchived", ClientInvoiceStatus.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ClientInvoiceStatus>(StoredProcedureConstants.SpGetAllInvoicePaymentStatus, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllInvoicePaymentStatus", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetInvoiceStatusException);
                return new List<ClientInvoiceStatus>();
            }
        }

        public List<TradeContractTypesModel> GetTradeContractTypes(TradeContractTypesModel TradeContractTypesModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@ContractTypeId", TradeContractTypesModel.ContractTypeId);
                    vParams.Add("@IsArchived", TradeContractTypesModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<TradeContractTypesModel>(StoredProcedureConstants.SpGetTradeContractTypes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTradeContractTypes", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetHtmlTagsException);
                return new List<TradeContractTypesModel>();
            }
        }
        public Guid? UpsertClientKycDetails(UpsertClientInputModel clientInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ClientId", clientInputModel.ClientId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertClientKycDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();

                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertClientKycDetails", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertClient);
                return null;
            }

        }
    }
}
