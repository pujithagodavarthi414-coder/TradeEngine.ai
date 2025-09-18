using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.SoftLabels;
using BTrak.Common;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
    public class SoftLabelsRepository : BaseRepository
    {
        public Guid? UpsertSoftLabels(SoftLabelsInputMethod softLabelsInputMethod, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SoftLabelId", softLabelsInputMethod.SoftLabelId);
                    vParams.Add("@SoftLabelName", softLabelsInputMethod.SoftLabelName);
                    vParams.Add("@SoftLabelKeyType", softLabelsInputMethod.SoftLabelKeyType);
                    vParams.Add("@SoftLabelValue", softLabelsInputMethod.SoftLabelValue);
                    vParams.Add("@BranchId", softLabelsInputMethod.BranchId);
                    vParams.Add("@TimeStamp", softLabelsInputMethod.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", softLabelsInputMethod.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertSoftLabel, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertSoftLabels", "SoftLabelsRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertSoftLabels);
                return null;
            }
        }

        public List<SoftLabelsOutputMethod> GetSoftLabels(SoftLabelsSearchCriteriaInputModel softLabelsSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SoftLabelId", softLabelsSearchCriteriaInputModel.SoftLabelId);
                    vParams.Add("@SoftLabelName", softLabelsSearchCriteriaInputModel.SoftLabelName);
                    vParams.Add("@SearchText", softLabelsSearchCriteriaInputModel.SearchText);
                    vParams.Add("@IsArchive", softLabelsSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<SoftLabelsOutputMethod>(StoredProcedureConstants.SpGetSoftLabels, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetSoftLabels", "SoftLabelsRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.SearchSoftLabels);
                return new List<SoftLabelsOutputMethod>();
            }
        }
    }
}
