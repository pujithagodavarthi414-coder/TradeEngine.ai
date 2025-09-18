using Btrak.Models.Dashboard;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class ProcessDashboardStatuRepository
    {
        public Guid? UpsertProcessDashboardStatus(ProcessDashboardStatusUpsertInputModel upsertProcessDashboardStatusInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@ProcessDashboardStatusId", upsertProcessDashboardStatusInputModel.ProcessDashboardStatusId);
                    vParams.Add("@StatusName", upsertProcessDashboardStatusInputModel.ProcessDashboardStatusName);
                    vParams.Add("@HexaValue", upsertProcessDashboardStatusInputModel.ProcessDashboardStatusHexaValue);
					vParams.Add("@TimeStamp", upsertProcessDashboardStatusInputModel.TimeStamp, DbType.Binary);
					vParams.Add("@IsArchived", upsertProcessDashboardStatusInputModel.IsArchived);
					vParams.Add("@StatusShortName", upsertProcessDashboardStatusInputModel.StatusShortName);
					vParams.Add("@TimeZone", upsertProcessDashboardStatusInputModel.TimeZone);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertProcessDashboardStatus, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertProcessDashboardStatus", "ProcessDashboardStatuRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionProcessDashboardStatusUpsert);
                return null;
            }
        }

        public List<ProcessDashboardStatusApiReturnModel> GetAllProcessDashboardStatuses(ProcessDashboardStatusInputModel upsertProcessDashboardStatusInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@ProcessDashboardStatusId", upsertProcessDashboardStatusInputModel.ProcessDashboardStatusId);
                    vParams.Add("@ProcessDashboardStatusName", upsertProcessDashboardStatusInputModel.ProcessDashboardStatusName);
                    vParams.Add("@ProcessDashboardStatusHexaValue", upsertProcessDashboardStatusInputModel.ProcessDashboardStatusHexaValue);
					vParams.Add("@IsArchived", upsertProcessDashboardStatusInputModel.IsArchived);
					vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ProcessDashboardStatusApiReturnModel>(StoredProcedureConstants.SpGetProcessDashboardStatuses, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllProcessDashboardStatuses", "ProcessDashboardStatuRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllProcessDashboardStatuses);
                return new List<ProcessDashboardStatusApiReturnModel>();
            }
        }
    }
}
