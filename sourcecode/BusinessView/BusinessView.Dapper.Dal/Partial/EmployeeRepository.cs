using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.Employee;
using Btrak.Models.HrManagement;
using Btrak.Models.User;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class EmployeeRepository
    {
        //NEW CODE
        public Guid? UpsertEmployee(EmployeeInputModel employeeModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EmployeeId", employeeModel.EmployeeId);
                    vParams.Add("@UserId", employeeModel.UserId);
                    vParams.Add("@EmployeeNumber", employeeModel.EmployeeNumber);
                    vParams.Add("@GenderId", employeeModel.GenderId);
                    vParams.Add("@MaritalStatusId", employeeModel.MaritalStatusId);
                    vParams.Add("@NationalityId", employeeModel.NationalityId);
                    vParams.Add("@DateofBirth", employeeModel.DateOfBirth);
                    vParams.Add("@Smoker", employeeModel.Smoker);
                    vParams.Add("@BranchId", employeeModel.BranchId);
                    vParams.Add("@MilitaryService", employeeModel.MilitaryService);
                    vParams.Add("@NickName", employeeModel.NickName);
                    vParams.Add("@ShiftTimingId", employeeModel.ShiftTimingId);
                    vParams.Add("@TimeStamp", employeeModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", employeeModel.IsArchived);
                    //vParams.Add("@IsTerminated", employeeModel.IsTerminated);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertEmployee, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployee", "EmployeeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertEmployee);
                return null;
            }
        }

        public List<EmployeeOutputModel> GetAllEmployees(EmployeeSearchCriteriaInputModel employeeSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EmployeeId", employeeSearchCriteriaInputModel.EmployeeId);
                    vParams.Add("@UserId", employeeSearchCriteriaInputModel.UserId);
                    vParams.Add("@IsActive", employeeSearchCriteriaInputModel.IsActive);
                    vParams.Add("@EmailSearchText", employeeSearchCriteriaInputModel.EmailSearchText);
                    vParams.Add("@DepartmentId", employeeSearchCriteriaInputModel.DepartmentId);
                    vParams.Add("@DesignationId", employeeSearchCriteriaInputModel.DesignationId);
                    vParams.Add("@EmploymentStatusId", employeeSearchCriteriaInputModel.EmploymentStatusId);
                    vParams.Add("@IsTerminated", employeeSearchCriteriaInputModel.IsTerminated);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@SearchText", employeeSearchCriteriaInputModel.SearchText);
                    vParams.Add("@LineManagerId", employeeSearchCriteriaInputModel.LineManagerId);
                    vParams.Add("@BranchId", employeeSearchCriteriaInputModel.BranchId);
                    vParams.Add("@PageNo", employeeSearchCriteriaInputModel.PageNumber);
                    vParams.Add("@PageSize", employeeSearchCriteriaInputModel.PageSize);
                    vParams.Add("@SortBy", employeeSearchCriteriaInputModel.SortBy);
                    vParams.Add("@SortDirection", employeeSearchCriteriaInputModel.SortDirection);
                    vParams.Add("@IsArchived", employeeSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@EntityId", employeeSearchCriteriaInputModel.EntityId);
                    vParams.Add("@IsReportTo", employeeSearchCriteriaInputModel.IsReportTo);
                    vParams.Add("@PayRollTemplateId", employeeSearchCriteriaInputModel.PayRollTemplateId);
                    
                    return vConn.Query<EmployeeOutputModel>(StoredProcedureConstants.SpGetAllEmployees, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllEmployees", "EmployeeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllEmployees);
                return new List<EmployeeOutputModel>();
            }
        }
        public Guid? UpsertEmployeeFields(EmployeeFieldsModel employeeFieldsModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Id", employeeFieldsModel.Id);
                    vParams.Add("@IsRequired", employeeFieldsModel.IsRequired);
                    vParams.Add("@IsHide", employeeFieldsModel.IsHide);
                    vParams.Add("@FieldName", employeeFieldsModel.FieldName);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertEmployeesFields, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeFields", "EmployeeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllEmployees);
                return null;
            }
        }
        public List<EmployeeFieldsModel> GetEmployeeFields(EmployeeFieldsModel employeeFieldsModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmployeeFieldsModel>(StoredProcedureConstants.SpGetEmployeeFields, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeFields", "EmployeeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllEmployees);
                return new List<EmployeeFieldsModel>();
            }
        }

        public List<EmployeeListApiOutputModel> GetEmployeesList(EmployeeSearchCriteriaInputModel employeeSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EmployeeId", employeeSearchCriteriaInputModel.EmployeeId);
                    vParams.Add("@UserId", employeeSearchCriteriaInputModel.UserId);
                    vParams.Add("@IsActive", employeeSearchCriteriaInputModel.IsActive);
                    vParams.Add("@EmailSearchText", employeeSearchCriteriaInputModel.EmailSearchText);
                    vParams.Add("@DepartmentId", employeeSearchCriteriaInputModel.DepartmentId);
                    vParams.Add("@DesignationId", employeeSearchCriteriaInputModel.DesignationId);
                    vParams.Add("@EmploymentStatusId", employeeSearchCriteriaInputModel.EmploymentStatusId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@SearchText", employeeSearchCriteriaInputModel.SearchText);
                    vParams.Add("@EntityId", employeeSearchCriteriaInputModel.EntityId);
                    vParams.Add("@LineManagerId", employeeSearchCriteriaInputModel.LineManagerId);
                    vParams.Add("@PageNo", employeeSearchCriteriaInputModel.PageNumber);
                    vParams.Add("@PageSize", employeeSearchCriteriaInputModel.PageSize);
                    vParams.Add("@SortBy", employeeSearchCriteriaInputModel.SortBy);
                    vParams.Add("@SortDirection", employeeSearchCriteriaInputModel.SortDirection);
                    return vConn.Query<EmployeeListApiOutputModel>(StoredProcedureConstants.SpGetEmployeesList, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeesList", "EmployeeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllEmployees);
                return new List<EmployeeListApiOutputModel>();
            }
        }

        public List<EmployeeDetailsApiOutputModel> GetAllEmployeeDetails(EmployeeSearchCriteriaInputModel employeeSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EmployeeId", employeeSearchCriteriaInputModel.EmployeeId);
                    vParams.Add("@UserId", employeeSearchCriteriaInputModel.UserId);
                    vParams.Add("@EmailSearchText", employeeSearchCriteriaInputModel.EmailSearchText);
                    vParams.Add("@DepartmentId", employeeSearchCriteriaInputModel.DepartmentId);
                    vParams.Add("@DesignationId", employeeSearchCriteriaInputModel.DesignationId);
                    vParams.Add("@EmploymentStatusId", employeeSearchCriteriaInputModel.EmploymentStatusId);
                    vParams.Add("@IsTerminated", employeeSearchCriteriaInputModel.IsTerminated);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@SearchText", employeeSearchCriteriaInputModel.SearchText);
                    vParams.Add("@LineManagerId", employeeSearchCriteriaInputModel.LineManagerId);
                    vParams.Add("@BranchId", employeeSearchCriteriaInputModel.BranchId);
                    vParams.Add("@PageNo", employeeSearchCriteriaInputModel.PageNumber);
                    vParams.Add("@PageSize", employeeSearchCriteriaInputModel.PageSize);
                    vParams.Add("@SortBy", employeeSearchCriteriaInputModel.SortBy);
                    vParams.Add("@SortDirection", employeeSearchCriteriaInputModel.SortDirection);
                    vParams.Add("@IsArchived", employeeSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@EntityId", employeeSearchCriteriaInputModel.EntityId);
                    vParams.Add("@IsReportTo", employeeSearchCriteriaInputModel.IsReportTo);
                    return vConn.Query<EmployeeDetailsApiOutputModel>(StoredProcedureConstants.SPGetAllEmployeeDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllEmployeeDetails", "EmployeeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllEmployees);
                return new List<EmployeeDetailsApiOutputModel>();
            }
        }

        public Guid? UpsertEmployeePersonalDetails(EmployeePersonalDetailsInputModel employeePersonalDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserId", employeePersonalDetailsInputModel.UserId);
                    vParams.Add("@EmployeeId", employeePersonalDetailsInputModel.EmployeeId);
                    vParams.Add("@FirstName", employeePersonalDetailsInputModel.FirstName);
                    vParams.Add("@Surname", employeePersonalDetailsInputModel.SurName);
                    vParams.Add("@Email", employeePersonalDetailsInputModel.Email);
                    vParams.Add("@NationalityId", employeePersonalDetailsInputModel.NationalityId);
                    vParams.Add("@Taxcode", employeePersonalDetailsInputModel.TaxCode);
                    vParams.Add("@DateOfBirth", employeePersonalDetailsInputModel.DateOfBirth);
                    vParams.Add("@GenderId", employeePersonalDetailsInputModel.GenderId);
                    vParams.Add("@MaritalStatusId", employeePersonalDetailsInputModel.MaritalStatusId);
                    vParams.Add("@RoleIds", employeePersonalDetailsInputModel.RoleIds);
                    vParams.Add("@IsActive", employeePersonalDetailsInputModel.IsActive);
                    vParams.Add("@RegisteredDateTime", employeePersonalDetailsInputModel.RegisteredDateTime);
                    vParams.Add("@IsActiveOnMobile", employeePersonalDetailsInputModel.IsActiveOnMobile);
                    vParams.Add("@MobileNo", employeePersonalDetailsInputModel.MobileNo);
                    vParams.Add("@Password", employeePersonalDetailsInputModel.Password);
                    vParams.Add("@TimeStamp", employeePersonalDetailsInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", employeePersonalDetailsInputModel.IsArchived);
                    vParams.Add("@DateOfJoining", employeePersonalDetailsInputModel.DateOfJoining);
                    vParams.Add("@JobCategoryId", employeePersonalDetailsInputModel.JobCategoryId);
                    vParams.Add("@DesignationId", employeePersonalDetailsInputModel.DesignationId);
                    vParams.Add("@EmploymentStatusId", employeePersonalDetailsInputModel.EmploymentStatusId);
                    vParams.Add("@EmployeeNumber", employeePersonalDetailsInputModel.EmployeeNumber);
                    vParams.Add("@ShiftTimingId", employeePersonalDetailsInputModel.ShiftTimingId);
                    vParams.Add("@BranchId", employeePersonalDetailsInputModel.BranchId);
                    vParams.Add("@TimeZoneId", employeePersonalDetailsInputModel.TimeZoneId);
                    vParams.Add("@CurrencyId", employeePersonalDetailsInputModel.CurrencyId);
                    vParams.Add("@IsUpsertEmployee", employeePersonalDetailsInputModel.IsUpsertEmployee);
                    vParams.Add("@ActiveFrom", employeePersonalDetailsInputModel.ActiveFrom);
                    vParams.Add("@ActiveTo", employeePersonalDetailsInputModel.ActiveTo);
                    vParams.Add("@Salary", employeePersonalDetailsInputModel.Salary);
                    vParams.Add("@PayrollTemplateId", employeePersonalDetailsInputModel.PayrollTemplateId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@PermittedBranches", employeePersonalDetailsInputModel.PermittedBranchIds);
                    vParams.Add("@BusinessUnitXML", employeePersonalDetailsInputModel.BusinessUnitXML);
                    vParams.Add("@MacAddress", employeePersonalDetailsInputModel.MacAddress);
                    vParams.Add("@MarriageDate", employeePersonalDetailsInputModel.MarriageDate);
                    vParams.Add("@EmployeeShiftId", employeePersonalDetailsInputModel.EmployeeShiftId);
                    vParams.Add("@IPNumber", employeePersonalDetailsInputModel.IPNumber);
                    vParams.Add("@DepartmentId", employeePersonalDetailsInputModel.DepartmentId);
                    vParams.Add("@UserAuthenticationId", employeePersonalDetailsInputModel.UserAuthenticationId);
                    vParams.Add("@FormJson", employeePersonalDetailsInputModel.FormSourc);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertEmployeePersonalDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeePersonalDetails", "EmployeeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertEmployeePersonalDetails);
                return null;
            }
        }

        public List<EmployeePersonalDetailsApiReturnModel> GetEmployeePersonalDetails(EmployeeDetailSearchCriteriaInputModel employeeDetailSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@EmployeeId", employeeDetailSearchCriteriaInputModel.EmployeeId);
                    vParams.Add("@SearchText", employeeDetailSearchCriteriaInputModel.SearchText);
                    vParams.Add("@PageNo", employeeDetailSearchCriteriaInputModel.PageNumber);
                    vParams.Add("@PageSize", employeeDetailSearchCriteriaInputModel.PageSize);
                    vParams.Add("@IsArchived", employeeDetailSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@IsReporting", employeeDetailSearchCriteriaInputModel.IsReporting);
                    vParams.Add("@IsPermission", employeeDetailSearchCriteriaInputModel.IsPermission);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmployeePersonalDetailsApiReturnModel>(StoredProcedureConstants.SpGetEmployeePersonalDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeePersonalDetails", "EmployeeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeePersonalDetails);
                return new List<EmployeePersonalDetailsApiReturnModel>();
            }
        }

        public Guid? UpsertEmployeeLicenceDetails(EmployeeLicenceDetailsInputModel employeeLicenceDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EmployeeLicenceDetailId", employeeLicenceDetailsInputModel.EmployeeLicenceDetailId);
                    vParams.Add("@EmployeeId", employeeLicenceDetailsInputModel.EmployeeId);
                    vParams.Add("@LicenceTypeId", employeeLicenceDetailsInputModel.LicenceTypeId);
                    vParams.Add("@LicenceNumber", employeeLicenceDetailsInputModel.LicenceNumber);
                    vParams.Add("@LicenceIssuedDate", employeeLicenceDetailsInputModel.LicenceIssuedDate);
                    vParams.Add("@LicenceExpiryDate", employeeLicenceDetailsInputModel.LicenceExpiryDate);
                    vParams.Add("@TimeStamp", employeeLicenceDetailsInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", employeeLicenceDetailsInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertEmployeeLicenceDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeLicenceDetails", "EmployeeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertEmployeeLicenceDetails);
                return null;
            }
        }

        public Guid? UpsertEmployeeContactDetails(EmployeeContactDetailsInputModel employeeContactDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EmployeeContactDetailId", employeeContactDetailsInputModel.EmployeeContactDetailId);
                    vParams.Add("@EmployeeId", employeeContactDetailsInputModel.EmployeeId);
                    vParams.Add("@StateId", employeeContactDetailsInputModel.StateId);
                    vParams.Add("@Address1", employeeContactDetailsInputModel.Address1);
                    vParams.Add("@Address2", employeeContactDetailsInputModel.Address2);
                    vParams.Add("@PostalCode", employeeContactDetailsInputModel.PostalCode);
                    vParams.Add("@CountryId", employeeContactDetailsInputModel.CountryId);
                    vParams.Add("@HomeTelephone", employeeContactDetailsInputModel.HomeTelephone);
                    vParams.Add("@Mobile", employeeContactDetailsInputModel.Mobile);
                    vParams.Add("@WorkTelephone", employeeContactDetailsInputModel.WorkTelephone);
                    vParams.Add("@WorkEmail", employeeContactDetailsInputModel.WorkEmail);
                    vParams.Add("@OtherEmail", employeeContactDetailsInputModel.OtherEmail);
                    vParams.Add("@ContactPersonName", employeeContactDetailsInputModel.ContactPersonName);
                    vParams.Add("@RelationshipId", employeeContactDetailsInputModel.RelationshipId);
                    vParams.Add("@DateOfBirth", employeeContactDetailsInputModel.DateOfBirth);
                    vParams.Add("@EmployeeContactTypeId", employeeContactDetailsInputModel.EmployeeContactTypeId);
                    vParams.Add("@TimeStamp", employeeContactDetailsInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", employeeContactDetailsInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertEmployeeContactDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeContactDetails", "EmployeeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertEmployeeContactDetails);
                return null;
            }
        }

        public List<EmployeeOverViewDetailsOutputModel> GetEmployeeOverViewDetails(Guid? employeeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@EmployeeId", employeeId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmployeeOverViewDetailsOutputModel>(StoredProcedureConstants.SpGetEmployeeOverViewDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeOverViewDetails", "EmployeeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeOverViewDetails);
                return new List<EmployeeOverViewDetailsOutputModel>();
            }
        }

        public Guid GetEmployeeId(Guid userId)
        {
            using (IDbConnection vConn = OpenConnection())
            {
                DynamicParameters vParams = new DynamicParameters();
                vParams.Add("@UserId", userId);
                return vConn.Query<Guid>("usp_GetEmployeeId", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }

        public List<TeamMemberOutputModel> GetMyTeamMembersList(SearchModel searchModel,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@SearchText", searchModel.SearchText);
                    vParams.Add("@IsAllUsers", searchModel.IsAllUsers);
                    vParams.Add("@IsArchived", searchModel.IsArchived);
                    vParams.Add("@IsForTracker", searchModel.IsForTracker);
                    return vConn.Query<TeamMemberOutputModel>(StoredProcedureConstants.SpGetMyTeamLeadsList, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetMyTeamMembersList", "EmployeeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetMyTeamMembersList);
                return new List<TeamMemberOutputModel>();
            }
        }

        public List<UserOutputModel> GetEmployeeReportToMembers(Guid? userId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserId", userId);
                    return vConn.Query<UserOutputModel>(StoredProcedureConstants.SpGetEmployeeReportToMembers, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeReportToMembers", "EmployeeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetMyMemberId);
                return new List<UserOutputModel>();
            }
        }

        public List<EmployeeOverViewDetailsOutputModel> GetMyEmployeeId(Guid? userId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserId", userId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmployeeOverViewDetailsOutputModel>(StoredProcedureConstants.SpGetAllEmployees, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetMyEmployeeId", "EmployeeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetMyMemberId);
                return new List<EmployeeOverViewDetailsOutputModel>();
            }
        }

        public EmployeeDetailsOutputModel GetMyEmployeeDetalis(Guid employeeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserId", employeeId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmployeeDetailsOutputModel>(StoredProcedureConstants.SpGetEmployeeDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetMyEmployeeDetalis", "EmployeeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetMyEmployeeDetails);
                return new EmployeeDetailsOutputModel();
            }
        }


        public Guid? UpsertBadge(BadgeModel badgeModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@BadgeId", badgeModel.BadgeId);
                    vParams.Add("@BadgeName", badgeModel.BadgeName);
                    vParams.Add("@ImageUrl", badgeModel.ImageUrl);
                    vParams.Add("@Description", badgeModel.Description);
                    vParams.Add("@Timestamp", badgeModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", badgeModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertBadge, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertBadge", "EmployeeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertBadge);
                return null;
            }
        }

        public List<BadgeModel> GetBadges(BadgeModel badgeModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@BadgeId", badgeModel.BadgeId);
                    vParams.Add("@SearchText", badgeModel.SearchText);
                    vParams.Add("@BadgeName", badgeModel.BadgeName);
                    vParams.Add("@IsArchived", badgeModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<BadgeModel>(StoredProcedureConstants.SpGetBadges, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetBadges", "EmployeeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetBadge);
                return new List<BadgeModel>();
            }
        }

        public Guid? AssignBadgeToEmployee(EmployeeBadgeModel badgeModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@Id", badgeModel.Id);
                    vParams.Add("@BadgeId", badgeModel.BadgeId);
                    vParams.Add("@BadgeDescription", badgeModel.BadgeDescription);
                    vParams.Add("@AssignedToXml", badgeModel.AssignedToXml);
                    vParams.Add("@IsArchived", badgeModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpAssignBadgeToEmployee, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "AssignBadgeToEmployee", "EmployeeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionAssignBadgeToEmployee);
                return null;
            }
        }

        public List<EmployeeBadgeModel> GetBadgesAssignedToEmployee(EmployeeBadgeModel badgeModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@UserId", badgeModel.UserId);
                    vParams.Add("@IsForOverView", badgeModel.IsForOverView);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmployeeBadgeModel>(StoredProcedureConstants.SpGetBadgesAssignedToEmployee, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetBadgesAssignedToEmployee", "EmployeeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetBadgesAssignedToEmployee);
                return new List<EmployeeBadgeModel>();
            }
        }

        public Guid? UpsertAnnouncement(AnnouncementModel announcementModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@AnnouncementId", announcementModel.AnnouncementId);
                    vParams.Add("@Announcement", announcementModel.Announcement);
                    vParams.Add("@AnnouncedTo", announcementModel.AnnouncedTo);
                    vParams.Add("@AnnouncementLevel", announcementModel.AnnouncementLevel);
                    vParams.Add("@IsArchived", announcementModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertAnnouncement, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertAnnouncement", "EmployeeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertAnnouncement);
                return null;
            }
        }

        public List<AnnouncementModel> GetAnnouncements(AnnouncementModel announcementModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@AnnouncementId", announcementModel.AnnouncementId);
                    vParams.Add("@EmployeeId", announcementModel.EmployeeId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<AnnouncementModel>(StoredProcedureConstants.SpGetAnnouncements, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAnnouncements", "EmployeeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAnnouncements);
                return new List<AnnouncementModel>();
            }
        }
        public Guid? UpsertGrade(GradeInputModel gradeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@GradeId", gradeInputModel.GradeId);
                    vParams.Add("@GradeName", gradeInputModel.GradeName);
                    vParams.Add("@GradeOrder", gradeInputModel.GradeOrder);
                    vParams.Add("@IsArchived", gradeInputModel.IsArchived);
                    vParams.Add("@TimeStamp", gradeInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertGrade, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertGrade", "EmployeeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertGrade);
                return null;
            }
        }
        public List<GetGradesOutputModel> GetGrades(GetGradesInputModel getGradesInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@GradeId", getGradesInputModel.GradeId);
                    vParams.Add("@SearchText", getGradesInputModel.SearchText); 
                    vParams.Add("@IsArchived", getGradesInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<GetGradesOutputModel>(StoredProcedureConstants.SpGetGrades, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetGrades", "EmployeeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetGrades);
                return new List<GetGradesOutputModel>();
            }
        }
        public Guid? UpsertEmployeeGrade(EmployeeGradeInputModel employeeGradeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@EmployeeGradeId", employeeGradeInputModel.EmployeeGradeId);
                    vParams.Add("@EmployeeId", employeeGradeInputModel.EmployeeId);
                    vParams.Add("@GradeId", employeeGradeInputModel.GradeId);
                    vParams.Add("@ActiveFrom", employeeGradeInputModel.ActiveFrom);
                    vParams.Add("@ActiveTo", employeeGradeInputModel.ActiveTo);
                    vParams.Add("@IsArchived", employeeGradeInputModel.IsArchived);
                    vParams.Add("@TimeStamp", employeeGradeInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertEmployeeGrade, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeGrade", "EmployeeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertEmployeeGrade);
                return null;
            }
        }
        public List<EmployeeGradeApiOutputModel> GetEmployeeGrades(EmployeeGradeSearchInputModel employeeGradeSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@EmployeeGradeId", employeeGradeSearchInputModel.EmployeeGradeId);
                    vParams.Add("@EmployeeId", employeeGradeSearchInputModel.EmployeeId);
                    vParams.Add("@SearchText", employeeGradeSearchInputModel.SearchText);
                    vParams.Add("@IsArchived", employeeGradeSearchInputModel.IsArchived);
                    vParams.Add("@PageNo", employeeGradeSearchInputModel.PageNumber);
                    vParams.Add("@SortDirection", employeeGradeSearchInputModel.SortDirection);
                    vParams.Add("@SortBy", employeeGradeSearchInputModel.SortBy);
                    vParams.Add("@PageSize", employeeGradeSearchInputModel.PageSize);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmployeeGradeApiOutputModel>(StoredProcedureConstants.SpGetEmployeeGrades, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeGrades", "EmployeeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeGrades);
                return new List<EmployeeGradeApiOutputModel>();
            }
        }

        public List<EmployeeDetailsHistoryApiReturnModel> GetEmployeeDetailsHistory(EmployeeDetailsHistoryApiInputModel employeeDetailsHistoryApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@UserId", employeeDetailsHistoryApiInputModel.UserId);
                    vParams.Add("@Category", employeeDetailsHistoryApiInputModel.Category);
                    vParams.Add("@PageSize", employeeDetailsHistoryApiInputModel.PageSize);
                    vParams.Add("@PageNumber", employeeDetailsHistoryApiInputModel.PageIndex);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmployeeDetailsHistoryApiReturnModel>(StoredProcedureConstants.SpGetEmployeeDetailsHistory, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeDetailsHistory", "EmployeeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeHistory);
                return new List<EmployeeDetailsHistoryApiReturnModel>();
            }
        }

        public bool UpdateUnreadAnnouncements(AnnouncementReadInputModel announcementReadInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@UserId", announcementReadInputModel.UserId);
                    vParams.Add("@AnnouncementId", announcementReadInputModel.AnnouncementId);
                    return vConn.Execute(StoredProcedureConstants.SpUpdateUnreadAnnouncements, vParams, commandType: CommandType.StoredProcedure) == -1;
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateUnreadAnnouncements", "EmployeeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, null);
                return false;
            }
        }

        public List<AnnouncementModel> GetUnreadAnnouncements(AnnouncementModel announcementModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@AnnouncementId", announcementModel.AnnouncementId);
                    vParams.Add("@UserId", announcementModel.UserId);
                    vParams.Add("@MonthOfAnnounced", announcementModel.AnnouncementDate);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<AnnouncementModel>(StoredProcedureConstants.SpGetUnreadAnnouncementsOfAnUser, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUnreadAnnouncements", "EmployeeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAnnouncements);
                return new List<AnnouncementModel>();
            }
        }

        public List<ReadAndUnReadUsersOfAnnouncementApiReturnModel> GetReadAndUnReadUsersOfAnnouncement(Guid? AnnouncementId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@AnnouncementId", AnnouncementId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ReadAndUnReadUsersOfAnnouncementApiReturnModel>(StoredProcedureConstants.SpGetReadAndUnReadUsersOfAnnouncement, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetReadAndUnReadUsersOfAnnouncement", "EmployeeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAnnouncements);
                return new List<ReadAndUnReadUsersOfAnnouncementApiReturnModel>();
            }
        }

        public List<EmployeeListApiOutputModel> GetEmployeesByRoleId(string roles, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@RoleIdsXml", roles);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmployeeListApiOutputModel>(StoredProcedureConstants.SpGetEmployeesByRoleId, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeesByRoleId", "EmployeeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAnnouncements);
                return null;
            }
        }

        public int GetActiveUsersCount(string siteAddress, Guid? loggedInUserId, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInUserId);
                    vParams.Add("@SiteAddress", siteAddress);
                    return vConn.Query<int>(StoredProcedureConstants.SpGetActiveUsersCount, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeesByRoleId", "EmployeeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAnnouncements);
                return 0;
            }
        }

        public bool GetIsHavingEmployeereportMembers(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<bool>(StoredProcedureConstants.SpIsHavingReportingMembers, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetIsHavingEmployeereportMembers", "EmployeeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertGrade);
                return false;
            }
        }
    }
}
