using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.PayRoll;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Models.Employee;
using Btrak.Models.User;

namespace Btrak.Dapper.Dal.Repositories
{
    public class PayRollRepository : BaseRepository
    {
        public Guid? UpsertPayRollComponent(PayRollComponentUpsertInputModel PayRollComponentUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@PayRollComponentId", PayRollComponentUpsertInputModel.PayRollComponentId);
                    vParams.Add("@ComponentName", PayRollComponentUpsertInputModel.ComponentName);
                    vParams.Add("@IsDeduction", PayRollComponentUpsertInputModel.IsDeduction);
                    vParams.Add("@IsVariablePay", PayRollComponentUpsertInputModel.IsVariablePay);
                    vParams.Add("@IsVisible", PayRollComponentUpsertInputModel.IsVisible);
                    vParams.Add("@IsArchived", PayRollComponentUpsertInputModel.IsArchived);
                    vParams.Add("@EmployeeContributionPercentage", PayRollComponentUpsertInputModel.EmployeeContributionPercentage);
                    vParams.Add("@EmployerContributionPercentage", PayRollComponentUpsertInputModel.EmployerContributionPercentage);
                    vParams.Add("@RelatedToContributionPercentage", PayRollComponentUpsertInputModel.RelatedToContributionPercentage);
                    vParams.Add("@TimeStamp", PayRollComponentUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertPayRollComponent, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPayRollComponent", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertPayRollComponent);
                return null;
            }
        }

