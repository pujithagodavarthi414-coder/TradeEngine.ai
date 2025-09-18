using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.Chat;
using BTrak.Common;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class ChannelMemberRepository 
    {
        public Guid? Upsert(ChannelUpsertInputModel aChannel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@ChannelId", aChannel.ChannelId);
                    vParams.Add("@ChannelName", aChannel.ChannelName);
                    vParams.Add("@MemberUserGuids", aChannel.ChannelMemberXml);
                    vParams.Add("@IsDeleted", aChannel.IsDeleted);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@ProjectId", aChannel.ProjectId);
                    return vConn.Query<Guid>(StoredProcedureConstants.SpUpsertChannelMember, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Upsert", "ChannelMemberRepository ", sqlException.Message), sqlException);

                string generalException = ValidationMessages.ExceptionAddChannelMember;
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, generalException);
                return null;
            }
        }

        public bool UpdateIsReadOnlyForChannelMembers(ChannelUpsertInputModel channelMemberModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@ChannelId", channelMemberModel.ChannelId);
                    vParams.Add("@UsersXML", channelMemberModel.ChannelMemberXml);
                    return vConn.Execute(StoredProcedureConstants.SpUpdateIsReadOnlyForChannelMembers, vParams, commandType: CommandType.StoredProcedure) == -1;
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateIsReadOnlyForChannelMembers", "ChannelMemberRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, null);
                return false;
            }
        }

    }
}
