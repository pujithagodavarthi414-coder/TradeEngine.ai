using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Models.TestRail;
using BTrak.Common;
using Dapper;

namespace Btrak.Dapper.Dal.Partial
{
    public class TestRailFileRepository : BaseRepository
    {
        public List<TestRailFileModel> SearchTestRailFiles(TestRailFileModel testRailFileModel, LoggedInContext loggedInContext)
        {
            using (IDbConnection vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@FileId", testRailFileModel.FileId);
                vParams.Add("@TestRailId", testRailFileModel.TestRailId);
                vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                vParams.Add("@IsTestCasePreCondition", testRailFileModel.IsTestCasePreCondition);
                vParams.Add("@IsTestCaseStatus", testRailFileModel.IsTestCaseStatus);
                vParams.Add("@IsTestCaseStep", testRailFileModel.IsTestCaseStep);
                vParams.Add("@IsTestRun", testRailFileModel.IsTestRun);
                vParams.Add("@IsTestPlan", testRailFileModel.IsTestPlan);
                vParams.Add("@IsMilestone", testRailFileModel.IsMilestone);
                vParams.Add("@IsTestCase", testRailFileModel.IsTestCase);
                return vConn.Query<TestRailFileModel>(StoredProcedureConstants.SpSearchTestRailFiles, vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        public List<Guid?> UpsertFile(TestRailFileModel testRailFileModel, LoggedInContext loggedInContext)
        {
            using (IDbConnection vConn = OpenConnection())
            {
                DynamicParameters vParams = new DynamicParameters();
                vParams.Add("@FileName", testRailFileModel.FileName);
                vParams.Add("@TestRailId", testRailFileModel.TestRailId);
                vParams.Add("@IsTestCasePreCondition", testRailFileModel.IsTestCasePreCondition);
                vParams.Add("@IsTestCaseStatus", testRailFileModel.IsTestCaseStatus);
                vParams.Add("@IsTestCaseStep", testRailFileModel.IsTestCaseStep);
                vParams.Add("@TestRunId", testRailFileModel.TestRunId);
                vParams.Add("@IsExpectedResult", testRailFileModel.IsExpectedResult);
                vParams.Add("@IsTestRun", testRailFileModel.IsTestRun);
                vParams.Add("@IsTestPlan", testRailFileModel.IsTestPlan);
                vParams.Add("@IsMilestone", testRailFileModel.IsMilestone);
                vParams.Add("@IsTestCase", testRailFileModel.IsTestCase);
                vParams.Add("@TimeStamp", testRailFileModel.TimeStamp, DbType.Binary);
                vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                vParams.Add("@FilePathXml",testRailFileModel.FilePathXml);
                return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertTestRailFile, vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }
    }
}
