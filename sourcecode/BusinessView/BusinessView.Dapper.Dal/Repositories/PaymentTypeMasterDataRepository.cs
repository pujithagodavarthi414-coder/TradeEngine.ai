using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.MasterData;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace Btrak.Dapper.Dal.Repositories
{
    public class PaymentTypeMasterDataRepository :BaseRepository
    {
        public Guid? UpsertPaymentType(PaymentTypeUpsertModel paymentTypeUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@PaymentTypeId", paymentTypeUpsertModel.PaymentTypeId);
                    vParams.Add("@PaymentTypeName", paymentTypeUpsertModel.PaymentTypeName);
                    vParams.Add("@IsArchived", paymentTypeUpsertModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@TimeStamp", paymentTypeUpsertModel.TimeStamp,DbType.Binary);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertPaymentType, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPaymentType", "PaymentTypeMasterDataRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionPaymentType);
                return null;
            }
        }
        public List<GetPaymentTypeOutputModel> GetPaymentTypes(GetPaymentTypeSearchCriteriaInputModel getPaymentTypeSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@PaymentTypeId", getPaymentTypeSearchCriteriaInputModel.PaymentTypeId);
                    vParams.Add("@PaymentTypeName", getPaymentTypeSearchCriteriaInputModel.PaymentTypeName);
                    vParams.Add("@SearchText", getPaymentTypeSearchCriteriaInputModel.SearchText);
                    vParams.Add("@IsArchived", getPaymentTypeSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<GetPaymentTypeOutputModel>(StoredProcedureConstants.SpGetPaymentTypes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPaymentTypes", "PaymentTypeMasterDataRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetPaymentType);
                return new List<GetPaymentTypeOutputModel>();
            }
        }
    }
}