        public List<PayRollComponentSearchOutputModel> GetPayRollComponents(PayRollComponentSearchInputModel PayRollComponentSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@PayRollComponentId", PayRollComponentSearchInputModel.PayRollComponentId);
                    vParams.Add("@ComponentName", PayRollComponentSearchInputModel.ComponentName);
                    vParams.Add("@IsDeduction", PayRollComponentSearchInputModel.IsDeduction);
                    vParams.Add("@IsVariablePay", PayRollComponentSearchInputModel.IsVariablePay);
                    vParams.Add("@IsVisible", PayRollComponentSearchInputModel.IsVisible);
                    vParams.Add("@SearchText", PayRollComponentSearchInputModel.SearchText);
                    vParams.Add("@IsArchived", PayRollComponentSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<PayRollComponentSearchOutputModel>(StoredProcedureConstants.SpGetPayRollComponents, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPayRollComponents", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetPayRollComponents);
                return new List<PayRollComponentSearchOutputModel>();
            }
        }

        public PayRollTemplateUpsertInputModel UpsertPayRollTemplate(PayRollTemplateUpsertInputModel PayRollTemplateUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@PayRollTemplateId", PayRollTemplateUpsertInputModel.PayRollTemplateId);
                    vParams.Add("@PayRollName", PayRollTemplateUpsertInputModel.PayRollName);
                    vParams.Add("@PayRollShortName", PayRollTemplateUpsertInputModel.PayRollShortName);
                    vParams.Add("@IsRepeatInfinitly", PayRollTemplateUpsertInputModel.IsRepeatInfinitly);
                    vParams.Add("@IslastWorkingDay", PayRollTemplateUpsertInputModel.IslastWorkingDay);
                    vParams.Add("@IsArchived", PayRollTemplateUpsertInputModel.IsArchived);
                    vParams.Add("@FrequencyId", PayRollTemplateUpsertInputModel.FrequencyId);
                    vParams.Add("@CurrencyId", PayRollTemplateUpsertInputModel.CurrencyId);
                    vParams.Add("@InfinitlyRunDate", PayRollTemplateUpsertInputModel.InfinitlyRunDate);
                    vParams.Add("@TimeStamp", PayRollTemplateUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<PayRollTemplateUpsertInputModel>(StoredProcedureConstants.SpUpsertPayRollTemplate, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPayRollTemplate", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertPayRollTemplate);
                return null;
            }
        }

        public List<PayRollTemplateSearchOutputModel> GetPayRollTemplates(PayRollTemplateSearchInputModel PayRollTemplateSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@PayRollTemplateId", PayRollTemplateSearchInputModel.PayRollTemplateId);
                    vParams.Add("@PayRollTemplateName", PayRollTemplateSearchInputModel.PayRollTemplateName);
                    vParams.Add("@FrequencyId", PayRollTemplateSearchInputModel.FrequencyId);
                    vParams.Add("@IsRepeatInfinitly", PayRollTemplateSearchInputModel.IsRepeatInfinitly);
                    vParams.Add("@IslastWorkingDay", PayRollTemplateSearchInputModel.IslastWorkingDay);
                    vParams.Add("@SearchText", PayRollTemplateSearchInputModel.SearchText);
                    vParams.Add("@IsArchived", PayRollTemplateSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<PayRollTemplateSearchOutputModel>(StoredProcedureConstants.SpGetPayRollTemplates, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPayRollTemplates", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetPayRollTemplates);
                return new List<PayRollTemplateSearchOutputModel>();
            }
        }

        public List<ComponentSearchOutPutModel> GetComponents(PayRollTemplateSearchInputModel PayRollTemplateSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@ComponentName", PayRollTemplateSearchInputModel.ComponentName);
                    return vConn.Query<ComponentSearchOutPutModel>(StoredProcedureConstants.SpGetComponents, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetComponents", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetPayRollTemplates);
                return new List<ComponentSearchOutPutModel>();
            }
        }

        public List<EmployeeBonus> GetEmployeesBonusDetails(Guid? employeeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@EmployeeId", employeeId);
                    return vConn.Query<EmployeeBonus>(StoredProcedureConstants.SpGetEmployeesBonusDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeesBonusDetails", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetEmployeesBonusDetails);
                return new List<EmployeeBonus>();
            }
        }

        public Guid? UpsertEmployeeBonusDetails(EmployeeBonus employeeBonus ,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
         {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    if (employeeBonus.Id != null)
                    {
                        employeeBonus.EmployeeIds = new List<Guid>();
                        employeeBonus.EmployeeIds.Add(employeeBonus.EmployeeId);
                    }
                   
                    vParams.Add("@Id", employeeBonus.Id);
                    vParams.Add("@EmployeeIds", string.Join(",",  employeeBonus.EmployeeIds));
                    vParams.Add("@Bonus", employeeBonus.Bonus);
                    vParams.Add("@UserId", loggedInContext.LoggedInUserId);
                    vParams.Add("@PayrollRunEmployeeId", null);
                    vParams.Add("@IsArchived", employeeBonus.IsArchived);
                    vParams.Add("@IsApproved", employeeBonus.IsApproved);
                    vParams.Add("@PayRollComponentId", employeeBonus.PayRollComponentId);
                    vParams.Add("@IsCtcType", employeeBonus.IsCtcType);
                    vParams.Add("@Percentage", employeeBonus.Percentage);
                    vParams.Add("@GeneratedDate", employeeBonus.GeneratedDate);
                    

                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertEmployeeBonus, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeBonusDetails", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.UpsertEmployeeBonusDetails);
                return Guid.NewGuid();
            }
        }

        public Guid? UpsertPayRollTemplateConfiguration(PayRollTemplateConfigurationUpsertInputModel PayRollTemplateConfigurationUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@PayRollTemplateConfigurationId", PayRollTemplateConfigurationUpsertInputModel.PayRollTemplateConfigurationId);
                    vParams.Add("@PayrollComponentId", PayRollTemplateConfigurationUpsertInputModel.PayRollComponentId);
                    vParams.Add("@PayRollComponentIds", PayRollTemplateConfigurationUpsertInputModel.PayRollComponentXml);
                    vParams.Add("@PayRollTemplateId", PayRollTemplateConfigurationUpsertInputModel.PayRollTemplateId);
                    vParams.Add("@IsPercentage", PayRollTemplateConfigurationUpsertInputModel.IsPercentage);
                    vParams.Add("@Amount", PayRollTemplateConfigurationUpsertInputModel.Amount);
                    vParams.Add("@Percentagevalue", PayRollTemplateConfigurationUpsertInputModel.Percentagevalue);
                    vParams.Add("@IsCtcDependent", PayRollTemplateConfigurationUpsertInputModel.IsCtcDependent);
                    vParams.Add("@IsRelatedToPT", PayRollTemplateConfigurationUpsertInputModel.IsRelatedToPT);
                    vParams.Add("@ComponentId", PayRollTemplateConfigurationUpsertInputModel.ComponentId);
                    vParams.Add("@DependentPayRollComponentId", PayRollTemplateConfigurationUpsertInputModel.DependentPayRollComponentId);
                    vParams.Add("@Order", PayRollTemplateConfigurationUpsertInputModel.Order);
                    vParams.Add("@IsArchived", PayRollTemplateConfigurationUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", PayRollTemplateConfigurationUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertPayRollTemplateConfiguration, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPayRollTemplateConfiguration", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertPayRollTemplateConfiguration);
                return null;
            }
        }

        public List<PayRollTemplateConfigurationSearchOutputModel> GetPayRollTemplateConfigurations(PayRollTemplateConfigurationSearchInputModel PayRollTemplateConfigurationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@PayRollTemplateId", PayRollTemplateConfigurationSearchInputModel.PayRollTemplateId);
                    vParams.Add("@SearchText", PayRollTemplateConfigurationSearchInputModel.SearchText);
                    vParams.Add("@IsArchived", PayRollTemplateConfigurationSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<PayRollTemplateConfigurationSearchOutputModel>(StoredProcedureConstants.SpGetPayRollTemplateConfigurations, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPayRollTemplateConfigurations", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetPayRollTemplateConfigurations);
                return new List<PayRollTemplateConfigurationSearchOutputModel>();
            }
        }

        public List<ResignationstausSearchOutputModel> GetResignationStatus(ResignationStatusSearchInputModel resignationStatusSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ResignationStatusId", resignationStatusSearchInputModel.ResignationStatusId);
                    vParams.Add("@StatusName", resignationStatusSearchInputModel.StatusName);
                    vParams.Add("@SearchText", resignationStatusSearchInputModel.SearchText);
                    vParams.Add("@IsArchived", resignationStatusSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ResignationstausSearchOutputModel>(StoredProcedureConstants.SpGetResignationStatus, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetResignationStatus", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetPayRollComponents);
                return new List<ResignationstausSearchOutputModel>();
            }
        }

        public Guid? UpsertResignationStatus(ResignationStatusSearchInputModel resignationStatusSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ResignationStatusId", resignationStatusSearchInputModel.ResignationStatusId);
                    vParams.Add("@StatusName", resignationStatusSearchInputModel.StatusName);
                    vParams.Add("@TimeStamp", resignationStatusSearchInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsArchived", resignationStatusSearchInputModel.IsArchived);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertResignationStatus, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertResignationStatus", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertPayRollComponent);
                return null;
            }
        }

        public List<EmployeeOutputModel> GetEmployees(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    var parameters = new DynamicParameters();
                    parameters.Add("@CompanyId", loggedInContext.CompanyGuid);
                    return vConn.Query<EmployeeOutputModel>(StoredProcedureConstants.SpGetAllEmployeesForBonus, parameters, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployees", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetPayRollTemplates);
                return new List<EmployeeOutputModel>();
            }
        }

        public Guid? UpsertPayRollRoleConfiguration(PayRollRoleConfigurationUpsertInputModel PayRollRoleConfigurationUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@PayRollRoleConfigurationId", PayRollRoleConfigurationUpsertInputModel.PayRollRoleConfigurationId);
                    vParams.Add("@PayRollTemplateId", PayRollRoleConfigurationUpsertInputModel.PayRollTemplateId);
                    vParams.Add("@RoleId", PayRollRoleConfigurationUpsertInputModel.RoleId);
                    vParams.Add("@IsArchived", PayRollRoleConfigurationUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", PayRollRoleConfigurationUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertPayRollRoleConfiguration, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPayRollRoleConfiguration", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertPayRollRoleConfiguration);
                return null;
            }
        }

        public List<PayRollRoleConfigurationSearchOutputModel> GetPayRollRoleConfigurations(PayRollRoleConfigurationSearchInputModel PayRollRoleConfigurationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@PayRollTemplateId", PayRollRoleConfigurationSearchInputModel.PayRollTemplateId);
                    vParams.Add("@SearchText", PayRollRoleConfigurationSearchInputModel.SearchText);
                    vParams.Add("@IsArchived", PayRollRoleConfigurationSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<PayRollRoleConfigurationSearchOutputModel>(StoredProcedureConstants.SpGetPayRollRoleConfigurations, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPayRollRoleConfigurations", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetPayRollRoleConfigurations);
                return new List<PayRollRoleConfigurationSearchOutputModel>();
            }
        }

        public Guid? UpsertPayRollBranchConfiguration(PayRollBranchConfigurationUpsertInputModel PayRollBranchConfigurationUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@PayRollBranchConfigurationId", PayRollBranchConfigurationUpsertInputModel.PayRollBranchConfigurationId);
                    vParams.Add("@PayRollTemplateId", PayRollBranchConfigurationUpsertInputModel.PayRollTemplateId);
                    vParams.Add("@BranchId", PayRollBranchConfigurationUpsertInputModel.BranchId);
                    vParams.Add("@IsArchived", PayRollBranchConfigurationUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", PayRollBranchConfigurationUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertPayRollBranchConfiguration, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPayRollBranchConfiguration", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertPayRollBranchConfiguration);
                return null;
            }
        }

        public List<PayRollBranchConfigurationSearchOutputModel> GetPayRollBranchConfigurations(PayRollBranchConfigurationSearchInputModel PayRollBranchConfigurationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@PayRollTemplateId", PayRollBranchConfigurationSearchInputModel.PayRollTemplateId);
                    vParams.Add("@SearchText", PayRollBranchConfigurationSearchInputModel.SearchText);
                    vParams.Add("@IsArchived", PayRollBranchConfigurationSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<PayRollBranchConfigurationSearchOutputModel>(StoredProcedureConstants.SpGetPayRollBranchConfigurations, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPayRollBranchConfigurations", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetPayRollBranchConfigurations);
                return new List<PayRollBranchConfigurationSearchOutputModel>();
            }
        }

        public Guid? UpsertPayRollGenderConfiguration(PayRollGenderConfigurationUpsertInputModel PayRollGenderConfigurationUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@PayRollGenderConfigurationId", PayRollGenderConfigurationUpsertInputModel.PayRollGenderConfigurationId);
                    vParams.Add("@PayRollTemplateId", PayRollGenderConfigurationUpsertInputModel.PayRollTemplateId);
                    vParams.Add("@GenderId", PayRollGenderConfigurationUpsertInputModel.GenderId);
                    vParams.Add("@IsArchived", PayRollGenderConfigurationUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", PayRollGenderConfigurationUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertPayRollGenderConfiguration, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPayRollGenderConfiguration", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertPayRollGenderConfiguration);
                return null;
            }
        }

        public List<PayRollGenderConfigurationSearchOutputModel> GetPayRollGenderConfigurations(PayRollGenderConfigurationSearchInputModel PayRollGenderConfigurationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@PayRollTemplateId", PayRollGenderConfigurationSearchInputModel.PayRollTemplateId);
                    vParams.Add("@SearchText", PayRollGenderConfigurationSearchInputModel.SearchText);
                    vParams.Add("@IsArchived", PayRollGenderConfigurationSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<PayRollGenderConfigurationSearchOutputModel>(StoredProcedureConstants.SpGetPayRollGenderConfigurations, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPayRollGenderConfigurations", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetPayRollGenderConfigurations);
                return new List<PayRollGenderConfigurationSearchOutputModel>();
            }
        }
        public Guid? UpsertPayRollMaritalStatusConfiguration(PayRollMaritalStatusConfigurationUpsertInputModel PayRollMaritalStatusConfigurationUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@PayRollMaritalStatusConfigurationId", PayRollMaritalStatusConfigurationUpsertInputModel.PayRollMaritalStatusConfigurationId);
                    vParams.Add("@PayRollTemplateId", PayRollMaritalStatusConfigurationUpsertInputModel.PayRollTemplateId);
                    vParams.Add("@MaritalStatusId", PayRollMaritalStatusConfigurationUpsertInputModel.MaritalStatusId);
                    vParams.Add("@IsArchived", PayRollMaritalStatusConfigurationUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", PayRollMaritalStatusConfigurationUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertPayRollMaritalStatusConfiguration, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPayRollMaritalStatusConfiguration", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertPayRollMaritalStatusConfiguration);
                return null;
            }
        }

        public List<PayRollMaritalStatusConfigurationSearchOutputModel> GetPayRollMaritalStatusConfigurations(PayRollMaritalStatusConfigurationSearchInputModel PayRollMaritalStatusConfigurationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@PayRollTemplateId", PayRollMaritalStatusConfigurationSearchInputModel.PayRollTemplateId);
                    vParams.Add("@SearchText", PayRollMaritalStatusConfigurationSearchInputModel.SearchText);
                    vParams.Add("@IsArchived", PayRollMaritalStatusConfigurationSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<PayRollMaritalStatusConfigurationSearchOutputModel>(StoredProcedureConstants.SpGetPayRollMaritalStatusConfigurations, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPayRollMaritalStatusConfigurations", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetPayRollMaritalStatusConfigurations);
                return new List<PayRollMaritalStatusConfigurationSearchOutputModel>();
            }
        }

        public List<PayRollTemplatesForEmployee> GetEmployeesPayTemplates(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    var parameters = new DynamicParameters();
                    parameters.Add("@CompanyId", loggedInContext.CompanyGuid);
                    return vConn.Query<PayRollTemplatesForEmployee>(StoredProcedureConstants.SpGetEmployeesPayTemplate, parameters, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeesPayTemplates", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetEmployeesPayTemplates);
                return new List<PayRollTemplatesForEmployee>();
            }
        }

        public List<EmployeePayRollConfiguration> GetEmployeePayrollConfiguration(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    var parameters = new DynamicParameters();
                    parameters.Add("@CompanyId", loggedInContext.CompanyGuid);
                    return vConn.Query<EmployeePayRollConfiguration>(StoredProcedureConstants.SpGetPayrollConfiguration, parameters, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeePayrollConfiguration", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetEmployeePayrollConfiguration);
                return new List<EmployeePayRollConfiguration>();
            }
        }

        public Guid? UpsertEmployeePayrollConfiguration(EmployeePayRollConfiguration employeePayRollConfiguration, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Id", employeePayRollConfiguration.Id);
                    vParams.Add("@EmployeeId", employeePayRollConfiguration.EmployeeId);
                    vParams.Add("@PayrollTemplateId", employeePayRollConfiguration.PayrollTemplateId);
                    vParams.Add("@ActiveFrom", employeePayRollConfiguration.ActiveFrom);
                    vParams.Add("@ActiveTo", employeePayRollConfiguration.ActiveTo);

                    vParams.Add("@UserId", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsApproved", employeePayRollConfiguration.IsApproved);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertPayrollConfiguration, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeePayrollConfiguration", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.UpsertEmployeePayrollConfiguration);
                return null;
            }
        }

        public List<EmployeeResignationSearchOutputModel> GetEmployeeResignation(EmployeeResignationSearchInputModel employeeResignationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EmployeeResignationId", employeeResignationSearchInputModel.EmployeeResignationId);
                    vParams.Add("@ResignationStatusId", employeeResignationSearchInputModel.ResignationStatusId);
                    vParams.Add("@SearchText", employeeResignationSearchInputModel.SearchText);
                    vParams.Add("@IsArchived", employeeResignationSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@EmployeeId", employeeResignationSearchInputModel.EmployeeId);
                    return vConn.Query<EmployeeResignationSearchOutputModel>(StoredProcedureConstants.SpGetEmployeeResignation, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeResignation", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetPayRollComponents);
                return new List<EmployeeResignationSearchOutputModel>();
            }
        }
        public List<EmployeeResigantionOutputModel> UpsertEmployeeResignation(EmployeeResignationSearchInputModel employeeResignationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EmployeeResignationId", employeeResignationSearchInputModel.EmployeeResignationId);
                    vParams.Add("@EmployeeId", employeeResignationSearchInputModel.EmployeeId);
                    vParams.Add("@IsApproved", employeeResignationSearchInputModel.IsApproved);
                    vParams.Add("@ResignationDate", employeeResignationSearchInputModel.ResignationDate);
                    vParams.Add("@LastDate", employeeResignationSearchInputModel.LastDate);
                    vParams.Add("@TimeStamp", employeeResignationSearchInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsArchived", employeeResignationSearchInputModel.IsArchived);
                    vParams.Add("@CommentByEmployee", employeeResignationSearchInputModel.CommentByEmployee);
                    vParams.Add("@CommentByEmployer", employeeResignationSearchInputModel.CommentByEmployer);
                    return vConn.Query<EmployeeResigantionOutputModel>(StoredProcedureConstants.SpUpsertEmployeeResignation, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeResignation", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertPayRollComponent);
                return null;
            }
        }

        public IEnumerable<PayRollStatus> GetPayrollStatusList(Guid? statusId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    var parameters = new DynamicParameters();
                    parameters.Add("@StatusId", statusId);
                    parameters.Add("@CompanyId", loggedInContext.CompanyGuid);
                    return vConn.Query<PayRollStatus>(StoredProcedureConstants.SpGetPayrollStatusList, parameters, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPayrollStatusList", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetPayRollStatusList);
                return new List<PayRollStatus>();
            }
        }

        public Guid? UpsertPayrollStatus(PayRollStatus payRollStatus, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Id", payRollStatus.Id);
                    vParams.Add("@CompanyId", loggedInContext.CompanyGuid);
                    vParams.Add("@PayrollStatusName", payRollStatus.PayRollStatusName);
                    vParams.Add("@IsArchived", payRollStatus.IsArchived);
                    vParams.Add("@UserId", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertPayrollStatus, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPayrollStatus", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertPayRollStatus);
                return null;
            }
        }
        public List<TaxAllowanceTypeModel> GetTaxAllowanceTypes(PayRollTemplateSearchInputModel payRollTemplateSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@TaxAllowanceTypeName", payRollTemplateSearchInputModel.TaxAllowanceTypeName);
                    return vConn.Query<TaxAllowanceTypeModel>(StoredProcedureConstants.SpGetTaxAllowanceTypes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTaxAllowanceTypes", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetPayRollTemplates);
                return new List<TaxAllowanceTypeModel>();
            }
        }

        public Guid? UpsertTaxAllowance(TaxAllowanceUpsertInputModel TaxAllowanceUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@TaxAllowanceId", TaxAllowanceUpsertInputModel.TaxAllowanceId);
                    vParams.Add("@Name", TaxAllowanceUpsertInputModel.Name);
                    vParams.Add("@TaxAllowanceTypeId", TaxAllowanceUpsertInputModel.TaxAllowanceTypeId);
                    vParams.Add("@IsPercentage", TaxAllowanceUpsertInputModel.IsPercentage);
                    vParams.Add("@MaxAmount", TaxAllowanceUpsertInputModel.MaxAmount);
                    vParams.Add("@PercentageValue", TaxAllowanceUpsertInputModel.PercentageValue);
                    vParams.Add("@PayRollComponentId", TaxAllowanceUpsertInputModel.PayRollComponentId);
                    vParams.Add("@ComponentId", TaxAllowanceUpsertInputModel.ComponentId);
                    vParams.Add("@ParentId", TaxAllowanceUpsertInputModel.ParentId);
                    vParams.Add("@FromDate", TaxAllowanceUpsertInputModel.FromDate);
                    vParams.Add("@ToDate", TaxAllowanceUpsertInputModel.ToDate);
                    vParams.Add("@OnlyEmployeeMaxAmount", TaxAllowanceUpsertInputModel.OnlyEmployeeMaxAmount);
                    vParams.Add("@MetroMaxPercentage", TaxAllowanceUpsertInputModel.MetroMaxPercentage);
                    vParams.Add("@LowestAmountOfParentSet", TaxAllowanceUpsertInputModel.LowestAmountOfParentSet);
                    vParams.Add("@TimeStamp", TaxAllowanceUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", TaxAllowanceUpsertInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@CountryId", TaxAllowanceUpsertInputModel.CountryId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertTaxAllowance, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTaxAllowance", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertTaxAllowance);
                return null;
            }
        }

        public List<TaxAllowanceSearchOutputModel> GetTaxAllowances(TaxAllowanceSearchInputModel TaxAllowanceSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@TaxAllowanceId", TaxAllowanceSearchInputModel.TaxAllowanceId);
                    vParams.Add("@SearchText", TaxAllowanceSearchInputModel.SearchText);
                    vParams.Add("@IsArchived", TaxAllowanceSearchInputModel.IsArchived);
                    vParams.Add("@IsMainPage", TaxAllowanceSearchInputModel.IsMainPage);
                    vParams.Add("@EmployeeId", TaxAllowanceSearchInputModel.EmployeeId);
                    vParams.Add("@TaxAllowanceName", TaxAllowanceSearchInputModel.Name);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<TaxAllowanceSearchOutputModel>(StoredProcedureConstants.SpGetTaxAllowances, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTaxAllowances", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetTaxAllowances);
                return new List<TaxAllowanceSearchOutputModel>();
            }
        }

        public List<PayrollRun> GetPayrollRunList(bool? isArchived, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserId", loggedInContext.LoggedInUserId);
                    vParams.Add("@CompanyId", loggedInContext.CompanyGuid);
                    vParams.Add("@IsArchived", isArchived);
                    
                    return vConn.Query<PayrollRun>(StoredProcedureConstants.SpGetPayrollRunList, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPayrollRunList", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetPayrollRunList);
                return new List<PayrollRun>();
            }
        }


        public Guid? UpsertEmployeeTaxAllowanceDetails(EmployeeTaxAllowanceDetailsUpsertInputModel EmployeeTaxAllowanceDetailsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EmployeeTaxAllowanceId", EmployeeTaxAllowanceDetailsUpsertInputModel.EmployeeTaxAllowanceId);
                    vParams.Add("@EmployeeId", EmployeeTaxAllowanceDetailsUpsertInputModel.EmployeeId);
                    vParams.Add("@TaxAllowanceId", EmployeeTaxAllowanceDetailsUpsertInputModel.TaxAllowanceId);
                    vParams.Add("@InvestedAmount", EmployeeTaxAllowanceDetailsUpsertInputModel.InvestedAmount);
                    vParams.Add("@ApprovedDateTime", EmployeeTaxAllowanceDetailsUpsertInputModel.ApprovedDateTime);
                    vParams.Add("@IsAutoApproved", EmployeeTaxAllowanceDetailsUpsertInputModel.IsAutoApproved);
                    vParams.Add("@IsOnlyEmployee", EmployeeTaxAllowanceDetailsUpsertInputModel.IsOnlyEmployee);
                    vParams.Add("@IsRelatedToHRA", EmployeeTaxAllowanceDetailsUpsertInputModel.IsRelatedToHRA);
                    vParams.Add("@IsApproved", EmployeeTaxAllowanceDetailsUpsertInputModel.IsApproved);
                    vParams.Add("@Comments", EmployeeTaxAllowanceDetailsUpsertInputModel.Comments);
                    vParams.Add("@OwnerPanNumber", EmployeeTaxAllowanceDetailsUpsertInputModel.OwnerPanNumber);
                    vParams.Add("@TimeStamp", EmployeeTaxAllowanceDetailsUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", EmployeeTaxAllowanceDetailsUpsertInputModel.IsArchived);
                    vParams.Add("@RelatedToMetroCity", EmployeeTaxAllowanceDetailsUpsertInputModel.RelatedToMetroCity);
                    vParams.Add("@IsFilesExist", EmployeeTaxAllowanceDetailsUpsertInputModel.IsFilesExist);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertEmployeeTaxAllowanceDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeTaxAllowanceDetails", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertEmployeeTaxAllowanceDetails);
                return null;
            }
        }

        public List<EmployeeTaxAllowanceDetailsSearchOutputModel> GetEmployeeTaxAllowanceDetailss(EmployeeTaxAllowanceDetailsSearchInputModel EmployeeTaxAllowanceDetailsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EmployeeTaxAllowanceId", EmployeeTaxAllowanceDetailsSearchInputModel.EmployeeTaxAllowanceId);
                    vParams.Add("@EmployeeId", EmployeeTaxAllowanceDetailsSearchInputModel.EmployeeId);
                    vParams.Add("@SearchText", EmployeeTaxAllowanceDetailsSearchInputModel.SearchText);
                    vParams.Add("@IsArchived", EmployeeTaxAllowanceDetailsSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmployeeTaxAllowanceDetailsSearchOutputModel>(StoredProcedureConstants.SpGetEmployeeTaxAllowanceDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeTaxAllowanceDetailss", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeTaxAllowanceDetails);
                return new List<EmployeeTaxAllowanceDetailsSearchOutputModel>();
            }
        }

        public List<PayrollRunEmployee> GetPayrollRunEmployeeList(Guid payrollRunId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@PayrollrunId", payrollRunId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<PayrollRunEmployee>(StoredProcedureConstants.SpGetPayrollRunemployeeList, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPayrollRunEmployeeList", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetPayrollRunemployeeList);
                return new List<PayrollRunEmployee>();
            }
        }

        public List<EmployeePayslip> GetPaySlipDetails(Guid payrollRunId, Guid employeeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@PayrollrunId", payrollRunId);
                    vParams.Add("@EmployeeId", employeeId);
                    return vConn.Query<EmployeePayslip>(StoredProcedureConstants.SpGetPaySlipOfAnEmployee, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPaySlipDetails", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetPaySlipDetails);
                return new List<EmployeePayslip>();
            }
        }


        public Guid? UpsertLeaveEncashmentSettings(LeaveEncashmentSettingsUpsertInputModel LeaveEncashmentSettingsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@LeaveEncashmentSettingsId", LeaveEncashmentSettingsUpsertInputModel.LeaveEncashmentSettingsId);
                    vParams.Add("@PayRollComponentId", LeaveEncashmentSettingsUpsertInputModel.PayRollComponentId);
                    vParams.Add("@BranchId", LeaveEncashmentSettingsUpsertInputModel.BranchId);
                    vParams.Add("@IsCtcType", LeaveEncashmentSettingsUpsertInputModel.IsCtcType);
                    vParams.Add("@Percentage", LeaveEncashmentSettingsUpsertInputModel.Percentage);
                    vParams.Add("@Amount", LeaveEncashmentSettingsUpsertInputModel.Amount);
                    vParams.Add("@IsArchived", LeaveEncashmentSettingsUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", LeaveEncashmentSettingsUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@ActiveFrom", LeaveEncashmentSettingsUpsertInputModel.ActiveFrom);
                    vParams.Add("@ActiveTo", LeaveEncashmentSettingsUpsertInputModel.ActiveTo);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertLeaveEncashmentSettings, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertLeaveEncashmentSettings", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertLeaveEncashmentSettings);
                return null;
            }
        }

        public List<LeaveEncashmentSettingsSearchOutputModel> GetLeaveEncashmentSettings(LeaveEncashmentSettingsSearchInputModel LeaveEncashmentSettingsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@LeaveEncashmentSettingsId", LeaveEncashmentSettingsSearchInputModel.LeaveEncashmentSettingsId);
                    vParams.Add("@SearchText", LeaveEncashmentSettingsSearchInputModel.SearchText);
                    vParams.Add("@IsArchived", LeaveEncashmentSettingsSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<LeaveEncashmentSettingsSearchOutputModel>(StoredProcedureConstants.SpGetLeaveEncashmentSettings, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetLeaveEncashmentSettings", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetLeaveEncashmentSettings);
                return new List<LeaveEncashmentSettingsSearchOutputModel>();
            }
        }

        public List<PayrollRunOutPutModel> InsertPayrollRun(PayrollRun payrollRun, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {

                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@BranchId", payrollRun.BranchId);
                    vParams.Add("@EmploymentStatusIds", payrollRun.EmploymentStatusIdsList);
                    vParams.Add("@EmployeeIds", payrollRun.EmployeeIdsList);
                    vParams.Add("@PayrollTemplateId", payrollRun.TemplateId);
                    vParams.Add("@RunStartDate", payrollRun.PayrollStartDate);
                    vParams.Add("@RunEndDate", payrollRun.PayrollEndDate);
                    vParams.Add("@NewPayrollRunId", payrollRun.Id);
                    vParams.Add("@ChequeDate", payrollRun.ChequeDate);
                    vParams.Add("@AlphaCode", payrollRun.AlphaCode);
                    vParams.Add("@Cheque", payrollRun.Cheque);
                    vParams.Add("@ChequeNo", payrollRun.ChequeNo);
                    
                    return vConn.Query<PayrollRunOutPutModel>(StoredProcedureConstants.SpProducePayroll, vParams, commandType: CommandType.StoredProcedure, commandTimeout: 0).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertPayrollRun", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionInsertPayrollRun);
                return null;
            }
        }

        public Guid? UpsertEmployeeAccountDetails(EmployeeAccountDetailsUpsertInputModel EmployeeAccountDetailsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EmployeeAccountDetailsId", EmployeeAccountDetailsUpsertInputModel.EmployeeAccountDetailsId);
                    vParams.Add("@EmployeeId", EmployeeAccountDetailsUpsertInputModel.EmployeeId);
                    vParams.Add("@PFNumber", EmployeeAccountDetailsUpsertInputModel.PFNumber);
                    vParams.Add("@UANNumber", EmployeeAccountDetailsUpsertInputModel.UANNumber);
                    vParams.Add("@ESINumber", EmployeeAccountDetailsUpsertInputModel.ESINumber);
                    vParams.Add("@PANNumber", EmployeeAccountDetailsUpsertInputModel.PANNumber);
                    vParams.Add("@IsArchived", EmployeeAccountDetailsUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", EmployeeAccountDetailsUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertEmployeeAccountDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeAccountDetails", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertEmployeeAccountDetails);
                return null;
            }
        }

        public List<EmployeeAccountDetailsSearchOutputModel> GetEmployeeAccountDetails(EmployeeAccountDetailsSearchInputModel EmployeeAccountDetailsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EmployeeAccountDetailsId", EmployeeAccountDetailsSearchInputModel.EmployeeAccountDetailsId);
                    vParams.Add("@IsArchived", EmployeeAccountDetailsSearchInputModel.IsArchived);
                    vParams.Add("@EmployeeId", EmployeeAccountDetailsSearchInputModel.EmployeeId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmployeeAccountDetailsSearchOutputModel>(StoredProcedureConstants.SpGetEmployeeAccountDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeAccountDetails", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeAccountDetails);
                return new List<EmployeeAccountDetailsSearchOutputModel>();
            }
        }

        public Guid? UpsertFinancialYearConfigurations(FinancialYearConfigurationsUpsertInputModel FinancialYearConfigurationsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FinancialYearConfigurationsId", FinancialYearConfigurationsUpsertInputModel.FinancialYearConfigurationsId);
                    vParams.Add("@CountryId", FinancialYearConfigurationsUpsertInputModel.CountryId);
                    vParams.Add("@FinancialYearTypeId", FinancialYearConfigurationsUpsertInputModel.FinancialYearTypeId);
                    vParams.Add("@FromMonth", FinancialYearConfigurationsUpsertInputModel.FromMonth);
                    vParams.Add("@ToMonth", FinancialYearConfigurationsUpsertInputModel.ToMonth);
                    vParams.Add("@IsArchived", FinancialYearConfigurationsUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", FinancialYearConfigurationsUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@ActiveFrom", FinancialYearConfigurationsUpsertInputModel.ActiveFrom);
                    vParams.Add("@ActiveTo", FinancialYearConfigurationsUpsertInputModel.ActiveTo);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertFinancialYearConfigurations, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertFinancialYearConfigurations", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertFinancialYearConfigurations);
                return null;
            }
        }

        public List<FinancialYearConfigurationsSearchOutputModel> GetFinancialYearConfigurations(FinancialYearConfigurationsSearchInputModel FinancialYearConfigurationsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FinancialYearConfigurationsId", FinancialYearConfigurationsSearchInputModel.FinancialYearConfigurationsId);
                    vParams.Add("@IsArchived", FinancialYearConfigurationsSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<FinancialYearConfigurationsSearchOutputModel>(StoredProcedureConstants.SpGetFinancialYearConfigurations, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetFinancialYearConfigurations", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetFinancialYearConfigurations);
                return new List<FinancialYearConfigurationsSearchOutputModel>();
            }
        }

        public Guid? UpdatePayrollRunEmployeeStatus(PayrollRunEmployee payrollRunEmployee, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@PayrollRunId", payrollRunEmployee.PayrollRunId);
                    vParams.Add("@EmployeeId", payrollRunEmployee.EmployeeId);
                    vParams.Add("@PayrollStatusId", payrollRunEmployee.PayrollStatusId);
                    vParams.Add("@IsHold", payrollRunEmployee.IsHold);
                    vParams.Add("@IsPayslipReleased", payrollRunEmployee.IsPayslipReleased);

                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpdatePayrollEmployeeStatus, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdatePayrollRunEmployeeStatus", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpdatePayrollRunEmployeeStatus);
                return null;
            }
        }

        public Guid? UpdatePayrollRunStatus(PayRollStatus payRollStatus, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@PayrollRunId", payRollStatus.PayrollRunId);
                    vParams.Add("@PayrollStatusId", payRollStatus.Id);
                    vParams.Add("@UserId", loggedInContext.LoggedInUserId);
                    vParams.Add("@WorkflowProcessInstanceId", payRollStatus.WorkflowProcessInstanceId);
                    vParams.Add("@StatusName", payRollStatus.PayRollStatusName);
                    vParams.Add("@Comments", payRollStatus.Comments);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpdatePayrollStatus, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdatePayrollRunStatus", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpdatePayrollRunStatus);
                return null;
            }
        }

        public List<UserOutputModel> GetUsersByRole(string roleName, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@RoleName", roleName);
                    vParams.Add("@CompanyId", loggedInContext.CompanyGuid);
                    return vConn.Query<UserOutputModel>(StoredProcedureConstants.SpGetUsersByRoleName, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUsersByRole", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetUsersByRole);
                return new List<UserOutputModel>();
            }
        }

        public Guid? UpsertPayRollCalculationConfigurations(PayRollCalculationConfigurationsUpsertInputModel PayRollCalculationConfigurationsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@PayRollCalculationConfigurationsId", PayRollCalculationConfigurationsUpsertInputModel.PayRollCalculationConfigurationsId);
                    vParams.Add("@BranchId", PayRollCalculationConfigurationsUpsertInputModel.BranchId);
                    vParams.Add("@PeriodTypeId", PayRollCalculationConfigurationsUpsertInputModel.PeriodTypeId);
                    vParams.Add("@PayRollCalculationTypeId", PayRollCalculationConfigurationsUpsertInputModel.PayRollCalculationTypeId);
                    vParams.Add("@IsArchived", PayRollCalculationConfigurationsUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", PayRollCalculationConfigurationsUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@ActiveFrom", PayRollCalculationConfigurationsUpsertInputModel.ActiveFrom);
                    vParams.Add("@ActiveTo", PayRollCalculationConfigurationsUpsertInputModel.ActiveTo);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);

                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertPayRollCalculationConfigurations, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPayRollCalculationConfigurations", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertPayRollCalculationConfigurations);
                return null;
            }
        }

