using AuthenticationServices.Common;
using AuthenticationServices.Models;
using AuthenticationServices.Models.TimeZone;
using AuthenticationServices.Repositories.Helpers;
using Dapper;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;

namespace AuthenticationServices.Repositories.Repositories.TimeZone
{
    public class TimeZoneRepository : ITimeZoneRepository
    {
        IConfiguration _iconfiguration;
        public TimeZoneRepository(IConfiguration iconfiguration)
        {
            _iconfiguration = iconfiguration;
        }

        public List<TimeZoneOutputModel> GetAllTimeZones(TimeZoneInputModel timeZoneInputModel, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnectionAuthentication())
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

        protected IDbConnection OpenConnectionAuthentication()
        {
            IDbConnection connection = new SqlConnection(_iconfiguration.GetConnectionString("AuthConnectionString"));
            connection.Open();
            return connection;
        }
    }
}
