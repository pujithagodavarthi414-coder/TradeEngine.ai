using System;
using System.Data;
using Dapper;
using System.Collections.Generic;
using System.Data.SqlClient;
using Btrak.Models;
using System.Linq;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models.Employee;
using Btrak.Models.HrManagement;
using BTrak.Common;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class EmployeeLanguageRepository
    {
        public Guid? UpsertEmployeeLanguages(EmployeeLanguagesInputModel employeeLanguagesInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EmployeeLanguageDetailId", employeeLanguagesInputModel.EmployeeLanguageId);
                    vParams.Add("@EmployeeId", employeeLanguagesInputModel.EmployeeId);
                    vParams.Add("@LanguageId", employeeLanguagesInputModel.LanguageId);
                    vParams.Add("@CanRead", employeeLanguagesInputModel.CanRead);
                    vParams.Add("@CanSpeak", employeeLanguagesInputModel.CanSpeak);
                    vParams.Add("@CanWrite", employeeLanguagesInputModel.CanWrite);
                    vParams.Add("@CompetencyId", employeeLanguagesInputModel.CompetencyId);
                    vParams.Add("@Comments", employeeLanguagesInputModel.Comments);
                    vParams.Add("@TimeStamp", employeeLanguagesInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", employeeLanguagesInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertEmployeeLanguages, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeLanguages", " EmployeeLanguageRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionEmployeeLanguages);
                return null;
            }
        }

        public List<EmployeeLanguageDetailsApiReturnModel> GetEmployeeLanguageDetails(EmployeeDetailSearchCriteriaInputModel employeeDetailSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
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
                    return vConn.Query<EmployeeLanguageDetailsApiReturnModel>(StoredProcedureConstants.SpGetEmployeeLanguageDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeLanguageDetails", " EmployeeLanguageRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeLanguageDetails);
                return new List<EmployeeLanguageDetailsApiReturnModel>();
            }
        }
        public List<EmployeeLanguageDetailsApiReturnModel> SearchEmployeeLanguageDetails(EmployeeLanguageDetailsInputModel getEmployeeLanguageDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@SearchText", getEmployeeLanguageDetailsInputModel.SearchText);
                    vParams.Add("@EmployeeId", getEmployeeLanguageDetailsInputModel.EmployeeId);
                    vParams.Add("@EmployeeLanguageId", getEmployeeLanguageDetailsInputModel.EmployeeLanguageId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmployeeLanguageDetailsApiReturnModel>(StoredProcedureConstants.SpGetEmployeeLanguageDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchEmployeeLanguageDetails", " EmployeeLanguageRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeLanguage);
                return new List<EmployeeLanguageDetailsApiReturnModel>();
            }
        }
    }
}