        public Guid? GetStatusIdByName(string statusName, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@StatusName", statusName);
                    vParams.Add("@CompanyId", loggedInContext.CompanyGuid);

                    return vConn.Query<Guid?>(StoredProcedureConstants.SpGetPayrollStatusByName, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetStatusIdByName", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertPayRollCalculationConfigurations);
                return null;
            }
        }

        public List<PayRollCalculationConfigurationsSearchOutputModel> GetPayRollCalculationConfigurations(PayRollCalculationConfigurationsSearchInputModel PayRollCalculationConfigurationsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@PayRollCalculationConfigurationsId", PayRollCalculationConfigurationsSearchInputModel.PayRollCalculationConfigurationsId);
                    vParams.Add("@IsArchived", PayRollCalculationConfigurationsSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<PayRollCalculationConfigurationsSearchOutputModel>(StoredProcedureConstants.SpGetPayRollCalculationConfigurations, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPayRollCalculationConfigurations", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetPayRollCalculationConfigurations);
                return new List<PayRollCalculationConfigurationsSearchOutputModel>();
            }
        }

        public Guid? UpsertEmployeeCreditorDetails(EmployeeCreditorDetailsUpsertInputModel EmployeeCreditorDetailsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EmployeeCreditorDetailsId", EmployeeCreditorDetailsUpsertInputModel.EmployeeCreditorDetailsId);
                    vParams.Add("@BranchId", EmployeeCreditorDetailsUpsertInputModel.BranchId);
                    vParams.Add("@BankId", EmployeeCreditorDetailsUpsertInputModel.BankId);
                    vParams.Add("@AccountNumber", EmployeeCreditorDetailsUpsertInputModel.AccountNumber);
                    vParams.Add("@AccountName", EmployeeCreditorDetailsUpsertInputModel.AccountName);
                    vParams.Add("@IfScCode", EmployeeCreditorDetailsUpsertInputModel.IfScCode);
                    vParams.Add("@IsArchived", EmployeeCreditorDetailsUpsertInputModel.IsArchived);
                    vParams.Add("@UseForPerformaInvoice", EmployeeCreditorDetailsUpsertInputModel.UseForPerformaInvoice);
                    vParams.Add("@Email", EmployeeCreditorDetailsUpsertInputModel.Email);
                    vParams.Add("@MobileNo", EmployeeCreditorDetailsUpsertInputModel.MobileNo);
                    vParams.Add("@PanNumber", EmployeeCreditorDetailsUpsertInputModel.PanNumber);
                    vParams.Add("@TimeStamp", EmployeeCreditorDetailsUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertEmployeeCreditorDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeCreditorDetails", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertEmployeeCreditorDetails);
                return null;
            }
        }

        public List<EmployeeCreditorDetailsSearchOutputModel> GetEmployeeCreditorDetails(EmployeeCreditorDetailsSearchInputModel EmployeeCreditorDetailsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EmployeeCreditorDetailsId", EmployeeCreditorDetailsSearchInputModel.EmployeeCreditorDetailsId);
                    vParams.Add("@IsArchived", EmployeeCreditorDetailsSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@UseForPerformaInvoice", EmployeeCreditorDetailsSearchInputModel.UseForPerformaInvoice);
                    return vConn.Query<EmployeeCreditorDetailsSearchOutputModel>(StoredProcedureConstants.SpGetEmployeeCreditorDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeCreditorDetails", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeCreditorDetails);
                return new List<EmployeeCreditorDetailsSearchOutputModel>();
            }
        }

        public List<PeriodTypeModel> GetPeriodTypes(PayRollTemplateSearchInputModel payRollTemplateSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<PeriodTypeModel>(StoredProcedureConstants.SpGetPeriodTypes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPeriodTypes", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetPayRollTemplates);
                return new List<PeriodTypeModel>();
            }
        }

        public List<PayRollRunTemplate> GetPayRollRunTemplates(Guid? payrollRunId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@PayrollRunId", payrollRunId);
                    return vConn.Query<PayRollRunTemplate>(StoredProcedureConstants.SpGetPaySlipsForAnExcel, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPayRollRunTemplates", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetPayRollRunTemplates);
                return new List<PayRollRunTemplate>();
            }
        }

        public List<PayRollCalculationTypeModel> GetPayRollCalculationTypes(PayRollTemplateSearchInputModel payRollTemplateSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<PayRollCalculationTypeModel>(StoredProcedureConstants.SpGetPayRollCalculationTypes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPayRollCalculationTypes", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetPayRollTemplates);
                return new List<PayRollCalculationTypeModel>();
            }
        }

        public void UpdatePayrollRunEmployeePaymentStatus(List<Guid?> payrollRunEmployeeIds, bool isProcessedTopay, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                 
                    vParams.Add("@PayrollRunEmployeeIds", string.Join(",", payrollRunEmployeeIds));
                    vParams.Add("@IsProcessedToPay", isProcessedTopay);
                    vConn.Query<PayRollRunTemplate>(StoredProcedureConstants.SpUpdatePayrollRunEmployeePaymentStatus, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "payrollRunEmployeeIds", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpdatePayrollRunEmployeePaymentStatus);
              
            }

        }

        public void UpdatePayrollRunBankPointer(Guid? payrollRunId, string bankSubmittedFilePointer, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();

                    vParams.Add("@PayrollRunId", payrollRunId);
                    vParams.Add("@BankSubmittedFilePointer", bankSubmittedFilePointer);
                    vConn.Query<PayRollRunTemplate>(StoredProcedureConstants.SpUpdatePayrollRunBankPointer, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdatePayrollRunBankPointer", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetPayRollRunTemplates);

            }

        }

        public List<PayrollRunEmployee> GetEmployeePayrollDetailsList(Guid employeeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@EmployeeId", employeeId);
                    return vConn.Query<PayrollRunEmployee>(StoredProcedureConstants.SpGetEmployeePayrollDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeePayrollDetailsList", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetEmployeePayrollDetailsList);
                return new List<PayrollRunEmployee>();
            }
        }


        public List<EmployeeOutputModel> GetEmployeesListByIds(List<Guid> empIds, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    //vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@EmpIds", string.Join(",", empIds));
                    return vConn.Query<EmployeeOutputModel>(StoredProcedureConstants.SpGetUserNamesByIds, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeesListByIds", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetEmployeesListByIds);
                return new List<EmployeeOutputModel>();
            }
        }

        public EmployeeSalaryCertificateModel GetEmployeeSalaryCertificate(Guid employeeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@EmployeeId", employeeId);
                    return vConn.Query<EmployeeSalaryCertificateModel>(StoredProcedureConstants.SpGetSalaryCertificateOfAnEmployee, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeSalaryCertificate", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeSalaryCertificate);
                return new EmployeeSalaryCertificateModel();
            }
        }

        public List<FinancialYearTypeModel> GetFinancialYearTypes(PayRollTemplateSearchInputModel payRollTemplateSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<FinancialYearTypeModel>(StoredProcedureConstants.SpGetFinancialYearTypes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetFinancialYearTypes", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetPayRollTemplates);
                return new List<FinancialYearTypeModel>();
            }
        }

        public decimal? GetPayrollRunEmployeeCount(Guid? payrollRunId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    //vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@PayrollRunId", payrollRunId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<decimal?>(StoredProcedureConstants.SpGetPayrollRunEmployeeCount, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPayrollRunEmployeeCount", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetPayrollRunEmployeeCount);
                return 0;
            }
        }

