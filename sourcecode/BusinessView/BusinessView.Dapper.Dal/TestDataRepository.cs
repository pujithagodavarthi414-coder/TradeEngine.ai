using System;
using System.Data;
using BTrak.Common;
using Dapper;

namespace Btrak.Dapper.Dal
{
    public class TestDataRepository : BaseRepository
    {
        public void ResetDatabaseToTestKickStartState(Guid userGuid, Guid companyGuid)
        {
            LoggingManager.Info($"Request in to execute ResetDatabaseToTestKickStartState with parameters of {userGuid} and {companyGuid}");
            using (var dbConnection = OpenConnection())
            {
                var dynamicParameters = new DynamicParameters();
                dynamicParameters.Add("@UserGuid", userGuid);
                dynamicParameters.Add("@CompanyGuid", companyGuid);
                dbConnection.Execute("USP_ResetDatabaseToTestKickStartState", dynamicParameters, commandTimeout: 1000, commandType: CommandType.StoredProcedure);
                LoggingManager.Info("Execution completed for the stored procedure usp_ResetDatabaseToTestKickStartState");
            }
        }

        public void ClearDatabaseForApiTests()
        {
            using (var dbConnection = OpenConnection())
            {
                var connection = dbConnection.CreateCommand();
                connection.CommandTimeout = 90;
                dbConnection.Execute("USP_ClearData", null, commandType: CommandType.StoredProcedure);
            }
        }

        public void PreScriptForApiTests()
        {
            using (var dbConnection = OpenConnection())
            {
                var connection = dbConnection.CreateCommand();
                connection.CommandTimeout = 90;
                dbConnection.Execute("USP_PostDeploymentScript", null, commandType: CommandType.StoredProcedure);
            }
        }

        public void TestDataInsertScript()
        {
            using (var dbConnection = OpenConnection())
            {
                var connection = dbConnection.CreateCommand();
                connection.CommandTimeout = 90;
                dbConnection.Execute("USP_TestDataInsertScript", null, commandType: CommandType.StoredProcedure);
            }
        }

        public void ExecuteFeatureProcedureScript()
        {
            using (var dbConnection = OpenConnection())
            {
                var connection = dbConnection.CreateCommand();
                connection.CommandTimeout = 90;
                dbConnection.Execute("USP_ExecuteFeatureProcedureScript", null, commandType: CommandType.StoredProcedure);
            }
        }

        public void ExecuteEntityFeatureProcedureScript()
        {
            using (var dbConnection = OpenConnection())
            {
                var connection = dbConnection.CreateCommand();
                connection.CommandTimeout = 90;
                dbConnection.Execute("USP_EntityFeatureProcedureScript", null, commandType: CommandType.StoredProcedure);
            }
        }
    }
}