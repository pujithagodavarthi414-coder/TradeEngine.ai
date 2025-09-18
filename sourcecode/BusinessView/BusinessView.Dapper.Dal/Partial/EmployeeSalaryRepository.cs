using System;
using System.Data;
using Dapper;
using System.Collections.Generic;
using System.Data.SqlClient;
using Btrak.Models;
using System.Linq;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models.Employee;
using BTrak.Common;
using Btrak.Models.HrManagement;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class EmployeeSalaryRepository:BaseRepository
    {
        public Guid? UpsertEmployeeSalaryDetails(Btrak.Models.Employee.EmployeeSalaryDetailsInputModel employeeSalaryDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
              {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EmployeeSalaryDetailId", employeeSalaryDetailsInputModel.EmployeeSalaryDetailId);
                    vParams.Add("@EmployeeId", employeeSalaryDetailsInputModel.EmployeeId);
                    vParams.Add("@PayGradeId", employeeSalaryDetailsInputModel.PayGradeId);
                    vParams.Add("@SalaryComponent", employeeSalaryDetailsInputModel.SalaryComponent);
                    vParams.Add("@PayFrequencyId", employeeSalaryDetailsInputModel.PayFrequencyId);
                    vParams.Add("@CurrencyId", employeeSalaryDetailsInputModel.CurrencyId);
                    vParams.Add("@Amount", employeeSalaryDetailsInputModel.Amount);
                    vParams.Add("@StartDate", employeeSalaryDetailsInputModel.StartDate);
                    vParams.Add("@EndDate", employeeSalaryDetailsInputModel.EndDate);
                    vParams.Add("@PaymentMethodId", employeeSalaryDetailsInputModel.PaymentMethodId);
                    vParams.Add("@SalaryParticularsFileId", employeeSalaryDetailsInputModel.SalaryParticularsFileId);
                    vParams.Add("@Comments", employeeSalaryDetailsInputModel.Comments);
                    vParams.Add("@IsDirectDeposit", employeeSalaryDetailsInputModel.IsDirectDeposit);
                    vParams.Add("@TimeStamp", employeeSalaryDetailsInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", employeeSalaryDetailsInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@NetPayAmount", employeeSalaryDetailsInputModel.NetPayAmount);
                    vParams.Add("@PayrollTemplateId", employeeSalaryDetailsInputModel.PayrollTemplateId);
                    vParams.Add("@TaxCalculationTypeId", employeeSalaryDetailsInputModel.TaxCalculationTypeId);
                    
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertEmployeeSalaryDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeSalaryDetails", "EmployeeSalaryRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionEmployeeSalaryDetails);
                return null;
            }
        }

        public List<EmployeeSalaryDetailsApiReturnModel> GetEmployeeSalaryDetails(EmployeeDetailSearchCriteriaInputModel employeeDetailSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
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
                    return vConn.Query<EmployeeSalaryDetailsApiReturnModel>(StoredProcedureConstants.SpGetEmployeeSalaryDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeSalaryDetails", "EmployeeSalaryRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeSalaryDetails);
                return new List<EmployeeSalaryDetailsApiReturnModel>();
            }
        }

        public List<EmployeeSalaryDetailsApiReturnModel> SearchEmployeeSalaryDetails(Btrak.Models.HrManagement.EmployeeSalaryDetailsInputModel getEmployeeSalaryDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@SearchText", getEmployeeSalaryDetailsInputModel.SearchText);
                    vParams.Add("@EmployeeId", getEmployeeSalaryDetailsInputModel.EmployeeId);
                    vParams.Add("@EmployeeSalaryDetailId", getEmployeeSalaryDetailsInputModel.EmployeeSalaryDetailId);
                    vParams.Add("@IsArchived", getEmployeeSalaryDetailsInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmployeeSalaryDetailsApiReturnModel>(StoredProcedureConstants.SpGetEmployeeSalaryDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchEmployeeSalaryDetails", "EmployeeSalaryRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeSalary);
                return new List<EmployeeSalaryDetailsApiReturnModel>();
            }
        }
    }
}
