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
    public partial class EmployeeWorkExperienceRepository
    {
        public Guid? UpsertEmployeeWorkExperience(EmployeeWorkExperienceInputModel employeeWorkExperienceInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EmployeeWorkExperienceId", employeeWorkExperienceInputModel.EmployeeWorkExperienceId);
                    vParams.Add("@EmployeeId", employeeWorkExperienceInputModel.EmployeeId);
                    vParams.Add("@DesignationId", employeeWorkExperienceInputModel.DesignationId);
                    vParams.Add("@PreviousCompany", employeeWorkExperienceInputModel.Company);
                    vParams.Add("@Comments", employeeWorkExperienceInputModel.Comments);
                    vParams.Add("@FromDate", employeeWorkExperienceInputModel.FromDate);
                    vParams.Add("@ToDate", employeeWorkExperienceInputModel.ToDate);
                    vParams.Add("@TimeStamp", employeeWorkExperienceInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", employeeWorkExperienceInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertEmployeeWorkExperience, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeWorkExperience", "EmployeeWorkExperienceRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionEmployeeWorkExperience);
                return null;
            }
        }

        public List<EmployeeWorkExperienceDetailsApiReturnModel> GetEmployeeWorkExperienceDetails(EmployeeDetailSearchCriteriaInputModel employeeDetailSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
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
                    vParams.Add("@SortBy", employeeDetailSearchCriteriaInputModel.SortBy);
                    vParams.Add("@SortDirection", employeeDetailSearchCriteriaInputModel.SortDirection);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmployeeWorkExperienceDetailsApiReturnModel>(StoredProcedureConstants.SpGetEmployeeWorkExperienceDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeWorkExperienceDetails", "EmployeeWorkExperienceRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeWorkExperienceDetails);
                return new List<EmployeeWorkExperienceDetailsApiReturnModel>();
            }
        }

        public List<EmployeeWorkExperienceDetailsApiReturnModel> SearchEmployeeWorkExperienceDetails(EmployeeWorkExperienceDetailsInputModel getEmployeeWorkExperienceDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@SearchText", getEmployeeWorkExperienceDetailsInputModel.SearchText);
                    vParams.Add("@EmployeeId", getEmployeeWorkExperienceDetailsInputModel.EmployeeId);
                    vParams.Add("@EmployeeWorkExperienceId", getEmployeeWorkExperienceDetailsInputModel.EmployeeWorkExperienceId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmployeeWorkExperienceDetailsApiReturnModel>(StoredProcedureConstants.SpGetEmployeeWorkExperienceDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchEmployeeWorkExperienceDetails", "EmployeeWorkExperienceRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeWorkExperience);
                return new List<EmployeeWorkExperienceDetailsApiReturnModel>();
            }
        }
    }
}
