using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.TransitionDeadline;
using BTrak.Common;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class TransitionDeadlineRepository
	 {
        public Guid? UpsertTransitionDeadline(TransitionDeadlineUpsertInputModel transitionDeadlineUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TransitionDeadlineId", transitionDeadlineUpsertInputModel.TransitionDeadlineId);
                    vParams.Add("@DeadLine", transitionDeadlineUpsertInputModel.Deadline);
					vParams.Add("@TimeStamp", transitionDeadlineUpsertInputModel.TimeStamp, DbType.Binary);
					vParams.Add("@IsArchived", transitionDeadlineUpsertInputModel.IsArchived);
					vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertTransitionDeadline, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTransitionDeadline", "TransitionDeadlineRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionTransitionDeadlineUpsert);
                return null;
            }
        }

        public List<TransitionDeadlineApiReturnModel> GetAllTransitionDeadlines(TransitionDeadlineInputModel transitionDeadlineInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@TransitionDeadlineId", transitionDeadlineInputModel.TransitionDeadlineId);
                    vParams.Add("@DeadLineName", transitionDeadlineInputModel.Deadline);
					vParams.Add("@IsArchived", transitionDeadlineInputModel.IsArchived);
					vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<TransitionDeadlineApiReturnModel>(StoredProcedureConstants.SpGetTransitionDeadlines, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllTransitionDeadlines", "TransitionDeadlineRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllTransitionDeadlines);
                return new List<TransitionDeadlineApiReturnModel>();
            }
        }
    }
}
