using System;
using System.Data;
using System.Linq;
using Dapper;
using Btrak.Models;
using System.Collections.Generic;
using System.Data.SqlClient;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models.Employee;
using BTrak.Common;
using Btrak.Models.HrManagement;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class EmploymentContractRepository : BaseRepository
    {
        public Guid? UpsertEmploymentContract(EmploymentContractInputModel employmentContractInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EmploymentContractId", employmentContractInputModel.EmploymentContractId);
                    vParams.Add("@EmployeeId", employmentContractInputModel.EmployeeId);
                    vParams.Add("@StartDate", employmentContractInputModel.StartDate);
                    vParams.Add("@EndDate", employmentContractInputModel.EndDate);
                    vParams.Add("@ContractDetails", employmentContractInputModel.ContractDetails);
                    vParams.Add("@ContractTypeId", employmentContractInputModel.ContractTypeId);
                    vParams.Add("@ContractedHours", employmentContractInputModel.ContractedHours);
                    vParams.Add("@HourlyRate", employmentContractInputModel.HourlyRate);
                    vParams.Add("@HolidayOrThisYear", employmentContractInputModel.HolidayOrThisYear);
                    vParams.Add("@HolidayOrFullEntitlement", employmentContractInputModel.HolidayOrFullEntitlement);
                    vParams.Add("@TimeStamp", employmentContractInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", employmentContractInputModel.IsArchived);
                    vParams.Add("@CurrencyId", employmentContractInputModel.CurrencyId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertEmploymentContract, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmploymentContract", "EmploymentContractRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionEmploymentContract);
                return null;
            }
        }

        public List<EmploymentContractDetailsApiReturnModel> GetEmploymentContractDetails(EmployeeDetailSearchCriteriaInputModel employeeDetailSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
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
                    return vConn.Query<EmploymentContractDetailsApiReturnModel>(StoredProcedureConstants.SpGetEmploymentContractDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmploymentContractDetails", "EmploymentContractRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmploymentContractDetails);
                return new List<EmploymentContractDetailsApiReturnModel>();
            }
        }

        public List<EmploymentContractDetailsApiReturnModel> SearchEmploymentContractDetails(EmployeeContractDetailsInputModel employeeContractDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@EmployeeId", employeeContractDetailsInputModel.EmployeeId);
                    vParams.Add("@EmploymentContractId", employeeContractDetailsInputModel.EmploymentContractId);
                    vParams.Add("@SearchText", employeeContractDetailsInputModel.SearchText);
                    vParams.Add("@IsArchived", employeeContractDetailsInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmploymentContractDetailsApiReturnModel>(StoredProcedureConstants.SpGetEmploymentContractDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchEmploymentContractDetails", "EmploymentContractRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmploymentContractDetails);
                return new List<EmploymentContractDetailsApiReturnModel>();
            }
        }
    }
}