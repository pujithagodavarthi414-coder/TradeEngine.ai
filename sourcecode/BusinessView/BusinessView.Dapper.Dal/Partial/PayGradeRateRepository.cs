using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.PayGradeRates;
using BTrak.Common;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class PayGradeRateRepository : BaseRepository
    {
        public Guid? AssignPayGradeRates(PayGradeRatesInputModel payGradeUpsertInputModel, string rateIds, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@PayGradeId", payGradeUpsertInputModel.PayGradeId);
                    vParams.Add("@RateIds", rateIds);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertPayGradeRate, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "AssignPayGradeRates", "PayGradeRateRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionAssignPayGradeRates);
                return null;
            }
        }

        public List<PayGradeRatesOutputModel> GetPayGradeRates(PayGradeRatesSearchCriteriaInputModel payGradeRatesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@PayGradeRateId", payGradeRatesSearchCriteriaInputModel.PayGradeRateId);
                    vParams.Add("@PayGradeId", payGradeRatesSearchCriteriaInputModel.PayGradeId);
                    vParams.Add("@RateId", payGradeRatesSearchCriteriaInputModel.RateId);
                    vParams.Add("@IsArchived", payGradeRatesSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<PayGradeRatesOutputModel>(StoredProcedureConstants.SpGetPayGradeRates, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPayGradeRates", "PayGradeRateRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetPayGradeRates);
                return new List<PayGradeRatesOutputModel>();
            }
        }
    }
}
