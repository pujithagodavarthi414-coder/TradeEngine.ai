using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.Employee;
using BTrak.Common;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
    public class BankDetailRepository: BaseRepository
    {
        public Guid? UpsertEmployeeBankDetails(EmployeeBankDetailUpsertInputModel employeeBankDetailUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@EmployeeBankId", employeeBankDetailUpsertInputModel.EmployeeBankId);
                    vParams.Add("@EmployeeId", employeeBankDetailUpsertInputModel.EmployeeId);
                    vParams.Add("@IFSCCode", employeeBankDetailUpsertInputModel.IFSCCode);
                    vParams.Add("@AccountNumber", employeeBankDetailUpsertInputModel.AccountNumber);
                    vParams.Add("@AccountName", employeeBankDetailUpsertInputModel.AccountName);
                    vParams.Add("@BuildingSocietyRollNumber", employeeBankDetailUpsertInputModel.BuildingSocietyRollNumber);
                    vParams.Add("@BankId", employeeBankDetailUpsertInputModel.BankId);
                    vParams.Add("@BranchName", employeeBankDetailUpsertInputModel.BranchName);
                    vParams.Add("@DateFrom", employeeBankDetailUpsertInputModel.EffectiveFrom);
                    vParams.Add("@DateTo", employeeBankDetailUpsertInputModel.EffectiveTo);
                    vParams.Add("@IsArchived", employeeBankDetailUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", employeeBankDetailUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertEmployeeBankDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeBankDetails", "BankDetailRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertEmployeeBankDetail);
                return null;
            }
        }

        public List<EmployeeBankDetailApiReturnModel> GetAllBankDetails(EmployeeBankDetailSearchInputModel employeeBankDetailSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@EmployeeId", employeeBankDetailSearchInputModel.EmployeeId);
                    vParams.Add("@EmployeeBankDetailsId", employeeBankDetailSearchInputModel.EmployeeBankDetailsId);
                    vParams.Add("@SearchText", employeeBankDetailSearchInputModel.SearchText);
                    vParams.Add("@AccountNameSearchText", employeeBankDetailSearchInputModel.AccountNameSearchText);
                    vParams.Add("@AccountNumberSearchText", employeeBankDetailSearchInputModel.AccountNumberSearchText);
                    vParams.Add("@BankNameSearchText", employeeBankDetailSearchInputModel.BankNameSearchText);
                    vParams.Add("@BranchNameSearchText", employeeBankDetailSearchInputModel.BranchNameSearchText);
                    vParams.Add("@EffectiveFrom", employeeBankDetailSearchInputModel.EffectiveFrom);
                    vParams.Add("@EffectiveTo", employeeBankDetailSearchInputModel.EffectiveTo);
                    vParams.Add("@IsArchived", employeeBankDetailSearchInputModel.IsArchived);
                    vParams.Add("@SortBy", employeeBankDetailSearchInputModel.SortBy);
                    vParams.Add("@SortDirection", employeeBankDetailSearchInputModel.SortDirection);
                    vParams.Add("@PageNo", employeeBankDetailSearchInputModel.PageNumber);
                    vParams.Add("@PageSize", employeeBankDetailSearchInputModel.PageSize);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmployeeBankDetailApiReturnModel>(StoredProcedureConstants.SpGetEmployeeAllBankDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllBankDetails", "BankDetailRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeBankDetails);
                return new List<EmployeeBankDetailApiReturnModel>();
            }
        }
    }
}
