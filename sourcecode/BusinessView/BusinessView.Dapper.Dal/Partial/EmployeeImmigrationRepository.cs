using System;
using System.Data;
using Dapper;
using Btrak.Models;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models.Employee;
using BTrak.Common;
using Btrak.Models.HrManagement;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class EmployeeImmigrationRepository
    {
        public Guid? UpsertEmployeeImmigrationDetails(Btrak.Models.Employee.EmployeeImmigrationDetailsInputModel employeeImmigrationDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EmployeeImmigrationId", employeeImmigrationDetailsInputModel.EmployeeImmigrationId);
                    vParams.Add("@EmployeeId", employeeImmigrationDetailsInputModel.EmployeeId);
                    vParams.Add("@Document", employeeImmigrationDetailsInputModel.Document);
                    vParams.Add("@DocumentNumber", employeeImmigrationDetailsInputModel.DocumentNumber);
                    vParams.Add("@IssuedDate", employeeImmigrationDetailsInputModel.IssuedDate);
                    vParams.Add("@ExpiryDate", employeeImmigrationDetailsInputModel.ExpiryDate);
                    vParams.Add("@EligibleStatus", employeeImmigrationDetailsInputModel.EligibleStatus);
                    vParams.Add("@CountryId", employeeImmigrationDetailsInputModel.CountryId);
                    vParams.Add("@EligibleReviewDate", employeeImmigrationDetailsInputModel.EligibleReviewDate);
                    vParams.Add("@Comments", employeeImmigrationDetailsInputModel.Comments);
                    vParams.Add("@ActiveFrom", employeeImmigrationDetailsInputModel.ActiveFrom);
                    vParams.Add("@ActiveTo", employeeImmigrationDetailsInputModel.ActiveTo);
                    vParams.Add("@TimeStamp", employeeImmigrationDetailsInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", employeeImmigrationDetailsInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertEmployeeImmigration, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeImmigrationDetails", "EmployeeImmigrationRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionEmployeeImmigrationDetails);
                return null;
            }
        }

        public List<EmployeeImmigrationDetailsApiReturnModel> GetEmployeeImmigrationDetails(EmployeeDetailSearchCriteriaInputModel employeeDetailSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
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
                    return vConn.Query<EmployeeImmigrationDetailsApiReturnModel>(StoredProcedureConstants.SpGetEmployeeImmigrationDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeImmigrationDetails", " EmployeeImmigrationRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeImmigrationDetails);
                return new List<EmployeeImmigrationDetailsApiReturnModel>();
            }
        }
        public List<EmployeeImmigrationDetailsApiReturnModel> SearchEmployeeImmigrationDetails(Btrak.Models.HrManagement.EmployeeImmigrationDetailsInputModel getEmployeeImmigrationDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@SearchText", getEmployeeImmigrationDetailsInputModel.SearchText);
                    vParams.Add("@EmployeeId", getEmployeeImmigrationDetailsInputModel.EmployeeId);
                    vParams.Add("@EmployeeImmigration", getEmployeeImmigrationDetailsInputModel.EmployeeImmigrationId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmployeeImmigrationDetailsApiReturnModel>(StoredProcedureConstants.SpGetEmployeeImmigrationDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchEmployeeImmigrationDetails", " EmployeeImmigrationRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeImmigration);
                return new List<EmployeeImmigrationDetailsApiReturnModel>();
            }
        }
    }
}
