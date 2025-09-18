using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.Notification;
using BTrak.Common;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class NotificationRepository : BaseRepository
    {
        public Guid? UpsertNotification(NotificationModel notificationModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@NotificationId", notificationModel.NotificationId);
                    vParams.Add("@NotificationTypeId", notificationModel.NotificationTypeId);
                    vParams.Add("@Summary", notificationModel.Summary);
                    vParams.Add("@NotificationJson", notificationModel.NotificationJson);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertNotification, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertNotification", "NotificationRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionNotificationUpsert);
                return null;
            }
        }

        public List<Guid?> UpsertUserNotificationRead(string NotificationIdXml,DateTime? NotificationReadTime,Guid? UserId,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@NotificationIdXml", NotificationIdXml);
                    vParams.Add("@UserId", UserId);
                    vParams.Add("@ReadDateTime", NotificationReadTime);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<List<Guid?>>(StoredProcedureConstants.SpUpsertUserNotificationRead, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertNotification", "NotificationRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUserNotificationReadUpsert);
                return null;
            }
        }

        public List<NotificationsOutputModel> GetNotifications (NotificationSearchModel notificationSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@NotificationId", notificationSearchModel.NotificationId);
                    vParams.Add("@NotificationTypeId", notificationSearchModel.NotificationTypeId);
                    vParams.Add("@Summary", notificationSearchModel.Summary);
                    vParams.Add("@SortBy", notificationSearchModel.SortBy);
                    vParams.Add("@SearchText", notificationSearchModel.SearchText);
                    vParams.Add("@SortDirection", notificationSearchModel.SortDirection);
                    vParams.Add("@PageSize", notificationSearchModel.PageSize);
                    vParams.Add("@PageNumber", notificationSearchModel.PageNumber);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<NotificationsOutputModel>(StoredProcedureConstants.SpGetNotifications, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetNotifications", "NotificationRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetNotifications);
                return new List<NotificationsOutputModel>();
            }
        }
    }
}
