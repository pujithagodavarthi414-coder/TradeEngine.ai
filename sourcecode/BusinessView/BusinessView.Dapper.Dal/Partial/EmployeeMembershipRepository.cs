using System.Collections.Generic;
using System.Data;
using System.Linq;
using Dapper;
using BTrak.Common;
using System;
using System.Data.SqlClient;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.Employee;
using Btrak.Models.HrManagement;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class EmployeeMembershipRepository 
    {
        public Guid? UpsertEmployeeMemberships(EmployeeMembershipUpsertInputModel employeeMembershipUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@EmployeeMembershipId", employeeMembershipUpsertInputModel.EmployeeMembershipId);
                    vParams.Add("@EmployeeId", employeeMembershipUpsertInputModel.EmployeeId);
                    vParams.Add("@MembershipId", employeeMembershipUpsertInputModel.MembershipId);
                    vParams.Add("@SubscriptionId", employeeMembershipUpsertInputModel.SubscriptionId);
                    vParams.Add("@SubscriptionAmount", employeeMembershipUpsertInputModel.SubscriptionAmount);
                    vParams.Add("@CurrencyId", employeeMembershipUpsertInputModel.CurrencyId);
                    vParams.Add("@CommenceDate", employeeMembershipUpsertInputModel.CommenceDate);
                    vParams.Add("@RenewalDate", employeeMembershipUpsertInputModel.RenewalDate);
                    vParams.Add("@IsArchived", employeeMembershipUpsertInputModel.IsArchived);
                    vParams.Add("@IssueCertifyingAuthority", employeeMembershipUpsertInputModel.IssueCertifyingAuthority);
                    vParams.Add("@NameOfTheCertificate", employeeMembershipUpsertInputModel.NameOfTheCertificate);
                    vParams.Add("@TimeStamp", employeeMembershipUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertEmployeeMemberships, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeMemberships", "EmployeeMembershipRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertEmployeeMemberShip);
                return null;
            }
        }

        public List<EmployeeMembershipDetailsApiReturnModel> GetEmployeeMembershipDetails(EmployeeDetailSearchCriteriaInputModel employeeDetailSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
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
                    vParams.Add("@SortBy", employeeDetailSearchCriteriaInputModel.SortBy);
                    vParams.Add("@SortDirection", employeeDetailSearchCriteriaInputModel.SortDirection);
                    vParams.Add("@IsArchived", employeeDetailSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmployeeMembershipDetailsApiReturnModel>(StoredProcedureConstants.SpGetEmployeeMembershipDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeMembershipDetails", "EmployeeMembershipRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeMembershipDetails);
                return new List<EmployeeMembershipDetailsApiReturnModel>();
            }
        }

        public List<EmployeeMembershipDetailsApiReturnModel> SearchEmployeeMembershipDetails(EmployeeMembershipDetailsInputModel getEmployeeMembershipDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@SearchText", getEmployeeMembershipDetailsInputModel.SearchText);
                    vParams.Add("@EmployeeId", getEmployeeMembershipDetailsInputModel.EmployeeId);
                    vParams.Add("@EmployeeMembershipid", getEmployeeMembershipDetailsInputModel.EmployeeMembershipid);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmployeeMembershipDetailsApiReturnModel>(StoredProcedureConstants.SpGetEmployeeMembershipDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchEmployeeMembershipDetails", "EmployeeMembershipRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeMembership);
                return new List<EmployeeMembershipDetailsApiReturnModel>();
            }
        }
    }
}
