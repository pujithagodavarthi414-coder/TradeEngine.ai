using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.BillingManagement;
using BTrak.Common;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
    public class ScheduleRepository : BaseRepository
    {
        public Guid? UpsertInvoiceSchedule(UpsertInvoiceScheduleInputModel upsertInvoiceScheduleInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@InvoiceScheduleId", upsertInvoiceScheduleInputModel.InvoiceScheduleId);
                    vParams.Add("@CurrencyId", upsertInvoiceScheduleInputModel.CurrencyId);
                    vParams.Add("@InvoiceId", upsertInvoiceScheduleInputModel.InvoiceId);
                    vParams.Add("@CompanyId", upsertInvoiceScheduleInputModel.CompanyId);
                    vParams.Add("@CompanyLogo", upsertInvoiceScheduleInputModel.CompanyLogo);
                    vParams.Add("@ScheduleName", upsertInvoiceScheduleInputModel.ScheduleName);
                    vParams.Add("@ScheduleTypeId", upsertInvoiceScheduleInputModel.ScheduleTypeId);
                    vParams.Add("@ScheduleType", upsertInvoiceScheduleInputModel.ScheduleType);                  
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@RatePerHour", upsertInvoiceScheduleInputModel.RatePerHour);
                    vParams.Add("@HoursPerSchedule", upsertInvoiceScheduleInputModel.HoursPerSchedule);
                    vParams.Add("@ScheduleSequenceId", upsertInvoiceScheduleInputModel.ScheduleSequenceId);
                    vParams.Add("@ScheduleSequenceQuantity", upsertInvoiceScheduleInputModel.ScheduleSequenceQuantity);
                    vParams.Add("@TimeStamp", upsertInvoiceScheduleInputModel.TimeStamp, DbType.Binary);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertInvoiceSchedule, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertInvoiceSchedule", "ScheduleRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertInvoiceSchedule);
                return null;
            }
        }

        public List<ScheduleOutputModel> GetInvoiceSchedules(ScheduleInputModel scheduleInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@InvoiceScheduleId", scheduleInputModel.InvoiceScheduleId);
                    vParams.Add("@DateFrom", scheduleInputModel.DateFrom);
                    vParams.Add("@DateTo", scheduleInputModel.DateTo);
                    vParams.Add("@SearchText", scheduleInputModel.SearchText);
                    vParams.Add("@IsArchived", scheduleInputModel.IsArchived);
                    return vConn.Query<ScheduleOutputModel>("USP_GetInvoiceSchedules", vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetInvoiceSchedules", "ScheduleRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetInvoiceSchedules);
                return new List<ScheduleOutputModel>();
            }
        }

        public List<ScheduleTypeOutputModel> GetScheduleTypes(ScheduleTypeInputModel scheduleTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@ScheduleTypeId", scheduleTypeInputModel.ScheduleTypeId);
                    return vConn.Query<ScheduleTypeOutputModel>("USP_GetScheduleTypes", vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetScheduleTypes", "ScheduleRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetScheduleTypes);
                return new List<ScheduleTypeOutputModel>();
            }
        }

        public List<ScheduleSequenceOutputModel> GetScheduleSequence(ScheduleSequenceInputModel scheduleSequenceInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@ScheduleSequenceId", scheduleSequenceInputModel.ScheduleSequenceId);
                    return vConn.Query<ScheduleSequenceOutputModel>("USP_GetScheduleSequence", vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetScheduleSequence", "ScheduleRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetScheduleSequences);
                return new List<ScheduleSequenceOutputModel>();
            }
        }

    }
}