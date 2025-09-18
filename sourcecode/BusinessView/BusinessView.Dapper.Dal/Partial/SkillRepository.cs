using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Models.HrManagement;

namespace Btrak.Dapper.Dal.Partial
{
    public partial class SkillRepository : BaseRepository
    {
        public Guid? UpsertSkills(SkillsInputModel skillsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SkillId", skillsInputModel.SkillId);
                    vParams.Add("@SkillName", skillsInputModel.SkillName);
                    vParams.Add("@TimeStamp", skillsInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", skillsInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertSkills, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertSkills", "SkillRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSkills);
                return null;
            }
        }
    }
}
