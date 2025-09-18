using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.SeatingArrangement;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class SeatingArrangementRepository
    {
        public Guid? UpsertSeatingArrangement(SeatingArrangementInputModel seatingArrangement, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SeatingId", seatingArrangement.SeatingId);
                    vParams.Add("@BranchId", seatingArrangement.BranchId);
                    vParams.Add("@EmployeeId", seatingArrangement.EmployeeId);
                    vParams.Add("@SeatCode", seatingArrangement.SeatCode);
                    vParams.Add("@Description", seatingArrangement.Description);
                    vParams.Add("@Comment", seatingArrangement.Comment);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsArchived", seatingArrangement.IsArchived);
                    vParams.Add("@TimeStamp", seatingArrangement.TimeStamp,DbType.Binary);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertSeatingArrangement, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertSeatingArrangement", "SeatingArrangementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertSeatingArrangement);
                return null;
            }
        }

        public List<SeatingArrangementOutputModel> SearchSeating(SeatingSearchCriteriaInputModel seatingSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@PageSize", seatingSearchCriteriaInputModel.PageSize);
                    vParams.Add("@PageNumber", seatingSearchCriteriaInputModel.PageNumber);
                    vParams.Add("@EmployeeId", seatingSearchCriteriaInputModel.EmployeeId);
                    vParams.Add("@IsArchived", seatingSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@SeatCode", seatingSearchCriteriaInputModel.SeatCode);
                    vParams.Add("@SortBy", seatingSearchCriteriaInputModel.SortBy);
                    vParams.Add("@BranchId", seatingSearchCriteriaInputModel.BranchId);
                    vParams.Add("@SortDirection", seatingSearchCriteriaInputModel.SortDirection);
                    vParams.Add("@SearchText", seatingSearchCriteriaInputModel.SearchText);
                    vParams.Add("@SeatingId", seatingSearchCriteriaInputModel.SeatingId);
                    vParams.Add("@EntityId", seatingSearchCriteriaInputModel.EntityId);
                    return vConn.Query<SeatingArrangementOutputModel>(StoredProcedureConstants.SpGetSeatingArrangements, vParams, commandType: CommandType.StoredProcedure)
                        .ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchSeating", "SeatingArrangementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchSeating);
                return null;
            }
        }

        public SeatingArrangementOutputModel GetSeatingById(Guid? seatingId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SeatingId", seatingId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<SeatingArrangementOutputModel>(StoredProcedureConstants.SpGetSeatingArrangements, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetSeatingById", "SeatingArrangementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetSeatingById);
                return null;
            }
        }
    }
}
