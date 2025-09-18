using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.HrManagement;
using BTrak.Common;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class ContractTypeRepository
    {
        public Guid? UpsertContractType(ContractTypeUpsertInputModel contractTypeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@ContractTypeId", contractTypeUpsertInputModel.ContractTypeId);
                    vParams.Add("@ContractTypeName", contractTypeUpsertInputModel.ContractTypeName);
                    vParams.Add("@IsArchived", contractTypeUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", contractTypeUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertContractType, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertContractType", " ContractTypeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertContractType);
                return null;
            }
        }

        public List<ContractTypeApiReturnModel> GetContractTypes(ContractTypeSearchInputModel contractTypeSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@ContractTypeId", contractTypeSearchInputModel.ContractTypeId);
                    vParams.Add("@SearchText", contractTypeSearchInputModel.SearchText);
                    vParams.Add("@IsArchived", contractTypeSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ContractTypeApiReturnModel>(StoredProcedureConstants.SpGetContractTypes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetContractTypes", " ContractTypeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetContractTypes);
                return new List<ContractTypeApiReturnModel>();
            }
        }
    }
}
