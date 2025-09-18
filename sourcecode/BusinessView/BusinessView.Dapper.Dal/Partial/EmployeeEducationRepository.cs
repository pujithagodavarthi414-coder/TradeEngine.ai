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
    public partial class EmployeeEducationRepository
    {
        public Guid? UpsertEmployeeEducationDetails(Btrak.Models.Employee.EmployeeEducationDetailsInputModel employeeEducationDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EmployeeEducationDetailId", employeeEducationDetailsInputModel.EmployeeEducationDetailId);
                    vParams.Add("@EmployeeId", employeeEducationDetailsInputModel.EmployeeId);
                    vParams.Add("@EducationLevelId", employeeEducationDetailsInputModel.EducationLevelId);
                    vParams.Add("@Institute", employeeEducationDetailsInputModel.Institute);
                    vParams.Add("@MajorSpecialization", employeeEducationDetailsInputModel.MajorSpecialization);
                    vParams.Add("@GpaOrScore", employeeEducationDetailsInputModel.GpaOrScore);
                    vParams.Add("@StartDate", employeeEducationDetailsInputModel.StartDate);
                    vParams.Add("@EndDate", employeeEducationDetailsInputModel.EndDate);
                    vParams.Add("@TimeStamp", employeeEducationDetailsInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", employeeEducationDetailsInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertEmployeeEducationDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeEducationDetails", " EmployeeEducationRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionEmployeeEducationDetails);
                return null;
            }
        }

        public List<EmployeeEducationDetailsApiReturnModel> GetEmployeeEducationDetails(EmployeeDetailSearchCriteriaInputModel employeeDetailSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
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
                    return vConn.Query<EmployeeEducationDetailsApiReturnModel>(StoredProcedureConstants.SpGetEmployeeEducationDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeEducationDetails", " EmployeeEducationRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeEducationDetails);
                return new List<EmployeeEducationDetailsApiReturnModel>();
            }
        }

        public List<EmployeeEducationDetailsApiReturnModel> SearchEmployeeEducationDetails(Btrak.Models.HrManagement.EmployeeEducationDetailsInputModel getEmployeeEducationDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@SearchText", getEmployeeEducationDetailsInputModel.SearchText);
                    vParams.Add("@EmployeeId", getEmployeeEducationDetailsInputModel.EmployeeId);
                    vParams.Add("@EmployeeEducationId", getEmployeeEducationDetailsInputModel.EmployeeEducationId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmployeeEducationDetailsApiReturnModel>(StoredProcedureConstants.SpGetEmployeeEducationDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchEmployeeEducationDetails", " EmployeeEducationRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeEducation);
                return new List<EmployeeEducationDetailsApiReturnModel>();
            }
        }
    }
}
