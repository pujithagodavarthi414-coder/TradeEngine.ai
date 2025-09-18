using Btrak.Dapper.Dal.Helpers;
using Btrak.Models.TimeZone;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Models;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class TimeZoneRepository
    {
        public Guid? UpsertTimeZone(TimeZoneInputModel timeZoneInputModel, List<ValidationMessage> validationMessages,LoggedInContext loggedInContext)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@TimeZoneId", timeZoneInputModel.TimeZoneId);
                    vParams.Add("@TimeZoneName", timeZoneInputModel.TimeZoneName);
                    vParams.Add("@TimeZoneAbbreviation", timeZoneInputModel.TimeZoneAbbreviation);
                    vParams.Add("@CountryCode", timeZoneInputModel.CountryCode);
                    vParams.Add("@CountryName", timeZoneInputModel.CountryName);
                    vParams.Add("@TimeZone", timeZoneInputModel.TimeZone);
                    vParams.Add("@TimeZoneOffset", timeZoneInputModel.TimeZoneOffset);
                    vParams.Add("@TimeStamp", timeZoneInputModel.TimeStamp,DbType.Binary);
                    vParams.Add("@IsArchived", timeZoneInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertTimeZone, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTimeZone", "TimeZoneRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionTimeZoneUpsert);
                return null;
            }
        }

        public List<TimeZoneOutputModel> GetAllTimeZones(TimeZoneInputModel timeZoneInputModel, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@TimeZoneId", timeZoneInputModel?.TimeZoneId);
                    vParams.Add("@TimeZoneName", timeZoneInputModel?.TimeZoneName);
                    vParams.Add("@IsArchived", timeZoneInputModel?.IsArchived);
                    return vConn.Query<TimeZoneOutputModel>(StoredProcedureConstants.SpGetTimeZones, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllTimeZones", "TimeZoneRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllTimeZones);
                return new List<TimeZoneOutputModel>();
            }
        }


        public List<TimeZoneOutputModel> GetAllTimeZoneLists(TimeZoneInputModel timeZoneInputModel, List<ValidationMessage> validationMessages, LoggedInContext loggedInContext)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<TimeZoneOutputModel>(StoredProcedureConstants.SpGetTimeZoneLists, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllTimeZones", "TimeZoneRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllTimeZones);
                return new List<TimeZoneOutputModel>();
            }
        }
    }
}



