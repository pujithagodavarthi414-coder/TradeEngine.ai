using Btrak.Dapper.Dal.Helpers;
using Btrak.Models.BoardType;
using BTrak.Common;
using Dapper;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Models;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class BoardTypeUiRepository
    {
        public List<BoardTypeUiApiReturnModel> GetAllBoardTypeUis(BoardTypeUiInputModel boardTypeUiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@BoardTypeUiId", boardTypeUiInputModel.BoardTypeUiId);
                    vParams.Add("@BoardTypeUiName", boardTypeUiInputModel.BoardTypeUiName);
                    vParams.Add("@BoardTypeUiView", boardTypeUiInputModel.BoardTypeUiView);
                    vParams.Add("@IsArchived", boardTypeUiInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<BoardTypeUiApiReturnModel>(StoredProcedureConstants.SpGetBoardTypeUis, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllBoardTypeUis", "BoardTypeUiRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionCanteenFoodItem);
                return new List<BoardTypeUiApiReturnModel>();
            }
        }
    }
}
