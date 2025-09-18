using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.BankAccount;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Dapper.Dal.Repositories
{
    public class BankAccountRepository :BaseRepository
    {
        public Guid? UpsertBankName(BankAccountInputModel bankAccountInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Id", bankAccountInputModel.Id);
                    vParams.Add("@BankAccountName", bankAccountInputModel.BankAccountName);
                    vParams.Add("@Banque", bankAccountInputModel.Banque);
                    vParams.Add("@Beneficiaire", bankAccountInputModel.Beneficiaire);
                    vParams.Add("@Iban", bankAccountInputModel.Iban);
                    vParams.Add("@TimeStamp", bankAccountInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", bankAccountInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid>(StoredProcedureConstants.SpUpsertBankAccount, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertBankName", "BankAccountRepository", sqlException.Message), sqlException);
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertGRD);
                return null;
            }
        }

        public List<BankAccountSearchOutputModel> GetBankAccount(BankAccountSearchInputModel bankAccountInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Id", bankAccountInputModel.Id);
                    vParams.Add("@SearchText", bankAccountInputModel.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<BankAccountSearchOutputModel>(StoredProcedureConstants.SpGetBankAccount, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetBankAccount", "BankAccountRepository", sqlException.Message), sqlException);
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetGRD);
                return new List<BankAccountSearchOutputModel>();
            }
        }
    }
}
