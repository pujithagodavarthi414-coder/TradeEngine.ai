using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DocumentStorageService.Common
{
   public  class StoredProcedureConstants
    {
        public const string SpUpsertFolder = "USP_UpsertFolder";
        public const string SpGetFolders = "USP_SearchFolders";
        public const string SpDeleteFolders = "USP_GetDeleteFoldersList";
        public const string SpDeleteFolder = "USP_DeleteFolder";
        public const string SpUpsertFolderAndStoreSize = "USP_UpsertFolderAndStoreSize";
        public const string SpUpsertUserStoryFiles = "USP_UpsertUserStoryFiles";
        public const string SpUpsertFoodOrderFiles = "USP_UpsertFoodOrderFiles";
        public const string SpUpsertExpensesFiles = "USP_UpsertExpensesFiles";
        public const string SpUpsertAuditFiles = "USP_UpsertAuditMultipleFiles";
        public const string SpUpsertHrmFiles = "USP_UpsertHrmFiles";
        public const string SpUpsertCustomFiles = "USP_UpsertCustomFiles";
        public const string SpUpsertCustomDocFiles = "USP_UpsertCustomDocFiles";
        public const string SpUpsertTestSuiteFiles = "USP_UpsertTestSuiteFiles";
        public const string SpUpsertTestRunFiles = "USP_UpsertTestRunFiles";
        public const string SpUpsertPayRollFiles = "USP_UpsertPayRollFiles";
        public const string SpUpsertCandidateFiles = "USP_UpsertCandidateFiles";
        public const string SpDeleteFile = "USP_DeleteFile";
        public const string SpUpsertFileName = "USP_UpsertFileName";
    }
}