        public List<ESIMonthlyStatementOutputModel> GetESIMonthlyStatement(PayRollReportsSearchInputModel payRollReportsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserId", payRollReportsSearchInputModel.UserId);
                    vParams.Add("@EntityId", payRollReportsSearchInputModel.EntityId);
                    vParams.Add("@IsActiveEmployeesOnly", payRollReportsSearchInputModel.IsActiveEmployeesOnly);
                    vParams.Add("@Date", payRollReportsSearchInputModel.Date);
                    vParams.Add("@SearchText", payRollReportsSearchInputModel.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ESIMonthlyStatementOutputModel>(StoredProcedureConstants.SpGetESIMonthlyStatement, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetESIMonthlyStatement", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionESIMonthlyStatement);
                return new List<ESIMonthlyStatementOutputModel>();
            }
        }
        public List<SalaryRegisterOutputModel> GetSalaryRegister(PayRollReportsSearchInputModel payRollReportsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserId", payRollReportsSearchInputModel.UserId);
                    vParams.Add("@EntityId", payRollReportsSearchInputModel.EntityId);
                    vParams.Add("@IsActiveEmployeesOnly", payRollReportsSearchInputModel.IsActiveEmployeesOnly);
                    vParams.Add("@DateFrom", payRollReportsSearchInputModel.DateFrom);
                    vParams.Add("@DateTo", payRollReportsSearchInputModel.DateTo);
                    vParams.Add("@SearchText", payRollReportsSearchInputModel.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<SalaryRegisterOutputModel>(StoredProcedureConstants.SpGetSalaryRegister, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetSalaryRegister", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSalaryRegister);
                return new List<SalaryRegisterOutputModel>();
            }
        }

        public List<IncomeSalaryStatementOutputModel> GetIncomeSalaryStatement(PayRollReportsSearchInputModel payRollReportsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserId", payRollReportsSearchInputModel.UserId);
                    vParams.Add("@EntityId", payRollReportsSearchInputModel.EntityId);
                    vParams.Add("@IsActiveEmployeesOnly", payRollReportsSearchInputModel.IsActiveEmployeesOnly);
                    vParams.Add("@Date", payRollReportsSearchInputModel.Date);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<IncomeSalaryStatementOutputModel>(StoredProcedureConstants.SpGetIncomeSalaryStatement, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetIncomeSalaryStatement", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionIncomeSalaryStatement);
                return new List<IncomeSalaryStatementOutputModel>();
            }
        }
        public List<ProfessionTaxMonthlyStatementOutputModel> GetProfessionTaxMonthlyStatement(PayRollReportsSearchInputModel payRollReportsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserId", payRollReportsSearchInputModel.UserId);
                    vParams.Add("@EntityId", payRollReportsSearchInputModel.EntityId);
                    vParams.Add("@IsActiveEmployeesOnly", payRollReportsSearchInputModel.IsActiveEmployeesOnly);
                    vParams.Add("@Date", payRollReportsSearchInputModel.Date);
                    vParams.Add("@PageNo", payRollReportsSearchInputModel.PageNumber);
                    vParams.Add("@SortDirection", payRollReportsSearchInputModel.SortDirection);
                    vParams.Add("@SortBy", payRollReportsSearchInputModel.SortBy);
                    vParams.Add("@PageSize", payRollReportsSearchInputModel.PageSize);
                    vParams.Add("@SearchText", payRollReportsSearchInputModel.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ProfessionTaxMonthlyStatementOutputModel>(StoredProcedureConstants.SpGetProfessionTaxMonthlyStatement, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetProfessionTaxMonthlyStatement", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionProfessionTaxMonthlyStatement);
                return new List<ProfessionTaxMonthlyStatementOutputModel>();
            }
        }
        public List<ProfessionTaxReturnsOutputModel> GetProfessionTaxReturns(PayRollReportsSearchInputModel payRollReportsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@BranchId", payRollReportsSearchInputModel.BranchId);
                    vParams.Add("@IsActiveEmployeesOnly", payRollReportsSearchInputModel.IsActiveEmployeesOnly);
                    vParams.Add("@Date", payRollReportsSearchInputModel.Date);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ProfessionTaxReturnsOutputModel>(StoredProcedureConstants.SpGetProfessionTaxReturns, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetProfessionTaxReturns", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionProfessionTaxReturns);
                return new List<ProfessionTaxReturnsOutputModel>();
            }
        }

        public List<SalaryBillRegisterOutputModel> GetSalaryBillRegister(PayRollReportsSearchInputModel payRollReportsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserId", payRollReportsSearchInputModel.UserId);
                    vParams.Add("@EntityId", payRollReportsSearchInputModel.EntityId);
                    vParams.Add("@IsActiveEmployeesOnly", payRollReportsSearchInputModel.IsActiveEmployeesOnly);
                    vParams.Add("@Date", payRollReportsSearchInputModel.Date);
                    vParams.Add("@PageNo", payRollReportsSearchInputModel.PageNumber);
                    vParams.Add("@SortDirection", payRollReportsSearchInputModel.SortDirection);
                    vParams.Add("@SortBy", payRollReportsSearchInputModel.SortBy);
                    vParams.Add("@PageSize", payRollReportsSearchInputModel.PageSize);
                    vParams.Add("@SearchText", payRollReportsSearchInputModel.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<SalaryBillRegisterOutputModel>(StoredProcedureConstants.SpGetSalaryBillRegister, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetSalaryBillRegister", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSalaryBillRegister);
                return new List<SalaryBillRegisterOutputModel>();
            }
        }
        public List<IncomeSalaryStatementDetailsOutputModel> GetIncomeSalaryStatementDetails(PayRollReportsSearchInputModel payRollReportsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserId", payRollReportsSearchInputModel.UserId);
                    vParams.Add("@EntityId", payRollReportsSearchInputModel.EntityId);
                    vParams.Add("@IsActiveEmployeesOnly", payRollReportsSearchInputModel.IsActiveEmployeesOnly);
                    vParams.Add("@Date", payRollReportsSearchInputModel.Date);
                    vParams.Add("@IsFinantialYearBased", payRollReportsSearchInputModel.IsFinantialYearBased);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<IncomeSalaryStatementDetailsOutputModel>(StoredProcedureConstants.SpGetIncomeSalaryStatementDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetIncomeSalaryStatementDetails", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionIncomeSalaryStatementDetails);
                return new List<IncomeSalaryStatementDetailsOutputModel>();
            }
        }

        public List<ITSavingsReportOutputModel> GetITSavingsReport(PayRollReportsSearchInputModel payRollReportsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserId", payRollReportsSearchInputModel.UserId);
                    vParams.Add("@EntityId", payRollReportsSearchInputModel.EntityId);
                    vParams.Add("@IsActiveEmployeesOnly", payRollReportsSearchInputModel.IsActiveEmployeesOnly);
                    vParams.Add("@PageNo", payRollReportsSearchInputModel.PageNumber);
                    vParams.Add("@SortDirection", payRollReportsSearchInputModel.SortDirection);
                    vParams.Add("@SortBy", payRollReportsSearchInputModel.SortBy);
                    vParams.Add("@PageSize", payRollReportsSearchInputModel.PageSize);
                    vParams.Add("@SearchText", payRollReportsSearchInputModel.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ITSavingsReportOutputModel>(StoredProcedureConstants.SpGetITSavingsReport, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetITSavingsReport", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionITSavingsReport);
                return new List<ITSavingsReportOutputModel>();
            }
        }

        public List<IncomeTaxMonthlyStatementOutputModel> GetIncomeTaxMonthlyStatement(PayRollReportsSearchInputModel payRollReportsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserId", payRollReportsSearchInputModel.UserId);
                    vParams.Add("@Date", payRollReportsSearchInputModel.Date);
                    vParams.Add("@EntityId", payRollReportsSearchInputModel.EntityId);
                    vParams.Add("@IsActiveEmployeesOnly", payRollReportsSearchInputModel.IsActiveEmployeesOnly);
                    vParams.Add("@PageNo", payRollReportsSearchInputModel.PageNumber);
                    vParams.Add("@SortDirection", payRollReportsSearchInputModel.SortDirection);
                    vParams.Add("@SortBy", payRollReportsSearchInputModel.SortBy);
                    vParams.Add("@PageSize", payRollReportsSearchInputModel.PageSize);
                    vParams.Add("@SearchText", payRollReportsSearchInputModel.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<IncomeTaxMonthlyStatementOutputModel>(StoredProcedureConstants.SpGetIncomeTaxMonthlyStatement, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetIncomeTaxMonthlyStatement", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionIncomeTaxMonthlyStatement);
                return new List<IncomeTaxMonthlyStatementOutputModel>();
            }
        }

        public List<SalaryForITOutputModel> GetSalaryforITOfAnEmployee(PayRollReportsSearchInputModel payRollReportsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserId", payRollReportsSearchInputModel.UserId);
                    vParams.Add("@Date", payRollReportsSearchInputModel.Date);
                    vParams.Add("@EntityId", payRollReportsSearchInputModel.EntityId);
                    vParams.Add("@IsActiveEmployeesOnly", payRollReportsSearchInputModel.IsActiveEmployeesOnly);
                    vParams.Add("@SearchText", payRollReportsSearchInputModel.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<SalaryForITOutputModel>(StoredProcedureConstants.SpGetSalaryforITOfAnEmployee, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetSalaryforITOfAnEmployee", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSalaryforITOfAnEmployee);
                return new List<SalaryForITOutputModel>();
            }
        }


        public Guid? UpsertTdsSettings(TdsSettingsUpsertInputModel TdsSettingsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@TdsSettingsId", TdsSettingsUpsertInputModel.TdsSettingsId);
                    vParams.Add("@BranchId", TdsSettingsUpsertInputModel.BranchId);
                    vParams.Add("@IsTdsRequired", TdsSettingsUpsertInputModel.IsTdsRequired);
                    vParams.Add("@IsArchived", TdsSettingsUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", TdsSettingsUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertTdsSettings, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTdsSettings", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertTdsSettings);
                return null;
            }
        }

        public List<TdsSettingsSearchOutputModel> GetTdsSettings(TdsSettingsSearchInputModel TdsSettingsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@TdsSettingsId", TdsSettingsSearchInputModel.TdsSettingsId);
                    vParams.Add("@SearchText", TdsSettingsSearchInputModel.SearchText);
                    vParams.Add("@IsArchived", TdsSettingsSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<TdsSettingsSearchOutputModel>(StoredProcedureConstants.SpGetTdsSettings, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTdsSettings", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetTdsSettings);
                return new List<TdsSettingsSearchOutputModel>();
            }
        }

        public List<HourlyTdsConfigurationSearchOutputModel> GetHourlyTdsConfiguration(HourlyTdsConfigurationSearchInputModel hourlyTdsConfigurationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@SearchText", hourlyTdsConfigurationSearchInputModel.SearchText);
                    vParams.Add("@SortBy", hourlyTdsConfigurationSearchInputModel.SortBy);
                    vParams.Add("@SortDirection", hourlyTdsConfigurationSearchInputModel.SortDirection);
                    vParams.Add("@PageNo", hourlyTdsConfigurationSearchInputModel.PageNumber);
                    vParams.Add("@PageSize", hourlyTdsConfigurationSearchInputModel.PageSize);
                    vParams.Add("@IsArchived", hourlyTdsConfigurationSearchInputModel.IsArchived);
                    return vConn.Query<HourlyTdsConfigurationSearchOutputModel>(StoredProcedureConstants.SpGetHourlyTdsConfiguration, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetHourlyTdsConfiguration", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetHourlyTdsConfiguration);
                return null;
            }
        }

        public string UpsertHourlyTdsConfiguration(HourlyTdsConfigurationUpsertInputModel hourlyTdsConfigurationUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@Id", hourlyTdsConfigurationUpsertInputModel.Id);
                    vParams.Add("@BranchId", hourlyTdsConfigurationUpsertInputModel.BranchId);
                    vParams.Add("@MaxLimit", hourlyTdsConfigurationUpsertInputModel.MaxLimit);
                    vParams.Add("@TaxPercentage", hourlyTdsConfigurationUpsertInputModel.TaxPercentage);
                    vParams.Add("@ActiveFrom", hourlyTdsConfigurationUpsertInputModel.ActiveFrom);
                    vParams.Add("@ActiveTo", hourlyTdsConfigurationUpsertInputModel.ActiveTo);
                    vParams.Add("@IsArchived", hourlyTdsConfigurationUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", hourlyTdsConfigurationUpsertInputModel.TimeStamp, DbType.Binary);
                    return vConn.Query<string>(StoredProcedureConstants.SpUpserttHourlyTdsConfiguration, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertHourlyTdsConfiguration", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertHourlyTdsConfiguration);
                return null;
            }
        }

        public List<DaysOfWeekConfigurationOutputModel> GetDaysOfWeekConfiguration(HourlyTdsConfigurationSearchInputModel hourlyTdsConfigurationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@SearchText", hourlyTdsConfigurationSearchInputModel.SearchText);
                    vParams.Add("@IsArchived", hourlyTdsConfigurationSearchInputModel.IsArchived);
                    return vConn.Query<DaysOfWeekConfigurationOutputModel>(StoredProcedureConstants.SpGetDaysOfWeekConfiguration, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDaysOfWeekConfigurations", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetDaysOfWeekConfiguration);
                return null;
            }
        }

        public string UpsertDaysOfWeekConfiguration(UpsertDaysOfWeekConfigurationInputModel upsertDaysOfWeekConfigurationInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@Id", upsertDaysOfWeekConfigurationInputModel.Id);
                    vParams.Add("@BranchId", upsertDaysOfWeekConfigurationInputModel.BranchId);
                    vParams.Add("@DayOfWeekId", upsertDaysOfWeekConfigurationInputModel.DayOfWeekId);
                    vParams.Add("@PartsOfDayId", upsertDaysOfWeekConfigurationInputModel.PartsOfDayId);
                    vParams.Add("@IsWeekend", upsertDaysOfWeekConfigurationInputModel.IsWeekend);
                    vParams.Add("@FromTime", upsertDaysOfWeekConfigurationInputModel.FromTime);
                    vParams.Add("@ToTime", upsertDaysOfWeekConfigurationInputModel.ToTime);
                    vParams.Add("@ActiveFrom", upsertDaysOfWeekConfigurationInputModel.ActiveFrom);
                    vParams.Add("@ActiveTo", upsertDaysOfWeekConfigurationInputModel.ActiveTo);
                    vParams.Add("@IsArchived", upsertDaysOfWeekConfigurationInputModel.IsArchived);
                    vParams.Add("@TimeStamp", upsertDaysOfWeekConfigurationInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsBankHoliday", upsertDaysOfWeekConfigurationInputModel.IsBankHoliday);
                    
                    return vConn.Query<string>(StoredProcedureConstants.SPUpsertDaysOfWeekConfiguration, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertDaysOfWeekConfiguration", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertDaysOfWeekConfiguration);
                return null;
            }
        }

        public List<AllowanceTimeSearchOutputModel> GetAllowanceTime(HourlyTdsConfigurationSearchInputModel hourlyTdsConfigurationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@SearchText", hourlyTdsConfigurationSearchInputModel.SearchText);
                    vParams.Add("@IsArchived", hourlyTdsConfigurationSearchInputModel.IsArchived);
                    return vConn.Query<AllowanceTimeSearchOutputModel>(StoredProcedureConstants.SpGetAllowanceTime, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllowanceTime", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetAllowanceTime);
                return null;
            }
        }

        public string UpsertAllowanceTime(UpsertAllowanceTimeInputModel upsertAllowanceTimeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@Id", upsertAllowanceTimeInputModel.Id);
                    vParams.Add("@BranchId", upsertAllowanceTimeInputModel.BranchId);
                    vParams.Add("@AllowanceRateSheetForId", upsertAllowanceTimeInputModel.AllowanceRateSheetForId);
                    vParams.Add("@MaxTime", upsertAllowanceTimeInputModel.MaxTime);
                    vParams.Add("@MinTime", upsertAllowanceTimeInputModel.MinTime);
                    vParams.Add("@ActiveFrom", upsertAllowanceTimeInputModel.ActiveFrom);
                    vParams.Add("@ActiveTo", upsertAllowanceTimeInputModel.ActiveTo);
                    vParams.Add("@IsArchived", upsertAllowanceTimeInputModel.IsArchived);
                    vParams.Add("@TimeStamp", upsertAllowanceTimeInputModel.TimeStamp, DbType.Binary);
                    return vConn.Query<string>(StoredProcedureConstants.SpUpsertAllowanceTime, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertAllowanceTime", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertAllowanceTime);
                return null;
            }
        }

        public List<ContractPayTypeModel> GetContractPayTypes(PayRollTemplateSearchInputModel payRollTemplateSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ContractPayTypeModel>(StoredProcedureConstants.SpGetContractPayTypes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetContractPayTypes", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetContractPayTypes);
                return new List<ContractPayTypeModel>();
            }
        }

        public Guid? UpsertContractPaySettings(ContractPaySettingsUpsertInputModel ContractPaySettingsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ContractPaySettingsId", ContractPaySettingsUpsertInputModel.ContractPaySettingsId);
                    vParams.Add("@BranchId", ContractPaySettingsUpsertInputModel.BranchId);
                    vParams.Add("@ContractPayTypeId", ContractPaySettingsUpsertInputModel.ContractPayTypeId);
                    vParams.Add("@ActiveFrom", ContractPaySettingsUpsertInputModel.ActiveFrom);
                    vParams.Add("@ActiveTo", ContractPaySettingsUpsertInputModel.ActiveTo);
                    vParams.Add("@IsToBePaid", ContractPaySettingsUpsertInputModel.IsToBePaid);
                    vParams.Add("@IsArchived", ContractPaySettingsUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", ContractPaySettingsUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertContractPaySettings, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertContractPaySettings", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertContractPaySettings);
                return null;
            }
        }

        public List<ContractPaySettingsSearchOutputModel> GetContractPaySettings(ContractPaySettingsSearchInputModel ContractPaySettingsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ContractPaySettingsId", ContractPaySettingsSearchInputModel.ContractPaySettingsId);
                    vParams.Add("@SearchText", ContractPaySettingsSearchInputModel.SearchText);
                    vParams.Add("@IsArchived", ContractPaySettingsSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ContractPaySettingsSearchOutputModel>(StoredProcedureConstants.SpGetContractPaySettings, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetContractPaySettings", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetContractPaySettings);
                return new List<ContractPaySettingsSearchOutputModel>();
            }
        }

        public List<PartsOfDayModel> GetPartsOfDays(PayRollTemplateSearchInputModel payRollTemplateSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<PartsOfDayModel>(StoredProcedureConstants.SpGetPartsOfDays, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPartsOfDays", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetPartsOfDays);
                return new List<PartsOfDayModel>();
            }
        }

        public Guid? UpsertEmployeeLoan(EmployeeLoanUpsertInputModel EmployeeLoanUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EmployeeLoanId", EmployeeLoanUpsertInputModel.EmployeeLoanId);
                    vParams.Add("@EmployeeId", EmployeeLoanUpsertInputModel.EmployeeId);
                    vParams.Add("@LoanAmount", EmployeeLoanUpsertInputModel.LoanAmount);
                    vParams.Add("@LoanTakenOn", EmployeeLoanUpsertInputModel.LoanTakenOn);
                    vParams.Add("@LoanInterestPercentagePerMonth", EmployeeLoanUpsertInputModel.LoanInterestPercentagePerMonth);
                    vParams.Add("@TimePeriodInMonths", EmployeeLoanUpsertInputModel.TimePeriodInMonths);
                    vParams.Add("@LoanTypeId", EmployeeLoanUpsertInputModel.LoanTypeId);
                    vParams.Add("@CompoundedPeriodId", EmployeeLoanUpsertInputModel.CompoundedPeriodId);
                    vParams.Add("@LoanPaymentStartDate", EmployeeLoanUpsertInputModel.LoanPaymentStartDate);
                    vParams.Add("@LoanBalanceAmount", EmployeeLoanUpsertInputModel.LoanBalanceAmount);
                    vParams.Add("@LoanTotalPaidAmount", EmployeeLoanUpsertInputModel.LoanTotalPaidAmount);
                    vParams.Add("@LoanClearedDate", EmployeeLoanUpsertInputModel.LoanClearedDate);
                    vParams.Add("@IsArchived", EmployeeLoanUpsertInputModel.IsArchived);
                    vParams.Add("@IsApproved", EmployeeLoanUpsertInputModel.IsApproved);
                    vParams.Add("@Name", EmployeeLoanUpsertInputModel.Name);
                    vParams.Add("@Description", EmployeeLoanUpsertInputModel.Description);
                    vParams.Add("@TimeStamp", EmployeeLoanUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);

                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertEmployeeLoan, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeLoan", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertEmployeeLoan);
                return null;
            }
        }

        public List<EmployeeLoanSearchOutputModel> GetEmployeeLoans(EmployeeLoanSearchInputModel EmployeeLoanSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EmployeeLoanId", EmployeeLoanSearchInputModel.EmployeeLoanId);
                    vParams.Add("@EmployeeId", EmployeeLoanSearchInputModel.EmployeeId);
                    vParams.Add("@SearchText", EmployeeLoanSearchInputModel.SearchText);
                    vParams.Add("@IsArchived", EmployeeLoanSearchInputModel.IsArchived);
                    vParams.Add("@IsApproved", EmployeeLoanSearchInputModel.IsApproved);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmployeeLoanSearchOutputModel>(StoredProcedureConstants.SpGetEmployeeLoans, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeLoans", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeLoans);
                return new List<EmployeeLoanSearchOutputModel>();
            }
        }

        public List<LoanTypeModel> GetLoanTypes(PayRollTemplateSearchInputModel payRollTemplateSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<LoanTypeModel>(StoredProcedureConstants.SpGetLoanTypes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetLoanTypes", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetLoanTypes);
                return new List<LoanTypeModel>();
            }
        }

        public List<EmployeeLoanInstallmentOutputModel> GetEmployeeLoanInstallment(HourlyTdsConfigurationSearchInputModel hourlyTdsConfigurationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsArchived", hourlyTdsConfigurationSearchInputModel.IsArchived);
                    vParams.Add("@EmployeeId", hourlyTdsConfigurationSearchInputModel.EmployeeId);
                    
                    return vConn.Query<EmployeeLoanInstallmentOutputModel>(StoredProcedureConstants.SpGetEmployeeLoanInstallment, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeLoanInstallment", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeLoanInstallments);
                return new List<EmployeeLoanInstallmentOutputModel>();
            }
        }

        public Guid? UpsertEmployeeLoanInstallment(EmployeeLoanInstallmentInputModel employeeLoanInstallmentInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@EmployeeId", employeeLoanInstallmentInputModel.EmployeeId);
                    vParams.Add("@Id", employeeLoanInstallmentInputModel.Id);
                    vParams.Add("@EmployeeLoanId", employeeLoanInstallmentInputModel.EmployeeLoanId);
                    vParams.Add("@InstallmentAmount", employeeLoanInstallmentInputModel.InstallmentAmount);
                    vParams.Add("@InstallmentDate", employeeLoanInstallmentInputModel.InstallmentDate);
                    vParams.Add("@IsArchived", employeeLoanInstallmentInputModel.IsArchived);
                    vParams.Add("@IsTobePaid", employeeLoanInstallmentInputModel.IsTobePaid);
                    vParams.Add("@PaidAmount", employeeLoanInstallmentInputModel.PaidAmount);
                    vParams.Add("@PrincipalAmount", employeeLoanInstallmentInputModel.PrincipalAmount);
                    vParams.Add("@TimeStamp", employeeLoanInstallmentInputModel.TimeStamp, DbType.Binary);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertEmployeeLoanInstallment, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeLoanInstallment", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertEmployeeLoanInstallment);
                return null;
            }
        }

        public Guid? EmployeeLoanCalulations(Guid? employeeLoanId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@EmployeeLoanId", employeeLoanId);
                    return vConn.Query<Guid?>("USP_GetInstallmentsForAnEmployeeLoan", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "EmployeeLoanCalulations", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertEmployeeLoan);
                return null;
            }
        }

        public Guid? EmployeeLoanInstallmentCalulations(Guid? employeeLoanInstallmentId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@EmployeeLoanInstallmentId", employeeLoanInstallmentId);
                    return vConn.Query<Guid?>("USP_UpdateInstallmentsOfAnEmployeeLoan", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "EmployeeLoanInstallmentCalulations", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertEmployeeLoanInstallment);
                return null;
            }
        }

        public PayRollMonthlyDetailsModel GetPayRollMonthlyDetails(string dateOfMonth, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {

                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@DateOfMonth", Convert.ToDateTime(dateOfMonth));
                    return vConn.Query<PayRollMonthlyDetailsModel>(StoredProcedureConstants.SpGetPayRollMonthlyDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPayRollMonthlyDetails", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetPayRollRunTemplates);
                return new PayRollMonthlyDetailsModel();
            }
        }

        public Guid? FinalPayRollRun(PayrollRun payrollRun, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@BranchId", payrollRun.BranchId);
                    vParams.Add("@EmploymentStatusIds", payrollRun.EmploymentStatusIdsList);
                    vParams.Add("@EmployeeIds", payrollRun.EmployeeIdsList);
                    vParams.Add("@PayrollTemplateId", payrollRun.TemplateId);
                    vParams.Add("@RunStartDate", payrollRun.PayrollStartDate);
                    vParams.Add("@RunEndDate", payrollRun.PayrollEndDate);
                    vParams.Add("@NewPayrollRunId", payrollRun.Id);
                    vParams.Add("@EmployeeDetails", payrollRun.EmployeeDetails);
                    vParams.Add("@ChequeDate", payrollRun.ChequeDate);
                    vParams.Add("@AlphaCode", payrollRun.AlphaCode);
                    vParams.Add("@Cheque", payrollRun.Cheque);
                    vParams.Add("@ChequeNo", payrollRun.ChequeNo);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpProduceFinalPayroll, vParams, commandType: CommandType.StoredProcedure, commandTimeout: 0).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "FinalPayRollRun", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionInsertPayrollRun);
                return null;
            }
        }


        public List<PayrollRunOutPutModel> GetPayRollRunEmployeeLeaveDetailsList(Guid? payRollRunId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@PayRollRunId", payRollRunId);

                    return vConn.Query<PayrollRunOutPutModel>(StoredProcedureConstants.SpGetPayrollRunEmployeeLeaveDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPayRollRunEmployeeLeaveDetailsList", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionInsertPayrollRun);
                return null;
            }
        }

        public List<EmployeeLoanInstallmentOutputModel> GetEmployeeLoanStatementDetails(Guid? employeeId, Guid? employeeLoanId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@EmployeeLoanId", employeeLoanId);
                    vParams.Add("@EmployeeId", employeeId);

                    return vConn.Query<EmployeeLoanInstallmentOutputModel>(StoredProcedureConstants.SpGetEmployeeLoanStatementDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeLoanStatementDetails", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionInsertPayrollRun);
                return null;
            }
        }

        public Guid? UpsertPayRollRunEmployeeComponent(PayRollRunEmployeeComponentUpsertInputModel PayRollRunEmployeeComponentUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@PayRollRunEmployeeComponentId", PayRollRunEmployeeComponentUpsertInputModel.PayRollRunEmployeeComponentId);
                    vParams.Add("@ActualComponentAmount", PayRollRunEmployeeComponentUpsertInputModel.ActualComponentAmount);
                    vParams.Add("@Comments", PayRollRunEmployeeComponentUpsertInputModel.Comments);
                    vParams.Add("@ComponentId", PayRollRunEmployeeComponentUpsertInputModel.ComponentId);
                    vParams.Add("@EmployeeId", PayRollRunEmployeeComponentUpsertInputModel.EmployeeId);
                    vParams.Add("@PayRollRunId", PayRollRunEmployeeComponentUpsertInputModel.PayRollRunId);
                    vParams.Add("@IsDeduction", PayRollRunEmployeeComponentUpsertInputModel.IsDeduction);
                    vParams.Add("@TimeStamp", PayRollRunEmployeeComponentUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertPayRollRunEmployeeComponent, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPayRollRunEmployeeComponent", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertPayRollRunEmployeeComponent);
                return null;
            }
        }
        public List<EmployeeESIReportOutputModel> GetEmployeeESIReport(PayRollReportsSearchInputModel payRollReportsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserId", payRollReportsSearchInputModel.UserId);
                    vParams.Add("@Date", payRollReportsSearchInputModel.Date);
                    vParams.Add("@EntityId", payRollReportsSearchInputModel.EntityId);
                    vParams.Add("@IsActiveEmployeesOnly", payRollReportsSearchInputModel.IsActiveEmployeesOnly);
                    vParams.Add("@SearchText", payRollReportsSearchInputModel.SearchText);
                    vParams.Add("@PageNo", payRollReportsSearchInputModel.PageNumber);
                    vParams.Add("@SortDirection", payRollReportsSearchInputModel.SortDirection);
                    vParams.Add("@SortBy", payRollReportsSearchInputModel.SortBy);
                    vParams.Add("@PageSize", payRollReportsSearchInputModel.PageSize);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmployeeESIReportOutputModel>(StoredProcedureConstants.SpGetEmployeeESIReport, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeESIReport", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionEmployeeESIReport);
                return new List<EmployeeESIReportOutputModel>();
            }
        }

        public List<RegisterOfWagesOutputModel> GetRegisterOfWages(PayRollReportsSearchInputModel payRollReportsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserId", payRollReportsSearchInputModel.UserId);
                    vParams.Add("@Date", payRollReportsSearchInputModel.Date);
                    vParams.Add("@EntityId", payRollReportsSearchInputModel.EntityId);
                    vParams.Add("@IsActiveEmployeesOnly", payRollReportsSearchInputModel.IsActiveEmployeesOnly);
                    vParams.Add("@SearchText", payRollReportsSearchInputModel.SearchText);
                    vParams.Add("@PageNo", payRollReportsSearchInputModel.PageNumber);
                    vParams.Add("@SortDirection", payRollReportsSearchInputModel.SortDirection);
                    vParams.Add("@SortBy", payRollReportsSearchInputModel.SortBy);
                    vParams.Add("@PageSize", payRollReportsSearchInputModel.PageSize);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<RegisterOfWagesOutputModel>(StoredProcedureConstants.SpGetRegisterOfWages, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetRegisterOfWages", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionRegisterOfWages);
                return new List<RegisterOfWagesOutputModel>();
            }
        }

        public List<EmployeePFReportOutputModel> GetEmployeePFReport(PayRollReportsSearchInputModel payRollReportsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserId", payRollReportsSearchInputModel.UserId);
                    vParams.Add("@Date", payRollReportsSearchInputModel.Date);
                    vParams.Add("@EntityId", payRollReportsSearchInputModel.EntityId);
                    vParams.Add("@IsActiveEmployeesOnly", payRollReportsSearchInputModel.IsActiveEmployeesOnly);
                    vParams.Add("@SearchText", payRollReportsSearchInputModel.SearchText);
                    vParams.Add("@PageNo", payRollReportsSearchInputModel.PageNumber);
                    vParams.Add("@SortDirection", payRollReportsSearchInputModel.SortDirection);
                    vParams.Add("@SortBy", payRollReportsSearchInputModel.SortBy);
                    vParams.Add("@PageSize", payRollReportsSearchInputModel.PageSize);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmployeePFReportOutputModel>(StoredProcedureConstants.SpGetEmployeePFReport, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeePFReport", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionEmployeePFReport);
                return new List<EmployeePFReportOutputModel>();
            }
        }

        public string GetTakeHomeAmount(Guid? employeeSalaryId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EmployeeSalaryId", employeeSalaryId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<string>(StoredProcedureConstants.SpGetTakeHomeAmount, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTakeHomeAmount", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionEmployeePFReport);
                return null;
            }
        }

        public string GetUserCountry(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<string>(StoredProcedureConstants.SpGetUserCountry, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserCountry", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionEmployeePFReport);
                return null;
            }
        }

        public List<RateTagOutputModel> GetRateTags(RateTagSearchCriteriaInputModel rateSheetSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@RateTagId", rateSheetSearchCriteriaInputModel.RateTagId);
                    vParams.Add("@RateTagName", rateSheetSearchCriteriaInputModel.RateTagName);
                    vParams.Add("@SearchText", rateSheetSearchCriteriaInputModel.SearchText);
                    vParams.Add("@IsArchived", rateSheetSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@RoleId", rateSheetSearchCriteriaInputModel.RoleId);
                    vParams.Add("@BranchId", rateSheetSearchCriteriaInputModel.BranchId);
                    vParams.Add("@EmployeeId", rateSheetSearchCriteriaInputModel.EmployeeId);
                    return vConn.Query<RateTagOutputModel>(StoredProcedureConstants.SpGetAllRateTags, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetRateTags", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetRateTags);
                return new List<RateTagOutputModel>();
            }
        }

        public List<RateTagForOutputModel> GetRateTagForNames(RateTagForSearchCriteriaInputModel rateTagForSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<RateTagForOutputModel>(StoredProcedureConstants.SpGetRateTagForTypes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetRateTagForNames", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetRateTagForNames);
                return new List<RateTagForOutputModel>();
            }
        }


        public Guid? UpsertRateTag(RateTagInputModel rateTagInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@RateTagId", rateTagInputModel.RateTagId);
                    vParams.Add("@RateTagName", rateTagInputModel.RateTagName);
                    vParams.Add("@RatePerHour", rateTagInputModel.RatePerHour);
                    vParams.Add("@RatePerHourMon", rateTagInputModel.RatePerHourMon);
                    vParams.Add("@RatePerHourTue", rateTagInputModel.RatePerHourTue);
                    vParams.Add("@RatePerHourWed", rateTagInputModel.RatePerHourWed);
                    vParams.Add("@RatePerHourThu", rateTagInputModel.RatePerHourThu);
                    vParams.Add("@RatePerHourFri", rateTagInputModel.RatePerHourFri);
                    vParams.Add("@RatePerHourSat", rateTagInputModel.RatePerHourSat);
                    vParams.Add("@RatePerHourSun", rateTagInputModel.RatePerHourSun);
                    vParams.Add("@TimeStamp", rateTagInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", rateTagInputModel.IsArchived);
                    vParams.Add("@RateTagForIds", rateTagInputModel.RateTagForIdsXml);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@MaxTime", rateTagInputModel.MaxTime);
                    vParams.Add("@MinTime", rateTagInputModel.MinTime);
                    vParams.Add("@EmployeeId", rateTagInputModel.EmployeeId);
                    vParams.Add("@RoleId", rateTagInputModel.RoleId);
                    vParams.Add("@BranchId", rateTagInputModel.BranchId);

                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertRateTag, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertRateTag", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionRateTag);
                return null;
            }
        }

        public Guid? InsertRateTagDetails(EmployeeRateTagDetailsAddInputModel employeeRateTagDetailsAddInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@RateTagStartDate", employeeRateTagDetailsAddInputModel.RateTagStartDate);
                    vParams.Add("@RateTagEndDate", employeeRateTagDetailsAddInputModel.RateTagEndDate);
                    vParams.Add("@RateTagEmployeeId", employeeRateTagDetailsAddInputModel.RateTagEmployeeId);
                    vParams.Add("@RateTagCurrencyId", employeeRateTagDetailsAddInputModel.RateTagCurrencyId);
                    vParams.Add("@EmployeeRateTagDetails", employeeRateTagDetailsAddInputModel.EmployeeRateTagDetailsString);
                    vParams.Add("@IsArchived", employeeRateTagDetailsAddInputModel.IsArchived);
                    vParams.Add("@IsClearCustomize", employeeRateTagDetailsAddInputModel.IsClearCustomize);
                    vParams.Add("@GroupPriority", employeeRateTagDetailsAddInputModel.GroupPriority);
                    vParams.Add("@TimeStamp", employeeRateTagDetailsAddInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpInsertRateTagDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertRateTagDetails", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionAddEmployeeRateTagDetails);
                return null;
            }
        }

        public Guid? UpdateRateTagDetails(EmployeeRateTagDetailsEditInputModel employeeRateTagDetailsEditInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EmployeeRateTagId", employeeRateTagDetailsEditInputModel.EmployeeRateTagId);
                    vParams.Add("@RateTagId", employeeRateTagDetailsEditInputModel.RateTagId);
                    vParams.Add("@RateTagCurrencyId", employeeRateTagDetailsEditInputModel.RateTagCurrencyId);
                    vParams.Add("@RateTagForId", employeeRateTagDetailsEditInputModel.RateTagForId);
                    vParams.Add("@RateTagStartDate", employeeRateTagDetailsEditInputModel.RateTagStartDate);
                    vParams.Add("@RateTagEndDate", employeeRateTagDetailsEditInputModel.RateTagEndDate);
                    vParams.Add("@RatePerHour", employeeRateTagDetailsEditInputModel.RatePerHour);
                    vParams.Add("@RatePerHourMon", employeeRateTagDetailsEditInputModel.RatePerHourMon);
                    vParams.Add("@RatePerHourTue", employeeRateTagDetailsEditInputModel.RatePerHourTue);
                    vParams.Add("@RatePerHourWed", employeeRateTagDetailsEditInputModel.RatePerHourWed);
                    vParams.Add("@RatePerHourThu", employeeRateTagDetailsEditInputModel.RatePerHourThu);
                    vParams.Add("@RatePerHourFri", employeeRateTagDetailsEditInputModel.RatePerHourFri);
                    vParams.Add("@RatePerHourSat", employeeRateTagDetailsEditInputModel.RatePerHourSat);
                    vParams.Add("@RatePerHourSun", employeeRateTagDetailsEditInputModel.RatePerHourSun);
                    vParams.Add("@RateTagEmployeeId", employeeRateTagDetailsEditInputModel.RateTagEmployeeId);
                    vParams.Add("@IsArchived", employeeRateTagDetailsEditInputModel.IsArchived);
                    vParams.Add("@TimeStamp", employeeRateTagDetailsEditInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@Priority", employeeRateTagDetailsEditInputModel.Priority);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpdateRateTagDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateRateTagDetails", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionEditEmployeeRateTagDetails);
                return null;
            }
        }

        public List<EmployeeRateTagDetailsApiReturnModel> GetEmployeeRateTagDetails(EmployeeDetailSearchCriteriaInputModel employeeDetailSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@EmployeeId", employeeDetailSearchCriteriaInputModel.EmployeeId);
                    vParams.Add("@SearchText", employeeDetailSearchCriteriaInputModel.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@StartDate", employeeDetailSearchCriteriaInputModel.StartDate);
                    vParams.Add("@EndDate", employeeDetailSearchCriteriaInputModel.EndDate);
                    vParams.Add("@GroupPriority", employeeDetailSearchCriteriaInputModel.GroupPriority);
                    vParams.Add("@RateTagRoleBranchConfigurationId", employeeDetailSearchCriteriaInputModel.RateTagRoleBranchConfigurationId);
                    return vConn.Query<EmployeeRateTagDetailsApiReturnModel>(StoredProcedureConstants.SpGetEmployeeRateTagDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeRateTagDetails", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeRateTagDetails);
                return new List<EmployeeRateTagDetailsApiReturnModel>();
            }
        }

        public List<EmployeeRateTagDetailsApiReturnModel> GetEmployeeRateTagDetailsById(EmployeeRateTagDetailsInputModel employeeRateTagDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@EmployeeId", employeeRateTagDetailsInputModel.EmployeeId);
                    vParams.Add("@SearchText", employeeRateTagDetailsInputModel.SearchText);
                    vParams.Add("@EmployeeRateTagId", employeeRateTagDetailsInputModel.EmployeeRateTagId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmployeeRateTagDetailsApiReturnModel>(StoredProcedureConstants.SpGetEmployeeRateTagDetailsById, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeRateTagDetailsById", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeRateTagDetails);
                return new List<EmployeeRateTagDetailsApiReturnModel>();
            }
        }

        public List<RateTagAllowanceTimeSearchOutputModel> GetRateTagAllowanceTime(HourlyTdsConfigurationSearchInputModel hourlyTdsConfigurationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@SearchText", hourlyTdsConfigurationSearchInputModel.SearchText);
                    vParams.Add("@IsArchived", hourlyTdsConfigurationSearchInputModel.IsArchived);
                    return vConn.Query<RateTagAllowanceTimeSearchOutputModel>(StoredProcedureConstants.SpGetRateTagAllowanceTime, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetRateTagAllowanceTime", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetRateTagAllowanceTime);
                return null;
            }
        }

        public string UpsertRateTagAllowanceTime(UpsertRateTagAllowanceTimeInputModel upsertRateTagAllowanceTimeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@Id", upsertRateTagAllowanceTimeInputModel.Id);
                    vParams.Add("@BranchId", upsertRateTagAllowanceTimeInputModel.BranchId);
                    vParams.Add("@AllowanceRateTagForId", upsertRateTagAllowanceTimeInputModel.AllowanceRateTagForId);
                    vParams.Add("@AllowanceRateTagForIds", upsertRateTagAllowanceTimeInputModel.AllowanceRateTagForIdsXml);
                    vParams.Add("@MaxTime", upsertRateTagAllowanceTimeInputModel.MaxTime);
                    vParams.Add("@MinTime", upsertRateTagAllowanceTimeInputModel.MinTime);
                    vParams.Add("@ActiveFrom", upsertRateTagAllowanceTimeInputModel.ActiveFrom);
                    vParams.Add("@ActiveTo", upsertRateTagAllowanceTimeInputModel.ActiveTo);
                    vParams.Add("@IsBankHoliday", upsertRateTagAllowanceTimeInputModel.IsBankHoliday);
                    vParams.Add("@IsArchived", upsertRateTagAllowanceTimeInputModel.IsArchived);
                    vParams.Add("@TimeStamp", upsertRateTagAllowanceTimeInputModel.TimeStamp, DbType.Binary);
                    return vConn.Query<string>(StoredProcedureConstants.SpUpsertRateTagAllowanceTime, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertRateTagAllowanceTime", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertRateTagAllowanceTime);
                return null;
            }
        }

        public Guid? UpsertPartsOfDay(PartsOfDayUpsertInputModel PartsOfDayUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@PartsOfDayId", PartsOfDayUpsertInputModel.PartsOfDayId);
                    vParams.Add("@PartsOfDayName", PartsOfDayUpsertInputModel.PartsOfDayName);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertPartsOfDay, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPartsOfDay", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertPartsOfDay);
                return null;
            }
        }

        public List<BankModel> GetBanks(BankSearchInputModel bankSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsArchived", bankSearchInputModel.IsArchived);
                    vParams.Add("@EmployeeId", bankSearchInputModel.EmployeeId);
                    vParams.Add("@BranchId", bankSearchInputModel.BranchId);
                    vParams.Add("@IsApp", bankSearchInputModel.IsApp);
                    return vConn.Query<BankModel>(StoredProcedureConstants.SpGetBanks, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetBanks", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetPayRollTemplates);
                return new List<BankModel>();
            }
        }

        public Guid? UpdateStatusOfPayrollComponents(Guid? PayrollRunId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@PayrollRunId", PayrollRunId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpdateStatusOfPayrollComponents, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateStatusOfPayrollComponents", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpdatePayrollRunStatus);
                return null;
            }
        }

