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
    public class AccessibleIpAddressesRepository : BaseRepository
    {
        public Guid? UpsertAccessibleIpAdresses(AccessibleIpAddressUpsertModel accessibleIpAddressUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@AccessisbleIpAdressesId", accessibleIpAddressUpsertModel.IpAddressId);
                    vParams.Add("@Name", accessibleIpAddressUpsertModel.LocationName);
                    vParams.Add("@IpAddress", accessibleIpAddressUpsertModel.IpAddress);
                    vParams.Add("@TimeStamp", accessibleIpAddressUpsertModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", accessibleIpAddressUpsertModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertAccessibleIpAddress, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertAccessibleIpAdresses", "AccessibleIpAddressesRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionAccessibleIpAddress);
                return null;
            }
        }
    }
}