        public Guid? InsertRateTagConfigurations(RateTagConfigurationAddInputModel employeeRateTagConfigurationAddInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@RateTagRoleBranchConfigurationId", employeeRateTagConfigurationAddInputModel.RateTagRoleBranchConfigurationId);
                    vParams.Add("@RateTagCurrencyId", employeeRateTagConfigurationAddInputModel.RateTagCurrencyId);
                    vParams.Add("@RateTagDetails", employeeRateTagConfigurationAddInputModel.RateTagConfigurationString);
                    vParams.Add("@IsArchived", employeeRateTagConfigurationAddInputModel.IsArchived);
                    vParams.Add("@TimeStamp", employeeRateTagConfigurationAddInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpInsertRateTagConfigurations, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertRateTagConfigurations", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionAddRateTagConfiguration);
                return null;
            }
        }

        public Guid? UpdateRateTagConfiguration(RateTagConfigurationEditInputModel employeeRateTagConfigurationEditInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@RateTagConfigurationId", employeeRateTagConfigurationEditInputModel.RateTagConfigurationId);
                    vParams.Add("@RateTagRoleBranchConfigurationId", employeeRateTagConfigurationEditInputModel.RateTagRoleBranchConfigurationId);
                    vParams.Add("@RateTagId", employeeRateTagConfigurationEditInputModel.RateTagId);
                    vParams.Add("@RateTagCurrencyId", employeeRateTagConfigurationEditInputModel.RateTagCurrencyId);
                    vParams.Add("@RateTagForId", employeeRateTagConfigurationEditInputModel.RateTagForId);
                    vParams.Add("@RatePerHour", employeeRateTagConfigurationEditInputModel.RatePerHour);
                    vParams.Add("@RatePerHourMon", employeeRateTagConfigurationEditInputModel.RatePerHourMon);
                    vParams.Add("@RatePerHourTue", employeeRateTagConfigurationEditInputModel.RatePerHourTue);
                    vParams.Add("@RatePerHourWed", employeeRateTagConfigurationEditInputModel.RatePerHourWed);
                    vParams.Add("@RatePerHourThu", employeeRateTagConfigurationEditInputModel.RatePerHourThu);
                    vParams.Add("@RatePerHourFri", employeeRateTagConfigurationEditInputModel.RatePerHourFri);
                    vParams.Add("@RatePerHourSat", employeeRateTagConfigurationEditInputModel.RatePerHourSat);
                    vParams.Add("@RatePerHourSun", employeeRateTagConfigurationEditInputModel.RatePerHourSun);
                    vParams.Add("@IsArchived", employeeRateTagConfigurationEditInputModel.IsArchived);
                    vParams.Add("@TimeStamp", employeeRateTagConfigurationEditInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@Priority", employeeRateTagConfigurationEditInputModel.Priority);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpdateRateTagConfiguration, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateRateTagConfiguration", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionEditRateTagConfiguration);
                return null;
            }
        }


        public List<RateTagConfigurationsApiReturnModel> GetRateTagConfigurations(RateTagConfigurationsInputModel rateTagConfigurationsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@RateTagRoleBranchConfigurationId", rateTagConfigurationsInputModel.RateTagRoleBranchConfigurationId);
                    vParams.Add("@StartDate", rateTagConfigurationsInputModel.StartDate);
                    vParams.Add("@EndDate", rateTagConfigurationsInputModel.EndDate);
                    vParams.Add("@IsArchived", rateTagConfigurationsInputModel.IsArchived);
                    return vConn.Query<RateTagConfigurationsApiReturnModel>(StoredProcedureConstants.SpGetRateTagConfigurations, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetRateTagConfigurations", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetRateTagConfigurations);
                return new List<RateTagConfigurationsApiReturnModel>();
            }
        }


        public Guid? ArchivePayRoll(PayRollRunArchiveInputModel payRollRunArchiveInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@PayRollRunId", payRollRunArchiveInputModel.PayRollRunId);
                    vParams.Add("@TimeStamp", payRollRunArchiveInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", payRollRunArchiveInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);

                    return vConn.Query<Guid?>(StoredProcedureConstants.SpArchivePayRoll, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ArchivePayRoll", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionArchivePayRoll);
                return null;
            }
        }

        public Guid? UpsertRateTagRoleBranchConfiguration(RateTagRoleBranchConfigurationUpsertInputModel rateTagRoleBranchConfigurationUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@RateTagRoleBranchConfigurationId", rateTagRoleBranchConfigurationUpsertInputModel.RateTagRoleBranchConfigurationId);
                    vParams.Add("@StartDate", rateTagRoleBranchConfigurationUpsertInputModel.StartDate);
                    vParams.Add("@EndDate", rateTagRoleBranchConfigurationUpsertInputModel.EndDate);
                    vParams.Add("@BranchId", rateTagRoleBranchConfigurationUpsertInputModel.BranchId);
                    vParams.Add("@RoleId", rateTagRoleBranchConfigurationUpsertInputModel.RoleId);
                    vParams.Add("@Priority", rateTagRoleBranchConfigurationUpsertInputModel.Priority);
                    vParams.Add("@IsArchived", rateTagRoleBranchConfigurationUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", rateTagRoleBranchConfigurationUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertRateTagRoleBranchConfiguration, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertRateTagRoleBranchConfiguration", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionEditRateTagConfiguration);
                return null;
            }
        }

        public List<RateTagRoleBranchConfigurationApiReturnModel> GetRateTagRoleBranchConfigurations(RateTagRoleBranchConfigurationInputModel rateTagConfigurationsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsArchived", rateTagConfigurationsInputModel.IsArchived);
                    

                    return vConn.Query<RateTagRoleBranchConfigurationApiReturnModel>(StoredProcedureConstants.SpGetRateTagRoleBranchConfigurations, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetRateTagRoleBranchConfigurations", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetRateTagConfigurations);
                return new List<RateTagRoleBranchConfigurationApiReturnModel>();
            }
        }

        public Guid? UpsertBank(BankUpsertInputModel bankUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@BankId", bankUpsertInputModel.BankId);
                    vParams.Add("@CountryId", bankUpsertInputModel.CountryId);
                    vParams.Add("@BankName", bankUpsertInputModel.BankName);
                    vParams.Add("@IsArchived", bankUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", bankUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertBank, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertBank", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionEditRateTagConfiguration);
                return null;
            }
        }

        public List<PayRollBandsSearchOutputModel> GetPayRollBands(PayRollBandsSearchInputModel PayRollBandSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@IsArchived", PayRollBandSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<PayRollBandsSearchOutputModel>(StoredProcedureConstants.SpGetPayRollBands, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPayRollBands", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetPayRollBands);
                return new List<PayRollBandsSearchOutputModel>();
            }
        }

        public Guid? UpsertPayRollBands(PayRollBandsUpsertInputModel PayRollTemplateUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@PayRollBandId", PayRollTemplateUpsertInputModel.PayRollBandId);
                    vParams.Add("@Name", PayRollTemplateUpsertInputModel.Name);
                    vParams.Add("@FromRange", PayRollTemplateUpsertInputModel.FromRange);
                    vParams.Add("@ToRange", PayRollTemplateUpsertInputModel.ToRange);
                    vParams.Add("@Percentage", PayRollTemplateUpsertInputModel.Percentage);
                    vParams.Add("@ActiveFrom", PayRollTemplateUpsertInputModel.ActiveFrom);
                    vParams.Add("@ActiveTo", PayRollTemplateUpsertInputModel.ActiveTo);
                    vParams.Add("@IsArchived", PayRollTemplateUpsertInputModel.IsArchived);
                    vParams.Add("@ParentId", PayRollTemplateUpsertInputModel.ParentId);
                    vParams.Add("@CountryId", PayRollTemplateUpsertInputModel.CountryId);
                    vParams.Add("@PayRollComponentId", PayRollTemplateUpsertInputModel.PayRollComponentId);
                    vParams.Add("@MinAge", PayRollTemplateUpsertInputModel.MinAge);
                    vParams.Add("@MaxAge", PayRollTemplateUpsertInputModel.MaxAge);
                    vParams.Add("@ForMale", PayRollTemplateUpsertInputModel.ForMale);
                    vParams.Add("@ForFemale", PayRollTemplateUpsertInputModel.ForFemale);
                    vParams.Add("@Handicapped", PayRollTemplateUpsertInputModel.Handicapped);
                    vParams.Add("@IsMarried", PayRollTemplateUpsertInputModel.IsMarried);
                    vParams.Add("@Order", PayRollTemplateUpsertInputModel.Order);
                    vParams.Add("@TimeStamp", PayRollTemplateUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertPayRollBands, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPayRollBands", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertPayRollBand);
                return null;
            }
        }

        public Guid? UpsertEmployeePreviousCompanyTax(EmployeePreviousCompanyTaxUpsertInputModel EmployeePreviousCompanyTaxUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EmployeePreviousCompanyTaxId", EmployeePreviousCompanyTaxUpsertInputModel.EmployeePreviousCompanyTaxId);
                    vParams.Add("@EmployeeId", EmployeePreviousCompanyTaxUpsertInputModel.EmployeeId);
                    vParams.Add("@TaxAmount", EmployeePreviousCompanyTaxUpsertInputModel.TaxAmount);
                    vParams.Add("@IsArchived", EmployeePreviousCompanyTaxUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", EmployeePreviousCompanyTaxUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertEmployeePreviousCompanyTax, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeePreviousCompanyTax", "PayRollRepository", sqlException.Message), sqlException);


                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertEmployeePreviousCompanyTax);
                return null;
            }
        }

        public List<EmployeePreviousCompanyTaxSearchOutputModel> GetEmployeePreviousCompanyTaxes(EmployeePreviousCompanyTaxSearchInputModel EmployeePreviousCompanyTaxSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EmployeePreviousCompanyTaxId", EmployeePreviousCompanyTaxSearchInputModel.EmployeePreviousCompanyTaxId);
                    vParams.Add("@IsArchived", EmployeePreviousCompanyTaxSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmployeePreviousCompanyTaxSearchOutputModel>(StoredProcedureConstants.SpGetEmployeePreviousCompanyTaxes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeePreviousCompanyTaxes", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeePreviousCompanyTaxes);
                return new List<EmployeePreviousCompanyTaxSearchOutputModel>();
            }
        }

        public List<TaxCalculationTypeModel> GetTaxCalculationTypes(TaxCalculationTypeModel taxCalculationTypeModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@EmployeeId", taxCalculationTypeModel.EmployeeId);  
                    return vConn.Query<TaxCalculationTypeModel>(StoredProcedureConstants.SpGetTaxCalculationTypes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTaxCalculationTypes", "PayRoll Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetPayRollTemplates);
                return new List<TaxCalculationTypeModel>();
            }
        }

        public Guid? UpsertPayRollRunEmployeeComponentYTD(PayRollRunEmployeeComponentUpsertInputModel PayRollRunEmployeeComponentYTDUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@PayRollRunEmployeeComponentYTDId", PayRollRunEmployeeComponentYTDUpsertInputModel.PayRollRunEmployeeComponentYtdId);
                    vParams.Add("@OriginalComponentAmount", PayRollRunEmployeeComponentYTDUpsertInputModel.OriginalComponentAmount);
                    vParams.Add("@Comments", PayRollRunEmployeeComponentYTDUpsertInputModel.YTDComments);
                    vParams.Add("@ComponentId", PayRollRunEmployeeComponentYTDUpsertInputModel.ComponentId);
                    vParams.Add("@EmployeeId", PayRollRunEmployeeComponentYTDUpsertInputModel.EmployeeId);
                    vParams.Add("@PayRollRunId", PayRollRunEmployeeComponentYTDUpsertInputModel.PayRollRunId);
                    vParams.Add("@IsDeduction", PayRollRunEmployeeComponentYTDUpsertInputModel.IsDeduction);
                    vParams.Add("@ComponentAmount", PayRollRunEmployeeComponentYTDUpsertInputModel.ComponentAmount);
                    vParams.Add("@TimeStamp", PayRollRunEmployeeComponentYTDUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);

                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertPayRollRunEmployeeComponentYTD, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPayRollRunEmployeeComponentYTD", "PayRoll Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertPayRollRunEmployeeComponentYTD);
                return null;
            }
        }

        public List<EmployeeRateTagConfigurationApiReturnModel> GetEmployeeRateTagConfigurations(EmployeeRateTagConfigurationInputModel rateTagConfigurationsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {       
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@EmployeeId", rateTagConfigurationsInputModel.EmployeeId);
                    return vConn.Query<EmployeeRateTagConfigurationApiReturnModel>(StoredProcedureConstants.SpGetEmployeeRateTagConfigurations, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeRateTagConfigurations", "PayRoll Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetRateTagConfigurations);
                return new List<EmployeeRateTagConfigurationApiReturnModel>();
            }
        }
    }
}
